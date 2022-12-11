alias fzf='fzf --multi'
alias nvimc="nvim -c 'Neotree' -c 'lua require([[telescope.builtin]]).oldfiles({only_cwd = true})'"
alias vif="nvim \$(fzf --preview 'bat --style=numbers --color=always --line-range :500 {}')"
alias sudop='sudo -E env "PATH=$PATH"' # Save PATH for sudo
alias bat="batcat"
alias zshcfg="nvim ~/.zshrc"
alias trl="tree -LhaC 3"
alias cdfc="cd \$(find * -type d | fzf)"
alias cdfh="cd \$(find ~ -type d | fzf)"
