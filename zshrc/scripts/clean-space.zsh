#!/usr/bin/env zsh

set -eu

apt-get autoremove
apt-get clean
apt-get autoclean
sudo journalctl --vacuum-size 10M
snap list --all | awk '/disabled/{print $1, $3}' |
    while read snapname revision; do
        snap remove "$snapname" --revision="$revision"
    done
docker image prune --all
