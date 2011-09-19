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

HOMEDIR=$HOME/.dotfiles/best-bash
BACKUPDIR=$HOMEDIR/backups

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
echo "This script will replace your home directory bash files"
echo "(.profile, .bashrc, .bash_profile, and .bash_logout)"
echo "with symlinks to the best-bash system."
echo "Your bash files will be moved to the best-bash/backups directory."

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
# Backup home files
############################################################
if [ ! -d $BACKUPDIR ]; then
  mkdir $BACKUPDIR
fi

date_string=$(date '+%Y_%m_%d_%H_%S')

# Clean out home dir
bash_files=( profile bashrc bash_profile bash_logout bash_aliases )
for bash_file in ${bash_files[@]}
do
  if [ -f "$HOME/.$bash_file" ]; then
    mv $HOME/.$bash_file $BACKUPDIR/${bash_file}_${date_string}
  fi
done

# Link to new files
# We skip bash_aliases here since it's inlcuded in the profil
bash_files=( bashrc bash_profile bash_logout )
for bash_file in ${bash_files[@]}
do
  ln -s $HOMEDIR/$bash_file.sh ~/.$bash_file
done

############################################################
# Create the custom folder for personalization
############################################################
CUSTOMDIR=$HOMEDIR/custom
if [ ! -d $CUSTOMDIR ]; then
  mkdir $CUSTOMDIR
fi

echo "Installed"
