json.extract! emergency, :code, :fire_severity, :medical_severity, :police_severity, :resolved_at, :full_response

# Here we could use emergency.responders.pluck(:name), but that would fire many (amount of Responder.count) queries
# during collection (#index) action. Instead, we make Emergency ::includes responders in the EmergenciesController#index
# and here use #map which seems counter-idiomatic, yet is more efficient (no queries to the database are fired,
# since responders are already stored in the memory). In effect, we chose 2 over 1 + n queries.
# During other actions (e.g. #show) this takes standard 2 queries - one for fetching emergency, and another - for
# fetching its responders
json.set! :responders, emergency.responders.map(&:name)