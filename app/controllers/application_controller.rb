require "#{Rails.root}/lib/controller_helpers/controller_helpers"

class ApplicationController < ActionController::API
  include ControllerHelpers

  def not_found
    render_json 404
  end
end
