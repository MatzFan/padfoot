RACK_ENV = 'test'.freeze unless defined?(RACK_ENV)
DONT_CLEAN = %w(parishes spatial_ref_sys).freeze

require File.expand_path(__dir__ + '/../config/boot')
Dir[File.expand_path(__dir__ + '/factories/**/*.rb')].each(&method(:require))
Dir[File.expand_path(__dir__ + '/../app/helpers/**/*.rb')].each(&method(:require))

def session
  last_request.env['rack.session'] # for session tests
end

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.include FactoryGirl::Syntax::Methods
  FactoryGirl.define do # FG uses save!, Sequel uses 'save'..
    to_create(&:save)
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation, { except: DONT_CLEAN }
    DatabaseCleaner.clean_with(:truncation, except: DONT_CLEAN)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

# You can use this method to custom specify a Rack app
# you want rack-test to invoke:
#
  # app Padfoot::App
#   app Padfoot::App.tap { |a| }
#   app(Padfoot::App) do
#     set :foo, :bar
#   end
#
def app(app = nil, &blk)
  @app ||= block_given? ? app.instance_eval(&blk) : app
  @app ||= Padrino.application
end
