json.extract! emergency, :code, :fire_severity, :medical_severity, :police_severity, :resolved_at, :full_response
json.set! :responders, emergency.responders.pluck(:name)