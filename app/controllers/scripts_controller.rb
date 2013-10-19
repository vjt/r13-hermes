# This controller serves JS embed files for external sites.
# The remote site is identified through the HTTP Referer header.
#
class ScriptsController < ApplicationController
  before_filter :find_site, :only => :show

  def show
    head :not_found and return unless @site
  end

  protected

    def find_site
      return unless request.referer.present?

      url = URI.parse(request.referer)
      @site = Site.find_by_host(url)

    rescue URI::InvalidURIError
      nil
    end

end
