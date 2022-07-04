# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# Theme
ZSH_THEME="robbyrussell"

# Plugins
plugins=(git vi-mode)

# Oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Vim bindings
bindkey -v

# Vim as default editor
EDITOR=nvim
VISUAL=nvim

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
