# raise open files limit
ulimit -n 1024

# Tell ls to be colourful
export CLICOLOR=1
# export LSCOLORS=Exfxcxdxbxegedabagacad

# Tell grep to highlight matches
export GREP_OPTIONS='--color=auto'

# export TERM="xterm-color"
# PS1='\[\e[0;33m\]\u\[\e[0m\]@\[\e[0;32m\]\h\[\e[0m\]:\[\e[0;34m\]\w\[\e[0m\]\$ '
# PS1='\[\e[0;34m\]\w\[\e[0m\]\$ '
# PS1='\[\e[0;34m\]\w\[\e[0m\] '

reset='\[\e[0m\]'
# blue='\[\e[1;34m\]'
purple='\[\e[1;35m\]'
# PS1="\[\033]0;\u@\h: \w\007\]${purple}\\w${reset} "
# PS1="\[\033]0;\w\007\]${purple}\\w${reset} "

# append to history instead of overwriting
shopt -s histappend

# don't log duplicate commands or commands starting w/a space
export HISTCONTROL=ignoreboth

# https://github.com/fotinakis/bashrc/blob/c4945f655f8d2071467201d2e76da5ba7df8d61c/init.sh#L47
# Eternal bash history.
# ---------------------
# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
export HISTFILE=~/.bash_eternal_history

PROMPT_COMMAND="${PROMPT_COMMAND:+${PROMPT_COMMAND}; }history -a"

export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

# export PATH="/usr/local/opt/node@10/bin:${PATH}:${HOME}/bin:${HOME}/go/bin:${HOME}/Library/Python/3.7/bin"
export PATH="${PATH}:/usr/local/opt/node@14/bin:${HOME}/bin:${HOME}/go/bin"
# shellcheck source=/dev/null
source <(npm completion)

# gnu tar
export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:${PATH}"

# use local::lib
eval "$(perl -I"$HOME/perl5/lib/perl5" -Mlocal::lib="$HOME/perl5")"

# eval "$(jira --completion-script-bash)"

JAVA_HOME="$(brew --prefix openjdk@11)/libexec/openjdk.jdk/Contents/Home"
# JAVA_HOME="$(/usr/libexec/java_home)"
export JAVA_HOME

EDITOR=$(command -v nvim)
export EDITOR

# cd to directory just by typing dir name
shopt -s autocd

# tab expand env vars
shopt -s direxpand

# use vi key bindings on cmd line
set -o vi

# # show vi mode in prompt, and colorize
# # readline: https://stackoverflow.com/a/32614367/8370398
# # tput codes: http://linuxcommand.org/lc3_adv_tput.php
# bind "set show-mode-in-prompt on"
# bind "set vi-ins-mode-string $(tput bold)$(tput setaf 4)+$(tput sgr0)"
# bind "set vi-cmd-mode-string $(tput bold)$(tput setaf 1):$(tput sgr0)"

if shopt | grep globstar >/dev/null 2>&1; then
    shopt -s globstar
fi

if command -v fd >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='fd --type file'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi
# suppress shellcheck warning:
# shellcheck source=/dev/null
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

if command -v exa >/dev/null 2>&1; then
    alias l='exa --long --all --links --git'
else
    alias l='ls -laFh'
fi
alias lll='ls -laFh --color | less -R'

alias cls='echo -e "\ec\e[3J"'

# alias myps="ps -u $(id -u) -f -H -ww"
# alias mypstop="watch -n 2 -t ps -u $(id -u) -f -H -ww"

# alias ptree="tree -ACF"

alias nproc='sysctl -n hw.activecpu'

if command -v docker >/dev/null 2>&1; then
    alias d='docker'
    complete -F _docker d
fi

if command -v docker-compose >/dev/null 2>&1; then
    alias dc='docker-compose'
    complete -F _docker_compose dc
fi

if command -v kubectl >/dev/null 2>&1; then
    # shellcheck source=/dev/null
    source <(kubectl completion bash)
    alias k='kubectl'
    complete -F __start_kubectl k
fi

alias g='goto'
if ! [[ $(uname -s) =~ Darwin* ]]; then
    complete -o filenames -F _complete_goto_bash g
else
    complete -F _complete_goto_bash g
fi

if command -v eksctl >/dev/null 2>&1; then
    # shellcheck source=/dev/null
    source <(eksctl completion bash)
fi

if command -v bat >/dev/null 2>&1; then
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
    # can also use neovim
    # export MANPAGER='nvim +Man!'
fi

alias vim=nvim
alias ovim=/usr/local/bin/vim
function vimdiff {
    nvim -d "$@"
}

function vimcfg {
    vim "${HOME}/.config/nvim/init.vim"
}

function bashcfg {
    vim "${HOME}/.bashrc"
}

# ag but open results in vim's quickfix window
function vg {
    # printf %q reprints each arg with shell escapes
    # shellcheck disable=SC2046
    echo :LAck $(printf '%q ' "$@") | vim -s -
}
alias nvg=vg

function ovg {
    /usr/local/bin/vim -q <(rg --vimgrep "$@") +copen
}

# removes newline on each line of arg (stdin default) and prints to stdout
function chomp {
    perl -pe 'chomp' "$@"
}

# shuffles lines of each arg (stdin default) and prints to stdout
function shuffle {
    perl -MList::Util -e 'print List::Util::shuffle <>' "$@"
}

function cdr { 
    cd "${PWD/$1/$2}"
}

# prints joined argument list using ":" delimiter, removing duplicates and preserving order
function merge-args() {
    perl -e 'print join ":", grep {!$h{$_}++} split ":", join ":", @ARGV' "$@"
}

# join args by a delimiter
# https://stackoverflow.com/questions/1527049/how-can-i-join-elements-of-an-array-in-bash/17841619#comment37571340_17841619
function join-by() {
    perl -e 'print join shift, @ARGV' -- "$@"; 
}

# pwd relative to home - prints path to $PWD from the $HOME directory
function pwdrth {
    python -c 'import os, sys; print(os.path.relpath(*sys.argv[1:]))' "$PWD" "$HOME"
}

function coc {
    PATH="$(merge-args /usr/local/opt/llvm/bin "$PATH")" XDG_CONFIG_HOME=$HOME/.nvim-coc/config XDG_DATA_HOME=$HOME/.nvim-coc/data nvim "$@"
}

function cocupdate {
    coc +PlugUpgrade +qa && coc +PlugUpdate +CocUpdate
}

# list files that match the pattern and sort the output
function rgls {
    rg --files-with-matches "$@" | sort
}

function rgs {
    rg --line-number --with-filename --color always "$@" | sort --stable --field-separator=: --key=1,1
}

# prints the single latest file/dir
function latest {
    # -l auto chomps command line input
    find "$@" -type f -print | perl -l -ne '$f{$_} = -M; END { @a = sort {$f{$a} <=> $f{$b}} keys %f; print $a[0] if (@a) }'
}

export ASAN_OPTIONS=detect_leaks=1
export LSAN_OPTIONS=report_objects=1
# export LSAN_OPTIONS=report_objects=1:fast_unwind_on_malloc=false

export LLVM_PROFILE_FILE=".llvm-cov/%h-%9m.profraw"
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
# export BAT_THEME="ansi-light"

export PATH="$HOME/.cargo/bin:$PATH"

# broot
# source /Users/shoda/Library/Preferences/org.dystroy.broot/launcher/bash/br

if command -v starship >/dev/null 2>&1; then
    _set_win_title() {
        echo -ne "\033]0;${PWD}\007"
    }
    # shellcheck disable=SC2034
    starship_precmd_user_func="_set_win_title"
    eval "$(starship init bash)"
else
    if type __git_ps1 &> /dev/null; then
        export GIT_PS1_SHOWDIRTYSTATE=1
        export GIT_PS1_SHOWSTASHSTATE=1
        export GIT_PS1_SHOWUNTRACKEDFILES=1
        export GIT_PS1_SHOWCOLORHINTS=1
    fi

    # ERR_SAVED_PS1=$PS1
    ERR_SAVED_PROMPT_COMMAND=$PROMPT_COMMAND

    __err_prompt_command() {
        local EXIT="$?"             # This needs to be first

        $ERR_SAVED_PROMPT_COMMAND

        # via git-prompt.sh:
        # __git_ps1 requires 2 or 3 arguments when called from PROMPT_COMMAND (pc)
        # in that case it _sets_ PS1. The arguments are parts of a PS1 string.
        # when two arguments are given, the first is prepended and the second appended
        # to the state string when assigned to PS1.
        # The optional third parameter will be used as printf format string to further
        # customize the output of the git-status string.
        # In this mode you can request colored hints using GIT_PS1_SHOWCOLORHINTS=true

        if [[ $EXIT -ne 0 ]]; then
            __git_ps1 "💩 \[\033]0;\w\007\]${purple}\\w${reset}" " "
            # PS1="💩 $(__git_ps1 "(%s) ")${ERR_SAVED_PS1}"
        else
            __git_ps1 "\[\033]0;\w\007\]${purple}\\w${reset}" " "
            # PS1="$(__git_ps1 "(%s) ")${ERR_SAVED_PS1}"
        fi
    }

    PROMPT_COMMAND=__err_prompt_command # runs prior to printing every command prompt
fi

[ -f ~/.project-functions.bash ] && source ~/.project-functions.bash
