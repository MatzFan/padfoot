RACK_ENV = 'test' unless defined?(RACK_ENV)
require 'capybara/rspec'
require 'capybara/email/rspec'
require File.expand_path(__dir__ + '/../config/boot')
Dir[File.expand_path(__dir__ + '/factories/**/*.rb')].each(&method(:require))
Dir[File.expand_path(__dir__ + '/../app/helpers/**/*.rb')].each(&method(:require))

Capybara.app = Padfoot::App # need this to tell Capy what the app is..
Capybara.javascript_driver = :webkit

Padfoot::App.set :delivery_method, :test # for capybara-email

def session
  last_request.env['rack.session'] # for session tests
end

RSpec.configure do |config|

  config.include Rack::Test::Methods

  config.include FactoryGirl::Syntax::Methods
  FactoryGirl.define do # FG uses save!, Sequel uses 'save'..
    to_create { |instance| instance.save }
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation, { except: %w[parishes spatial_ref_sys] }
    DatabaseCleaner.clean_with(:truncation, { except: %w[parishes spatial_ref_sys] })
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  # config.before(:each) do
  #   page.driver.allow_url('*') # capy webkit - silences warnings
  # end

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
