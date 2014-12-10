source 'https://rubygems.org'
ruby '2.1.5'

gem 'padrino', '0.12.4'

# Server requirements
gem 'thin', '1.6.3'
gem 'rake', '10.4.2'
gem 'padrino-sprockets', '0.0.3', require: 'padrino/sprockets'
gem 'uglifier', '2.6.0' # JS compression
gem 'yui-compressor', '0.12.0' # CSS compression

# Optional JSON codec (faster performance)
# gem 'oj'

# Component requirements
gem 'sass', '3.4.9'
gem 'haml', '4.0.6'
gem 'pg', '0.17.1'
gem 'sequel', '4.17.0'

group :test do
  gem 'rspec', '3.1.0'
  gem 'rack-test', '0.6.2', require: 'rack/test'
  gem 'factory_girl', '4.5.0'
  gem 'database_cleaner', '1.3.0'
end

# Or Padrino Edge
# gem 'padrino', :github => 'padrino/padrino-framework'

# Or Individual Gems
# %w(core support gen helpers cache mailer admin).each do |g|
#   gem 'padrino-' + g, '0.12.4'
# end
