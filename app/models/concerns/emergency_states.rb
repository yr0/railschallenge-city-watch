module EmergencyStates
  extend ActiveSupport::Concern
  include DispatchCalculations

  included do
    include AASM

    after_create :handle!
    before_save :resolve, if: :resolved_at, unless: :resolved?

    aasm column: 'state' do
      state :announced, initial: true
      state :handled, before_enter: :dispatch_responders
      state :resolved, before_enter: :rest_responders

      event :handle do
        transitions from: :announced, to: :handled
      end

      event :resolve do
        transitions from: :handled, to: :resolved
      end
    end
  end

  private

  def dispatch_responders
    self.full_response, self.responder_ids = calculate_available_responders
  end

  def rest_responders
    responders.delete_all
  end
end
