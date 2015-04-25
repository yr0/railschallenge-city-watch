class Responder < ActiveRecord::Base
  include CapacityReporting

  # allow creation of column 'type'
  self.inheritance_column = 'type_inherited'

  enum type: %w(fire medical police)

  validates :type, presence: true
  validates :name, presence: true, uniqueness: true
  validates :capacity, presence: true, inclusion: 1..5

  belongs_to :emergency, foreign_key: :emergency_code

  # Have to introduce this scope because, strangely enough, ActiveRecord's #enum doesn't work when using 'type' in
  # 'where' queries (e.g. Responder.where(type: 'fire')). This bug might be caused by SQLite
  # or current name of enum column('type')
  scope :of_type, ->(type) { method(type).call }

  scope :available, -> { where(emergency_code: nil) }
  scope :at_work, -> { where(on_duty: true) }
end
