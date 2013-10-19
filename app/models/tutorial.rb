class Tutorial < ActiveRecord::Base
  belongs_to :site
  has_many :tips, as: :tippable
end
