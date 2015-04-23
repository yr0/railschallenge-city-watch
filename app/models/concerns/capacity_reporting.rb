module CapacityReporting
  extend ActiveSupport::Concern

  module ClassMethods
    def capacity_report
      # get capitalized type names: ["Fire", "Medical", "Police"]
      types_hash = types.keys.map(&:capitalize)

      capacity = all_sums

      # fetch type result from capacity, otherwise - fill with zeroes
      types_hash.each_with_index.with_object({}) do |(type, idx), result|
        result[type] = capacity[idx] || [0, 0, 0, 0]
      end
    end

    # get all types' sums in one query, instead of 12
    def all_sums
      query = connection.execute <<SQL
SELECT  type,
        SUM(capacity) AS total,
        SUM(CASE WHEN emergency_code IS NULL THEN capacity ELSE 0 END) AS are_available,
        SUM(CASE WHEN on_duty='t' THEN capacity ELSE 0 END) AS are_on_duty,
        SUM(CASE WHEN emergency_code IS NULL AND on_duty='t' THEN capacity ELSE 0 END) AS are_on_duty_and_available
FROM    responders
GROUP BY type;
SQL

      # get only integer-indexed values from query: [[0, 12, 7, 12, 7], [2, 1, 0, 1, 0]]
      query.map! { |result_hash| result_hash.keep_if { |k| k.is_a? Integer }.values }

      # transform the values by keys: {0 => [12, 7, 12, 7], 2 => [1, 0, 1, 0]}
      query.map { |arr| [arr[0], arr[1..-1]] }.to_h
    end
  end
end
