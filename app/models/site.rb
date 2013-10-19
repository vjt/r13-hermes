# The Site model represent a User's site, that has many tips and many
# tutorials.
#
class Site < ActiveRecord::Base
  belongs_to :user, inverse_of: :sites

  has_many :tips, as: :tippable, inverse_of: :tippable
  has_many :tutorials, inverse_of: :site

  validates :user_id, :name, :hostname, presence: true

  def self.by_user(user)
    where(user_id: user.id)
  end
end
