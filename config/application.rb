require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Ordenapp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.active_record.default_timezone = :local
    config.time_zone = 'Bogota'
    config.i18n.available_locales = [:en, :es]
    config.i18n.default_locale = :es
    # config.active_job_queue_adapter = Rails.env.production? ? :sidekiq : :async
    config.exceptions_app = self.routes
    config.autoloader = :classic

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource(
          '*',
          headers: :any,
          expose: ["Authorization"],
          methods: [:get, :patch, :put, :delete, :post, :options, :show]
        )
      end
    end
  end
end
