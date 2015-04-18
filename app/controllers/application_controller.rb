class ApplicationController < ActionController::API
  include ApplicationHelper

  def not_found
    render_json 404
  end
end
