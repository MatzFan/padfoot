source 'https://rubygems.org'
ruby '2.5.0'

group :production do
  gem 'unicorn', '5.3.0'
end

gem 'mime-types', '>= 2.6.1', require: 'mime/types/columnar' # save mem
gem 'padrino', '0.14.1.1'

gem 'bcrypt', '3.1.11', require: 'bcrypt'
gem 'gon-sinatra', '0.1.2'
gem 'mechanize', '2.7.5'
gem 'padrino-sprockets', '0.0.3', require: 'padrino/sprockets'
gem 'parallel', '1.12.0'
gem 'rake', '12.1.0'
gem 'thin', '1.7.2'
gem 'uglifier', '3.2.0' # JS compression
gem 'yui-compressor', '0.12.0' # CSS compression

# Optional JSON codec (faster performance)
# gem 'oj', '2.11.4', require: 'oj'

# Component requirements
gem 'aws-sdk', '3.0.1', require: 'aws-sdk'
gem 'gis_scraper', '0.1.10.pre'
gem 'haml', '5.0.4'
gem 'linguistics', '2.1.0'
gem 'pg', '0.21.0'
gem 'sass', '3.5.1'
gem 'sequel', '5.0.0'
gem 'sequel_pg', '1.7.1', require: 'sequel'
gem 'stripe', '3.3.1'
gem 'therubyracer', '0.12.3' # needed for pg on Linux

group :test do
  gem 'capybara', '2.15.1'
  gem 'capybara-email', '2.5.0'
  gem 'database_cleaner', '1.6.1'
  gem 'factory_girl', '4.8.0'
  gem 'faker', '1.8.4'
  gem 'rack-test', '0.7.0', require: 'rack/test'
  gem 'rspec', '3.7.0'
  gem 'selenium-webdriver', '3.5.2'
end

group :development do
  gem 'derailed_benchmarks', '1.3.2'
  gem 'memory_profiler', '0.9.8'
  gem 'stackprof', '0.2.10'
end

group :test, :development do
  gem 'better_errors', '2.3.0', require: 'better_errors'
end
