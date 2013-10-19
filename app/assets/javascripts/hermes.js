(function() {
  var jQuery;

  if (window.jQuery === undefined || window.jQuery.fn.jquery !== '1.10.2') {
    var script_tag = document.createElement('script');
    script_tag.setAttribute("src", "//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js");

    if (script_tag.readyState) {
      script_tag.onreadystatechange = function () {
        if (this.readyState == 'complete' || this.readyState == 'loaded') {
          scriptLoadHandler();
        }
      };
    } else {
      script_tag.onload = scriptLoadHandler;
    }
    (document.getElementsByTagName("head")[0] || document.documentElement).appendChild(script_tag);
  } else {
    jQuery = window.jQuery;
    main();
  }

  function scriptLoadHandler() {
    jQuery = window.jQuery.noConflict(true);
    main();
  }

  function main() {
    jQuery(document).ready(function($) {
      // Hermes code here.
      $.ajax('//localhost:3000/payload.js', {
        dataType: 'jsonp',
        success: function() {
          alert('ye!');
        }
      });
    });
  }
})();
