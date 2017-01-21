#!/bin/zsh
if [ "$(id -u)" != "0" ]; then
  if [ "$(pwd)" = "/home/user" ]; then
    # open the shell in the same directory as last directory, and print files in current directory when cding into it
    if [ -f ~/.lastdir ]; then
      cd "`cat ~/.lastdir`"
    fi
    export LASTDIR="/"
  fi
fi
function chpwd {
  pwd > ~/.lastdir
  newdir=`pwd`
  if [ ! "$LASTDIR" = "$newdir" ]; then
    ls -tCF --color=yes --width=`tput cols` | head -7
  fi
  export BEFOREDIR="$LASTDIR"
  export LASTDIR="$newdir"
}
