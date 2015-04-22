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
                       .pluck(:id, :capacity)
                       .to_h
    end

    def calculate
      return [false, @capacities.keys] if @capacities.empty? || @severity > @capacities.values.reduce(&:+)

      dispatch_from_combinations

      [@response, @dispatched]
    end

    private

    def dispatch_from_combinations
      (1..@capacities.values.size).each do |n|
        @capacities.values.combination(n).each do |value_combination|
          # RuboCop frowns at empty return values
          return true if check_combination value_combination
        end
      end

      best_worst_or_fail
    end

    def best_worst_or_fail
      @dispatched = if @best_worst.empty?
                      @response = false
                      @capacities.keys
                    else
                      @capacities.invert.slice(*@best_worst).values
                    end
    end

    def check_combination(value_combination)
      if value_combination.reduce(:+) == @severity
        @dispatched = @capacities.invert.slice(*value_combination).values
        return true
      end
      @best_worst = value_combination if @best_worst.empty? && value_combination.reduce(:+) > @severity
      false
    end
  end
end
