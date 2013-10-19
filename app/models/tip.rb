class Tip < ActiveRecord::Base
  belongs_to :tippable, polymorphic: true
end
