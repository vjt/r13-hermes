# Tips / tutorials can be dismissed permanently or until a specific
# time. This model saves the user preference for models who include
# the Politeness module.
#
# The state is saved per user, with a timestamp, representing when
# to display the message again. Complete dismissal can thus be
# implemented with a timestamp way forward in the future.
#
class State < ActiveRecord::Base
  belongs_to :message, polymorphic: true

  validates :message_id, :message_type, :remote_user, presence: true

  def self.ephemeral_user
    'huid_' << SecureRandom.hex(48)
  end

  scope :for_type, -> type { where(:message_type => type) }

  scope :unwanted_by, -> remote_user do
    select(:message_id).
    where(:remote_user => remote_user).
    where('show_at > ?', Time.now)
  end

  # Dismisses the given message for the given user, so that it
  # won't be displayed again until the `up_to` timestamp. If
  # the timestamp is `nil`, then the message will be dismissed
  # forever (more or less ;-).
  def self.dismiss!(message, remote_user, up_to = nil)
    new.tap do |state|
      state.message     = message
      state.remote_user = remote_user
      state.show_at     = up_to || Time.at(0xffffffff)
      state.save!
    end
  end

end
