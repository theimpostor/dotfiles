echo "sourcing .bash_profile"

# Tell ls to be colourful
export CLICOLOR=1
export LSCOLORS=Exfxcxdxbxegedabagacad

# Tell grep to highlight matches
export GREP_OPTIONS='--color=auto'

export TERM="xterm-color"
# PS1='\[\e[0;33m\]\u\[\e[0m\]@\[\e[0;32m\]\h\[\e[0m\]:\[\e[0;34m\]\w\[\e[0m\]\$ '
# PS1='\[\e[0;34m\]\w\[\e[0m\]\$ '
# PS1='\[\e[0;34m\]\w\[\e[0m\] '

__prompt_command() {
    local EXIT="$?"             # This needs to be first

    local reset='\[\e[0m\]'
    local red='\[\e[1;31m\]'
    local blue='\[\e[1;34m\]'

    local color=${blue}

    if [ $EXIT != 0 ]; then
        color=${red}            # Add red if exit code non 0
    fi

    PS1="${color}\\w${reset} "

    # append to history after every command
    # export PROMPT_COMMAND='history -a'
    history -a
}

PROMPT_COMMAND=__prompt_command # runs prior to printing every command prompt

if [ -f /usr/local/etc/bash_completion ]; then
    . /usr/local/etc/bash_completion
fi

export PATH=${PATH}:~/bin

JAVA_HOME="$(/usr/libexec/java_home)"
export JAVA_HOME

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

# alias myps="ps -u $(id -u) -f -H -ww"
# alias mypstop="watch -n 2 -t ps -u $(id -u) -f -H -ww"

# alias ptree="tree -ACF"

alias dc='docker-compose'

alias scratchpad='vim ~/Dropbox/work/pad.txt'

# ag but open results in vim's quickfix window
function vg {
    vim -q <(ag --vimgrep "$@") +copen
}

export BRANCH=$HOME/src/messaging/branches
export TRUNK=$HOME/src/messaging/trunk

source "$HOME/goto/goto.bash"

# goto -r common     ~/src/messaging/trunk/common
# goto -r ffy        ~/src/messaging/trunk/firefly
# goto -r ffy-qa     ~/src/messaging/trunk/firefly_qa
# goto -r ftl        ~/src/messaging/branches/ftl/ftl-5.3.x-branch/hydra
# goto -r src        ~/src
# goto -r thirdparty ~/src/messaging/trunk/thirdparty
# goto -r trunk      ~/src/messaging/trunk

