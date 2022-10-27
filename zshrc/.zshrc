# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Theme
ZSH_THEME="robbyrussell"

# Plugins
plugins=(
  asdf
  docker
  docker-compose
  git
  kubectl
  vi-mode
  zsh-syntax-highlighting
)

# Oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Vim bindings
bindkey -v

# Vim as default editor
export EDITOR=nvim
export VISUAL=nvim

# Go
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Aliases
alias sudo='sudo -E env "PATH=$PATH"' # Save PATH for sudo
alias fzf='fzf --multi'
alias bat="batcat"
alias zshcfg="nvim ~/.zshrc"
alias trl="tree -LhaC 3"
alias cdfc="cd \$(find * -type d | fzf)"
alias cdfh="cd \$(find ~ -type d | fzf)"
alias vif="nvim \$(fzf --preview 'bat --style=numbers --color=always --line-range :500 {}')"
alias vi='nvim --noplugin'

# Docker

## Containers

### List running
unalias dcls
function dcls {
  CONTAINER=($(docker container ls | fzf))
  CONTAINER_ID=$CONTAINER[1]
  echo $CONTAINER_ID
}

### List all
unalias dclsa
function dclsa {
  CONTAINER=($(docker container ls -a | fzf))
  CONTAINER_ID=$CONTAINER[1]
  echo $CONTAINER_ID
}

### Exec on any conatiner
unalias dxcit
function dxcit {
  PROG=${1:-sh}
  CONTAINER_ID=$(dclsa)
  docker container exec -it $CONTAINER_ID $PROG 2> /dev/null || (docker container start $CONTAINER_ID && docker container exec -it $@ $CONTAINER_ID $PROG)
}

### Start
unalias dst
function dst {
  CONTAINER_ID=$(dclsa)
  docker container start $@ $CONTAINER_ID
}

### Stop
unalias dstp
function dstp {
  CONTAINER_ID=$(dcls)
  docker container stop $@ $CONTAINER_ID
}

## Git
alias gsai="git stash apply --index"
alias ghf="gstu && gcm && gl && gcb"

unalias gstl
alias gstl="git stash list --format='%gd{%ch}: %gs'"

# Insales
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
