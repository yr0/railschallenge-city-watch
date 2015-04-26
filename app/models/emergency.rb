class Emergency < ActiveRecord::Base
  include EmergencyStates

  has_many :responders, foreign_key: :emergency_code

  validates :code, presence: true, uniqueness: true
  validates :fire_severity, :police_severity, :medical_severity,
            presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Calculate fully responded emergencies and total amount of emergencies
  # @return [Array<Integer>]:
  #   - [Integer] number of emergencies with full response
  #   - [Integer] total count of emergencies
  def self.fully_responded_and_total
    [where(full_response: true).count, count]
  end
end
