// This almigthy file implements the connection between Hermes and the target
// site during Tip authoring. It opens up the target site in a pop-up window,
// so 90's, with a specific URL fragment to enable the authoring component in
// hermes.js, that works much like WebKit's and FireBug inspectors.
//
// Then, after selecting and clicking onto an element, its CSS selector is
// calculated (roughly) and it is passed back onto the window.opener to be
// then stored in Hermes' DB.
//
$(function () {
  $('[data-tip-connector]').on('click', function () {
    var connector = $(this), options = connector.data('tip-connector');
    var hostname  = options.hostname;
    var path      = options.path;

    if (!path && options.path_input)
      path = $(options.path_input).val();

    if (!path)
      throw new Error('Unable to fetch site path from DOM');

    var url = hostname + path;

    if (!/^http/.test(url))
      url = 'http://' + url;

    connector.attr({href: url});
    return true;
  });
});
