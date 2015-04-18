class Emergency < ActiveRecord::Base
  include EmergencyStates

  extend FriendlyId
  friendly_id :code, use: :slugged, slug_column: :code

  self.primary_key = :code

  has_many :responders, foreign_key: :emergency_code

  validates :code, presence: true, uniqueness: true
  validates :fire_severity, :police_severity, :medical_severity, allow_blank: true, length: { minimum: 0 }
end
