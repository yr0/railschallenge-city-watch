module CapacityReporting
  extend ActiveSupport::Concern

  module ClassMethods
    def capacity_report
      result = {}
      capacity = all_sums

      # reformat types to capitalized type name
      types_hash = types.map { |k, v| [k.to_s.capitalize, v] }.to_h

      types_hash.each do |responder_type, types_index_in_table|
        type_sums = nil
        capacity.each do |type_capacity|
          if type_capacity[0] == types_index_in_table
            type_sums = type_capacity[1..-1]
            break
          end
        end

        # if no responder of specific type is found, fill with zeroes
        type_sums ||= [0, 0, 0, 0]

        result[responder_type] = type_sums
      end

      result
    end

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

      # get only integer-indexed values from query
      query.map! { |s| s.keep_if { |k| k.is_a? Integer }.values }
    end
  end
end
