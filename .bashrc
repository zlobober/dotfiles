alias po="xclip -sel clip -i"
alias vim="vim -p"
alias gvim="gvim -p"
alias ls="ls -N --color --time-style='+%Y-%m-%d %H:%M:%S'"
alias grep="grep --color"
alias egrep="egrep --color"

ulimit -n $((256*1024))

alias preview_html='x-www-browser "data:text/html;base64,$(base64 -w 0 <&0)"'

source /etc/bash_completion.d/git-prompt

export SVN_EDITOR=vim

#export PATH=/home/max42/yt_arc/source/python/yt/wrapper/bin:$PATH
#export PYTHONPATH="/home/max42/hermes/hermes:$PYTHONPATH" #:/home/max42/yt_arc/source/python:$PYTHONPATH"

parse_branch() {
    if [[ "${PWD##/home/max42/arc/arcadia}" != "${PWD}" ]]; then 
        path="/home/max42/arc/arcadia";
        if [ -e $path/.arc/HEAD ]; then
            branch=$(cat $path/.arc/HEAD | grep "ymbol" | awk -F'["]' '{print $2}')
        fi
    fi
    if [ -z $branch ]; then
        branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null  2> /dev/null)
    fi
    if [ ! -z $branch ]; then
        space=' '
        echo "$space($branch)"
    fi
}

PS1_smile='$(if [ $? = 0 ]; then echo "\[\033[01;36m\]-_-\[\033[00m\]"; else echo "\[\033[01;31m\]o_O\[\033[00m\]"; fi)'
PS1_userhost='\[\033[01;32m\]\u@\[\033[01;35m\]\h\[\033[00m\]'
PS1_vcs='\[\033[01;33m\]$(parse_branch)'
PS1_yt='\[\033[01;31m\][$YT_PROXY]\[\033[00m\]'
PS1_wd='\[\033[01;34m\]\w\[\033[00m\]'
export PS1="${PS1_smile} ${PS1_userhost}${PS1_vcs} ${PS1_yt}: ${PS1_wd} $ "

function swap()         
{
    local TMPFILE=tmp.$$
    if [[ "$1" = "" ]] || [[ "$2" = "" ]]; then
        echo swap: two arguments expected
        return
    fi
    mv "$1" $TMPFILE || return
    mv "$2" "$1" || return
    mv $TMPFILE "$2" || return
}

function grep_kill() {
    set -u
    for pid in `ps aux | grep "$1" | grep -v grep | awk '{print $2}'`; do
        kill -9 $pid
    done
    echo "Remaining processes:"
    ps aux | grep "$1" | grep -v grep
    set +u
}

function ls_elf()
{
    find . -type f | xargs file | grep "ELF.*executable" | awk -F: '{print $1}' | xargs echo
}

function rm_elf()
{
    rm `ls_elf`
}

refresh_tmux() {
    if [[ -n $TMUX ]]; then
        NEW_SSH_AUTH_SOCK=`tmux showenv | grep ^SSH_AUTH_SOCK | cut -d = -f 2`
        if [[ -n $NEW_SSH_AUTH_SOCK ]] && [[ -S $NEW_SSH_AUTH_SOCK ]]; then
            SSH_AUTH_SOCK=$NEW_SSH_AUTH_SOCK
            export SSH_AUTH_SOCK
        fi
        DISPLAY=`tmux showenv | grep ^DISPLAY | cut -d = -f 2`
        export DISPLAY
    fi
}
