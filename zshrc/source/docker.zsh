# Containers

## Kill all
alias dka="docker kill \$(docker ps -q)"

LS_CONTAINER_FORMAT="table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.RunningFor}}"

## List running
unalias dcls
function dcls {
  CONTAINER=($(docker container ls --format=$LS_CONTAINER_FORMAT | fzf))
  CONTAINER_ID=$CONTAINER[1]
  [ ! -z "$CONTAINER_ID" ] && echo $CONTAINER_ID
}

## List all
unalias dclsa
function dclsa {
  CONTAINER=($(docker container ls -a --format=$LS_CONTAINER_FORMAT | fzf))
  CONTAINER_ID=$CONTAINER[1]
  [ ! -z "$CONTAINER_ID" ] && echo $CONTAINER_ID
}

## Exec on any conatiner
unalias dxcit
function dxcit {
  PROG=${@:-sh}
  CONTAINER_ID=$(dclsa)
  [ ! -z "$CONTAINER_ID" ] && docker container exec -it --user=root $CONTAINER_ID sh -c $PROG 2> /dev/null ||\
      [ ! -z "$CONTAINER_ID" ] && (docker container start $CONTAINER_ID && docker container exec -it $CONTAINER_ID $PROG)
}

## Start
unalias dst
function dst {
  CONTAINER_ID=$(dclsa)
  [ ! -z "$CONTAINER_ID" ] && docker container start $CONTAINER_ID
}

## Stop
unalias dstp
function dstp {
  CONTAINER_ID=$(dcls)
  [ ! -z "$CONTAINER_ID" ] && docker container stop $CONTAINER_ID
}
