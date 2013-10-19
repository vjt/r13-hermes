# Be polite: save the state of a message as requested by the user,
# and fetch only the ones the user really wants. Details in the
# State model.
#
module Politeness
  extend ActiveSupport::Concern

  included do
    has_many :states, as: :message, inverse_of: :message

    def self.respecting(remote_user)
      where("id NOT IN (#{State.for_type(self).unwanted_by(remote_user).to_sql})")
    end
  end
end
