source 'https://rubygems.org'
ruby '2.1.5'

group :production do
  gem 'unicorn', '4.8.3'
end

gem 'padrino', '0.12.4'

gem 'thin', '1.6.3'
gem 'rake', '10.4.2'
gem 'padrino-sprockets', '0.0.3', require: 'padrino/sprockets'
gem 'uglifier', '2.6.0' # JS compression
gem 'yui-compressor', '0.12.0' # CSS compression
gem 'bcrypt-ruby', '3.1.5', require: 'bcrypt'
gem 'mechanize', '2.7.2' # 2.7.3 conflicts with Padrino re mime-types 1.0/2.0
gem 'gon-sinatra', '0.1.2'

# Optional JSON codec (faster performance)
# gem 'oj', '2.11.4', require: 'oj'

# Component requirements
gem 'sass', '3.4.9'
gem 'haml', '4.0.6'
gem 'pg', '0.17.1'
gem 'sequel', '4.17.0'
gem 'sequel_pg', '1.6.11', require: 'sequel'
gem 'aws-sdk', '2.0.24', require: 'aws-sdk'
gem 'curb', '0.8.6'
# gem 'mongo', '1.12.0'
# gem 'bson_ext', '1.12.0'

group :test do
  gem 'rspec', '3.1.0'
  gem 'rack-test', '0.6.2', require: 'rack/test'
  gem 'factory_girl', '4.5.0'
  gem 'database_cleaner', '1.3.0'
  gem 'faker', '1.4.3'
end

group :test, :development do
  gem 'better_errors', '2.0.0', require: 'better_errors'
end
