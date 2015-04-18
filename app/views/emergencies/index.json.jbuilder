json.array!(@emergencies) do |emergency|
  json.extract! emergency, :id, :code, :fire_severity, :medical_severity, :police_severity, :full_response, :resolved_at
  json.url emergency_url(emergency, format: :json)
end
