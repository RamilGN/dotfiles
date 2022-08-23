# path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# theme
ZSH_THEME="robbyrussell"

# plugins
plugins=(git vi-mode asdf)

# oh-my-zsh
source $ZSH/oh-my-zsh.sh

# ls highlighting
export LS_COLORS=$LS_COLORS:"ow=36:"

# vim bindings
bindkey -v

# vim as default editor
export EDITOR=nvim
export VISUAL=nvim

# go
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# aliases
alias sudo='sudo -E env "PATH=$PATH"' # Save PATH for sudo
alias bat="batcat"
alias zshcfg="nvim ~/.zshrc"
alias trl="tree -LhaC 3"
alias cdf="cd \$(find * -type d | fzf)"
alias vif="nvim \$(fzf --preview 'bat --style=numbers --color=always --line-range :500 {}')"

## git
alias gsai="git stash apply --index"

# insales
LETSDEV_REPO=$HOME/insales/letsdev2
if [ -d $LETSDEV_REPO ]
then
  export LETSDEV_REPO
  alias letsdev=$LETSDEV_REPO/letsdev.rb
  alias insales='docker-compose exec -e COLUMNS="`tput cols`" -e LINES="`tput lines`" -u 1000 -w /home/app/code insales bash'
  alias 1c_synch="docker-compose exec -u 1000 -w /home/app/code 1c_sync bash -l"
  . $LETSDEV_REPO/bash-completions

  function tshssh {
    TERM=xterm-256color tsh ssh $1
  }

  function tshssht {
    TERM=xterm-256color tsh ssh -t $1 tmux new-session -As ramilg
  }
fi
