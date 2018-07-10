alias po="xclip -sel clip -i"
alias vim="vim -p"
alias gvim="gvim -p"
alias ls="ls -N --color"
alias ll="ls -N -al --color"
alias grep="grep --color"
alias egrep="egrep --color"

source /etc/bash_completion.d/git-prompt

export SVN_EDITOR=vim

export PS1='$(if [ $? = 0 ]; then echo "\[\033[01;36m\]-_-\[\033[00m\]"; else echo "\[\033[01;31m\]o_O\[\033[00m\]"; fi) \[\033[01;32m\]\u@\[\033[01;35m\]\h\[\033[01;33m\]$(__git_ps1) \[\033[01;31m\][$YT_PROXY]\[\033[00m\]: \[\033[01;34m\]\w\[\033[00m\] $ '

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
