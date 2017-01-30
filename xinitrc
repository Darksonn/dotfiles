#!/bin/bash
~/dotfiles/keymap.sh
xset m 4/1 1
xbindkeys &
export GTK_IM_MODULE=xim
export XMODIFIERS="@im=none"
(sleep 300; /opt/dropbox/dropboxd) &
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
[[ -f ~/background ]] && feh --bg-scale ~/background
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

