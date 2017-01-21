# completions
fpath+=~/.zfunc

# history
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory

# beep: shut up
# notify: don't tell me if a job exists while another job is running
unsetopt beep notify

# syntax highlighting enabled
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

for f in ~/dotfiles/rc/*.sh; do source "$f"; done

PROMPT="%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg_no_bold[yellow]%}%1~ %{$reset_color%}%# "
#PROMPT="%n@%m %1~ %# "
