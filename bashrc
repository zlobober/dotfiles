# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# ===================================================================

export PATH=$PATH:/usr/local/go/bin

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
    if [[ "${PWD##/home/max/nebo/nebo}" != "${PWD}" ]]; then 
        path="/home/max/nebo/nebo";
        if [ -e $path/.arc/HEAD ]; then
            branch=$(cat $path/.arc/HEAD | awk -F'["]' '{print $2}')
        fi
    fi
    if [[ "${PWD##/home/max/arc/arcadia}" != "${PWD}" ]]; then 
        path="/home/max/arc/arcadia";
        if [ -e $path/.arc/HEAD ]; then
            branch=$(cat $path/.arc/HEAD | awk -F'["]' '{print $2}')
        fi
    fi
    if [[ "${PWD##/home/max/ytarc/arcadia}" != "${PWD}" ]]; then 
        path="/home/max/ytarc/arcadia";
        if [ -e $path/.arc/HEAD ]; then
            branch=$(cat $path/.arc/HEAD | awk -F'["]' '{print $2}')
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
PS1_kube='\[\033[01;35m\]{$(kubectl config current-context)}\[\033[00m\]'
PS1_wd='\[\033[01;34m\]\w\[\033[00m\]'
export PS1="${PS1_smile} ${PS1_userhost}${PS1_vcs} ${PS1_yt} $PS1_kube: ${PS1_wd} $ "

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

function WDEV()
{
#    PYTHONPATH=~/yt/source/python:$PYTHONPATH PATH=~/yt/source/python/yt/wrapper/bin:$PATH $*
    PATH=~/bin:$PATH $*
}

function WDEV2()
{
    PYTHONPATH=~/yt2/source/python:$PYTHONPATH PATH=~/yt2/source/python/yt/wrapper/bin:$PATH $*
}

function YAPASTE()
{
    ( echo -e "$ $*\n" ; $* ) | ya paste
}

function yte()
{
    if [[ "$1" == "" ]] ; then
        echo "Specify Cypress path as the only argument"
        return 1
    fi
    NAME=.yte.$$
    echo "Checking existence of $1" >&2
    ex="$(yt exists $1)" || return 2
    rm -f $NAME
    if [[ "$ex" == "true" ]] ; then
        type="$(yt get $1/@type --format dsv)" || return 3
        if [[ "$type" != "document" ]] ; then
            echo "Why are you trying to edit node of type $type? Only documents are supported :)"
            return 4
        fi
        echo "$1 exists, getting it content into $NAME" >&2
        yt get $1 >$NAME || return 5
    else
        echo "$1 does not exist, creating empty file" >&2
        touch $NAME
    fi
    echo "Invoking Vim" >&2
    vim $NAME || vim_failed=1
    if [[ "$vim_failed" == "1" ]] ; then
        echo "Vim exited abnormally" >&2;
        return 6;
    fi
    if [[ "$ex" == "true" ]] ; then
        echo "Setting content of $1" >&2
        yt set $1 <$NAME || return 7
    else
        echo "Creating new document $1" >&2
        yt create document $1 --attributes "{value=$(cat $NAME)}" || return 8
    fi
    echo "Removing $NAME" >&2
    rm $NAME
    echo "Success" >&2
}

function cdt()
{
    pwd=$(pwd)
    pwdb=${pwd/arc\/arcadia/arc\/build}
    pwda=${pwd/arc\/build/arc\/arcadia}
    if [[ "$pwd" != "$pwdb" ]] ; then
        echo "$pwd -> $pwdb";
        cd $pwdb
    fi
    if [[ "$pwd" != "$pwda" ]] ; then
        echo "$pwd -> $pwda";
        cd $pwda
    fi
}

function core_pattern()
{
    echo "Current core pattern: $(cat /proc/sys/kernel/core_pattern)"
    read -p "Enter local or tmp or exit by ctrl-C: " new_location
    if [[ "$new_location" == "local" ]] ; then
        sudo sh -c "echo core.%p.%s.%t.%e >/proc/sys/kernel/core_pattern"
    elif [[ "$new_location" == "tmp" ]] ; then
        sudo sh -c "echo /tmp/core.%p.%s.%t.%e >/proc/sys/kernel/core_pattern"
    else
        echo "Wrong option: $new_location"
    fi
    echo "New core pattern: $(cat /proc/sys/kernel/core_pattern)"
}

alias sum="paste -sd+ | bc"

function yarun()
{
    ya make
    cdt
    bin=$(ls -t --color=never | head -n1)
    ./${bin} $*
    cdt
}


function yagosetup() {
    export GOPATH='/home/max/go'
    export GOROOT=$(ya tool go --print-toolchain-path)
    export PATH=$GOROOT/bin:$PATH
}

export PATH=$PATH:/usr/local/go/bin

alias sshq="ssh max42@max42-dev.vla.yp-c.yandex.net"
alias sshd="ssh max42@dev.nebius.yt"


export EDITOR=vim
alias yavpn='sudo openvpn --config ~/.itsme/openvpn.conf'

# The next line updates PATH for CLI.
if [ -f '/home/max/yandex-cloud/path.bash.inc' ]; then source '/home/max/yandex-cloud/path.bash.inc'; fi

# The next line enables shell command completion for yc.
if [ -f '/home/max/yandex-cloud/completion.bash.inc' ]; then source '/home/max/yandex-cloud/completion.bash.inc'; fi

export PATH=$PATH:/home/max/.local/bin

alias pssh="~/pssh --bastion-user max42"
alias nssh="~/nssh"

export PATH=$PATH:/home/max/go/bin

export YA_USER=max42

# The next line updates PATH for CLI.
if [ -f '/home/max/nebius-cloud/path.bash.inc' ]; then source '/home/max/nebius-cloud/path.bash.inc'; fi

# The next line enables shell command completion for ncp.
if [ -f '/home/max/nebius-cloud/completion.bash.inc' ]; then source '/home/max/nebius-cloud/completion.bash.inc'; fi

export PATH=/home/max/cloud-go/api/ycpcli/cmd/ycp:$PATH
