class Tutorial < ActiveRecord::Base
  include Publicable

  belongs_to :site
  has_many :tips, as: :tippable

  validates :site_id, presence: true
  validates :site,    associated: true
end
