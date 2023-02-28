Rails.application.configure do

    # The test environment is used exclusively to run your application's
    # test suite. You never need to work with it otherwise. Remember that
    # your test database is "scratch space" for the test suite and is wiped
    # and recreated between test runs. Don't rely on the data there!
    config.cache_classes = true

    # Do not eager load code on boot. This avoids loading your whole application
    # just for the purpose of running a single test. If you are using a tool that
    # preloads Rails for running tests, you may have to set it to true.
    config.eager_load = false

    # Configure static file server for tests with Cache-Control for performance.
    config.serve_static_files   = false
    config.static_cache_control = 'public, max-age=3600'
    config.reload_classes_only_on_change = false
    # Show full error reports and disable caching.
    config.consider_all_requests_local       = true
    config.action_controller.perform_caching = false

    # Raise exceptions instead of rendering exception templates.
    config.action_dispatch.show_exceptions = false

    # Disable request forgery protection in test environment.
    config.action_controller.allow_forgery_protection = false

    # Randomize the order test cases are executed.
    config.active_support.test_order = :random

    # Print deprecation notices to the stderr.
    config.active_support.deprecation = :stderr

    # Raises error for missing translations
    # config.action_view.raise_on_missing_translations = true
  #mailer configuration
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = false
  config.active_job.queue_adapter = :async


  # config.action_mailer.default_url_options = { host: "localhost:3000" }
  config.action_mailer.default_url_options = { host: ENV["HOST"] }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: ENV["MAIL_HOST"],
    port: 587,
    user_name: ENV["MAIL_USERNAME"],
    password: ENV["MAIL_PASSWORD"],
    enable_starttls_auto: true,
    authentication: :login
  }

  config.i18n.fallbacks = true
end
