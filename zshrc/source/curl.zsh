## Kill all
alias c="curl"

alias cjget="_cjget"
function _cjget() {
    COMMAND="curl -sS -H 'Accept: application/json' -X GET '$1' | jq"
    echo $COMMAND
    zsh -c $COMMAND
}

alias cjpost="_cjpost"
function _cjpost() {
    COMMAND="curl -sS -H 'Content-Type: application/json' -H 'Content-Type: application/json' -X POST '$1' -d '$2' | jq"
    echo $COMMAND
    (echo "$2" | jq > /dev/null) && zsh -c $COMMAND
}
