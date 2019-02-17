# replace evil capslocks by shift
xmodmap -e "keycode 66 = Shift_L NoSymbol Shift_L"


# Prompt
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/' -e 's/((/(((/' -e 's/))/)))/'
}

export PS1="\u \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] \n$ "

# Vars
export LC_ALL='en_US.UTF8'
export PATH=$PATH
export FZF_DEFAULT_COMMAND='git ls-files'
export SBT_OPTS="-Xmx1536M -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -Xss4M"
export TMPDIR="/tmp"
export HUSKY_SKIP_INSTALL=true
export EDITOR="vim"
export REACT_EDITOR="vim"

# Aliases
alias vi=vim
alias emacs="emacs -mm &"

# methods
vims() { 
  vim `echo "\"$@\"" | xargs ag -l`;
}

vimf() {
  vim `find -type f -name $1`
}

