# Tips / tutorials can be dismissed permanently or until a specific
# time. This model saves the user preference for models who include
# the Politeness module.
#
# The state is saved per user, with a timestamp, representing when
# to display the message again. Complete dismissal can thus be
# implemented with a timestamp way forward in the future.
#
class State < ActiveRecord::Base
  belongs_to :message, polymorphic: true, inverse_of: :state

  def self.ephemeral_user
    'huid_' << SecureRandom.hex(48)
  end

  scope :for_type, -> type { where(:message_type => type) }

  scope :unwanted_by, -> remote_user do
    select(:id).
    where(:remote_user => remote_user).
    where('show_at > ?', Time.now)
  end

end
