#!/usr/bin/env bash
############################################################
# profile.sh
# Environment settings that apply to all shells.
############################################################

HOMEDIR=$HOME/.dotfiles/best-bash

# Include conf file
. $HOMEDIR/conf

############################################################
# Editors
############################################################

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
export PATH=/Applications/MacVim:$PATH
export PATH=/opt/subversion/bin:$PATH
