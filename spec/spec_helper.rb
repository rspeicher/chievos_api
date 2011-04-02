PADRINO_ENV = 'test' unless defined?(PADRINO_ENV)
require File.expand_path(File.dirname(__FILE__) + "/../config/boot")

require 'support/factories'

RSpec.configure do |conf|
  conf.mock_with :mocha
  conf.include Rack::Test::Methods

  conf.before(:suite) { Ohm.flush }
end

def app
  ##
  # You can handle all padrino applications using instead:
  #   Padrino.application
  ChievosApi.tap { |app|  }
end
