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
# Config
files=$BASHDIR/conf/bash.conf
if [ -e $files ]; then
  source $files
fi

# SCP
# If not running interactively, don't do anything
# This prevents these rules from being loaded for non-interactive
# sessions like scp.
[ -z "$PS1" ] && return

# The install script creates this symlink to the best-bash system
BASHDIR=$HOME/.best-bash

lowercase(){
  echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/"
}

#
# Detect SHH session
#
# Useful for omitting some features over a SSH connection
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  SESSION_TYPE='remote/ssh'
else
  SESSION_TYPE='local'
fi


############################################################
# Detect OS
############################################################
OS=`lowercase \`uname\``
if [ $OS == "darwin" ]; then
  OS="mac"
elif [ $OS == "MINGW32_NT-6.1" ]; then
  OS="win"
else
  OS="linux"
fi

############################################################
# Editors
############################################################
# Set vim as the default editor for things like Git commits
export EDITOR='vim'

############################################################
# Path definitions
############################################################
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=/usr/local/mysql/bin:$PATH

############################################################
# Useful variables
############################################################
timestamp() {
  date +%Y-%m-%dT%H:%M:%S%z
}

############################################################
# Prompt
############################################################
# If you edit the prompt at all, make sure to escape any
# non-printing characters with:
# \[033[ and \]
#
# If you don't do this, the prompt will look like it is working
# but there will be problems with CTRL-r history searches.
# See:
# http://tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html
# http://serverfault.com/questions/224306/why-does-ctrl-r-act-weirdly-showing-only-part-of-a-command-on-os-x
#
# Git completion scripts provide branch names in PS1 thus:
# http://blog.bitfluent.com/post/27983389/git-utilities-you-cant-live-without

# Sourcing a modified version of Todd Wolfson's sexy-bash-prompt.
# Only enable some Git PS1/prompt features on remote connections.
# Git features can be slow and we don't want to slow down a remote connection.
if [ $SESSION_TYPE == "local" ]; then
  PROMPT_GIT_FEATURES="full"
elif [ $SESSION_TYPE == "remote/ssh" ]; then
  PROMPT_GIT_FEATURES="branch"
else
  PROMPT_GIT_FEATURES="none"
fi

# Basic prompt for deploy and root users
if [ $USER == "deploy" ] || [ $UID == 0 ] ; then
  PROMPT_GIT_FEATURES="none"
fi

source $BASHDIR/bash_prompt.sh

############################################################
# Color
############################################################
# Set terminal colors
export CLICOLOR=1

# Enable color support of ls and also add handy aliases
# This is most useful on linux systems
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
# Don't write duplicate lines in the bash_history
export HISTCONTROL=ignoredups

# Append to the history file, don't overwrite it. This will cause some
# duplicates, even with the setting above since t a new history setting is
# saved with each session.
shopt -s histappend

# Large command history file
HISTFILESIZE=1000000
HISTSIZE=10000

############################################################
# Autocompletion
############################################################
# Help bash autocomplete filenames starting with dots
shopt -s dotglob

# Ignore case with autocompletion
bind "set completion-ignore-case on"

# Autocomplete hostnames from the host file
if [ -e ~/.ssh/known_hosts ]; then
  complete -W "$(echo `cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | sed -e 's/,.*//g' | uniq | grep -v "\["`;)" ssh
fi

# Autocomplete git commands and branch names
source $BASHDIR/includes/git-completion.sh

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
# Paging
############################################################
# On a Mac, I'm mostly using iTerm which has nice scrolling
# and a search feature, so I don't care about paging output.
# So I set the pager to cat. On Linux and SSH sessions, I
# probably still want the help of a pager, so I use less.
if [ "$OS" = "mac" ]; then
  export PAGER=cat
else
  export PAGER="less"
fi

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# If iTerm integration is installed, then link load it.
if [ "$OS" = "mac" ]; then
  test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
fi

############################################################
# Includes
############################################################
# Aliases
source $BASHDIR/bash_aliases.sh

# Auto-complete Python Fabric tasks
source $BASHDIR/includes/fabric-completion.bash

# Load custom defintions
#
# These are defined in a seperate folder that is ignored
# by the best-bash Git repo, and customized across multiple
# deploys of this bash profile.
# Since they are in their own folder, they can even be a
# seperate Git repo themselves.
shopt -s nullglob
files=($BASHDIR/custom/*)
if [ ${#files[@]} -gt 0 ]; then
  for f in "${files[@]}"
  do
    source $f
  done
fi
shopt -u nullglob

#
# MacVim Setup
#
# If we're on a Mac and mvim is present, then hijack the vi symlink to mvim
# and pass the --remote-tab-silent paramater so that new `vi filename`
# requests open in the same window with a new tab.
#
# This needs to live down here at the bottom of the script so that we get
# any custom paths set for the which command. I am loading MacVim with Boxen,
# and that path is defined in my custom loads.
vipath=$(which mvim 2> /dev/null) # Silence errors if not present
rc=$?
if [ "$OS" = "mac" ]; then
  if [[ $rc == 0 ]]; then
    vi(){
      if [ $1 ]; then
        $vipath --remote-tab-silent $1
      else
        $vipath
      fi
    }
  fi
fi
