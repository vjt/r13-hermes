module PathScoping
  extend ActiveSupport::Concern

  included do
    def self.within(path)
      where("? LIKE path || '%'", path.presence || '/')
    end
  end
end
