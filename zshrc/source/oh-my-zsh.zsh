export ZSH=$HOME/.oh-my-zsh

# Theme
ZSH_THEME='robbyrussell'

# No lazy keymaps for zsh-vi-mode
ZVM_INIT_MODE=sourcing

# Plugins
plugins=(
  asdf
  docker
  docker-compose
  git
  golang
  kubectl
  zsh-syntax-highlighting
  zsh-vi-mode
  globalias
)

# Oh-my-zsh
source $ZSH/oh-my-zsh.sh
