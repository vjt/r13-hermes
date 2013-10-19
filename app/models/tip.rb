class Tip < ActiveRecord::Base
  include Publicable
  include Sortable

  belongs_to :tippable, polymorphic: true

  validates :tippable_id, :tippable_type, presence: true
  validates :tippable, associated: true

  validates :title, :content, presence: true

  def as_json(*)
    { :content => self.content }
  end
end
