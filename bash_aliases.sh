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
# Prevent xQuartz from trying to run, when typing this common typo
alias x=:
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

# Shortcuts to the Mac OS Spotlight commands
if [ "$OS" = "mac" ]; then
  alias f='mdfind -onlyin . -name '
  alias fs='mdfind -onlyin . '
fi

###############################################################################
# Changing directories
###############################################################################

# Correct simple cd spelling mistakes
shopt -s cdspell

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

# Compress mkdir, and then cd'ing into it, into a single shortcut
function mc() {
  mkdir -p "$*" && cd "$*" && pwd
}

###############################################################################
# Rsync
#
# -a = --archive - Recursive, and preserve file attributes.
# -v = --verbose - List the files that are being transfered.
# -z = --compress - Compress data before the transfer.
# -h = --human-readable - Output file sizes in MB, GB, etc, not just bytes.
# --progress = Show the progress of the transfer so that we feel warm and fuzzy
#
###############################################################################
alias rsc='rsync -avzh --progress --exclude ".DS_Store"'

###############################################################################
# Extracting
###############################################################################
extract () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xvjf $1    ;;
      *.tar.gz)    tar xvzf $1    ;;
      *.tgz)       tar xvzf $1    ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xvf $1     ;;
      *.tbz2)      tar xvjf $1    ;;
      *.tgz)       tar xvzf $1    ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)           echo "'$1' cannot be extracted via >extract<" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

###############################################################################
# OS X Specific Tools
###############################################################################
if [ $OS == 'mac' ]; then
  # Replicate the tree function on OS X
  # TODO - wrap this in a conditional
  #        some of these flags are pretty OS X specific
  alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
  # Copy curent directory to clipboard

  # Quicker smaller top
  # -R don't show memory
  # -F don't show frameworks
  # -s loop every two seconds
  # -n show 30 processes
  alias topp='top -ocpu -R -F -s 2 -n30'

  # Copy curent directory to clipboard
  alias cpwd='printf "%q\n" "$(pwd)" | pbcopy'

  # Dump man pages to Preview
  pman() {
    man -t "${1}" | open -f -a /Applications/Preview.app/
  }

  # Aliases for MacVim if it exists
  vipath=$(which mvim 2> /dev/null)
  if [ ! -z $vipath  ] ; then
    alias vi="mvim"
    alias vim="mvim"
  fi

  # Easy command to start and stop PostgreSQL server
  if [ -d /usr/local/var/postgres ] ; then
    alias pgs='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
    alias pgq='pg_ctl -D /usr/local/var/postgres stop -s -m fast'
  fi

  # Correct puppet version
  export PATH=/opt/puppetlabs/bin:$PATH

fi

###############################################################################
# Vim
###############################################################################
# Even if you aren't on MacOS, never use vi, always use vim
#if [ $OS != "mac" ]; then
# alias vi="vim"
#fi

# ci is a command for the RCS VCS. I don't use it. But I often mistype vi
# as ci, so I'm aliasing it to prevent that.
alias ci="vi"

###############################################################################
# Atom & WebStorm
###############################################################################
# Less is more
if [ -e /usr/local/bin/atom ]; then
  alias a="atom"
fi

if [ -e /usr/local/bin/wstorm ]; then
  alias ws="wstorm"
fi

###############################################################################
# Git
###############################################################################
# Removing the -b flag
# It isn't supported until Git 1.7.2 which isn't common in CentOS and other
# Linux rpms just yet. So, removing this makes this bash profile a bit more
# portable for now.
# alias gs='git status -sb'
alias gs='git status -s'

alias gc='git commit -v'
alias ga='git add'
alias gap='git add -p'
# Common typo
alias gao='git add -p'
alias gapi='git -c interactive.diffFilter="git diff --color-words" add -p'
alias gaa='git add -A'
alias gco='git checkout'
alias gl='git log --oneline --decorate --color=always | less -R'
alias gd='git diff'
alias gdt='git difftool'
alias gps='git push'
alias gpsm='git push origin master'
alias gpsmt='git push origin master --tags'
alias gpsd='git push origin develop'
alias gpl='git pull'
alias gplm='git pull origin master'
alias gpld='git pull origin develop'
alias gf='git fetch'
alias gb='git branch'
alias gba='git branch -a -v -v'
alias gun='git reset HEAD'             # Unstage added changes
alias gbc='git checkout -b'
alias gsh='git stash save -u'
alias gshl='git stash list --date=relative'
# Delete branches that have been merged to master
alias gclean='git branch --merged master | grep -v "\* master" | xargs -n 1 git branch -d'
#alias git-permission-reset='!git diff -p -R | grep -E \"^(diff|(old|new) mode)\" | git apply'
alias not-git='git status --ignored'

# Opens the github page for the current git repository in your browser
# from https://github.com/jasonneylon/dotfiles/
function gh() {
  giturl=$(git config --get remote.origin.url)
  if [ "$giturl" == "" ]
  then
    echo "Not a git repository or no remote.origin.url set"
  else
    giturl=${giturl/git\@github\.com\:/https://github.com/}
    giturl=${giturl/\.git//}
    echo $giturl
    open $giturl
  fi
}

# Open a local development site in the browser when called from within
# a folder in the ~/Sites or ~/www directory
function dev() {
  result=${PWD##*/}
  open "http://$result.dev"
}

###############################################################################
# Networking
###############################################################################
# List all open ports where you are listening
alias ports='netstat -tulpn | grep LISTEN'
# List open internet connections
alias net-open='lsof -i'
alias myip="dig TXT +short o-o.myaddr.l.google.com @ns1.google.com | awk -F'\"' '{ print $2}'"

###############################################################################
# Generate random files
###############################################################################
# TODO: write command to make a random text file
#alias gent =
alias geni='convert -size 100x100 xc: +noise Random random.png'

###############################################################################
# Reload bash
###############################################################################
# TODO fix
alias reload='. ~/.bash_profile'
