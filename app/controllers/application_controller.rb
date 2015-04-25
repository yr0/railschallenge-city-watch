class ApplicationController < ActionController::API
  include ActionController::ImplicitRender
  include ErrorHandling

  # all 404 routes go here
  def not_found
    render_error status: :not_found, body: 'page not found'
  end
end
