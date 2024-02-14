# vim bindings
bindkey -v

# vim as default editor
export EDITOR=nvim
export SUDO_EDITOR=nvim
export VISUAL=nvim
export ASDF_GOLANG_MOD_VERSION_ENABLED=true
export FZF_DEFAULT_OPTS='--multi --height 50% --layout=reverse --border'

# power of a
function a {
    ALIAS_STR=$(alias | fzf)
    COMMAND="${ALIAS_STR#*=}"
    COMMAND="${COMMAND/#\'/}"
    COMMAND="${COMMAND/%\'/}"
    ZSH_SOURCE="source ~/.zshrc"
    print -S "$COMMAND"
    COMMAND="${ZSH_SOURCE}; ${COMMAND}"
    zsh -c $COMMAND
}

# copy to clipboard
function xclipsel() {
    echo -n $1 | xclip -sel clip
}

# cheat sheets
function cheat {
    CHEAT=$(curl -s cheat.sh/:list | fzf)
    curl -s cheat.sh/${CHEAT}
}

# teleport with kitty
function tshssh {
    TERM=xterm-256color tsh ssh $1
}

# teleport with kitty and tmux
function tshssht {
    TERM=xterm-256color tsh ssh -t $1 tmux new-session -As ramilg
}

# misc
alias ssh='TERM=xterm-256color ssh'
alias sudop='sudo -E env "PATH=$PATH"' # Save PATH for sudo
alias zshcfg='nvim ~/dotfiles/zshrc/'
alias trl='tree -LhaC 3 -I .git'
alias vim='nvim'

function trans() {
    just-translate-cli -l1=ru -l2=en -t="$*"
}

# function translate-and-notify() {
#     SELECTION=$(xclip -out -selection primary)
#     TRANSLATION=$(trans $SELECTION)
#     notify-send --icon=info "$SELECTION" "$TRANSLATION"
# }

alias vpn="ruby ~/dotfiles/scripts/vpn/main.rb"
alias gpt="ruby ~/dotfiles/scripts/gpt/main.rb"

# postgres
alias pg-sandbox='docker run --rm --name pg-sandbox -p 5432:5432 -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -d postgres:14'
alias pg-console='psql postgresql://postgres:postgres@localhost:5432'

# cd with fzf
alias cdfc='cd $(find * -type d | fzf)'
alias cdfh='cd $(find ~ -type d | fzf)'

# rails
alias rails_load_fixtures='xclipsel "RAILS_ENV=test FIXTURES_PATH="spec/fixtures" bin/rails db:fixtures:load"'

# ngrok
alias ngrok_host_header_rewrite='xclipsel "ngrok http --host-header=rewrite my.site.io:80"'

# nvim/ruby/solargraph
alias ruby_load_gems_for_solargraph_to_nvim='GEM_HOME="$HOME/.local/share/nvim/mason/packages/solargraph" GEM_PATH="$HOME/.local/share/nvim/mason/packages/solargraph" bundle'

# kubectl get all running pods
alias kgpar='kgpa --field-selector=status.phase=Running | fzf'
alias kxcit='kubectl_exec_it'
function kubectl_exec_it {
    KUBE_LINE=$(kgpar)
    NAMESPACE=$(echo "$KUBE_LINE" | awk '{print $1}')
    POD=$(echo "$KUBE_LINE" | awk '{print $2}')
    [ ! -z "$POD" ] && kubectl exec --stdin --tty -n $NAMESPACE $POD -- $@
}
