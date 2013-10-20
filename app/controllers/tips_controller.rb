class TipsController < ApplicationController
  include Authenticated

  before_filter :find_site
  before_filter :find_tip, only: %w( show edit update destroy )
  before_filter :generate_xd_token, only: %w( new edit )

  def index
    @tips = @site.tips.order('created_at DESC') # FIXME

    # redirect_to new_site_tip_path(@site) if @tips.blank?
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

    render js: "$('##{dom_id(@tip)}').hide('fade');"

    # redirect_to site_tips_path(@site), :notice => 'Tip deleted'
  end

  protected

    def find_site
      @site = Site.find(params[:site_id])
    end

    def find_tip
      @tip = @site.tips.find(params[:id])
    end

    def tip_params
      params.require(:tip).permit(
        :title, :content, :published_at, :path,
        :unpublished_at, :selector, :position, :redisplay
      ).tap do |params|
        params[:redisplay] = nil if params[:redisplay] === '0'
      end
    end

    # This is a token to passed between the #tip-connector and the
    # target web site, to enable the authoring component in it and
    # to authorize communication.
    #
    # TODO: actually use a random token and verify it - for now it
    # is only used to pass the opener scheme to postMessage.
    #
    def generate_xd_token
      @tip_connector_token = "#hermes-authoring,#{request.scheme}"
    end
end
