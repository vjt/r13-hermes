# This controllers is the backend core, from which users manage the sites
# they want to get the help elements in.
#
class SitesController < ApplicationController
  include Authenticated

  before_filter :find_site, :only => %w( show edit update destroy )

  def index
    @site = Site.new
  end

  def show
  end

  def new
    @site = Site.new
  end

  def create
    @site = current_user.sites.new(sites_param)
    @site.save

    respond_to do |format|
      format.html { redirect_to sites_path }
      format.js
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    @site.update_attributes(sites_param)

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @site.destroy
    render js: "$('##{dom_id(@site)}').remove()";
  end

  protected
    def sites_param
      params.require(:site).permit(:name, :hostname, :description)
    end

    def find_site
      @site = Site.find(params[:id])
    end
end
