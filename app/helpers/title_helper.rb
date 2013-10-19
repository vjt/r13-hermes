module TitleHelper

  # This helper provides both input and output capabilities
  # for managing page title in Rails views and layouts.
  #
  # When called with +args+, it stores all args for later retrieval.
  # Additionally, it always return a formatted title so that
  # it can be easily called without arguments to display the full page title.
  #
  # You can pass some additional options to customize the behavior of the returned string.
  # The following options are supported:
  #
  # separator - The String separator used to join all title elements
  #             Defaults to a dash "-".
  # site      - The String name of the site to be appended to page title.
  # headline  - The String website headline to be appended to page title,
  #             after any element.
  #
  # Examples
  #
  #   # in a template set the title of the page
  #   <h1><%= title "Latest news" %></h1>
  #   # => <h1>Latest news</h1>
  #
  #   # in the layout print the title of the page
  #   # with the name of the site
  #   <title><%= title :site => 'My Site' %></title>
  #   # => <title>Latest news | My Site</title>
  #
  # Returns the String current title.
  def title(*args)
    @_title ||= []
    @_title_options ||= {
      :separator => ' - ',
      :headline  => nil,
      :site      => nil,
    }

    options  = args.extract_options!
    @_title += args unless args.empty?
    @_title_options.merge!(options)

    @_title.clone.tap do |title|
      title << @_title_options[:site]     if @_title_options[:site]
      title << @_title_options[:headline] if @_title_options[:headline]
    end.join(@_title_options[:separator])
  end

  def headline
    @_title.first
  end
end
