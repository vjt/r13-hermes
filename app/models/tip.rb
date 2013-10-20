class Tip < ActiveRecord::Base
  include Publicable
  include Politeness
  include PathScoping
  include RankedModel

  belongs_to :tippable, polymorphic: true, inverse_of: :tips

  validates :tippable_id, :tippable_type, presence: true
  validates :tippable, associated: true

  validates :title, :content, presence: true

  sanitizes :content

  attr_accessor :redisplay

  before_save do |tip|
    tip.redisplay && tip.states.delete_all
  end

  ranks :row_order, :with_same => [:tippable_id, :tippable_type]
  scope :sorted, -> { rank(:row_order) }

  def position=(pos)
    self.row_order_position = pos
  end

end
