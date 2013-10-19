# This controller serves JS embed files for external sites.
# The remote site is identified through the HTTP Referer header.
#
class MessagesController < ApplicationController
  before_filter :find_site
  before_filter :find_message, only: %w( update )

  skip_before_action :verify_authenticity_token, only: :update

  def index
    head :not_found and return unless @site

    callback = params[:callback]
    head :bad_request and return unless callback.present?

    remote_user = (cookies['__hermes_user'] ||= State.ephemeral_user)

    @messages =
      @site.tips.published.respecting(remote_user) +
      @site.tutorials.published.respecting(remote_user)

    render json: render_to_string, callback: callback
  end

  # Updates the status of the given message type and ID for the hermes_user
  # stored in the cookies.
  #
  # params[:until] is expected to be a JS timestamp, that is - milliseconds
  # passed after the Unix Epoch.
  #
  def update
    head :bad_request and return unless @message.present?

    remote_user = cookies['__hermes_user']
    head :bad_request and return unless remote_user.present?

    up_to = if params[:until].present?
      Time.at(params[:until].to_i / 1000)
    end

    @message.dismiss! remote_user, up_to

    head :created
  end

  protected

    def find_site
      return unless request.referer.present?

      url = URI.parse(request.referer)
      return unless url.scheme.in? %w( http https )

      @site = Site.find_by_hostname(url.host)

    rescue URI::InvalidURIError
      nil
    end

    def find_message
      return unless params.values_at(:type, :id).all?(&:present?)
      model = params[:type].camelize.constantize

      return unless model.included_modules.include?(Publicable)
      @message = model.find(params[:id])
    end

end
