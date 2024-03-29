require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PollsAppApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1
    config.autoload_paths += %W(
      #{ Rails.root.join('lib') }
      #{ Rails.root.join('app', 'serializers') }
      
    )

    class Application < Rails::Application
      config.active_record.primary_key = :uuid
    
      config.generators do |g|
        g.orm :active_record, primary_key_type: :uuid
        g.orm :active_record, foreign_key_type: :uuid
      end
    end


    config.action_cable.disable_request_forgery_protection = true
    config.action_cable.url = "/cable"

    
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.active_job.queue_adapter = :sidekiq
    config.api_only = true
  end
end
