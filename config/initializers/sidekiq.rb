Sidekiq.configure_server do |c|
  c.redis = {url: 'redis://redis:6379/1'}
end

Sidekiq.configure_client do |c|
  c.redis = {url: 'redis://redis:6379/1'}
end

Sidekiq.default_worker_options = { 'backtrace' => 10 }
