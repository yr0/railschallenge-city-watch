class ApplicationController < ActionController::API
  include ActionController::ImplicitRender
  include ApplicationHelper

  rescue_from ActionController::ParameterMissing, ActionController::UnpermittedParameters do |exception|
    render_error body: exception.message
  end

  rescue_from ActiveRecord::RecordNotFound do
    not_found
  end

  def not_found
    render_error status: :not_found
  end
end
