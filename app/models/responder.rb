class Responder < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged, slug_column: :name

  self.primary_key = :name
  self.inheritance_column = nil

  enum type: %w(fire medical police)

  belongs_to :emergency, foreign_key: :emergency_code

  validates :type, presence: true
  validates :name, presence: true, uniqueness: true
  validates :capacity, presence: true, inclusion: 1..5
end
