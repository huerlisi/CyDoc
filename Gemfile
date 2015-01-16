# Gemfile
# =======
# Policies:
# * We do not add versioned dependencies unless needed
# * If we add versioned dependencies, we document the reason
# * We use single quotes
# * We use titles to group related gems

# Settings
# ========
source 'https://rubygems.org'

# Rails
# =====
gem 'rails', '~> 3.2'

# Unicorn
# =======
gem 'unicorn'

# Database
# ========
gem 'mysql2'
gem 'sqlite3'

# Asset Pipeline
# ==============
gem 'less-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'therubyracer'
gem 'quiet_assets'

# CRUD
# ====
gem 'inherited_resources'
gem 'has_scope'
gem 'kaminari'
gem 'show_for'
gem 'i18n_rails_helpers'

# I18n
# ====
gem 'routing-filter'

# UI
# ==
gem 'jquery-rails'
gem 'haml'
gem 'twitter-bootstrap-rails'
gem 'lyb_sidebar'
gem 'simple-navigation'

# Forms
# =====
gem 'simple_form'
gem 'select2-rails'
gem 'in_place_editing'


# Access Control
# ==============
gem 'devise', '~> 2.2' # Changed API
gem 'devise-i18n'
gem 'cancan', '1.6.8' # Issue with aliases
gem 'lyb_devise_admin'

# State Machine
gem 'aasm'

# Date/Time handling
gem 'validates_timeliness'

# Application Settings
gem 'ledermann-rails-settings', '~> 1.2', :require => 'rails-settings' # Changed API

# Addresses
gem 'unicode_utils'
gem 'has_vcards', '~> 0.20' # Data model changes, needs synced release with CyDoc
gem 'autocompletion'
gem 'swissmatch'
gem 'swissmatch-location', :require => 'swissmatch/location/autoload'

# Files
gem 'carrierwave'

# Billing
gem 'has_accounts', '~> 1.1' # Changed API
gem 'has_accounts_engine', '~> 1.1' # Changed API
gem 'acts-as-taggable-on'
gem 'vesr'

# Import / Export
gem 'fastercsv'
gem 'activerecord-sqlserver-adapter'
gem 'csv-mapper'

# Multiple Databases
gem 'use_db'

# PDF generation
gem 'prawn', '1.0.0.rc2' # table support needs porting, group has been dropped

# Printing
gem 'cupsffi'

# Search
gem 'thinking-sphinx', '~> 2.0' # Changed API


# Development
# ===========
group :development do
  # Debugging
  gem 'better_errors'
  gem 'binding_of_caller'  # Needed by binding_of_caller to enable html console

  # Deployment
  gem 'capones_recipes'
end

# Dev and Test
# ============
group :development, :test do
  # Testing Framework
  gem 'rspec-rails'
  gem 'rspec-activemodel-mocks'

  # Browser
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'poltergeist'
  gem 'selenium-webdriver'

  # Matchers/Helpers
  gem 'accept_values_for'

  # Debugger
  gem 'pry-rails'
  gem 'pry-byebug'

  # Fixtures
  gem 'database_cleaner'
  gem 'connection_pool'
  gem "factory_girl_rails"
end

# Docs
# ====
group :doc do
  # Docs
  gem 'rdoc'
end
