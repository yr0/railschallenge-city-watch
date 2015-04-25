##
# State machine for emergencies.
#
#
# First emergency is 'announced', then 'handled', and lastly, 'resolved'.
#
# When emergency is created and transitions to 'handled' state, available responders' capacities are calculated
# to match emergency's various types of severity. If all severities are covered by responders' capacities,
# emergency's full_response field is set to true.
#
# After emergency's field 'resolved_at' is set for the first time, the emergency transitions to 'resolved' state and
# all its responders are allowed to 'rest', i.e. become available.
module EmergencyStates
  extend ActiveSupport::Concern
  include DispatchCalculations

  included do
    include AASM

    # ActiveRecord callbacks that concern states for Emergency model
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

  ##
  # Store full response and responder_ids in the emergency record after calculating responders for
  # all severity kinds of emergency.
  def dispatch_responders
    self.full_response, self.responder_ids = try_responding_in_full
  end

  ##
  # Make associated responders available since emergency is resolved
  def rest_responders
    responders.delete_all
  end
end
