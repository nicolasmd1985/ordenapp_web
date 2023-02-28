# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
# gem 'rails', '~> 5.2.3'
gem 'rails', '~> 7.0.2.2'
# Use mysql as the database for Active Record
gem 'pg'
# gem 'mysql2', '>= 0.4.4', '< 0.6.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'duktape'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
gem 'omniauth', "~> 1.9.1"
gem 'devise'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
gem "cancan"
#geocoder
gem 'geocoder'

gem "figaro"

#gem for locals
gem 'rails-i18n'
gem "i18n-js"

gem 'jquery-rails'
gem 'heatmap-rails'

gem 'jquery-validation-rails'

gem "font-awesome-rails"

gem 'material_icons'

gem 'popper_js'

gem 'aos', '~> 0.1.0'

#Generate PDF's
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'
#barcodes
gem 'barby'
gem 'chunky_png', '~> 1.3', '>= 1.3.5'
gem 'rqrcode'
#csv
gem 'fastercsv'
gem 'rubyzip', '>= 1.0.0'
gem 'zip-zip'
gem 'axlsx'
gem 'axlsx_rails'
# gem 'acts_as_xlsx', :git => "git://github.com/NickSealer/acts_as_xlsx.git"
gem 'acts_as_xlsx'

#gems for credentials aws
gem "fog-aws"

#gem carriewave
gem 'carrierwave'

# Use ActiveStorage variant
gem 'mini_magick'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

# Use ActiveModel has_secure_password
gem 'bcrypt'

gem 'jwt'

#use engine haml
gem 'haml'

# Pagination
gem 'will_paginate', '~> 3.1.0'

#front
# gem 'twitter-bootstrap-rails', '~> 4.0'
# gem 'materialize-sass', '~> 1.0.0'

gem "recaptcha"
gem 'bootstrap', '~> 4.5.0'

#swet alert
gem 'rails-assets-sweetalert2', '~> 5.1.1', source: 'https://rails-assets.org'
gem 'sweet-alert2-rails'

gem "sidekiq", "~> 5.1", ">= 5.1.3"
gem 'whenever'
gem 'fcm'

gem 'draper'

#facebook OmniAuth
gem 'omniauth-facebook'
#google OmniAuth
gem 'omniauth-google-oauth2'

#breadcrumb
gem "breadcrumbs_on_rails"

group :production do
  gem "passenger", ">= 5.0.25", require: "phusion_passenger/rack_handler"
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails', '~> 3.8'
  gem "better_errors"
  gem "binding_of_caller"
  gem 'capybara'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'pry'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rubocop-rails'
  gem "letter_opener", "~> 1.4", ">= 1.4.1"
end

group :test do
  gem 'webdrivers', '~> 3.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
