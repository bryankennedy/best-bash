#!/usr/bin/env bash
############################################################
# install.sh
# Install script for best-bash system.
#
# Replaces your home directory bash settings with the
# best-bash system.
#
# Designed to be run after you create a conf file from
# conf.sample.
############################################################

BASHDIR=${PWD}
BACKUPDIR=$BASHDIR/backups
CUSTOMDIR=$BASHDIR/custom

############################################################
# Ask for Y/n input with a default option
#
# Returns the user's choice
############################################################
function choice {
  CHOICE=' '
  local prompt="$1"
  local default="$2"
  local answer

  #Ask the question
  read -p "$prompt" answer

  # Interpret no answer as the default answer
  [ -z $answer ] && answer="$default"

  # Check the answer. Case insensitve.
  # Dump non-conforming answers to a variable for error messages.
  case "$answer" in
    [yY1] ) CHOICE='y';;
    [nN0] ) CHOICE='n';;
    *     ) CHOICE="$answer";;
  esac
}

############################################################
# Instructions
############################################################
echo "This script will delete any (.profile, .bashrc, .bash_profile,"
echo "and .bash_logout) files in your home directory."
echo "NO BACKUP WILL BE MADE!"

# If NO, or error
choice "Do you wish to continue [Y/n]: " "y"
if [ "$CHOICE" != "y" ]; then
  if [ "$CHOICE" = "n" ]; then
    echo "Quitting. Your files are unafected"
    exit
  fi
  echo "I didn't understand, $CHOICE. Quiting."
  exit
fi

############################################################
# Delete home files
############################################################
# Clean out home dir
bash_files=( profile bashrc bash_profile bash_logout bash_aliases best-bash )
for bash_file in ${bash_files[@]}
do
  if [ -f "$HOME/.$bash_file" ] || [ -h "$HOME/.$bash_file" ]; then
    rm -rf $HOME/.$bash_file
  fi
done

echo "Uninstalled"
