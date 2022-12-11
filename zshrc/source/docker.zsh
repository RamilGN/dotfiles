# Containers

## Kill all
alias dka="docker kill \$(docker ps -q)"

## List running
unalias dcls
function dcls {
  CONTAINER=($(docker container ls | fzf))
  CONTAINER_ID=$CONTAINER[1]
  echo $CONTAINER_ID
}

## List all
unalias dclsa
function dclsa {
  CONTAINER=($(docker container ls -a | fzf))
  CONTAINER_ID=$CONTAINER[1]
  echo $CONTAINER_ID
}

## Exec on any conatiner
unalias dxcit
function dxcit {
  PROG=${@:-sh}
  CONTAINER_ID=$(dclsa)
  docker container exec -it $CONTAINER_ID sh -c $PROG 2> /dev/null || (docker container start $CONTAINER_ID && docker container exec -it $@ $CONTAINER_ID $PROG)
}

## Start
unalias dst
function dst {
  CONTAINER_ID=$(dclsa)
  docker container start $@ $CONTAINER_ID
}

## Stop
unalias dstp
function dstp {
  CONTAINER_ID=$(dcls)
  docker container stop $@ $CONTAINER_ID
}
