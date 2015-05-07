source 'https://rubygems.org'

ruby '2.2.2'
gem 'rails', '4.2.0'
gem 'arel'
gem 'jquery-rails'
gem 'sprockets-rails', '3.0.0.beta1'
gem 'sass-rails', '>= 3.2'
gem 'uglifier', '>= 1.0.3'

gem 'activeadmin', github: 'activeadmin' # admin framework
gem 'bootstrap-sass', '~> 3.3.3' # use bootstrap3
gem 'browser' # for variants support
gem 'carrierwave' # for handling file uploads
gem 'delayed_job_active_record' # for background job processing
gem 'delayed_job_web', '>= 1.2.0' # web interface for delayed job
gem 'devise', '3.4.1' # for authentication
gem 'devise-async', github: 'mhfs/devise-async' # for sending devise emails in background
gem 'email_validator' # for email validation
gem 'font-awesome-sass', '~> 4.3.0' # use font-awesome
gem 'jbuilder', '~> 1.2' # for building JSON
gem 'haml-rails' # haml as templating engine
gem 'handy' # collection of handy tools
gem 'honeybadger' # for error tracking
gem 'mail_interceptor' # intercepts outgoing emails in non-production environment
gem 'pg' # database
gem 'rails_12factor', group: [:staging, :production] # for logging to work in heroku
gem 'simple_form' # forms made easy for rails
gem 'sprockets-strict-mode' # use 'strict mode' in JavaScript
gem 'unicorn', group: [:staging, :production]

group :development do
  gem 'quiet_assets' # mutes assets pipeline log messages
  gem 'spring' # speeds up development by keeping your application running in the background
  gem 'thin' # application server for development
  gem 'web-console', '~> 2.0' # web console
end

group :test do
  gem 'minitest-reporters', require: false # customizable MiniTest output formats
  gem 'simplecov', require: false # for test coverage report
end
