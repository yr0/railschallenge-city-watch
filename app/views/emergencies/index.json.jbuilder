json.emergencies do
  json.array!(@emergencies) do |emergency|
    json.partial!('emergency', emergency: emergency)
  end
end
