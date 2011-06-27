#!/usr/bin/env bash
############################################################
# bash_profile.sh
# Interactive bash shell settings
############################################################
HOMEDIR=$HOME/.dotfiles/best-bash

# Include conf file
. $HOMEDIR/conf

# Include bashrc and profile settings
. $HOMEDIR/bashrc.sh
. $HOMEDIR/profile.sh

############################################################
# Bash settings
############################################################
# Set terminal colors
export CLICOLOR=1

# Close root after n seconds of inactivity
[ "$UID" = 0 ] && export TMOUT=180

# Less is more
export PAGER="less"

############################################################
# Bash prompt
############################################################
# If you edit the prompt at all, make sure to escape any characters
# that don't print. It will look like your prompt is working
# but will cause problems with CTRL-r history searches.
# See:
# http://tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html
# http://serverfault.com/questions/224306/why-does-ctrl-r-act-weirdly-showing-only-part-of-a-command-on-os-x
# This explains why we set the TERM to xterm
# http://stackoverflow.com/questions/35563/how-do-i-make-bash-reverse-search-work-in-terminal-app-without-it-displaying-garb
# Git completion scripts provide branch names in PS1 thus:
# http://blog.bitfluent.com/post/27983389/git-utilities-you-cant-live-without
export TERM=xterm
PS1='\[\033[1;31m\]\#\[\033[0m\] \[\033[1;35m\]\u\[\033[0m\]@\[\033[1;33m\]\h\[\033[0m\]$(__git_ps1 "\[\033[1;31m\] (%s)\[\033[0m\] "):\[\033[1;34m\]\w\[\033[0m\] \$ '

############################################################
# Alias definitions
############################################################
if [ -f $HOMEDIR/bash_aliases.sh ]; then
    . $HOMEDIR/bash_aliases.sh
fi

############################################################
# Custom defintions
#
# These are defined in a seperate folder that can be ignored
# by this Git repo, and customized across multiple deploys
# of this bash profile.
# Since they are in their own folder, they can even be a
# seperate Git repo themselves.
############################################################
shopt -s nullglob
shopt -s dotglob
files=($HOMEDIR/custom/*)
if [ ${#files[@]} -gt 0 ]; then
  for f in $HOMEDIR/custom/*
  do
    . $f
  done
fi
shopt -u nullglob

############################################################
# Autocompletion
############################################################
# Ignore case
bind "set completion-ignore-case on"
if [ -f /opt/local/etc/bash_completion ]; then
     . /opt/local/etc/bash_completion
fi

# Autocomplete hostnames
complete -W "$(echo `cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | sed -e s/,.*//g | uniq | grep -v "\["`;)" ssh

############################################################
# On login
############################################################
echo -e "Uptime: `uptime`"
