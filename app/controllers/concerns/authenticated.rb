module Authenticated
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
  end
end
