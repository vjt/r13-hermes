# This controllers is the backend core, from which users manage the sites
# they want to get the help elements in.
#
class SitesController < ApplicationController
  before_action :authenticate_user!

  before_filter :find_site, :only => %w( show edit update destroy )

  def index
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
    @site = current_user.sites.
      new(params.require(:site).permit(:name, :hostname, :description))

    if @site.save
      redirect_to site_path(@site)
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  protected
    def find_site
      @site = Site.find(params[:id])
    end
end
