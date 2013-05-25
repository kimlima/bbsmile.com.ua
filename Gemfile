source 'https://rubygems.org'

gem 'rails', '4.0.0.rc1'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'
gem 'ancestry', github: 'stefankroes/ancestry', branch: 'master'
gem 'nilify_blanks'

gem 'slim', github: 'slim-template/slim', ref: '594f4f90'
# gem 'slim-rails', github: 'slim-template/slim-rails'
gem 'cells'
gem 'simple_form', '>= 3.0.0beta1'
gem 'attribute_normalizer'
gem 'acts_as_list'
gem 'acts-as-taggable-on', github: 'mbleigh/acts-as-taggable-on'

gem 'jquery-rails'
gem 'json', '~> 1.7.7'
gem 'bootstrap-wysihtml5-rails'
gem 'paperclip'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'less-rails-bootstrap'
  gem 'font-awesome-rails'
  gem 'coffee-rails', '>= 4.0.0beta1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

group :development do
  gem 'seedbank'
  gem 'rb-inotify', require: false
  gem 'guard-rspec'
  gem 'guard-cucumber'
  gem 'guard-zeus-client'
  gem 'meta_request'
end

group :development, :test do
  gem 'rspec-rails', '~> 2.13.0'
  gem 'factory_girl_rails'
  gem 'faker'
end

group :test do
  gem 'cucumber-rails', require: false, github: 'cucumber/cucumber-rails', branch: 'master_rails4_test'
  gem 'capybara'
  gem 'shoulda'
  gem 'launchy'
  gem 'database_cleaner'
end


# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano'

# To use debugger
# gem 'debugger'
