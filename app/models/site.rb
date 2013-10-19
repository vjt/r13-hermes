# The Site model represent a User's site, that has many tips and many
# tutorials.
#
class Site < ActiveRecord::Base
  belongs_to :user

  has_many :tips
  has_many :tutorials

  validates :user_id, :name, :url, presence: true

  def self.by_user(user)
    where(user_id: user.id)
  end

  def self.find_by_host(url)
    return unless url.scheme.in? %w( http https )

    where(url: url.host).first
  end
end
