require "coveralls"
Coveralls.wear!

def enable_test_coverage
  require "simplecov"

  SimpleCov.start do
    add_filter "/test/"

    add_group "Models",       "app/models"
    add_group "Mailers",      "app/mailers"
    add_group "Controllers",  "app/controllers"
    add_group "Uploaders",    "app/uploaders"
    add_group "Helpers",      "app/helpers"
    add_group "Workers",      "app/workers"
    add_group "Services",     "app/services"
  end
end

enable_test_coverage if ENV["COVERAGE"]

ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "mocha/mini_test"
require "webmock/minitest"
require "minitest/reporters"

reporter_options = { color: true, slow_count: 10 }

Minitest::Reporters.use!(
  Minitest::Reporters::DefaultReporter.new(reporter_options),
  ENV,
  Minitest.backtrace_filter
)

class ActiveSupport::TestCase

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all
  include FactoryGirl::Syntax::Methods

  # Add more helper methods to be used by all tests here...
end

class ActionController::TestCase
  include Devise::TestHelpers
end

require "vcr"

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = "test/vcr_cassettes"
  c.default_cassette_options = {
    record: :new_episodes,
    allow_playback_repeats: true
  }
  c.debug_logger = STDOUT
  c.allow_http_connections_when_no_cassette = true
end
