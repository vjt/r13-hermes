module Sortable
  extend ActiveSupport::Concern

  included do
    include RankedModel
    ranks :position

    scope :sorted, -> { rank(:position) }
  end
end
