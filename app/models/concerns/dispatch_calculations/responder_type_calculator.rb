module DispatchCalculations
  class ResponderTypeCalculator
    def initialize(type, severity)
      @severity = severity
      @response = true
      @dispatched = []
      @best_worst = []

      @capacities =    Responder
                       .method(type).call
                       .where(on_duty: true)
                       .order(capacity: :asc)
                       .pluck(:name, :capacity)
                       .to_h
    end

    def calculate
      return [false, @capacities.keys] if @capacities.empty? || @severity > @capacities.values.reduce(:+)

      dispatch_best_first

      [@response, @dispatched]
    end

    private

    def dispatch_best_first
      (1..@capacities.values.size).each do |n|
        @capacities.values.combination(n).each do |value_combination|
          # RuboCop frowns at empty return values
          return true if check_combination value_combination
        end
      end

      # dispatch units whose sum of capacities matches severity the closest
      # if such units don't exist - dispatch all responders without full response
      best_worst_or_all
    end

    def best_worst_or_all
      @dispatched = if @best_worst.empty?
                      @response = false
                      @capacities.keys
                    else
                      @capacities.invert.slice(*@best_worst).values
                    end
    end

    def check_combination(value_combination)
      values_sum = value_combination.reduce(:+)
      if values_sum == @severity
        @dispatched = @capacities.invert.slice(*value_combination).values
        return true
      end
      @best_worst = value_combination if @best_worst.empty? && values_sum > @severity
      false
    end
  end
end
