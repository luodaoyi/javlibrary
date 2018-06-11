require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# if defined?(Rails) && (Rails.env == 'development')
#   # Rails.logger = Logger.new(STDOUT)
#   Rails.logger.level = Logger::DEBUG
# end


module JavLibraryRails
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Define ENV['url'] for this crawler, default javlibrary url.
    $JAVLIBRARY_URL = "http://www.javlibrary.com"
    $JAVBUS_URL = "https://www.javbus9.pw/"
  end
end
