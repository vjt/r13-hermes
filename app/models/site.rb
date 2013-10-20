# The Site model represent a User's site, that has many tips and many
# tutorials.
#
class Site < ActiveRecord::Base
  belongs_to :user, inverse_of: :sites

  has_many :tips, as: :tippable, inverse_of: :tippable, dependent: :destroy
  has_many :tutorials,           inverse_of: :site,     dependent: :destroy

  validates :user_id, :name, :hostname, presence: true

  before_save :strip_scheme # Sacrifice correctness for user-friendlyness.

  def self.by_user(user)
    where(user_id: user.id)
  end

  def self.by_url(url)
    host = url.host
    port = if (url.scheme == 'http' && url.port != 80) ||
              (url.scheme == 'https' && url.port != 443)
      url.port.to_s
    end

    where(hostname: [host, port].compact.join(':')).first
  end

  def url
    hostname =~ /^http/ ? hostname : "http://#{hostname}"
  end

  protected
    def strip_scheme
      self.hostname = self.hostname.sub(%r{^https?://}, '')
    end
end
