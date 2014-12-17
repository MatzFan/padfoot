RACK_ENV = 'development' unless defined?(RACK_ENV) # development default
require File.expand_path(__dir__ + '/../config/boot')
