# replace evil capslocks by shift
xmodmap -e "keycode 66 = Shift_L NoSymbol Shift_L"
# Only load Liquid Prompt in interactive shells, not from a script or from scp
# [[ $- = *i* ]] && source ~/liquidprompt/liquidprompt
PATH=$PATH:~/.local/bin/:~/.yarn/bin/
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\u \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] \n$ "
export LC_ALL='en_US.UTF8'

vims() {
    vim -c "vim $1 ${2-"**/*.js"}"
}

vimf() {
    vim `find -name $1`
}

export PATH=$PATH:.vim/pack/minpac/start/fzf/bin
export FZF_DEFAULT_COMMAND='git ls-files'
alias eslint_pro='~/travauxlib/pro/node_modules/eslint/bin/eslint.js $1 -f ~/.vim/ftplugin/formatter.js'
