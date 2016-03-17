#!/bin/zsh
function start_agent {
  echo "Initializing new SSH agent..."
  # spawn ssh-agent
  /usr/bin/ssh-agent -t 43200 | sed 's/^echo/#echo/' > "${SSH_ENV}"
  echo succeeded
  chmod 600 "${SSH_ENV}"
  . "${SSH_ENV}" > /dev/null
  /usr/bin/ssh-add
}
if [ "$(id -u)" != "0" ]; then
  # the ssh-agent for encrypted ssh keys
  SSH_ENV=$HOME/.ssh/environment
  if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent > /dev/null || {
      start_agent;
    }
  else
    start_agent;
  fi

fi
