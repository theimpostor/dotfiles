# shellcheck shell=bash
# vim:ft=bash:sw=4:ts=4:expandtab
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

# https://github.com/fotinakis/bashrc/blob/c4945f655f8d2071467201d2e76da5ba7df8d61c/init.sh#L47
# Eternal bash history.
# ---------------------
# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
HISTFILESIZE=
HISTSIZE=
HISTTIMEFORMAT="[%F %T] "
# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
HISTFILE="$HOME/.bash_eternal_history"

PROMPT_COMMAND="${PROMPT_COMMAND:+${PROMPT_COMMAND}; }history -a"

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

if command -v exa >/dev/null 2>&1; then
    alias l='exa --long --extended --all --links --git'
else
    alias l='ls -laFh'
fi
alias lll='ls -laFh --color | less -R'

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

if [ -f "$HOME/nvim-nightly/setup-env.sh" ]; then
    source "$HOME/nvim-nightly/setup-env.sh"
fi

if command -v nvim >/dev/null 2>&1; then
    EDITOR=$(command -v nvim)
    export EDITOR
fi

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

# shellcheck source=.local/goto/goto.sh
[[ -f "$HOME/.local/goto/goto.sh" ]] && source "$HOME/.local/goto/goto.sh"
alias g='goto'
if ! [[ $(uname -s) =~ Darwin* ]]; then
    complete -o filenames -F _complete_goto_bash g
else
    complete -F _complete_goto_bash g
fi

alias ovim="$(command -v vim)"
alias vim='nvim'
if command -v bat >/dev/null 2>&1; then
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
elif command -v nvim >/dev/null 2>&1; then
    # can also use neovim
    export MANPAGER='nvim +Man!'
fi

function vimdiff {
    nvim -d "$@"
}

function vimcfg {
    vim "$(vim --clean --headless "+echo stdpath('config') . '/init.vim'" "+q" 2>&1)"
}

function bashcfg {
    vim "${HOME}/.bashrc"
}

# ag but open results in vim's quickfix window
function vg {
    # vim +LAck\ \""$*"\"
    # vim -q <(ag --vimgrep "$@") +copen
    # printf %q reprints each arg with shell escapes
    # shellcheck disable=SC2046
    echo :LAck $(printf '%q ' "$@") | vim -s -
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
    #shellcheck disable=2164
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

# function osccopy {
#     osc52 "$@"
# }

# function oscpaste {
#     osc52 --paste "$@"
# }

if command -v osc >/dev/null 2>&1; then
    # shellcheck source=/dev/null
    source <(osc completion bash)
fi


export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

if command -v zoxide > /dev/null 2>&1; then
    eval "$(zoxide init bash)"
fi

if command -v starship >/dev/null 2>&1; then
    _set_win_title() {
        echo -ne "\033]0;$USER $PWD\007"
    }
    # shellcheck disable=SC2034
    starship_precmd_user_func="_set_win_title"
    eval "$(starship init bash)"
fi

# TODO: test for hterm
export COLORTERM=truecolor

export DFT_DISPLAY=side-by-side-show-both

PATH="/home/sahir/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/sahir/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/sahir/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/sahir/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/sahir/perl5"; export PERL_MM_OPT;
. "$HOME/.cargo/env"

# installed in .cargo/bin
if command -v vivid >/dev/null 2>&1; then
    LS_COLORS="$(vivid generate tokyonight-night)"; export LS_COLORS
fi

if command -v fzf >/dev/null 2>&1; then
    # Set up fzf key bindings and fuzzy completion
    eval "$(fzf --bash)"
fi

