LETSDEV_REPO=$HOME/insales/letsdev2
if [ -d $LETSDEV_REPO ]
then
  export LETSDEV_REPO
  alias letsdev=$LETSDEV_REPO/letsdev.rb
  alias ins='docker-compose exec -e COLUMNS="`tput cols`" -e LINES="`tput lines`" -u 1000 -w /home/app/code insales bash'
  alias insnow='docker start insales_insales_1 insales_redis_1 insales_postgres_1 insales_elasticnext_1 insales_delayedjob_1 insales_sidekiq_1'
  alias synch="docker-compose exec -u 1000 -w /home/app/code 1c_sync bash -l"
  . $LETSDEV_REPO/bash-completions

  function tshssh {
    TERM=xterm-256color tsh ssh $1
  }

  function tshssht {
    TERM=xterm-256color tsh ssh -t $1 tmux new-session -As ramilg
  }
fi