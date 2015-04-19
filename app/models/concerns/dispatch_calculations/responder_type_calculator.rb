module DispatchCalculations
  class ResponderTypeCalculator
    def initialize(type, severity)
      @severity = severity
      @capacities =    Responder
                       .method(type).call
                       .where(on_duty: true)
                       .order(capacity: :desc)
                       .pluck(:name, :capacity)
                       .to_h
      @response = true
      @dispatched = []
    end

    def calculate
      return [false, @capacities.keys] if @capacities.empty? || @severity > @capacities.values.reduce(&:+)

      distribute_optimally

      [@response, @dispatched]
    end

    def distribute_optimally
      reducing_severity = @severity

      loop do
        capacity = filter_capacities.values.find { |e| e <= reducing_severity }
        if capacity
          @dispatched << filter_capacities.invert[capacity]
          reducing_severity -= capacity
          break if reducing_severity == 0
        else
          find_bigger_capacity_or_fail
          break
        end
      end
    end

    private

    def filter_capacities
      # if we would need to scale, here we would select filtered capacities from database
      @capacities.except(*@dispatched)
    end

    def find_bigger_capacity_or_fail
      bigger_capacity = filter_capacities.values.find { |e| e > @severity }
      if bigger_capacity
        @dispatched = [filter_capacities.invert[bigger_capacity]]
      else
        @response = false
      end
    end
  end
end
