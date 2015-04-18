module ApplicationHelper
  def render_json(status, body_hash = {})
    status = status.to_s
    if body_hash.empty? && error_responses.key?(status)
      body_hash = error_responses[status]
    end

    render json: body_hash.to_json, status: status
  end

  def error_responses
    {
      '404' => { message: 'page not found' }
    }
  end
end
