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

reset='\[\e[0m\]'
blue='\[\e[1;34m\]'
PS1="${blue}\\w${reset} "

PROMPT_COMMAND='history -a'

if [ -f /usr/local/etc/bash_completion ]; then
    . /usr/local/etc/bash_completion
fi

export PATH=${PATH}:${HOME}/bin:${HOME}/go/bin

JAVA_HOME="$(/usr/libexec/java_home)"
export JAVA_HOME

# append to history instead of overwriting
shopt -s histappend

# don't log duplicate commands or commands starting w/a space
export HISTCONTROL=ignoreboth

# expand history size
export HISTFILESIZE=1000000
export HISTSIZE=1000000

EDITOR=$(command -v vim)
export EDITOR

# cd to directory just by typing dir name
shopt -s autocd

# tab expand env vars
shopt -s direxpand

# use vi key bindings on cmd line
set -o vi

if shopt | grep globstar >/dev/null 2>&1; then
    shopt -s globstar
fi

# suppress shellcheck warning:
# shellcheck source=/dev/null
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

alias l='ls -laFh'
alias lll='ls -laFh --color | less -R'

alias cls='echo -e "\ec\e[3J"'

# alias myps="ps -u $(id -u) -f -H -ww"
# alias mypstop="watch -n 2 -t ps -u $(id -u) -f -H -ww"

# alias ptree="tree -ACF"

alias dc='docker-compose'

alias scratchpad='vim ~/Dropbox/work/pad.txt'

alias vim=nvim
function vimdiff {
    nvim -d "$@"
}

# ag but open results in vim's quickfix window
function vg {
    vim +LAck\ \""$*"\"
    # vim -q <(ag --vimgrep "$@") +copen
}

# removes newline on each line of arg (stdin default) and prints to stdout
function chomp {
    perl -pe 'chomp' "$@"
}

# shuffles lines of each arg (stdin default) and prints to stdout
function shuffle {
    perl -MList::Util -e 'print List::Util::shuffle <>' "$@"
}

export BRANCH=$HOME/src/messaging/branches
export TRUNK=$HOME/src/messaging/trunk

# source "$HOME/goto/goto.bash"

export ASAN_OPTIONS=detect_leaks=1
export LSAN_OPTIONS=fast_unwind_on_malloc=false

ERR_SAVED_PS1=$PS1
ERR_SAVED_PROMPT_COMMAND=$PROMPT_COMMAND

__err_prompt_command() {
    local EXIT="$?"             # This needs to be first

    $ERR_SAVED_PROMPT_COMMAND

    if [[ $EXIT -ne 0 ]]; then
        PS1="💩 ${ERR_SAVED_PS1}"
    else
        PS1=${ERR_SAVED_PS1}
    fi
}

PROMPT_COMMAND=__err_prompt_command # runs prior to printing every command prompt

export LLVM_PROFILE_FILE=".llvm-cov/%h-%9m.profraw"
