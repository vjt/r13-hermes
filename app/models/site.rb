# The Site model represent a User's site, that has many tips and many
# tutorials.
#
class Site < ActiveRecord::Base
  belongs_to :user

  has_many :tips
  has_many :tutorials

  validates :user_id, :name, :hostname, presence: true

  def self.by_user(user)
    where(user_id: user.id)
  end
end
