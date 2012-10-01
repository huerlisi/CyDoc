require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env) if defined?(Bundler)

module CyDoc
  class Application < Rails::Application
    config.autoload_paths += [config.root.join('lib')]
    config.encoding = 'utf-8'
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    # See Rails::Configuration for more options.

    # Skip frameworks you're not going to use (only works if using vendor/rails).
    # To use Rails without a database, you must remove the Active Record framework
    # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

    # Only load the plugins named here, in the order given. By default, all plugins
    # in vendor/plugins are loaded in alphabetical order.
    # :all can be used as a placeholder for all plugins not explicitly named
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Add additional load paths for your own custom dirs
    # config.load_paths += %W( #{RAILS_ROOT}/extras )

    # Force all environments to use the same logger level
    # (by default production uses :info, the others :debug)
    # config.log_level = :debug

    # Use the database for sessions instead of the cookie-based default,
    # which shouldn't be used to store highly confidential information
    # (create the session table with 'rake db:sessions:create')
    # config.action_controller.session_store = :active_record_store

    # Use SQL instead of Active Record's schema dumper when creating the test database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Activate observers that should always be running
    # config.active_record.observers = :cacher, :garbage_collector

    # Make Active Record use UTC-base instead of local time
    config.time_zone = 'Bern'
    config.active_record.default_timezone = :utc

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.fallbacks = [:'de-CH', :de]
    config.i18n.default_locale = 'de-CH'

    # Authentication
    config.active_record.observers = :user_observer

    # Filter parameters
    config.filter_parameters += [:password, :password_confirmation, :old_password]

    # Using vendored plugin as it needs to be included after validates_timeliness
    # config.gem 'validation_reflection'
  end
end
