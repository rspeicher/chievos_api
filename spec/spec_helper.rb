PADRINO_ENV = 'test' unless defined?(PADRINO_ENV)
require File.expand_path(File.dirname(__FILE__) + "/../config/boot")

require 'support/factories'
require 'support/fixture'

FakeWeb.allow_net_connect = false

RSpec.configure do |conf|
  conf.mock_with :mocha

  conf.include Rack::Test::Methods
  conf.include Fixture

  conf.after(:suite) { Ohm.flush }
end

def app
  ##
  # You can handle all padrino applications using instead:
  #   Padrino.application
  ChievosApi.tap { |app|  }
end
