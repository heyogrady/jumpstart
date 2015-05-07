# this template has been picked up from
# https://devcenter.heroku.com/articles/rails-unicorn

worker_processes (ENV["WEB_CONCURRENCY"] || 3).to_i
timeout (ENV["UNICORN_TIMEOUT"] || 15).to_i
preload_app true

before_fork do |_server, _worker|
  Signal.trap "TERM" do
    puts "Unicorn master intercepting TERM, sending myself QUIT instead"
    Process.kill "QUIT", Process.pid
  end

  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end
end

after_fork do |_server, _worker|
  Signal.trap "TERM" do
    puts "Unicorn worker intercepting TERM and doing nothing..."
    puts "...waiting for master to send QUIT"
  end

  if defined?(ActiveRecord::Base)
    config = ActiveRecord::Base.configurations[Rails.env] ||
    Rails.application.config.database_configuration[Rails.env]
    config["reaping_frequency"] = (ENV["DB_REAPING_FREQUENCY"] || 10).to_i
    config 
    ActiveRecord::Base.establish_connection
  end
end
