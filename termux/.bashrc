if ! ps T -o command | grep "^/data/data/com.termux/files/usr/bin/proot" > /dev/null; then
    echo "starting chroot"
    exec termux-chroot
fi

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-*color) color_prompt=yes;;
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

__prompt_command() {
    local EXIT="$?"             # This needs to be first

    local reset='\[\e[0m\]'
    # local magenta='\[\e[1;35m\]'
    local blue='\[\e[1;34m\]'

    local color=${blue}

    PS1="${color}\\w${reset} "

    # if [ $EXIT != 0 ]; then
    #     color="${magenta}"          # Add magenta if exit code non 0
    # fi

    if [[ $EXIT -ne 0 ]]; then
        PS1="💩 ${PS1}"
    fi

    # append to history after every command
    # export PROMPT_COMMAND='history -a'
    history -a
}

# If this is an xterm set the title to user@host:dir
case "$TERM" in
    xterm*|rxvt*)
        # PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        PROMPT_COMMAND=__prompt_command # runs prior to printing every command prompt
        ;;
    *)
        ;;
esac

# append to history instead of overwriting
shopt -s histappend

# don't log duplicate commands or commands starting w/a space
export HISTIGNORE=ignoreboth

# expand history size
export HISTFILESIZE=1000000
export HISTSIZE=1000000

EDITOR=$(which vim)
export EDITOR

# cd to directory just by typing dir name
shopt -s autocd

# tab expand env vars
shopt -s direxpand

# use vi key bindings on cmd line
set -o vi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

alias l='ls -laFh'
alias lll='ls -laFh --color | less -R'

alias cls='echo -e "\ec\e[3J"'

alias myps="ps -u $(id -u) -f -H -ww"
alias mypstop="watch -n 2 -t ps -u $(id -u) -f -H -ww"

# ag but open results in vim's quickfix window
function vg {
    vim -q <(ag --vimgrep "$@") +copen
}

export PATH="${PATH}:${HOME}/go/bin"

