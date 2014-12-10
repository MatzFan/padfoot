RACK_ENV = 'test' unless defined?(RACK_ENV)
require File.expand_path(__dir__ + '/../config/boot')
Dir[File.expand_path(__dir__ + '/factories/**/*.rb')].each(&method(:require))
Dir[File.expand_path(__dir__ + '/../app/helpers/**/*.rb')].each(&method(:require))

RSpec.configure do |config|

  config.include Rack::Test::Methods

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
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
#   app Padfoot::App
#   app Padfoot::App.tap { |a| }
#   app(Padfoot::App) do
#     set :foo, :bar
#   end
#
def app(app = nil, &blk)
  @app ||= block_given? ? app.instance_eval(&blk) : app
  @app ||= Padrino.application
end
