# Set the working application directory
# working_directory "/path/to/your/app"
working_directory "#{ENV["WORKING_DIRECTORY"]}"

# Unicorn PID file location
# pid "/path/to/pids/unicorn.pid"
pid "#{ENV["WORKING_DIRECTORY"]}/pids/unicorn.pid"

# Path to logs
# stderr_path "/path/to/logs/unicorn.log"
# stdout_path "/path/to/logs/unicorn.log"
stderr_path "#{ENV["WORKING_DIRECTORY"]}/logs/unicorn.log"
stdout_path "#{ENV["WORKING_DIRECTORY"]}/logs/unicorn.log"

# Unicorn socket
# listen "/tmp/unicorn.[app name].sock"
listen "/tmp/webapp.sock"

# Number of processes
# worker_processes 4
worker_processes 2

# Time-out
timeout 30