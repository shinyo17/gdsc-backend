#!/usr/bin/env puma

directory '/home/ubuntu/standard-backend/current'
rackup "/home/ubuntu/standard-backend/current/config.ru"
environment 'production'

tag ''

pidfile "/home/ubuntu/standard-backend/shared/tmp/pids/puma.pid"
state_path "/home/ubuntu/standard-backend/shared/tmp/pids/puma.state"

threads 4,16

bind 'unix:/home/ubuntu/standard-backend/shared/tmp/sockets/puma.sock'

workers 0

restart_command 'bundle exec puma'

preload_app!

# on_restart do
#   puts 'Refreshing Gemfile'
#   ENV["BUNDLE_GEMFILE"] = ""
# end


# before_fork do
#   ActiveRecord::Base.connection_pool.disconnect!
# end

# on_worker_boot do
#   ActiveSupport.on_load(:active_record) do
#     ActiveRecord::Base.establish_connection
#   end
# end
