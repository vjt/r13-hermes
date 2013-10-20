module ApplicationHelper
  def logo
     link_to root_path, :id => 'logo', :class => 'brand' do
      content_tag(:span, 'Antani') + ' | Hermes'
     end.to_s
  end
end
