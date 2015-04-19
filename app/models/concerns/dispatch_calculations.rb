module DispatchCalculations
  def calculate_available_responders
    full_response = true
    all_units = []

    Responder.types.keys.each do |type|
      severity = method(:"#{type}_severity").call

      next unless severity > 0

      response, units = ResponderTypeCalculator.new(type, severity).calculate

      all_units += units
      full_response &&= response
    end

    [full_response, all_units]
  end
end
