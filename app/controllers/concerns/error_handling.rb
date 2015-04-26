##
# Encompasses all application logic concerning handling of 404 and 400 errors with proper API responses
module ErrorHandling
  extend ActiveSupport::Concern

  ##
  # HTTP errors that are actually used in the project and their corresponding status codes
  HTTP_ERRORS = {
    not_found: 404,
    unprocessable_entity: 422
  }

  included do
    rescue_from ActionController::ParameterMissing, ActionController::UnpermittedParameters do |exception|
      render_error body: exception.message
    end

    rescue_from ActiveRecord::RecordInvalid do |exception|
      render_error body: exception.record.errors.messages
    end

    rescue_from ActiveRecord::RecordNotFound do
      not_found
    end
  end

  ##
  # Helper method for rendering json errors
  #
  # @param [Hash] opts options for error:
  # @option opts [Symbol] :status - string-coded key from {HTTP_ERRORS} to be returned . Default: :unprocessable_entity
  # @option opts [String] :body - message to be passed along with error status. Defaults to value of :status
  def render_error(opts = {})
    opts[:status] ||= :unprocessable_entity
    status = HTTP_ERRORS[opts[:status].to_sym]
    body = { message: opts[:body] || opts[:status] }.to_json

    render json: body, status: status
  end
end
