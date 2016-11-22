source 'https://rubygems.org'
ruby '2.3.2'

group :production do
  gem 'unicorn', '5.0.1'
end

gem 'mime-types', '>= 2.6.1', require: 'mime/types/columnar' # save mem
gem 'padrino', '0.13.3.2'

gem 'thin', '1.6.4'
gem 'rake', '11.2.2'
gem 'padrino-sprockets', '0.0.3', require: 'padrino/sprockets'
gem 'uglifier', '2.7.2' # JS compression
gem 'yui-compressor', '0.12.0' # CSS compression
gem 'bcrypt', '3.1.10', require: 'bcrypt'
gem 'mechanize', '2.7.5'
gem 'gon-sinatra', '0.1.2'
gem 'parallel', '1.9.0'

# Optional JSON codec (faster performance)
# gem 'oj', '2.11.4', require: 'oj'

# Component requirements
gem 'sass', '3.4.21'
gem 'haml', '4.0.7'
gem 'pg', '0.19.0'
gem 'sequel', '4.32'
gem 'sequel_pg', '1.6.14', require: 'sequel'
gem 'aws-sdk', '2.2.24', require: 'aws-sdk'
gem 'linguistics', '2.1.0'
gem 'stripe', '1.36.0'
gem 'gis_scraper', '0.1.10.pre'

group :test do
  gem 'rspec', '3.4.0'
  gem 'rack-test', '0.6.3', require: 'rack/test'
  gem 'factory_girl', '4.5.0'
  gem 'database_cleaner', '1.5.1'
  gem 'faker', '1.6.3'
  gem 'capybara', '2.6.2'
  gem 'capybara-email', '2.5.0'
  gem 'selenium-webdriver', '2.52.0'
end

group :development do
  gem 'derailed_benchmarks', '1.3.1'
  gem 'memory_profiler', '0.9.7'
  gem 'stackprof', '0.2.9'
end

group :test, :development do
  gem 'better_errors', '2.1.1', require: 'better_errors'
end
