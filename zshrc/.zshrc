export PATH=$HOME/.local/bin:$PATH

# VIM as default editor.
export EDITOR=nvim
export SUDO_EDITOR=nvim
export VISUAL=nvim

# Go.
export ASDF_GOLANG_MOD_VERSION_ENABLED=true
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export GO111MODULE=auto

sources=(
  'oh-my-zsh'
  'misc'
  'docker'
  'git'
  'curl'
  'insales'
  'secrets'
  'fzf'
)

zstyle ':omz:alpha:lib:git' async-prompt no

for s in "${sources[@]}"; do
  source $HOME/dotfiles/zshrc/source/${s}.zsh
done
