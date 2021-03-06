#!/bin/zsh
alias listprinters='lpstat -p -d'
# add the mdcd command, which makes a directory and then cds into it
function mdcd {
  mkdir -- "$1"
  cd "$1"
}
function pdfcat {
  out="$1"
  shift
  gs -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -sOutputFile="$out" "$@"
}
# replacement for cp, also works with ssh
alias c='rsync -avz --info=progress2'
alias cdn='cd /home/user/Dropbox/htx/noter/'

