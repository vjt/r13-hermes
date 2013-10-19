module PathScoping
  extend ActiveSupport::Concern

  included do
    def self.within(path)
      where('path LIKE ?', "#{path}%")
    end
  end
end
