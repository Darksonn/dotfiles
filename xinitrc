#!/bin/bash
if [ "$WM" == "" ]; then
  setxkbmap -option caps:escape
  setxkbmap -option compose:rctrl
  setxkbmap -option bksp:bksp_escape
  if [ -f ~/.awesome_config ]; then
    export awesomeconfig=$(cat ~/.awesome_config)
  else
    export awesomeconfig=/home/user/.config/awesome
  fi
  awesomelog=/var/log/awesome/awesome.log
  echo "Using log file $awesomelog"
  (xrdb -merge ~/.Xresources && exec awesome -c "$awesomeconfig") >& "$awesomelog"
  unset awesomeconfig awesomelog
else
  log=~/.log
  echo "Using log file $log"
  exec "$WM" > "$log" 2>&1
  unset log
fi

