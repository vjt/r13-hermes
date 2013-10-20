$(function () {
  $("a[rel~=popover], .has-popover").popover();
  $("a[rel~=tooltip], .has-tooltip").tooltip();
  $('.datetimepicker').datetimepicker({
        language: 'en-US'
            });

  // WYSIWYG Editor
  $('.wysihtml5').each(function() {
    $(this).wysihtml5({
      'font-styles': false, //Font styling, e.g. h1, h2, etc. Default true
      'emphasis'   : true,  // Italics, bold, etc. Default true
      'lists'      : false, // (Un)ordered lists, e.g. Bullets, Numbers. Default true
      'html'       : false, // Button which allows you to edit the generated HTML. Default false
      'link'       : true,  // Button to insert a link. Default true
      'image'      : false, // Button to insert an image. Default true,
      'color'      : true   // Button to change color of font
    });
  });
});
