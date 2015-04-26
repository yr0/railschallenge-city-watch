json.emergencies do
  json.array!(@emergencies) do |emergency|
    json.partial!('emergency', emergency: emergency)
  end
end

json.set! :full_responses, Emergency.fully_responded_and_total
