# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Theme
ZSH_THEME='robbyrussell'

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
alias nvimc="nvim -c 'Neotree' -c 'lua require([[telescope.builtin]]).oldfiles({only_cwd = true})'"
alias vif="nvim \$(fzf --preview 'bat --style=numbers --color=always --line-range :500 {}')"
alias sudop='sudo -E env "PATH=$PATH"' # Save PATH for sudo
alias fzf='fzf --multi'
alias bat="batcat"
alias zshcfg="nvim ~/.zshrc"
alias trl="tree -LhaC 3"
alias cdfc="cd \$(find * -type d | fzf)"
alias cdfh="cd \$(find ~ -type d | fzf)"

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

# Git

## Stash && checkout main && pull && create new branch and checkout
alias ghf="gstu && gcm && gl && gcb"

## Branch
unalias gb; function gb {
  if [ $# -eq 0 ]
  then
    echo $(git branch | fzf) | xargs
  else
    git branch $@
  fi
}
## Branch all
unalias gba; function gba {
  echo $(git branch -a | fzf) | xargs | sed 's/remotes\/origin\///'
}
### Branch delete
unalias gbd; function gbd {
  BRANCH=$(gb)
  [ ! -z "$BRANCH" ] && git branch -d $BRANCH
}
### Branch force delete
unalias gbD; function gbD {
  BRANCH=$(gb) 
  [ ! -z "$BRANCH" ] && git branch -D $BRANCH
}

### Checkout
unalias gco; function gco {
  if [ $# -eq 0 ]
  then
   BRANCH=$(gb)
  else
   BRANCH=$@
  fi
  [ ! -z "$BRANCH" ] && git checkout $BRANCH
}
### Checkout all
function gcoa {
  if [ $# -eq 0 ]
  then
    BRANCH=$(gba)
  else
    BRANCH=$@
  fi
  git checkout $BRANCH
}

## Stash
unalias gstl; function gstl {
  echo $(git stash list --format='%gd{%ch}: %gs' | fzf) | sed 's/stash@{//' | sed 's/}{.*//'
}
## Stash delete
unalias gstd; function gstd {
  STASH_INDEX=$(gstl)
  [ ! -z "$STASH_INDEX" ] && git stash drop $STASH_INDEX
}
## Stash apply
function gsai {
  STASH_INDEX=$(gstl)
  [ ! -z "$STASH_INDEX" ] && git stash apply --index $STASH_INDEX
}

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
