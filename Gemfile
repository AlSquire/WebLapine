source 'https://rubygems.org'

ruby '2.0.0' unless ENV['TRAVIS']

gem 'rails', '4.0'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# gem 'sqlite3'

gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier'
gem 'compass-rails', '~> 2.0.alpha.0' # Rails 4 compatibility

gem 'jquery-rails'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19'

group :production do
  gem 'mysql2'
  gem 'thin'
  gem 'rails_12factor'
end

group :development, :test do
  gem 'sqlite3'
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
  # gem 'delorean'
  gem 'rb-fsevent'
  gem 'growl'
  gem 'database_cleaner'
  gem 'guard-livereload'
  gem 'yajl-ruby'
  gem 'webmock'
  gem 'vcr'
  gem 'taps'
end

gem 'haml'
gem 'kaminari'
gem 'rails_autolink'
gem 'rest-client'
gem 'nokogiri'

gem 'rack-google-analytics'

# http://stackoverflow.com/questions/16426398/active-admin-install-with-rails-4
gem 'activeadmin', github: 'gregbell/active_admin'
