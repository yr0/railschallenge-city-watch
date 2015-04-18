json.array!(@responders) do |responder|
  json.extract! responder, :type, :name, :capacity, :on_duty, :emergency_code
  json.url responder_url(responder, format: :json)
end
