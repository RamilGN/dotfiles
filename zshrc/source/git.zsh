# Stash && checkout main && pull && create new branch and checkout
alias ghf="gstu && gcm && gl && gcb"
alias gclean!="git clean -fd && git restore ."

# Branch
unalias gb; function gb {
  if [ $# -eq 0 ]
  then
    echo $(git branch | fzf) | xargs
  else
    git branch $@
  fi
}
## Branch all
unalias gba; function gba {
  echo $(git branch -a | fzf) | xargs | sed 's/remotes\/origin\///'
}
## Branch delete
unalias gbd; function gbd {
  BRANCH=$(gb)
  [ ! -z "$BRANCH" ] && git branch -d $BRANCH
}
## Branch force delete
unalias gbD; function gbD {
  BRANCH=$(gb)
  [ ! -z "$BRANCH" ] && git branch -D $BRANCH
}

# Checkout
unalias gco; function gco {
  if [ $# -eq 0 ]
  then
   BRANCH=$(gb)
  else
   BRANCH=$@
  fi
  [ ! -z "$BRANCH" ] && git checkout $BRANCH
}
# Checkout all
function gcoa {
  if [ $# -eq 0 ]
  then
    BRANCH=$(gba)
  else
    BRANCH=$@
  fi
  git checkout $BRANCH
}

# Stash
unalias gstl; function gstl {
  echo $(git stash list --format='%gd{%ch}: %gs' | fzf) | sed 's/stash@{//' | sed 's/}{.*//'
}
## Stash delete
unalias gstd; function gstd {
  STASH_INDEX=$(gstl)
  [ ! -z "$STASH_INDEX" ] && git stash drop $STASH_INDEX
}
## Stash apply
function gsai {
  STASH_INDEX=$(gstl)
  [ ! -z "$STASH_INDEX" ] && git stash apply --index $STASH_INDEX
}
