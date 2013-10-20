# This controllers is the backend core, from which users manage the sites
# they want to get the help elements in.
#
class SitesController < ApplicationController
  include Authenticated

  before_filter :find_site, :only => %w( show edit update destroy )

  def index
    @site = Site.new
    @sites = Site.by_user(current_user)

    if @sites.blank?
      redirect_to new_site_path, notice: "Create your first site"
    end
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
  end

  def update
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
