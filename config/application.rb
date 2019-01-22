require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PicnotesServer
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.exceptions_app = self.routes

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Don't generate system test files.
    config.generators.system_tests = nil
    # => This is an example of ALL available config options
    # => You're able to see exactly how it works here:
    # => https://github.com/richpeck/exception_handler/blob/master/lib/exception_handler/config.rb

    # => Config hash (no initializer required)
    config.exception_handler = {
      dev:        nil, # allows you to turn ExceptionHandler "on" in development
      db:         nil, # allocates a "table name" into which exceptions are saved (defaults to nil)
      email:      nil, # sends exception emails to a listed email (string // "you@email.com")

      # Custom Exceptions
      custom_exceptions: {
        #'ActionController::RoutingError' => :not_found # => example
      },

      # On default 5xx error page, social media links included
      social: {
        facebook: nil, # Facebook page name
        twitter:  nil, # Twitter handle
        youtube:  nil, # Youtube channel name / ID
        linkedin: nil, # LinkedIn name
        fusion:   nil  # FL Fusion handle
      },

      # This is an entirely NEW structure for the "layouts" area
      # You're able to define layouts, notifications etc ↴

      # All keys interpolated as strings, so you can use symbols, strings or integers where necessary
      exceptions: {

        :all => {
          layout: "exception", # define layout
          notification: true, # (false by default)
          deliver: #something here to control the type of response
        },
        :4xx => {
          layout: nil, # define layout
          notification: true, # (false by default)
          deliver: #something here to control the type of response
        },
        :5xx => {
          layout: "exception", # define layout
          notification: true, # (false by default)
          deliver: #something here to control the type of response
        },
        500 => {
          layout: "exception", # define layout
          notification: true, # (false by default)
          deliver: #something here to control the type of response
        },

        # This is the old structure
        # Still works but will be deprecated in future versions

        501 => "exception",
        502 => "exception",
        503 => "exception",
        504 => "exception",
        505 => "exception",
        507 => "exception",
        510 => "exception"

      }
    }
  end
end
