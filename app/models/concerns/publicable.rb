module Publicable
  extend ActiveSupport::Concern

  included do
    scope :published, -> { where('? BETWEEN published_at AND unpublished_at', Time.now) }

    validate :publishing_timestamps_sequence
  end

  def published?
    now = Time.now
    published_at <= now && unpublished_at >= now
  end

  protected
    def publishing_timestamps_sequence
      if published_at.blank?
        self.published_at = Time.at(0)
      end

      if unpublished_at.blank?
        self.unpublished_at = Time.at(0xffffffff)
      end

      if published_at > unpublished_at
        errors.add :published_at, "Publish time cannot happen after unpublish time"
      end
    end
end
