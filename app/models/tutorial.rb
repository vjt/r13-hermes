class Tutorial < ActiveRecord::Base
  include Publicable

  belongs_to :site, inverse_of: :tutorials
  has_many :tips, as: :tippable, inverse_of: :tippable

  validates :site_id, presence: true
  validates :site,    associated: true
end
