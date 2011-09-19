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

############################################################
# OS
############################################################
if [ "{$OS}" == "Darwin" ]; then
  OS=mac
else
  OS=linux
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
# Window
############################################################
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

############################################################
# Less
############################################################
# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

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

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
