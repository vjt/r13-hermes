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

  function createCookie(name,value,days) {
    if (days) {
      var date = new Date();
      date.setTime(date.getTime()+(days*24*60*60*1000));
      var expires = "; expires="+date.toGMTString();
    }
    else var expires = "";
    document.cookie = name+"="+value+expires+"; path=/";
  }

  function readCookie(name) {
    var nameEQ = name + "=";
    var ca = document.cookie.split(';');
    for(var i=0;i < ca.length;i++) {
      var c = ca[i];
      while (c.charAt(0)==' ') c = c.substring(1,c.length);
      if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
    }
    return null;
  }

  function eraseCookie(name) {
    createCookie(name,"",-1);
  }

  function Hermes(data) {
    this.show = function() {
      switch(data.type) {
      case 'tutorial':
        break;
      case 'broadcast':
        break;
      default:
        this.showBroadcast();
        break;
      }
    }

    this.showBroadcast = function() {
      var tip = jQuery('<div class="hermes-broadcast" />');
      var close = jQuery('<span class="hermes-broadcast-close" />');

      tip.html(data.content);
      tip.css({
        'background-color': '#D9EDF7',
        'border-color': '#BCE8F1',
        'color': '#3A87AD',
        'border-radius': '4px',
        'border-width': '1px',
        'border-style': 'solid',
        'font-family': '"Helvetica Neue", Helvetica, Arial, sans-serif',
        'padding': '15px',
        'font-size': '14px',
        'line-height': '1.428571429'
      });

      close.html("×");
      close.css({
        'cursor': 'pointer',
        'float': 'right',
        'font-size': '21px',
        'font-weight': 'bold',
        'text-shadow': '0 1px 0 #FFF',
        'color': '#000',
        'opacity': '0.2',
        'line-height': '1'
      });

      close.click(function(e) {
        jQuery(e.target).parents('.hermes-broadcast').hide('fade');
      });

      tip.append(close);

      jQuery(document.body).prepend(tip);
    }

    return this;
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
        success: function(data, status) {
          new Hermes(data[0]).show();
        }
      });
    });
  }
})();
