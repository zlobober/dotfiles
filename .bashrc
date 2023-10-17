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
            branch=$(cat $path/.arc/HEAD | awk -F'["]' '{print $2}')
        fi
    fi
    if [[ "${PWD##/home/max42/ytarc/arcadia}" != "${PWD}" ]]; then 
        path="/home/max42/ytarc/arcadia";
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

export RUN_PY_TEST_INSTALL_DIR="/home/max42/yt/build/bin"

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
    export GOPATH='/home/max42/go'
    export GOROOT=$(ya tool go --print-toolchain-path)
    export PATH=$GOROOT/bin:$PATH
}

export PATH=$PATH:/usr/local/go/bin

alias sshq="ssh max42-dev.vla.yp-c.yandex.net"
alias sshd="ssh yt-dev.yt.yandexcloud.co.il"


# The next line updates PATH for Yandex Cloud CLI.
if [ -f '/home/max42/yandex-cloud/path.bash.inc' ]; then source '/home/max42/yandex-cloud/path.bash.inc'; fi

# The next line enables shell command completion for yc.
if [ -f '/home/max42/yandex-cloud/completion.bash.inc' ]; then source '/home/max42/yandex-cloud/completion.bash.inc'; fi

export EDITOR=vim
