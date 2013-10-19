class TipsController < ApplicationController
  include Authenticated

  before_filter :find_site
  before_filter :find_tip, only: %w( show edit update destroy )

  def index
    @tips = @site.tips.order('created_at DESC') # FIXME

    if @tips.blank?
      redirect_to new_site_tip_path(@site), :notice => 'Create your first tip'
    end
  end

  def show
  end

  def new
    @tip = @site.tips.new
  end

  def create
    @tip = @site.tips.new(tip_params)

    if @tip.save
      redirect_to site_tips_path(@site)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @tip.update_attributes(tip_params)
      redirect_to site_tips_path(@site), :notice => 'Tip saved'
    else
      render :edit
    end
  end

  def destroy
    @tip.destroy
    redirect_to site_tips_path(@site), :notice => 'Tip deleted'
  end

  protected

    def find_site
      @site = Site.find(params[:site_id])
    end

    def find_tip
      @tip = @site.tips.find(params[:id])
    end

    def tip_params
      params.
        require(:tip).
        permit(:title, :content, :published_at,
               :unpublished_at, :selector, :position)
    end
end
