HTML::WhiteListSanitizer.allowed_css_properties   = %w(text-align color background-color)
HTML::WhiteListSanitizer.shorthand_css_properties = %w()
HTML::WhiteListSanitizer.allowed_css_keywords     = %w(left center right justify rgb)

engine = HTML::WhiteListSanitizer.new

ie_cleaner = lambda {|options|
  node = options[:node]
  return unless node.present? && node.element?

  if node.name.downcase == 'font'
    node.name = 'span'
  end
}

css_class_filterer = lambda {|options|
  node = options[:node]
  if node.present? && node.element? && node['class'].present?
    node['class'] = nil unless node['class'] =~ /^wysiwyg-color/
  end
}

Sanitize::Rails.configure(
  :elements => %w[ a b br em i p span strong ],

  :attributes => {
    'span' => ['class'],
    'a'    => ['href'],
    'img'  => ['src']
  },

  :add_attributes => {
    'a' => { 'rel' => 'nofollow' }
  },

  :protocols => {
    'a' =>   {'href' => ['ftp', 'http', 'https', 'mailto', :relative]},
    'img' => {'src'  => ['http', 'https']}
  },

  :transformers => [ie_cleaner, css_class_filterer],

  :whitespace_elements => %w(
    address article aside blockquote dd dl dt footer
    h3 h4 header hgroup hr nav pre section sub sup tr
    td option input
  )
)
