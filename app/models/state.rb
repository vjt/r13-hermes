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
  #
  # Returns true if the change was successful, or false if no
  # state change was applied.
  #
  def self.dismiss!(message, remote_user, up_to = nil)
    up_to = nil if up_to.respond_to?(:past?) && up_to.past?

    state = find_or_initialize_by(
      message_id:   message.id,
      message_type: message.class.name,
      remote_user:  remote_user
    )

    state.show_at = up_to || Time.at(0xffffffff)

    return false unless state.changed?

    state.save!
  end

end
