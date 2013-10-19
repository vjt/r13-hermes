module PathScoping
  extend ActiveSupport::Concern

  included do
    def self.within(path)
      where('path ILIKE ?', "#{path}%")
    end
  end
end
