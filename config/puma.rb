# Puma can serve each request in a thread from an internal thread pool.
# The `threads`method takes two numbers: a minimum and maximum.
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

worker_timeout 3600 if ENV.fetch("RAILS_ENV", "development") == "development"

# Specifies the `environment` that Puma will run in.
environment ENV.fetch("RAILS_ENV") { "development" }

# --- CHOOSE ONE BINDING METHOD ---
# Method 1: Using the `port` directive (simpler for basic TCP)
# port ENV.fetch("PORT") { 3000 } # If you use this, comment out the `bind` line below.

# Method 2: Using the `bind` directive (more explicit, preferred)
# Comment out the `port` directive above if you use this `bind` line.
bind "tcp://0.0.0.0:#{ENV.fetch("PORT") { 3000 }}"
# --- END CHOOSE ONE BINDING METHOD ---


# workers ENV.fetch("WEB_CONCURRENCY") { 2 } # Uncomment for multi-process mode
# preload_app! # Uncomment if using workers

plugin :tmp_restart

# if defined?(ActiveRecord::Base) && ENV.fetch("WEB_CONCURRENCY", 0).to_i > 0
#   before_fork do
#     ActiveRecord::Base.connection_pool.disconnect!
#   end

#   on_worker_boot do
#     ActiveRecord::Base.establish_connection
#   end
# end