# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Color definitions
color_red='\[$(tput setaf 1)\]'
color_green='\[$(tput setaf 2)\]'
color_yellow='\[$(tput setaf 3)\]'
color_blue='\[$(tput setaf 4)\]'
color_reset='\[$(tput sgr0)\]'

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

# Color prompt toggle. Set to no to disable.
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
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Most customizations should go in the following file
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

function speedFibertel() {
    wget -O/dev/null http://sftp.fibertel.com.ar/services/file-1GB.img
}

screen_title() {
    echo -ne '\ek'$*'\e\\'
}

xterm_title() {
    echo -ne '\033]0;'$*'\a'
}

title() {
    case "$TERM" in
    xterm*|rxvt*)
        xterm_title "$@"
        ;;
    screen*)
        xterm_title $(hostname)
        screen_title "$@"
        ;;
    *) ;;
    esac
}

case "$TERM" in
screen*)
    SCREENTITLE='\['$(screen_title '\w')'\\]'
    trap 'title $(basename ${BASH_COMMAND/ */})' DEBUG
    ;;
*)  ;;
esac

PS1="${SCREENTITLE}${PS1}"

PROMPT_DIRTRIM=3

export PGUSER=postgres


hg_revision() {
    # This function returns a prompt prefix for mercurial repositories, similar to __git_ps1

    # It does the following but more efficiently, to avoid slowing down the shell prompt.
    # if hg id > /dev/null 2>&1; then
    #     echo -n "[$(hg id -b):$(hg id -t)] "
    # fi
    # 

    while [ "$PWD" != "/" ]; do
        if branch=$(cat .hg/branch 2>/dev/null); then
            break
        fi
        cd ..
    done

    if [ -z "$branch" ]; then
        return
    fi

    if ! [ -f ".hg/tag" ] || [ ".hg/branch" -nt ".hg/tag" ]; then
        tag=$(hg id -t < /dev/null 2> /dev/null)
        echo $tag > .hg/tag
    else
        tag=$(cat .hg/tag 2> /dev/null)
    fi

    echo -n "[$branch:$tag] "
}
PS1="$color_yellow\$(hg_revision)\$(__git_ps1 '(%s) ')$color_reset$PS1"

# Command line fuzzy finder, to make life easier
# https://github.com/junegunn/fzf#using-git
# Probably want to `apt-get install highlight tree` as well
export FZF_CTRL_T_OPTS="--preview '[ -f {} -o -d {} ] && (highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
export FZF_COMPLETION_OPTS="$FZF_CTRL_T_OPTS --preview-window hidden --bind '?:toggle-preview'"
[ -f ~/.fzf.bash ] && source ~/.fzf.bash


# NPM packages
export PATH="$PATH:$HOME/.npm_packages/bin"
