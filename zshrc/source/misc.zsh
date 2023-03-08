alias ssh='TERM=xterm-256color ssh'
alias vif="nvim \$(fzf --preview 'batcat --style=numbers --color=always --line-range :500 {}')"
alias sudop='sudo -E env "PATH=$PATH"' # Save PATH for sudo
alias bat="batcat"
alias zshcfg="nvim ~/dotfiles/zshrc/"
alias trl="tree -LhaC 3"
alias cdfc="cd \$(find * -type d | fzf)"
alias cdfh="cd \$(find ~ -type d | fzf)"

function a {
    ALIAS_STR=$(alias | fzf)
    COMMAND="${ALIAS_STR#*=}"
    COMMAND="${COMMAND/#\'/}"
    COMMAND="${COMMAND/%\'/}"
    ZSH_SOURCE="source ~/.zshrc"
    COMMAND="${ZSH_SOURCE}; ${COMMAND}"
    zsh -c $COMMAND || echo -n $COMMAND | xclip -sel clip
}

# Vim bindings
bindkey -v

# Vim as default editor
export EDITOR=nvim
export VISUAL=nvim

# Cheat sheets
function cheat {
    CHEAT=$(curl -s cheat.sh/:list | fzf)
    curl -s cheat.sh/${CHEAT}
}

export FZF_DEFAULT_OPTS='--multi --height 50% --layout=reverse --border'
