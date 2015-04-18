module EmergencyStates
  extend ActiveSupport::Concern

  included do
    include AASM

    aasm column: 'state' do
      state :announced, initial: true
      state :handled
      state :resolved

      event :handle do
        transitions from: :announced, to: :handled
      end

      event :resolve do
        after do
          update_resolved
          save
        end
        transitions from: :handled, to: :resolved
      end
    end
  end

  private

  def update_resolved
    self.resolved_at = Time.zone.now
  end
end
