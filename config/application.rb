require_relative "boot"

require "rails/all"

require 'open-uri'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Mygithub
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.active_job.queue_adapter = :sidekiq
    
    config.autoload_paths += [config.root.join('app')]

    config.cache_store = :redis_store, 'redis://localhost:6379/0/cache', { expires_in: 90.minutes }

    config.generators do |g|
      g.test_framework :rspec,
                       view_specs: false,
                       controller_specs: true,
                       helper_specs: false,
                       routing_specs: false,
                       request_specs: false

    end


  end
end
