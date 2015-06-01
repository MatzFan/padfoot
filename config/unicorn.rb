worker_processes Integer(ENV['WEB_CONCURRENCY'] || 2) # default is 3
timeout 60
preload_app true

before_fork do |server, worker|

  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  DB.disconnect
end
