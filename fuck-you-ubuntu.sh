#!/usr/bin/env bash
set -euo pipefail

LOG="/tmp/fix-wifi-and-monitor.$(date +%Y%m%d-%H%M%S).log"
exec > >(tee -a "$LOG") 2>&1

say() { echo -e "\n==> $*\n"; }
have() { command -v "$1" >/dev/null 2>&1; }

require_root() {
  if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
    echo "Please run as root: sudo $0"
    exit 1
  fi
}

kernel_ver() { uname -r; }

wifi_present() {
  lspci -nn | grep -qiE 'network controller.*8086:24f3|intel.*wireless 8260'
}

nvidia_present() {
  lspci | grep -qiE 'VGA compatible controller: NVIDIA|Display controller: NVIDIA'
}

nm_restart() {
  if systemctl is-active --quiet NetworkManager; then
    say "Restarting NetworkManager…"
    systemctl restart NetworkManager || true
  fi
}

reload_iwlwifi() {
  say "Attempting Wi-Fi repair (iwlwifi)…"

  if ! wifi_present; then
    say "Intel 8260 not detected via lspci. Skipping iwlwifi reload."
    return 0
  fi

  # If the module cannot be found/loaded, the kernel modules set is broken;
  # reinstalling linux-modules-extra often fixes it.
  if ! modinfo iwlwifi >/dev/null 2>&1; then
    say "iwlwifi module not found for this kernel. Reinstalling kernel modules-extra…"
    apt-get update -y
    apt-get install -y --reinstall "linux-modules-extra-$(kernel_ver)" || true
  fi

  nm_restart

  # Try unload/load; ignore errors if busy.
  say "Reloading iwlwifi module…"
  modprobe -r iwlwifi 2>/dev/null || true
  sleep 1
  modprobe iwlwifi || true

  nm_restart

  say "Wi-Fi status snapshot:"
  rfkill list || true
  ip link || true
}

ensure_headers() {
  say "Ensuring kernel headers are installed for $(kernel_ver)…"
  apt-get update -y
  apt-get install -y "linux-headers-$(kernel_ver)" || true

  # Quick sanity check: module.lds should exist when headers are correctly installed.
  local hdr="/usr/src/linux-headers-$(kernel_ver)/scripts/module.lds"
  if [[ ! -f "$hdr" ]]; then
    say "Kernel headers still look incomplete (missing: $hdr)"
    say "Running apt --fix-broken install…"
    apt-get -y --fix-broken install || true
    apt-get install -y "linux-headers-$(kernel_ver)" || true
  fi
}

repair_dpkg_state() {
  say "Repairing broken packages (if any)…"
  apt-get -y --fix-broken install || true
  dpkg --configure -a || true
}

reinstall_nvidia_stack() {
  say "Attempting NVIDIA repair…"

  if ! nvidia_present; then
    say "No NVIDIA GPU detected via lspci. Skipping NVIDIA steps."
    return 0
  fi

  ensure_headers
  repair_dpkg_state

  # If you’re pinned to 535 (as your log showed), keep it.
  # This reinstalls DKMS + driver meta and triggers module build for the running kernel.
  say "Reinstalling NVIDIA packages (535)…"
  apt-get install -y --reinstall nvidia-dkms-535 nvidia-driver-535 || true

  repair_dpkg_state

  say "Attempting to load NVIDIA kernel modules…"
  modprobe nvidia 2>/dev/null || true
  modprobe nvidia_modeset 2>/dev/null || true
  modprobe nvidia_uvm 2>/dev/null || true
  modprobe nvidia_drm 2>/dev/null || true

  say "nvidia-smi check:"
  if have nvidia-smi; then
    if nvidia-smi; then
      say "NVIDIA driver is responding."
    else
      say "nvidia-smi still failing."
    fi
  else
    say "nvidia-smi not found (package not installed or PATH issue)."
  fi
}

try_restore_display_without_reboot() {
  say "Trying to restore multi-monitor without reboot…"

  # If nvidia-smi works now, a display-manager restart often restores outputs.
  if have nvidia-smi && nvidia-smi >/dev/null 2>&1; then
    # Prefer restarting gdm3/sddm/lightdm if present.
    for dm in gdm3 sddm lightdm; do
      if systemctl list-unit-files | grep -q "^${dm}\.service"; then
        if systemctl is-active --quiet "$dm"; then
          say "Restarting display manager: $dm (this will log you out)…"
          systemctl restart "$dm" || true
          break
        fi
      fi
    done
  fi

  say "xrandr snapshot (if available):"
  if have xrandr; then
    xrandr || true
  fi
}

main() {
  require_root

  say "Logging to: $LOG"
  say "Kernel: $(kernel_ver)"
  say "Detected hardware:"
  lspci | grep -E "Network controller|VGA compatible controller|Display controller" || true

  # 1) Wi-Fi quick repair
  reload_iwlwifi

  # 2) NVIDIA + secondary display repair
  reinstall_nvidia_stack
  try_restore_display_without_reboot

  say "Done. If your second monitor is still missing but nvidia-smi now works,"
  say "log out / restart the display manager, or reboot as a last resort."
  say "Log saved at: $LOG"
}

main "$@"
