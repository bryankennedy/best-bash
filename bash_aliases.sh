#!/usr/bin/env bash
###############################################################################
# bash_aliases.sh
# Useful bash aliases
###############################################################################

###############################################################################
# Shorthand
###############################################################################
alias c='clear'
alias g='grep'
alias xx="exit"
# Ask before doing anything dangerous
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"
# Readable path
alias path='echo -e ${PATH//:/\\n}'

###############################################################################
# Listing
###############################################################################
# List normal files
alias l='ls -lh'
# List everything, including hidden files
alias ll='ls -hal'
# List everything, by reverse date
alias lld='ls -thral'
# List for wildcard searches without all those subdir files
# usage:
#     lw thi*
#     lw *.txt
alias lw='ls -dhal'

###############################################################################
# Searching
###############################################################################
function findin () {
  find . -exec grep -q "$1" '{}' \; -print
}

###############################################################################
# Changing directories
###############################################################################
# Shorthand navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
# Compress the cd, ls -l series of commands.
function cl () {
   if [ $# = 0 ]; then
      cd && l
   else
      cd "$*" && l
   fi
}
# Alias for common miss-type
alias lc="cl"
# Compress the mkdir > cd into it series of commands
function mc() {
  mkdir -p "$*" && cd "$*" && pwd
}

###############################################################################
# Extracting
###############################################################################
extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1        ;;
            *.tar.gz)    tar xvzf $1     ;;
            *.tgz)    tar xvzf $1     ;;
            *.bz2)       bunzip2 $1       ;;
            *.rar)       unrar x $1     ;;
            *.gz)        gunzip $1     ;;
            *.tar)       tar xvf $1        ;;
            *.tbz2)      tar xvjf $1      ;;
            *.tgz)       tar xvzf $1       ;;
            *.zip)       unzip $1     ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1    ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

###############################################################################
# OS X Specific Tools
###############################################################################
if [ $OS = "mac" ]; then
  # Replicate the tree function on OS X
  # TODO - wrap this in a conditional
  #        some of these flags are pretty OS X specific
  alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
  # Copy curent directory to clipboard

  # Quicker smaller top
  alias topp='top -ocpu -R -F -s 2 -n30'

  # Copy curent directory to clipboard
  alias cpwd='pwd|xargs echo -n|pbcopy'

  # Dump man pages to Preview
  pman() {
    man -t "${1}" | open -f -a /Applications/Preview.app/
  }

  # Vim
  alias vi="mvim"
fi

###############################################################################
# Vim
###############################################################################
# Even if you aren't on MacOS, never use vi, always use vim
if [ $OS != "mac" ]; then
  alias vi="vim"
fi

###############################################################################
# Git
###############################################################################
alias gs='git status -s -b'
alias gc='git commit -v'
alias ga='git add'
alias gaa='git add -A'
alias gco='git checkout'
alias gd='git diff'
alias gps='git push'
alias gpsm='git push origin master'
alias gpsd='git push origin develop'
alias gpl='git pull'
alias gplm='git pull origin master'
alias gpld='git pull origin develop'
alias gb='git branch'

###############################################################################
# Reload bash
###############################################################################
# TODO fix
alias reload='. ~/.bash_profile'
