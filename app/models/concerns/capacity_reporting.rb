##
# Logic pertaining the report counting of responders' capacity
module CapacityReporting
  extend ActiveSupport::Concern

  module ClassMethods
    # Generate capacity report on all types of responders.
    # @example
    #   Responder.capacity_report
    #   # => { "Fire" => [5, 2, 5, 2], "Medical" => [7, 1, 3, 1], "Police" => [0, 0, 0, 0] }
    # @return [Hash] all capacities by type
    def capacity_report
      types.keys.each.with_object({}) do |type, result|
        result[type.capitalize] = count_capacities_by_type type
      end
    end

    # Count capacities sums for specific type. Method relies on scopes
    # @param [String] type type of responder
    # @example
    #   Responder.count_capacities('fire')
    #   # => [5, 2, 5, 2]
    # @return [Array<Integer>] total capacity, capacity of those available, on duty, and both available and on duty
    def count_capacities_by_type(type)
      [
        of_type(type).sum(:capacity),
        of_type(type).available.sum(:capacity),
        of_type(type).at_work.sum(:capacity),
        of_type(type).available.at_work.sum(:capacity)
      ]
    end
  end
end
