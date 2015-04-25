##
# Logic concerning dispatching just the right amount of responders
module DispatchCalculations
  # Tries to get responders that are ready to handle all kinds of severity
  # for emergency.
  # @example
  #   Emergency.try_responding_in_full
  #   # => [true, [1, 2, 4, 6, 7, 9, 11, 12, 15]]
  # @return [Array<Boolean, Array<Integer>>]
  #   - [Boolean] indicates if full response is achieved for all types of severities
  #   - [Array<Integer>] responders ids that were dispatched
  def try_responding_in_full
    full_response = true
    all_units = []

    Responder.types.keys.each do |type|
      severity = method(:"#{type}_severity").call

      next unless severity > 0

      response, units = ResponderTypeCalculator.new(type, severity).calculate_response_and_dispatched

      all_units += units
      full_response &&= response
    end

    [full_response, all_units]
  end
end
