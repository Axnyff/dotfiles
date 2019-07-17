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

del_stopped(){
    local name=$1
    local state
    state=$(docker inspect --format "{{.State.Running}}" "$name" 2>/dev/null)

    if [[ "$state" == "false" ]]; then
        docker rm "$name"
    fi
}

dev() {
  docker container start travauxlib-db
  cd ~/travauxlib
  set $SESSION="travauxlib"
  tmux new-session $SESSION -d
  tmux split-window
  tmux resize-pane -D 10
  tmux select-pane -U
  tmux new-window -n "api" -t 1 -c "api"
  tmux previous-window
  tmux attach-session $SESSION
}


# Aliases
alias vi=vim
alias go_docker='docker rm -f $(docker ps -a -q) && docker run -p 5432:5432 --name travauxlib-db -e POSTGRES_USER=play -e POSTGRES_DB=travauxlib -e POSTGRES_PASSWORD=play -d postgres && ruby ~/travauxlib/api/restore_db.rb'
alias go_docker_empty='docker rm -f $(docker ps -a -q) && docker run -p 5432:5432 --name travauxlib-db -e POSTGRES_USER=play -e POSTGRES_DB=travauxlib -e POSTGRES_PASSWORD=play -d postgres'
alias go_docker_test='docker run -p 5431:5432 --name travauxlib-db-test --restart=always -e POSTGRES_USER=play -e POSTGRES_DB=travauxlib-test -e POSTGRES_PASSWORD=play -d postgres'
alias all_about_that_base='psql -E -d travauxlib -h localhost -U play'
alias website_start="php bin/console server:start"
alias website_refresh="php bin/console travauxlib:clear-cloudflare-cache"


[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[[ -s /home/axnyff/.autojump/etc/profile.d/autojump.sh ]] && source /home/axnyff/.autojump/etc/profile.d/autojump.sh
