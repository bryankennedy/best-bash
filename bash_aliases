###############################################################################
# Shorthand
###############################################################################
alias c='clear'
alias xx="exit"

###############################################################################
# Listing
###############################################################################
# List normal files
alias l='ls -lh'
# List everything, including hidden files
alias ll='ls -lah'
# List for wildcard searches without all those subdir files
alias lw='ls -lahd'

###############################################################################
# Changing directories
###############################################################################
# Shorthand navigation
alias ..='cd ..'
alias ...='cd ../..'
# Compress the cd, ls -l series of commands.
function cl () {
   if [ $# = 0 ]; then
      cd && ll
   else
      cd "$*" && ll
   fi
}
# Alias for common miss-type
alias lc="cl"
# Compress the mkdir > cd into it series of commands
function mc() {
  mkdir -p "$*" && cd "$*" && pwd
}


###############################################################################
# OS X Specific Tools
###############################################################################
if [ $OS = "MacOS" ]; then
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
fi

###############################################################################
# Git 
###############################################################################
alias gs='git status'
alias gc='git commit'
alias gco='git checkout'
alias gd='git diff'
alias gps='git push'
alias gpsd='git push origin develop'
alias gpsm='git push origin master'
