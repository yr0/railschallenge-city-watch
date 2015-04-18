json.array!(@responders) do |responder|
  json.extract! responder, :id, :type, :name, :capacity, :on_duty, :emergency_id
  json.url responder_url(responder, format: :json)
end
