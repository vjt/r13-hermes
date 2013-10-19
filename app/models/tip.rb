class Tip < ActiveRecord::Base
  include RankedModel
  ranks :position

  belongs_to :tippable, polymorphic: true
end
