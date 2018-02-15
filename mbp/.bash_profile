echo "sourcing .bash_profile"

# Tell ls to be colourful
export CLICOLOR=1
export LSCOLORS=Exfxcxdxbxegedabagacad

# Tell grep to highlight matches
export GREP_OPTIONS='--color=auto'

export TERM="xterm-color"
# PS1='\[\e[0;33m\]\u\[\e[0m\]@\[\e[0;32m\]\h\[\e[0m\]:\[\e[0;34m\]\w\[\e[0m\]\$ '
#PS1='\[\e[0;34m\]\w\[\e[0m\]\$ '
PS1='\[\e[0;34m\]\w\[\e[0m\] '

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

# append to history after every command
export PROMPT_COMMAND='history -a'

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

alias l='ls -laFh'
alias lll='ls -laFh --color | less -R'

alias cls='echo -e "\ec\e[3J"'

# alias myps="ps -u $(id -u) -f -H -ww"
# alias mypstop="watch -n 2 -t ps -u $(id -u) -f -H -ww"

# alias ptree="tree -ACF"

alias dc='docker-compose'

# ag but open results in vim's quickfix window
function vg {
    vim -q <(ag --vimgrep "$@") +copen
}
