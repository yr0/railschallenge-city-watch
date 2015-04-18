require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CityWatch
  class Application < Rails::Application
    config.active_record.raise_in_transactional_callbacks = true
    config.action_controller.action_on_unpermitted_parameters = :raise
  end
end
