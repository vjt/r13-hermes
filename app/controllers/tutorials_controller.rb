class TutorialsController < ApplicationController
  include Authenticated

  before_filter :find_site
  before_filter :find_tutorial, only: %w( show edit update destroy )

  def index
    @tutorials = @site.tutorials.order('created_at DESC') # FIXME

    if @tutorials.blank?
      redirect_to new_site_tutorial_path(@site), :notice => 'Create your first tutorial'
    end
  end

  def show
  end

  def new
    @tutorial = @site.tutorials.new
  end

  def create
    @tutorial = @site.tutorials.new(tutorial_params)

    if @tutorial.save
      redirect_to site_tutorials_path(@site)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @tutorial.update_attributes(tutorial_params)
      redirect_to site_tutorials_path(@site), :notice => 'tutorial saved'
    else
      render :edit
    end
  end

  def destroy
    @tutorial.destroy
    redirect_to site_tutorials_path(@site), :notice => 'tutorial deleted'
  end

  protected

    def find_site
      @site = Site.find(params[:site_id])
    end

    def find_tutorial
      @tutorial = @site.tutorials.find(params[:id])
    end

    def tutorial_params
      params.
        require(:tutorial).
        permit(:title, :published_at,
               :unpublished_at, :path, :position)
    end
end
