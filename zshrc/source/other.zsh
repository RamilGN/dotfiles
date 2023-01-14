# Vim bindings
bindkey -v

# Vim as default editor
export EDITOR=nvim
export VISUAL=nvim

function cheat {
    CHEAT=$(curl -s cheat.sh/:list | fzf)
    curl -s cheat.sh/${CHEAT}
}
