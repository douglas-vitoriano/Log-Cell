source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.1.3"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"
# Ruby library to interface with the SQLite3 database engine
gem "sqlite3", "~> 2.9", ">= 2.9.3"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"

# Trestle is a modern, responsive admin framework for Ruby on Rails.
gem "trestle", "~> 0.10.1"

# Search plugin for the Trestle admin framework
gem "trestle-search", "~> 0.5.1"

# Authentication plugin for the Trestle admin framework
gem "trestle-auth", "~> 0.5.0"

# Flexible authentication solution for Rails with Warden
gem "devise", "~> 5.0", ">= 5.0.3"

# AASM is a continuation of the acts-as-state-machine rails plugin, built for plain Ruby objects.
gem "aasm", "~> 5.5", ">= 5.5.2"

# Allows marking ActiveRecord objects as discarded, and provides scopes for filtering.
gem "discard", "~> 1.4"

# Track changes to your models, for auditing or versioning.
gem "paper_trail", "~> 17.0"

# This library provides integration of RubyMoney - Money gem with Rails
gem "money-rails", "~> 3.0"

# # Validate, generate and format CPF/CNPJ numbers. Include command-line tools.
# gem "cpf_cnpj", "~> 1.0", ">= 1.0.1"

# Barby creates barcodes.
gem "barby", "~> 0.7.0"

# rqrcode is a library for encoding QR Codes
gem "rqrcode", "~> 3.2"

# This pure Ruby library can read and write PNG images without depending on an external image library, like RMagick. It tries to be memory efficient and reasonably fast
gem "chunky_png", "~> 1.4"

# Prawn is a fast, tiny, and nimble PDF generator for Ruby
gem "prawn", "~> 2.5"

# Prawn::Table provides tables for the Prawn PDF toolkit
gem "prawn-table", "~> 0.2.2"

# Wicked PDF uses the shell utility wkhtmltopdf to serve a PDF file to a user from HTML
gem "wicked_pdf", "~> 2.8", ">= 2.8.2"

# Provides binaries for WKHTMLTOPDF project in an easily accessible package.
gem "wkhtmltopdf-binary", "~> 0.12.6.10"

# The simplest way to group temporal data
gem "groupdate", "~> 6.8"

# Ruby implementation of Nanoid, secure URL-friendly unique ID generator
gem "nanoid", "~> 0.1.0"

# A Ruby wrapper for the Cloudflare API.
gem "cloudflare", "~> 4.5"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Audits gems for known security defects (use config/bundler-audit.yml to ignore issues)
  gem "bundler-audit", require: false

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false

  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"

  # Loads env variables from dotnev file
  gem "dotenv", "~> 2.8"

  gem "guard-rspec", require: false
  gem "rspec-rails", "~> 8.0.4"
  gem "rspec-html-matchers", "~> 0.10.0"
  gem "rspec-sonarqube-formatter", "~> 1.5", require: false

  gem "capybara"
  gem "capybara-selenium"
  gem "database_cleaner-active_record"

  gem "webmock", "~> 3.23"
  gem "faker", "~> 3.4"

  gem "simplecov"
  gem "simplecov-json"
end

group :development do
end
