ENV['RACK_ENV'] = 'test'

require_relative '../app/app'
require 'rspec'
require 'rack/test'

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.formatter = :documentation
end

# Allows me to access session in tests.
def session
  last_request.env['rack.session']
end
