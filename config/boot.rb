# Defines our constants
RACK_ENV = ENV['RACK_ENV'] ||= 'development'  unless defined?(RACK_ENV)
PADRINO_ROOT = File.expand_path('../..', __FILE__) unless defined?(PADRINO_ROOT)
PADRINO_LOGGER = { staging: { log_level: :info } } if RACK_ENV == 'staging'

# Load our dependencies
require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
Bundler.require(:default, RACK_ENV)

Padrino::Logger::Config[:development][:log_level] = :devel

credentials = Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
S3 = Aws::S3::Client.new(credentials: credentials, region: ENV['AWS_REGION'])
BUCKET = 'meetingdocs'

# JMTPROJ4 = '+proj=tmerc +lat_0=49.225 +lon_0=-2.135 +k=0.9999999000000001 '+
#              '+x_0=40000 +y_0=70000 +ellps=GRS80 +units=m +no_defs'
# JTM_FACTORY = RGeo::Cartesian.factory(srid: 3109, proj4: JMTPROJ4)
# WGS84_FACTORY = RGeo::Geographic.spherical_factory(srid: 4326)

PARISHES = %w(Grouville St.\ Brelade St.\ Clement St.\ Helier St.\ John St.\ Lawrence St.\ Martin St.\ Mary St.\ Ouen St.\ Peter St.\ Saviour Trinity)

# Padrino::Logger::Config[:development][:log_static] = true
#
# ## Configure your I18n
#
# I18n.default_locale = :en
# I18n.enforce_available_locales = false
#
# ## Configure your HTML5 data helpers
#
# Padrino::Helpers::TagHelpers::DATA_ATTRIBUTES.push(:dialog)
# text_field :foo, :dialog => true
# Generates: <input type="text" data-dialog="true" name="foo" />
#
# ## Add helpers to mailer
#
# Mail::Message.class_eval do
#   include Padrino::Helpers::NumberHelpers
#   include Padrino::Helpers::TranslationHelpers
# end

##
# Add your before (RE)load hooks here
#
Padrino.before_load do
end

##
# Add your after (RE)load hooks here
#
Padrino.after_load do
end

Padrino.load!
