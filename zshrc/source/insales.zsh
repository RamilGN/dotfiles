LETSDEV_REPO=$HOME/insales/letsdev2

if [ -d $LETSDEV_REPO ]
then
  export LETSDEV_REPO

  alias letsdev=$LETSDEV_REPO/letsdev.rb

  alias insales_dev_container='docker exec -it --user root insales-insales-1 /bin/bash'
  alias insales_dev_rails_console='docker exec -it insales-insales-1 bin/rails c'
  alias insales_dev_start_no_webpack='docker start insales-insales-1 insales-redis-1 insales-postgres-1 insales-elasticnext-1 insales-delayedjob-1 insales-sidekiq-1 insales-minio-1'
  alias inasles_dev_rspec_coverage='xclipsel "COVERAGE=1 bundle exec rspec spec/"'
  alias 1c_sync_dev_container='docker exec -it 1c-synch-1c-sync-1 /bin/bash'
  alias 1c_sync_dev_rails_console='docker exec -it 1c-synch-1c-sync-1 bin/rails c'
fi
