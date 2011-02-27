#!/bin/bash

BACKUPDIR=$HOMEDIR/backups/

echo "This will backup the bash configuration files in your home directory and replace them with symlinks to the best-bash system."

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

choice "Do you wish to continue [Y/n]: " "y"
if [ "$CHOICE" != "y" ]; then
  if [ "$CHOICE" = "n" ]; then
    echo "Quitting. Your files are unnafected"
    exit
  fi
  if [ "$CHOICE" != "n" ] || [ "$CHOICE" != "y" ] ; then
    echo "I didn't understand, $CHOICE. Quiting."
    exit
  fi
fi

echo "Working"
#.profile
#mv ~/.profile $BACKUPDIR
#ln -s $HOMEDIR/profile.sh ~/.profile

#.bashrc
#mv ~/.bashrc $BACKUPDIR
#ln -s $HOMEDIR/bashrc.bash ~/.bashrc

#.bash_profile
#mv ~/.bash_profile $BACKUPDIR
#ln -s $HOMEDIR/bash_profile.bash ~/.bash_profile

#.bash_logout
#mv ~/.bash_logout $BACKUPDIR
#ln -s $HOMEDIR/bash_logout.bash ~/.bash_logout
