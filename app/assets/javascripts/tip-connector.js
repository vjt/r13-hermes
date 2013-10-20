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
  $('[data-tip-connect-path]').on('change', function () {
    var input  = $(this);
    var target = $(input.data('tip-connect-path'));

    target.attr('href', [
      target.data('hostname'),
      input.val(),
      '#', target.data('token'),
    ].join(''));
  });
});
