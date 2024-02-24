# Stash && checkout main && pull && create new branch and checkout.
alias ghf='gstu && gcm && gl && gcb'
alias gclean!='git clean -fd && grs . && grst .'
alias glb='git log $(git_current_branch) --not $(git_main_branch)'

# Branch.
alias gby='xclipsel $(git_current_branch)'

unalias gb; function gb {
  if [ $# -eq 0 ]
  then
    echo $(git branch | fzf) | xargs
  else
    git branch $@
  fi
}

## Branch all.
unalias gba; function gba {
  echo $(git branch -a | fzf) | xargs | sed 's/remotes\/origin\///'
}
## Branch delete.
unalias gbd; function gbd {
  BRANCH=$(gb)
  [ ! -z "$BRANCH" ] && git branch -d $BRANCH
}
## Branch force delete.
unalias gbD; function gbD {
  BRANCH=$(gb)
  [ ! -z "$BRANCH" ] && git branch -D $BRANCH
}

# Checkout.
unalias gco; function gco {
  if [ $# -eq 0 ]
  then
   BRANCH=$(gb)
  else
   BRANCH=$@
  fi
  [ ! -z "$BRANCH" ] && git checkout $(echo $BRANCH | sed 's/^\*\s*//')
}
# Checkout all.
function gcoa {
  if [ $# -eq 0 ]
  then
    BRANCH=$(gba)
  else
    BRANCH=$@
  fi
  [ ! -z "$BRANCH" ] && git checkout $(echo $BRANCH | sed 's/^\*\s*//')
}

# Stash index.
function _git_stash_index; {
  echo $(git stash list --format='%gd{%ch}: %gs' | fzf) | sed 's/stash@{//' | sed 's/}{.*//'
}

# Stash list.
function _gstl {
  STASH_INDEX=$(_git_stash_index)
  [ ! -z "$STASH_INDEX" ] && git $1 stash show --text $STASH_INDEX
}
unalias gstl
alias gstl="_gstl $1# git stash list and show"

# Stash delete.
unalias gstd; function gstd {
  STASH_INDEX=$(_git_stash_index)
  [ ! -z "$STASH_INDEX" ] && git stash drop $STASH_INDEX
}
# Stash apply.
function gsti {
  STASH_INDEX=$(_git_stash_index)
  [ ! -z "$STASH_INDEX" ] && git stash apply --index $STASH_INDEX
}
