# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="robbyrussell"

# Plugins
plugins=(git vi-mode asdf)

# Oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Vim bindings
bindkey -v

# Vim as default editor
export EDITOR=nvim
export VISUAL=nvim

# For ssh
export TERM=xterm-256color

# GO
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Aliases
alias sudo='sudo -E env "PATH=$PATH"' # Save PATH for sudo
alias b="batcat"
alias v="nvim"
alias zshcfg="nvim ~/.zshrc"

# Job: InSales
LETSDEV_REPO=$HOME/insales/letsdev2
if [ -d LETSDEV_REPO ]
then
  export LETSDEV_REPO
  alias letsdev=$LETSDEV_REPO/letsdev.rb
  alias insales='docker-compose exec -e COLUMNS="`tput cols`" -e LINES="`tput lines`" -u 1000 -w /home/app/code insales bash'
. $LETSDEV_REPO/bash-completions
fi

