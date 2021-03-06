require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Backend
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    # config.middleware.insert_before ActionDispatch::Request
    config.api_only = true
    config.action_mailer.default_url_options = { host: "example.com" }
    config.active_job.queue_adapter = :sidekiq
  end
end

ActiveModelSerializers.config.default_includes = '**'
