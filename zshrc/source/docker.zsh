# Containers.

## Inspect with shell.
alias dksh="docker run -it --entrypoint=sh"

LS_CONTAINER_FORMAT='table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.RunningFor}}'

## List running
unalias dcls; alias dcls="docker_container_ls"
function docker_container_ls {
  CONTAINER=($(docker container ls --format=$LS_CONTAINER_FORMAT | fzf))
  CONTAINER_ID=$CONTAINER[1]
  [ ! -z "$CONTAINER_ID" ] && echo $CONTAINER_ID
}

## List all.
unalias dclsa; alias dclsa="docker_container_ls_a"
function docker_container_ls_a {
  CONTAINER=($(docker container ls -a --format=$LS_CONTAINER_FORMAT | fzf))
  CONTAINER_ID=$CONTAINER[1]
  [ ! -z "$CONTAINER_ID" ] && echo $CONTAINER_ID
}

## Exec on any conatiner.
unalias dxcit; alias dxcit="docker_container_exec_it"
function docker_container_exec_it {
  PROG=${@:-sh}
  CONTAINER_ID=$(dclsa)
  [ ! -z "$CONTAINER_ID" ] && docker container exec -it --user=root $CONTAINER_ID sh -c $PROG 2> /dev/null ||\
      [ ! -z "$CONTAINER_ID" ] && (docker container start $CONTAINER_ID && docker container exec -it $CONTAINER_ID $PROG)
}

## Attach to container
alias dca="docker_container_attach"
function docker_container_attach {
  PROG=${@:-sh}
  CONTAINER_ID=$(dcls)
  [ ! -z "$CONTAINER_ID" ] && docker container attach $CONTAINER_ID
}
## Start.
alias dstart="docker_container_start"
function docker_container_start {
  CONTAINER_ID=$(dclsa)
  [ ! -z "$CONTAINER_ID" ] && docker container start $CONTAINER_ID
}

## Stop
alias dstop="docker_container_stop"
function docker_container_stop {
  CONTAINER_ID=$(dcls)
  [ ! -z "$CONTAINER_ID" ] && docker container stop $CONTAINER_ID
}

## Kill
alias dk="docker_container_kill"
function docker_container_kill {
  CONTAINER_ID=$(dcls)
  [ ! -z "$CONTAINER_ID" ] && docker container kill $CONTAINER_ID
}
## Kill all.
alias dka='docker container kill $(docker ps -q)'

## Remove.
unalias drm; alias drm="docker_container_rm"
function docker_container_rm {
  CONTAINER_ID=$(dclsa)
  [ ! -z "$CONTAINER_ID" ] && docker container rm $CONTAINER_ID
}
