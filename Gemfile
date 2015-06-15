source "https://rubygems.org"

ruby "2.2.2"

gem "rails", "4.2.1"

gem "bootstrap-sass", "~> 3.3.3" # use bootstrap3
# gem "bitters" # scaffold application styles
# gem "bourbon", "~> 4.2.0" # Sass mixins
# gem "neat", "~> 1.7.0" # emantic grids
# gem "refills" # components & patterns based on Bourbon, Neat and Bitters

gem "activeadmin", github: "activeadmin" # admin framework
gem "airbrake" # for error tracking
gem "analytics-ruby", "~> 2.0.0", require: "segment/analytics" # segment.io
gem "arel"
gem "autoprefixer-rails" # for CSS vendor prefixes
gem "binding_of_caller" # interactive prompt in error messages
gem "browser" # for variants support
gem "carrierwave" # for handling file uploads
gem "country_select" # for automatic country select with simple_form
gem "daemons" # for starting Delayed Job background process
gem "delayed_job_active_record" # for background job processing
gem "delayed_job_web", ">= 1.2.0" # web interface for delayed job
gem "devise", "3.4.1" # for authentication
gem "devise-async", github: "mhfs/devise-async" # send devise emails in bg
gem "email_prefixer" # adds prefix to the subject in emails
gem "email_validator" # for email validation
gem "flutie" # for page_title and body_class view helpers
gem "fog", require: false # for handling s3
gem "friendly_id", "~> 5.1.0"
gem "font-awesome-sass", "~> 4.3.0" # use font-awesome
gem "i18n-tasks"
# gem "intercom-rails" # tracking user behavior
gem "jbuilder", "~> 1.2" # for building JSON
gem "jquery-rails"
gem "haml-rails" # haml as templating engine
gem "handy" # collection of handy tools
gem "lograge" # shortens format of rails request logs onto a single line
gem "mail_interceptor", github: "bigbinary/mail_interceptor", group: [:development, :staging] # intercepts outgoing emails in nonproduction environment
gem "marginalia" # attaches comments to Active Record queries
gem "mini_magick" # for resizing images
# gem "newrelic_rpm" # monitor app performance
gem "normalize-rails", "~> 3.0.0"
gem "omniauth"
gem "omniauth-facebook"
gem "omniauth-google-oauth2"
gem "omniauth-linkedin"
gem "pg" # database
gem "rack-timeout", group: [:staging, :production] # abort long requests
gem "rails_12factor", group: [:staging, :production] # for logging in heroku
gem "sass-rails", "~> 5.0"
gem "simple_form" # forms made easy for rails
gem "sprockets-rails", "3.0.0.beta1"
gem "sprockets-strict-mode" # use "strict mode" in JavaScript
gem "stripe", "~> 1.15.0" # charging customers
gem "stripe_event" # Stripe webhook integration
gem "twilio-ruby" # phone and SMS services
gem "uglifier", ">= 1.0.3"
gem "unicorn", group: [:staging, :production] # staging & production server
gem "yaml_dump", github: "vanboom/yaml_dump" # dump db records to yaml files

group :development do
  gem "better_errors" # better rails error messages
  gem "bullet" # notify of db queries that can be improved
  gem "guard-livereload", require: false # changed files = autoreloaded browser
  gem "guard-minitest" # automatically run tests
  gem "guard-rubocop" # use rubocop with guard
  gem "meta_request" # for using RailsPanel Chrome extension
  gem "quiet_assets" # mutes assets pipeline log messages
  gem "rubocop" # evaluate against style guide
  gem "spring" # speeds up development by keeping app running in the background
  gem "thin" # application server for development
  gem "web-console", "~> 2.0" # for debugging via in-browser IRB consoles
end

group :development, :test do
  gem "awesome_print"
  gem "byebug" # for interactively debugging behavior
  gem "dotenv-rails" # or loading environment variables
  gem "pry-rails" # for interactively exploring objects
  if !ENV["CI"]
    gem "ruby_gntp" # send notifications to Growl
  end
end

group :test do
  gem "capybara-webkit" # acceptance testing with browser automation
  gem "codeclimate-test-reporter", require: nil # CodeClimate test coverage
  gem "coveralls", require: false # Report test coverage
  gem "factory_girl_rails" # for setting up ruby objects as test data
  gem "minitest-around" # acceptance testing with browser automation
  gem "minitest-rails-capybara" # high-level acceptance testing with Capybara
  gem "minitest-reporters", require: false # customizable MiniTest output
  gem "mocha", require: false # mocking and stubbing library
  gem "simplecov", require: false # for test coverage report
  gem "timecop" # for testing time
  gem "vcr" # record and reuse external HTTP requests to speed up testing
  gem "webmock" # goes with VCR
end
