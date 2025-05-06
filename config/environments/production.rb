Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot for better performance and memory savings (ignored by Rake tasks).
  config.eager_load = true

  # Full error reports are disabled.
  config.consider_all_requests_local = false

  # Turn on fragment caching in view templates.
  config.action_controller.perform_caching = true

  # Enable serving of static files from the `/public` folder
  config.public_file_server.enabled = true
  config.serve_static_assets = true

  # Compress CSS using a preprocessor
  config.assets.css_compressor = nil  # Disable CSS compression temporarily

  # Do not fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = true  # Allow runtime compilation

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.asset_host = "http://assets.example.com"

  # Cache assets for far-future expiry since they are all digest stamped.
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=#{1.year.to_i}",
    "X-Content-Type-Options" => "nosniff",
    "X-Frame-Options" => "DENY",
    "X-XSS-Protection" => "1; mode=block"
  }

  # Store uploaded files on the local file system (see config/storage.yml for options)
  config.active_storage.service = :local

  # Assume all access to the app is happening through a SSL-terminating reverse proxy.
  config.assume_ssl = true

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = false

  # Log to STDOUT with the current request id as a default log tag.
  config.log_tags = [ :request_id ]
  config.logger = ActiveSupport::Logger.new(STDOUT)
  config.logger = ActiveSupport::TaggedLogging.new(config.logger)

  # Change to "debug" to log everything (including potentially personally-identifiable information!)
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Prevent health checks from clogging up the logs.
  config.silence_healthcheck_path = "/up"

  # Don't log any deprecations.
  config.active_support.report_deprecations = false

  # Use a real queuing backend for Active Job (and separate queues per environment)
  config.active_job.queue_adapter = :async

  # Mailer configuration
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default_url_options = { host: ENV["HOST"] }
  config.action_mailer.asset_host = ENV["HOST"]
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    user_name: ENV['EMAIL_USERNAME'],
    password: ENV['EMAIL_PASSWORD'],
    address: ENV['EMAIL_HOST'],
    port: ENV['EMAIL_PORT'],
    authentication: :plain,
    enable_starttls_auto: true
  }

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # Set the secret key base from environment variable
  config.secret_key_base = ENV['secret_key_base']
end
