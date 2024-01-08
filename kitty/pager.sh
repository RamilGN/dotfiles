#!/usr/bin/env bash

set -eu

AUTOCMD_TERMCLOSE_CMD="normal G"

exec nvim -u NORC 63<&0 0</dev/null \
    -c "map <silent> q :qa!<CR>" \
    -c "nmap <silent> i :qa!<CR>" \
    -c "set shell=bash scrollback=100000 termguicolors laststatus=0 clipboard+=unnamedplus ic scs" \
    -c "autocmd TermEnter * stopinsert" \
    -c "autocmd TermClose * ${AUTOCMD_TERMCLOSE_CMD}" \
    -c 'terminal sed </dev/fd/63 -e "s/'$'\x1b'']8;;file:[^\]*[\]//g" && sleep 0.01 && printf "'$'\x1b'']2;"'
