# This controllers is the backend core, from which users manage the sites
# they want to get the help elements in.
#
class SitesController < ApplicationController
  before_action :authenticate_user!

  before_filter :find_site, :only => %w( show edit update destroy )

  def index
    @sites = Site.by_user(current_user)
  end

  def show
  end

  def new
    @site = Site.new
  end

  def create
    @site = Site.new(params[:site])

    if @site.save
      redirect_to :show
    else
      render :edit
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
