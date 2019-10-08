# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers: a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum; this matches the default thread size of Active Record.
#
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count

# Specifies the `environment` that Puma will run in.
#
environment ENV.fetch("RAILS_ENV") { "development" }

# Specifies the number of `workers` to boot in clustered mode.
# Workers are forked webserver processes. If using threads and workers together
# the concurrency of the application would be max `threads` * `workers`.
# Workers do not work on JRuby or Windows (both of which do not support
# processes).
#
# workers ENV.fetch("WEB_CONCURRENCY") { 2 }

# Use the `preload_app!` method when specifying a `workers` number.
# This directive tells Puma to first boot the application and load code
# before forking the application. This takes advantage of Copy On Write
# process behavior so workers use less memory.
#
# preload_app!

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart

# SSL in development (as DFE Signin redirects to https://localhost:3000 but
# just listen on port 3000 elsewhere
listen_port = ENV.fetch("PORT") { 3000 }

if Rails.env.development?

  cert = Rails.root.join('config', 'ssl', 'localhost.crt')
  key = Rails.root.join('config', 'ssl', 'localhost.key')

  unless File.exist?(cert) && File.exist?(key)
    fail "No SSL certificate found, run `rails dev:ssl:generate` to proceed"
  end

  ssl_bind '127.0.0.1', listen_port, cert: cert, key: key, verify_mode: 'none'
else
  port listen_port
end
