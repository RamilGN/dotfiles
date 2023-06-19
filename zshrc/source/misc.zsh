alias pg-sandbox='docker run --rm --name pg-sandbox -p 5432:5432 -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -d postgres:14'
alias pg-console='psql postgresql://postgres:postgres@localhost:5432'
alias ssh='TERM=xterm-256color ssh'
alias vif="nvim \$(fzf --preview 'batcat --style=numbers --color=always --line-range :500 {}')"
alias sudop='sudo -E env "PATH=$PATH"' # Save PATH for sudo
alias zshcfg="nvim ~/dotfiles/zshrc/"
alias trl="tree -LhaC 3 -I .gi"
alias cdfc="cd \$(find * -type d | fzf)"
alias cdfh="cd \$(find ~ -type d | fzf)"
alias kgpar="kgpa --field-selector=status.phase=Running | fzf"

function gpt() {
    echo -e "$@" | bat --style=grid

    INPUT=$(echo "$@" | jq -Rsa '.')
    JSON='{
      "model": "gpt-3.5-turbo",
      "messages": [
        {
          "role": "system",
          "content": "You are a helpful assistant."
        },
        {
          "role": "user",
          "content": '"$INPUT"'
        }
      ]
   }'
   JSON=$(echo -E $JSON | jq)

   RES=$(curl https://api.openai.com/v1/chat/completions -s -H "Content-Type: application/json" -H "Authorization: Bearer $OPENAI_API_KEY" -d $JSON)
   RES=$(echo -E $RES | jq '.choices[0].message.content' | sed 's/^"//; s/"$//')
   print $RES | bat -P --style=grid -l md
}

function foo() {
    INPUT=$(bat)
    echo -E $INPUT
}

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
