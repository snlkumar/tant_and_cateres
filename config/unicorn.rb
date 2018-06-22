# set path to the application
app_dir = File.expand_path("../..", __FILE__)
shared_dir = "#{app_dir}/shared"
working_directory app_dir

# Set unicorn options
worker_processes 2
preload_app true
timeout 30

# Path for the Unicorn socket
listen "#{app_dir}/tmp/sockets/unicorn.sock", :backlog => 64

# Set path for logging
stderr_path "#{shared_dir}/log/unicorn.stderr.log"
stdout_path "#{shared_dir}/log/unicorn.stdout.log"

# Set proccess id path
pid "#{app_dir}/tmp/pids/unicorn.pid"