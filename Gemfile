source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.3", ">= 7.0.3.1"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

gem "figaro"
gem "kaminari"
gem "pg_search"
gem "jb"
gem "jwt"
gem "google-protobuf"
gem "anycable-rails"
gem "daemons", "~> 1.4", require: false

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "timecop"
  gem "factory_bot_rails"
end

group :development do
  # Solargraph is a powerful ruby language server which provides intellisense
  # But, Support for rails is incomplete
  #
  # See https://github.com/castwide/solargraph/issues/87
  gem "solargraph"
  gem "solargraph-rails"

  gem "rufo"
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
  gem "faker", git: "https://github.com/faker-ruby/faker.git", branch: "master"
  gem "pry"
  # deploy
  gem "ed25519"
  gem "bcrypt_pbkdf"
  gem "capistrano", "~> 3.17", require: false
  gem "capistrano3-puma", github: "seuros/capistrano-puma"
  gem "capistrano-rails", "~> 1.6", require: false
  gem "capistrano-bundler", "~> 2.1", require: false
  gem "capistrano-rbenv", "~> 2.2", require: false
  gem "capistrano-rbenv", "~> 2.2", require: false
  gem "capistrano-anycable"

  # This gem boost up developer's speed by supporting Hot Module Reloading
  gem "rails_live_reload"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem "n_plus_one_control"
end
