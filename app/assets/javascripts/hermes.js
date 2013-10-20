//= require hermes-endpoint
//= require jquery.pagetour

(function() {
  var jQuery,
      jQueryURL     = '//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js',
      hermesURL     = __hermes_host__ + '/messages.js',
      foundationURL = __hermes_host__ + '/foundation.min.js',
      modernizrURL  = __hermes_host__ + '/custom.modernizr.js';

  function loadJavaScript(url, loadHandler) {
    var script_tag = document.createElement('script');
    script_tag.setAttribute('src', url);

    if (script_tag.readyState) {
      script_tag.onreadystatechange = function () {
        if (this.readyState == 'complete' || this.readyState == 'loaded') {
          typeof loadHandler == 'function' && loadHandler();
        }
      };
    } else {
      script_tag.onload = loadHandler;
    }
    (document.getElementsByTagName('head')[0] || document.documentElement).appendChild(script_tag);
  }

  if (window.jQuery === undefined || window.jQuery.fn.jquery !== '1.10.2') {
    loadJavaScript(jQueryURL, jQueryLoadHandler);
  } else {
    jQuery = window.jQuery;
    main();
  }

  function jQueryLoadHandler() {
    jQuery = window.jQuery.noConflict(true);
    main();
  }

  function main() {
    jQuery(document).ready(function($) {
      var h = new Hermes($);

      if (/#hermes-authoring/.test(document.location.hash) && window.opener) {
        h.author();
      } else {
        h.display();
      }
    });
  }

  function Hermes($) {
    this.endpoint = hermesURL;

    this.display = function() {
      __hermes_init_pagetour__($);

      $.ajax(h.endpoint, {
        dataType: 'jsonp',
        success: function(messages, status) {
          var message = null;
          while (message = messages.shift()) { h.show(message); }
        }
      });
    }

    this.show = function(message) {
      switch(message.type) {
      case 'tutorial':
        break;
      case 'tip':
        break;
      default:
        this.showBroadcast(message);
        break;
      }
    }

    this.showTutorial = function(message) {
      alert(message.type);
    }

    this.showTip = function(message) {
      alert(message.type);
    }

    this.showBroadcast = function(message) {
      var broadcast = $('<div class="hermes-broadcast" />');
      var close = $('<span class="hermes-broadcast-close" />');

      broadcast.html(message.content);
      broadcast.css({
        'background-color': '#D9EDF7',
        'border-color': '#BCE8F1',
        'color': '#3A87AD',
        'border-radius': '4px',
        'border-width': '1px',
        'border-style': 'solid',
        'font-family': '"Helvetica Neue", Helvetica, Arial, sans-serif',
        'padding': '15px',
        'font-size': '14px',
        'line-height': '18px'
      });

      close.attr('data-url', message.url);
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
        $.ajax(message.url, {
          dataType: 'jsonp',
          complete: function(jqXHR, status) {
            $(e.target).parents('.hermes-broadcast').hide('fade');
          }
        });
      });

      broadcast.append(close);

      $(document.body).prepend(broadcast);
    }

    this.author = function () {
      // Cache the document here for speed.
      var doc = $(document);

      // This is the selected element, that gets updated while hovering
      var selected = undefined;

      // This is the way out, that sends the selected element Selector out to
      // the opener window.
      var callback = function (event) {
        event.preventDefault();
        event.stopPropagation();
        event.stopImmediatePropagation();

        var path = getPath(selected);
        window.opener.__hermes_connect_callback(path);
        window.close();
      };

      // Stolen from http://stackoverflow.com/a/4588211/69379
      //
      var getPath = function (el) {
        var names = [];

        while (el.parentNode) {
          if (el.id) {
            names.unshift('#'+el.id);
            break;
          } else {
            if (el == el.ownerDocument.documentElement)
              names.unshift(el.tagName);
            else {
              for (var c=1, e=el; e.previousElementSibling; e = e.previousElementSibling, c++);
              names.unshift(el.tagName + ':nth-child('+c+')');
            }
            el = el.parentNode;
          }
        }
        return names.join(' > ');
      };

      // Create the 4 overlays that make up the border of the hovering element.
      //
      var css = {
        margin: 0, padding: 0, position: 'absolute',
        'background-color': '#a00', cursor: 'pointer'
      };
      var overlay = {
        N: $('<div/>', {id: 'overlayN'}).css(css),
        S: $('<div/>', {id: 'overlayS'}).css(css),
        E: $('<div/>', {id: 'overlayE'}).css(css),
        W: $('<div/>', {id: 'overlayW'}).css(css),
      };

      for (i in overlay) {
        overlay[i].bind('click.hermes', callback);
        $('html').append(overlay[i]);
      }

      var thickness = 5; // px

      // And now set the mousemove event handler
      $('body').on('mousemove', function (event) {
        try {

          var elem = event.toElement;

          if (elem.tagName == 'BODY')
            return;

          if (elem == selected)
            return;

          // Build the wrapping rectangle
          //
          var rect = elem.getBoundingClientRect();
          var stop = doc.scrollTop(), sleft = doc.scrollLeft();

          // North
          //
          overlay.N.css({
            width:  rect.width,
            height: thickness,
            top:    (rect.top - thickness/2) + stop,
            left:   (rect.left) + sleft
          });

          // South
          //
          overlay.S.css({
            width:  rect.width,
            height: thickness,
            top:    (rect.top + rect.height - thickness/2) + stop,
            left:   (rect.left) + sleft
          });

          // East
          //
          overlay.E.css({
            width:  thickness,
            height: rect.height + thickness,
            top:    (rect.top  - thickness/2) + stop,
            left:   (rect.left + rect.width - thickness/2) + sleft
          });

          // West
          //
          overlay.W.css({
            width:  thickness,
            height: rect.height + thickness,
            top:    (rect.top  - thickness/2) + stop,
            left:   (rect.left - thickness/2) + sleft
          });

          // Reset the old selected element
          //
          if (selected) {
            selected = $(selected);
            selected.css(selected.data('hermes-restore-css')).
              data('hermes-restore-css', null).
              unbind('click.hermes', callback);
          }
          selected = elem;

          // Set the onclick handler to our callback
          //
          $(selected).data('hermes-restore-css', {
            'cursor': selected.style.cursor,
            'background-color': selected.style.backgroundColor
          }).css({
            'cursor': 'pointer',
            'background-color': '#ddd'
          }).bind('click.hermes', callback);

        } catch (e) {
          console.log(e);
        }
      });
    }

    return this;
  }

})();
