worker_processes 6
timeout 60

# Load rails app into the master before forking workers
# for super-fast worker spawn times
preload_app true

# Listen on a Unix socket
listen "#{ENV['HOME']}/.unicorn.sock"

# Working directory
working_directory "#{ENV['HOME']}/current"
ENV['BUNDLE_GEMFILE'] = "#{ENV['PWD']}/Gemfile"

# Log stdout and stderr in separate files
#
stdout_path 'log/unicorn.stdout.log'
stderr_path 'log/unicorn.stderr.log'

pid "#{ENV['HOME']}/.unicorn.pid"

Unicorn::HttpServer::START_CTX[0] = "#{ENV['HOME']}/bin/unicorn"

before_fork do |server, worker|
  ##
  # When sent a USR2, Unicorn will suffix its pidfile with .oldbin and
  # immediately start loading up a new version of itself (loaded with a new
  # version of our app). When this new Unicorn is completely loaded
  # it will begin spawning workers. The first worker spawned will check to
  # see if an .oldbin pidfile exists. If so, this means we've just booted up
  # a new Unicorn and need to tell the old one that it can now die. To do so
  # we send it a QUIT.
  #
  # Using this method we get 0 downtime deploys.

  old_pid = "#{ENV['HOME']}/.unicorn.pid.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill('QUIT', File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  ##
  # Unicorn master loads the app then forks off workers - because of the way
  # Unix forking works, we need to make sure we aren't using any of the parent's
  # sockets, e.g. db connection

  ActiveRecord::Base.establish_connection

  # CouchDB and Memcached would go here but their connections are established
  # on demand, so the master never opens a socket
end

