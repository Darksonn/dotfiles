#!/bin/bash
setxkbmap -option caps:backspace
setxkbmap -option compose:rctrl
setxkbmap -option bksp:bksp_escape
xset m 4/1 1
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
if [ "$WM" == "" ]; then
  log=~/.log
  i3 >& "$log"
  unset log
else
  log=~/.log
  echo "Using log file $log"
  exec $WM > "$log" 2>&1
  unset log
fi

