# encoding: utf-8

module ApplicationHelper
  def logo
    link_to root_path, :id => 'logo', :class => 'brand' do
      image_tag('hermes-logo.png', size: '30x30') + content_tag(:span, '') + 'Hermes'
    end.to_s
  end

  def include_tinymce
    unless @tinymce_loaded
      @tinymce_loaded = true
      content_for(:head) { tinymce_assets }
      tinymce
    end
  end

  def gravatar(email, size)
    default = case Rails.env
              when 'production'  then "http://www.eyeonplay.com/assets/user-#{size}.png"
              when 'staging'     then "http://staging.eyeonplay.com/assets/user-#{size}.png"
              else 'identicon'
              end

    gravatar_id = Digest::MD5.hexdigest(email.downcase)
    return "http://gravatar.com/avatar/#{gravatar_id}?size=#{size}&default=#{CGI.escape(default)}"
  end
end
