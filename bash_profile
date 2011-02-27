############################################################
# Bash settings
############################################################
# Set terminal colors
Export CLICOLOR=1

# Large command history file
hISTFILESIZE=1000000000
HISTSIZE=1000000

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
export TERM=xterm
PS1='\[\033[1;31m\]\#\[\033[0m\] \[\033[1;35m\]\u\[\033[0m\]@\[\033[1;33m\]\h\[\033[0m\]:\[\033[1;34m\]\w\[\033[0m\] \$ ' 

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

############################################################
# Alias definitions 
############################################################
if [ -f $HOMEDIR/bash_aliases ]; then
    . $HOMEDIR/bash_aliases
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
if [ -d $HOMEDIR/custom ]; then
    . $HOMEDIR/custom/*
fi

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
