# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

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
force_color_prompt=yes

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
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w \$\[\033[00m\] '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# __prompt_command() {
#     local EXIT="$?"             # This needs to be first

#     local reset='\[\e[0m\]'
#     # local magenta='\[\e[1;35m\]'
#     local blue='\[\e[1;34m\]'

#     local color=${blue}

#     PS1="${color}\\w${reset} "

#     # if [ $EXIT != 0 ]; then
#     #     color="${magenta}"          # Add magenta if exit code non 0
#     # fi

#     if [[ $EXIT -ne 0 ]]; then
#         PS1="💩 ${PS1}"
#     fi

#     # append to history after every command
#     # export PROMPT_COMMAND='history -a'
#     history -a
# }

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    # PROMPT_COMMAND=__prompt_command # runs prior to printing every command prompt
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
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

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

source <(npm completion)

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

if command -v fd >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='fd --type file'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi
# suppress shellcheck warning:
# shellcheck source=/dev/null
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

alias l='ls -laFh'
alias lll='ls -laFh --color | less -R'

alias cls='echo -e "\ec\e[3J"'

function vimcfg {
    vim "${HOME}/.vimrc"
}

function bashcfg {
    vim "${HOME}/.bashrc"
}

# ag but open results in vim's quickfix window
function vg {
    echo :LAck $(printf '%q ' "$@") | vim -s -
    # vim +LAck\ \""$*"\"
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

# prints the single latest file/dir
function latest {
    # -l auto chomps command line input
    find "$@" -type f -print | perl -l -ne '$f{$_} = -M; END { @a = sort {$f{$a} <=> $f{$b}} keys %f; print $a[0] if (@a) }'
}

export PATH="${HOME}/go/bin:${PATH}"
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

alias temp='/opt/vc/bin/vcgencmd measure_temp'
