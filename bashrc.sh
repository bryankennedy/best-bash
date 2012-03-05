#!/usr/bin/env bash
############################################################
# bashrc.sh
#
# This is the primary bash configuration for all shells.
#
# Linux GUI
# On Linux machines bash automatically loads this file
# first for non-login shells (GUI windows when you are
# actually sitting at the computer).
#
# OS X GUI
# OS X does treats each new Terminal window as an interactive
# login shell, so this file would not normally be loaded.
# To work around this wierdness, this bashrc file is included
# from the bash_profile file.
#
# Linux & OS X SSH
# This file would not normally be loaded in a SSH session.
# So this file is included from the bash_profile file.
############################################################

############################################################
# Setup
############################################################
# SCP
# If not running interactively, don't do anything
# This prevents these rules from being loaded for non-interactive
# sessions like scp.
[ -z "$PS1" ] && return

HOMEDIR=$HOME/.dotfiles/best-bash

lowercase(){
  echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/"
}

############################################################
# OS
############################################################
OS=`lowercase \`uname\``
if [ $OS == "darwin" ]; then
  OS='mac'
else
  OS='linux'
fi

############################################################
# On login
############################################################
echo -e "Uptime: `uptime`"

############################################################
# Editors
############################################################
EDITOR='vim'
export VISUAL=$EDITOR
export GIT_EDITOR=$EDITOR
export SVN_EDITOR=$EDITOR

############################################################
# Path definitions
############################################################
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=/usr/local/mysql/bin:$PATH
export PATH=/opt/local/bin:$PATH
export PATH=/opt/local/sbin:$PATH
# TODO conditional
export PATH=/Applications/MacVim:$PATH
export PATH=/opt/subversion/bin:$PATH

############################################################
# Useful variables
############################################################
export DATE=$(date +%Y-%m-%dT%H:%M:%S%z)

############################################################
# Prompt
############################################################
# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

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

# If you edit the prompt at all, make sure to escape any
# non-printing characters with:
# \[033[ and \]
# If you don't do this, the prompt will look like it is working
# but there will be problems with CTRL-r history searches.
# See:
# http://tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html
# http://serverfault.com/questions/224306/why-does-ctrl-r-act-weirdly-showing-only-part-of-a-command-on-os-x
#
# This explains why we set the TERM to xterm
# http://stackoverflow.com/questions/35563/how-do-i-make-bash-reverse-search-work-in-terminal-app-without-it-displaying-garb
#
# Git completion scripts provide branch names in PS1 thus:
# http://blog.bitfluent.com/post/27983389/git-utilities-you-cant-live-without
export TERM=xterm
PS1='\[\033\n\[\[\033[1;31m\]\#\[\033[0m\] \[\033[1;35m\]\u\[\033[0m\]@\[\033[1;33m\]\h\[\033[0m\]$(__git_ps1 "\[\033[1;31m\] (%s)\[\033[0m\] "):\[\033[1;34m\]\w\[\033[0m\] \$ '

############################################################
# Color
############################################################
# Set terminal colors
export CLICOLOR=1
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

############################################################
# History
############################################################
# Don't put duplicate lines in the history.
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it
shopt -s histappend

# Large command history file
HISTFILESIZE=1000000000
HISTSIZE=1000000

############################################################
# Autocompletion
############################################################
# Help bash autocomplete filenames starting with dots
shopt -s dotglob

# Ignore case
bind "set completion-ignore-case on"
if [ -f /opt/local/etc/bash_completion ]; then
     . /opt/local/etc/bash_completion
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# TODO combine the two conditionals above

# Autocomplete hostnames
complete -W "$(echo `cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | sed -e 's/,.*//g' | uniq | grep -v "\["`;)" ssh

############################################################
# Security
############################################################
# Close root after n seconds of inactivity
[ "$UID" = 0 ] && export TMOUT=180

############################################################
# Window
############################################################
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

############################################################
# Less
############################################################
# Less is more
export PAGER="less"

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

############################################################
# Includes
############################################################
# Aliases
. $HOMEDIR/bash_aliases.sh

# Include bash scripts in the includes folder
source $HOMEDIR/includes/git-completion.sh

# Load custom defintions
#
# These are defined in a seperate folder that is ignored
# by the best-bash Git repo, and customized across multiple
# deploys of this bash profile.
# Since they are in their own folder, they can even be a
# seperate Git repo themselves.
shopt -s nullglob
files=($HOMEDIR/custom/*)
if [ ${#files[@]} -gt 0 ]; then
  for f in $HOMEDIR/custom/*
  do
    . $f
  done
fi
