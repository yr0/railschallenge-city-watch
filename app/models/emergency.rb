class Emergency < ActiveRecord::Base
  include EmergencyStates

  extend FriendlyId
  friendly_id :code, use: :slugged, slug_column: :code

  self.primary_key = :code

  has_many :responders, foreign_key: :emergency_code

  validates :code, presence: true, uniqueness: true
  validates :fire_severity, :police_severity, :medical_severity,
            presence: true, numericality: { greater_than_or_equal_to: 0 }

  # calculate fully responded emergencies and total amount of emergencies
  def self.total_and_responded
    [where(full_response: true).count, count]
  end
end
