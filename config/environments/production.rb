Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Ensures that a master key has been made available in either ENV["RAILS_MASTER_KEY"]
  # or in config/master.key. This key is used to decrypt credentials (and other encrypted files).
  # config.require_master_key = true

  # Enable static file serving from the `/public` folder (turn off `rails serve static files`).
  config.public_file_server.enabled = true
  config.serve_static_assets = true

  # Compress CSS using a preprocessor.
  config.assets.css_compressor = nil

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = true

  config.assets.prefix = '/ordenapp/assets'

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.asset_host = "http://assets.example.com"

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for Apache
  # config.action_dispatch.x_sendfile_header = "X-Accel-Redirect" # for NGINX

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # Mount Action Cable outside main process or domain.
  # config.action_cable.mount_path = nil
  # config.action_cable.url = "wss://example.com/cable"
  # config.action_cable.allowed_request_origins = [ "http://example.com", /http:\/\/example.*/ ]

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # Include generic and useful information about system operation, but avoid logging too much
  # information to avoid inadvertent exposure of personally identifiable information (PII).
  config.log_level = :info

  # Prepend all log lines with the following tags.
  config.log_tags = [ :request_id ]

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Use a real queuing backend for Active Job (and separate queues per environment).
  # config.active_job.queue_adapter     = :resque
  # config.active_job.queue_name_prefix = "ordenapp_production"

  config.action_mailer.perform_caching = false

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Don't log any deprecations.
  config.active_support.report_deprecations = false

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Use a different logger for distributed setups.
  # require "syslog/logger"
  # config.logger = ActiveSupport::TaggedLogging.new(Syslog::Logger.new "app-name")

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # Enable fragment caching in view templates
  config.action_controller.perform_caching = true

  # Set cache headers for static files
  config.public_file_server.headers = {
    'Cache-Control' => "public, max-age=#{1.year.to_i}",
    'X-Content-Type-Options' => 'nosniff',
    'X-Frame-Options' => 'DENY',
    'X-XSS-Protection' => '1; mode=block'
  }

  # Assume all access to the app is happening through a SSL-terminating reverse proxy.
  config.assume_ssl = true

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = false

  # Prevent health checks from clogging up the logs.
  config.silence_healthcheck_path = "/up"

  # Change to "debug" to log everything (including potentially personally-identifiable information!)
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Mailer configuration
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default_url_options = { 
    host: ENV["HOST"],
    script_name: Rails.application.config.relative_url_root
  }
  config.action_mailer.asset_host = "https://#{ENV["HOST"]}#{Rails.application.config.relative_url_root}"
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    user_name: ENV['EMAIL_USERNAME'],
    password: ENV['EMAIL_PASSWORD'],
    address: ENV['EMAIL_HOST'],
    port: ENV['EMAIL_PORT'],
    authentication: :plain,
    enable_starttls_auto: true
  }

  # Set the secret key base from environment variable
  config.secret_key_base = ENV['secret_key_base']

  # config.relative_url_root = "/ordenapp"
end
