# replace evil capslocks by shift
xmodmap -e "keycode 66 = Shift_L NoSymbol Shift_L"

# Prompt
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/' -e 's/((/(((/' -e 's/))/)))/'
}

# Vars
export PS1="\u \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] \n$ "
export LC_ALL='en_US.UTF8'
export PATH=~/bin:$PATH
export DENO_INSTALL="/home/axnyff/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"
export SBT_OPTS="-Xmx1536M -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -Xss4M"
export TMPDIR="/tmp"
export HUSKY_SKIP_INSTALL=true
export EDITOR="vim"
export REACT_EDITOR="vim"
export FZF_DEFAULT_COMMAND='grep -vf <(git ls-files -d) <(git ls-files -o -c --exclude-standard)'


# methods
vims() { 
  vim `echo "\"$@\"" | xargs ag -l`;
}

vimf() {
  vim `find -type f -name $1`
}

fox(){
  sh -c 'env WINEPREFIX="/home/axnyff/.wine" wine-stable C:\\Program\ Files\ \(x86\)\\foxwq\\foxwq\\foxwq.exe' 2> /dev/null &
}

del_stopped(){
    local name=$1

    local state
    state=$(docker inspect --format "{{.State.Running}}" "$name" 2>/dev/null)

    if [[ "$state" == "false" ]]; then
        docker rm "$name"
    fi
}

dev() {
  docker container start hemea-db
  cd ~/travauxlib
  set $SESSION="travauxlib"
  tmux new-session $SESSION -d
  tmux split-window
  tmux resize-pane -D 10
  tmux select-pane -U
  tmux new-window -n "api" -t 1 -c "#{pane_current_path}/api"
  tmux split-window -c "#{pane_current_path}"
  tmux resize-pane -D 10
  tmux select-pane -U
  tmux new-window -n "notes" -t 2 -c "/home/axnyff/todos" "bash --rcfile <(cat /etc/bash.bashrc ~/.bashrc ~/todos/init)"
  tmux new-window -n "playground" -t 3 -c "/home/axnyff/playground"
  tmux split-window -c "#{pane_current_path}"
  tmux resize-pane -D 10
  tmux previous-window
  tmux attach-session $SESSION
}

kanyesay() {
  curl -s https://api.kanye.rest?format=text | cowsay -e "oO"
}


# Aliases
alias vi=vim

alias go_docker='docker rm -f $(docker ps -a -q) && docker run -p 5432:5432 --name hemea-db -e POSTGRES_USER=hemea -e POSTGRES_DB=hemea -e POSTGRES_PASSWORD=hemea -d postgres && ruby ~/travauxlib/api/restore_db.rb'
alias go_docker_empty='docker rm -f $(docker ps -a -q) && docker run -p 5432:5432 --name hemea-db -e POSTGRES_USER=hemea -e POSTGRES_DB=hemea -e POSTGRES_PASSWORD=hemea -d postgres'
alias go_docker_test='docker run -p 5431:5432 --name hemea-db-test --restart=always -e POSTGRES_USER=hemea -e POSTGRES_DB=travauxlib-test -e POSTGRES_PASSWORD=hemea -d postgres'
alias all_about_that_base='psql -E -d hemea -h localhost -U hemea'

ag() {
  # command ag --hidden \
  #   -p "$(git rev-parse --is-inside-work-tree &>/dev/null && echo "$(git rev-parse --show-toplevel)/.gitignore")" \
  #   "$@"
  command ag --hidden "$@"
}


[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[[ -s /home/axnyff/.autojump/etc/profile.d/autojump.sh ]] && source /home/axnyff/.autojump/etc/profile.d/autojump.sh


# replace _git_checkout with this in /usr/share/bash-completion/completions/git
_git_checkout ()
{
	__git_has_doubledash && return

	case "$cur" in
	--conflict=*)
		__gitcomp "diff3 merge" "" "${cur##--conflict=}"
		;;
	--*)
		__gitcomp_builtin checkout "--no-track --no-recurse-submodules"
		;;
	*)
		# check if --track, --no-track, or --no-guess was specified
		# if so, disable DWIM mode
		local flags="--track --no-track --no-guess" track_opt="--track"
		if [ "$GIT_COMPLETION_CHECKOUT_NO_GUESS" = "1" ] ||
		   [ -n "$(__git_find_on_cmdline "$flags")" ]; then
			track_opt=''
		fi
	  __gitcomp_nl "$(__git_heads '' $track)"
		;;
	esac
}

alias deploy_pro="heroku pipelines:promote -a travauxlib-pro-staging"
alias deploy_api="heroku pipelines:promote -a travauxlib-api-staging"
alias deploy_app="heroku pipelines:promote -a travauxlib-app-staging"
alias deploy_admin="heroku pipelines:promote -a travauxlib-admin-staging"
alias bye="tmux kill-session -t 0"
alias z="systemctl suspend ; bye"
alias off="systemctl poweroff"
alias kgs="java -jar ~/stuff/cgoban.jar > /dev/null 2>&1 &"
alias micon='amixer set Capture cap > /dev/null && echo "Mic is ON"'
alias micoff='amixer set Capture nocap > /dev/null; echo "Mic is OFF"'
alias fuckoff='pkill -9 node;pkill -9 java'

move_cards() {
    BOARD_CLUB_PRO="5d834df725505a52b198e5d0"
    BOARD_MARKETPLACE="5b3a5adcbc272ce52d6d68f1"
    READY_TO_SHIP_PRO="5d834e62b61e066c9a35bb83"
    READY_TO_SHIP_MARKETPLACE="5f6aff5d671856402eac2ed0"
    PROD_PRO="5d834ea06c91e25e1fc42d70"
    PROD_MARKETPLACE="5f6aff624b222a74e40a8645"
    http POST "https://api.trello.com/1/lists/${READY_TO_SHIP_PRO}/moveAllCards?key=${TRELLO_API_KEY}&token=${TRELLO_API_TOKEN}&idBoard=${BOARD_CLUB_PRO}&idList=${PROD_PRO}" > /dev/null
    http POST "https://api.trello.com/1/lists/${READY_TO_SHIP_MARKETPLACE}/moveAllCards?key=${TRELLO_API_KEY}&token=${TRELLO_API_TOKEN}&idBoard=${BOARD_MARKETPLACE}&idList=${PROD_MARKETPLACE}" > /dev/null
  }

