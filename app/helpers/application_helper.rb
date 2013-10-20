# encoding: utf-8

module ApplicationHelper
  def logo
    link_to root_path, :id => 'logo', :class => 'brand' do
      content_tag(:span, '⚚') + ' Hermes'
    end.to_s
  end

  def include_tinymce
    unless @tinymce_loaded
      @tinymce_loaded = true
      content_for(:head) { tinymce_assets }
      tinymce
    end
  end
end
