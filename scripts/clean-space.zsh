#!/usr/bin/env zsh

set -eu

dnf autoremove
sudo journalctl --vacuum-size 10M
docker image prune --all
