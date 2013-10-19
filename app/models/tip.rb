class Tip < ActiveRecord::Base
  include Publicable
  include Politeness
  include PathScoping
  include Sortable

  belongs_to :tippable, polymorphic: true, inverse_of: :tips

  validates :tippable_id, :tippable_type, presence: true
  validates :tippable, associated: true

  validates :title, :content, presence: true
end
