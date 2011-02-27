#!/bin/bash
############################################################
# profile.sh
# Environment settings that apply to all shells.
############################################################

# Include conf file
. ./conf

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
