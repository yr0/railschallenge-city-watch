json.emergencies do
  json.array!(@emergencies) do |emergency|
    json.partial!('emergency', emergency: emergency)
  end
end

json.set! :full_responses, Emergency.total_and_responded
