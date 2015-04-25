module DispatchCalculations
  class ResponderTypeCalculator
    ##
    # DispatchCalculations::ResponderTypeCalculator is a class for calculating capacity response for emergency
    # of certain severity. Usage:
    #
    #   DispatchCalculations::ResponderTypeCalculator.new('fire', 18)
    #
    # @param [String] type type of responders whose total capacity should be calculated
    # @param [Integer] severity certain type severity of emergency
    def initialize(type, severity)
      @severity = severity
      @response = true
      @dispatched = []

      # Capacities of responders that match severity the closest
      @closest_match = []

      # Get ids and capacities of responders of certain type, that are on duty and available, sorted in ascending order
      @capacities =    Responder
                       .of_type(type)
                       .available
                       .at_work
                       .order(capacity: :asc)
                       .pluck(:id, :capacity)
                       .to_h
    end

    ##
    # Process given severity to try and match it with capacities of available responders
    # @example
    #   rtc = DispatchCalculations::ResponderTypeCalculator.new('fire', 18)
    #   rtc.calculate_response_and_dispatched
    #   #=> [true, [1, 6, 8, 15]]
    # @return [Array<Boolean, Array<Integer>>] array of two elements
    #   - [Boolean] true if severity has been matched completely by available responders' capacities
    #   - [Array<Integer>] array of ids of dispatched responders
    def calculate_response_and_dispatched
      # return falsey full response and empty array if no available responders were found
      # or
      # return falsey full response and all responders' ids if severity is bigger than sum of all capacities
      return [false, @capacities.keys] if @capacities.empty? || @severity > @capacities.values.reduce(:+)

      dispatch_best_first

      [@response, @dispatched]
    end

    private

    ##
    # Find best combination of responders' capacities that sum up to given severity.
    # All capacities are ordered ascendingly, that is why we can 'jump out' of loop as soon as the capacities sum
    # matches severity, being sure that we get the optimal result or closest matching result in @closest_match variable
    # @return [Boolean] true if best combination is found, otherwise proceed to #closest_match_or_all
    def dispatch_best_first
      (1..@capacities.values.size).each do |n|
        @capacities.values.combination(n).each do |value_combination|
          return true if check_combination value_combination
        end
      end

      closest_match_or_all
    end

    ##
    # Check if combination of capacity value combination sums up to given severity.
    # For example:
    #   @severity = 15
    #   check_combination([1, 2, 3, 5])
    #   # => false
    #   check_combination([1, 1, 2, 3, 3, 5])
    #   # => true
    # If sum of capacities values does not match the severity, but is bigger, the value combination is stored
    # in @closest_match variable that is set only once (due to @capacities ascending order we are sure
    # that @closest_match stores the smallest possible result.
    # For example:
    #   @severity = 6
    #   check_combination([2, 5])
    #   # => false
    #   @closest_match
    #   # => [2, 5]
    # @return [Boolean] true if value_combination sums up to given severity, otherwise - false
    def check_combination(value_combination)
      values_sum = value_combination.reduce(:+)
      if values_sum == @severity
        @dispatched = @capacities.invert.slice(*value_combination).values
        return true
      end
      @closest_match = value_combination if @closest_match.empty? && values_sum > @severity
      false
    end

    ##
    # Set @dispatched value after dispatch_best_first has no results. @dispatched is set to units whose
    # sum of capacities matches severity the closest. If such units don't exist - @dispatched
    # is set to all responders and @response is set to false
    def closest_match_or_all
      @dispatched = if @closest_match.any?
                      @capacities.invert.slice(*@closest_match).values
                    else
                      @response = false
                      @capacities.keys
                    end
    end
  end
end
