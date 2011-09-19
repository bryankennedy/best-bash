#!/usr/bin/env bash
############################################################
# bash_profile.sh
# 
# This file is primarily for routing conditional situations.
# This file is loaded first in "Interactive login" shells.
# This includes:
#   SSH or tty sessions on Linux
#   Every new terminal window in OS X
############################################################
HOMEDIR=$HOME/.dotfiles/best-bash

# Include bashrc
. $HOMEDIR/bashrc.sh
