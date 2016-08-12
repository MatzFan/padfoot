worker_processes Integer(ENV['WEB_CONCURRENCY'] || 1) # default is 3
timeout 60
preload_app true

before_fork do |_server, _worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  DB.disconnect
end
