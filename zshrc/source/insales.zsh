LETSDEV_REPO=$HOME/insales/letsdev2

if [ -d $LETSDEV_REPO ]
then
  export LETSDEV_REPO

  alias letsdev=$LETSDEV_REPO/letsdev.rb

  alias insales_dev_container='docker exec -it insales_insales_1 /bin/bash'
  alias insales_dev_rails_console='docker exec -it insales_insales_1 bin/rails c'
  alias insales_dev_start_no_webpack='docker start insales_insales_1 insales_redis_1 insales_postgres_1 insales_elasticnext_1 insales_delayedjob_1 insales_sidekiq_1 insales_minio_1'

  alias 1c_sync_dev_container="docker exec -it 1c_synch_1c_sync_1 /bin/bash"
  alias 1c_sync_dev_console="docker exec -it 1c_synch_1c_sync_1 bin/rails c"
fi
