# encoding: utf-8

module ApplicationHelper
  def logo
    link_to root_path, :id => 'logo', :class => 'brand' do
      content_tag(:span, '⚚') + ' Hermes'
    end.to_s
  end
end
