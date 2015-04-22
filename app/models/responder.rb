class Responder < ActiveRecord::Base
  include CapacityReporting

  self.inheritance_column = nil

  enum type: %w(fire medical police)

  belongs_to :emergency, foreign_key: :emergency_code

  validates :type, presence: true
  validates :name, presence: true, uniqueness: true
  validates :capacity, presence: true, inclusion: 1..5
end
