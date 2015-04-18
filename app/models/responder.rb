class Responder < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged, slug_column: :name

  self.primary_key = :name

  TYPES = %w(fire medical police)
  enum responder_type: TYPES

  belongs_to :emergency, foreign_key: :emergency_code

  validates :responder_type, presence: true
  validates :name, presence: true, uniqueness: true
  validates :capacity, presence: true, length: { in: 1..5 }
end
