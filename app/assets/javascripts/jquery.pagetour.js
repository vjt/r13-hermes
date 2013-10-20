/*

  PageTour: A guide through your website. In a simple and effective way!

  (c) 2013, Stefano Ceschi Berrini
  
  @author  Stefano Ceschi Berrini <stefano.ceschib@gmail.com> @stecb
  @link    https://github.com/stecb/pagetour
  @license http://opensource.org/licenses/MIT
  @version 0.3.1
*/
(function($) {
  var PageTour;
  PageTour = (function() {

    PageTour.prototype.options = {
      prefix: 'pagetour',
      labelNext: 'next',
      labelPrev: 'prev',
      labelFinish: 'done',
      labelHideAll: '&times;',
      autoStart: false,
      mainContent: false,
      fadeTo: 0.8,
      showMasks: true,
      helpTitle: 'tips',
      showHelp: true,
      defaultPadding: 2
    };

    PageTour.prototype.started = false;

    PageTour.prototype.masks = {};

    PageTour.prototype.currentStep = -1;

    PageTour.prototype.currentElement = null;

    PageTour.prototype.currentStepElement = null;

    PageTour.prototype.documentHeight = 0;

    /*
        *
        * initialize method (when the new Pagetour element is instatiated)
        *
        * @param steps, an array of objects : each object is composed by
        *   { 
        *     selector : 'id_of_the_item_to_be_displayed', 
        *     description : 'guide html message'
        *   }
        * @param options, object of options
        *
    */

    function PageTour(steps, o) {
      $.extend(this.options, o);
      this.steps = steps;
      this._buildMask();
      this._buildTooltip();
      this._setEvents();
      if (this.options.autoStart) this.start();
      this;
    }

    PageTour.prototype._setDocumentHeight = function() {
      this.documentHeight = $(document).height();
      return this;
    };

    /*
        *
        * _buildMask, internal method, for first mask creation (wrapper, top, left, right)
        *
    */

    PageTour.prototype._buildMask = function() {
      var o;
      o = this.options;
      this.masks.wrapper = $("<div class='" + o.prefix + "-mask-wrapper'></div>");
      if (o.showHelp) {
        this.masks.wrapper.append($("<div class='" + o.prefix + "-mask-help' title='" + o.helpTitle + "'>?</div>"));
      }
      this.masks.top = $("<div class='" + o.prefix + "-mask-top'></div>");
      this.masks.left = $("<div class='" + o.prefix + "-mask-left'></div>");
      this.masks.right = $("<div class='" + o.prefix + "-mask-right'></div>");
      this.masks.bottom = $("<div class='" + o.prefix + "-mask-bottom'></div>");
      $(document.body).append(this.masks.wrapper.append(this.masks.top).append(this.masks.left).append(this.masks.right).append(this.masks.bottom));
      return this;
    };

    /*
        *
        * _buildTooltip
        *
    */

    PageTour.prototype._buildTooltip = function() {
      var o, tooltipTpl;
      o = this.options;
      tooltipTpl = o.template || ("<div class=\"" + o.prefix + "-step-tooltip blue popover in\">\n  <div class=\"arrow\"></div>\n  <div class=\"popover-inner\">\n    <div class=\"" + o.prefix + "-step-hide\" title=\"close guide\" data-placement=\"right\" data-animation=\"false\">" + o.labelHideAll + "</div>\n    <h3 class=\"popover-title\"></h3>\n    <div class=\"" + o.prefix + "-step-tooltip-content popover-content\"><p class=\"" + o.prefix + "-step-tooltip-description\"></p></div>\n    <div class=\"" + o.prefix + "-step-tooltip-controls\">\n      <a href='#' class='btn btn-small floatright " + o.prefix + "-step-next'>\n        " + o.labelNext + "\n        <i class='icon-arrow-right'></i>\n      </a>\n      <a href='#' class='btn btn-small floatright " + o.prefix + "-step-close'>\n        <i class='icon-thumbs-up'></i>\n        " + o.labelFinish + "\n      </a>\n      <a href='#' class='btn btn-small " + o.prefix + "-step-prev'>\n        <i class='icon-arrow-left'></i>\n        " + o.labelPrev + "\n      </a>\n    </div>\n</div>");
      this.tooltip = $(tooltipTpl);
      this.tooltip.find("." + o.prefix + "-step-hide").tooltip({
        animation: false,
        container: 'body'
      });
      return this.masks.wrapper.append(this.tooltip);
    };

    /*
        *
        * _setEvents, internal method, for prev/next controls (delegation to the wrapper)
        *
    */

    PageTour.prototype._setEvents = function() {
      var o,
        _this = this;
      o = this.options;
      this.masks.wrapper.on('click', "." + o.prefix + "-step-next", this._nextStep.bind(this));
      this.masks.wrapper.on('click', "." + o.prefix + "-step-prev", this._prevStep.bind(this));
      this.masks.wrapper.on('click', "." + o.prefix + "-step-close", this.close.bind(this));
      this.masks.wrapper.on('click', "." + o.prefix + "-step-hide", this.close.bind(this));
      $(window).resize(this._recalculateSides.bind(this));
      return $(document).keydown(function(e) {
        if (_this.started) {
          switch (e.keyCode) {
            case 39:
              if (_this.currentStep < _this.steps.length - 1) _this._nextStep();
              return false;
            case 37:
              if (_this.currentStep > 0) _this._prevStep();
              return false;
            case 27:
              _this.close();
              return false;
          }
        } else {
          if (e.shiftKey && e.keyCode === 191) return _this.start();
        }
      });
    };

    /*
        *
        * _setMask, internal method, to set the proper offset to each mask
        *
        * @param position, the position object of the current element
        * @param size, the size object of the current element
        *
    */

    PageTour.prototype._setMask = function(position, size) {
      var bottomTop, o;
      bottomTop = position.y + size.y;
      o = this.options;
      if (this.options.showMasks) {
        this.masks.top.css({
          top: 0,
          height: position.y - (this.currentStepElement.padding || o.defaultPadding)
        }).fadeTo(100, o.fadeTo);
        this.masks.bottom.css({
          height: this.documentHeight - bottomTop - (this.currentStepElement.padding || o.defaultPadding),
          top: bottomTop + (this.currentStepElement.padding || o.defaultPadding)
        }).fadeTo(100, o.fadeTo);
        this.masks.left.css({
          height: size.y + ((this.currentStepElement.padding || o.defaultPadding) * 2),
          top: position.y - (this.currentStepElement.padding || o.defaultPadding),
          width: position.x - (this.currentStepElement.padding || o.defaultPadding)
        }).fadeTo(100, o.fadeTo);
        this.masks.right.css({
          height: size.y + ((this.currentStepElement.padding || o.defaultPadding) * 2),
          top: position.y - (this.currentStepElement.padding || o.defaultPadding),
          width: $(document.body).width() - position.x - size.x - (this.currentStepElement.padding || o.defaultPadding)
        }).fadeTo(100, o.fadeTo);
      }
      return this._setTooltip(position, size);
    };

    /*  
    *
    * _recalculateSides, internal method, needed when the window is resized (left/right masks change)
    *
    */

    PageTour.prototype._recalculateSides = function() {
      var marginBottom, marginTop, originalPosition, position, size;
      if (this.started) {
        originalPosition = this.currentElement.offset();
        marginTop = typeof this.currentStepElement.margin_top !== 'undefined' ? this.currentStepElement.margin_top : 0;
        marginBottom = typeof this.currentStepElement.margin_bottom !== 'undefined' ? this.currentStepElement.margin_bottom : 0;
        size = {
          x: this.currentElement.outerWidth(),
          y: this.currentElement.outerHeight() + marginBottom + marginTop
        };
        position = {
          x: originalPosition.left,
          y: originalPosition.top - marginTop
        };
        this._setDocumentHeight();
        this._setMask(position, size);
        return this._setTooltipPosition(size, position);
      }
    };

    /*
        *
        * _setTooltipPosition, internal method, to set the tooltip position
        *
        * @param position, the position object of the current element
        * @param size, the size object of the current element
        *
    */

    PageTour.prototype._setTooltipPosition = function(size, position) {
      var fixed, left, originalTop, pos, top;
      pos = this.currentStepElement.position;
      fixed = this.currentStepElement.fixed;
      if (!!fixed) {
        [this.masks.top, this.masks.bottom, this.masks.left, this.masks.right, this.tooltip].forEach(function(el) {
          return el.addClass('fixed');
        });
      } else {
        [this.masks.top, this.masks.bottom, this.masks.left, this.masks.right, this.tooltip].forEach(function(el) {
          return el.removeClass('fixed');
        });
      }
      if (typeof pos === 'undefined' || pos === 'top' || pos === 'bottom') {
        left = position.x - ~~(this.tooltip.width() / 2) + ~~(size.x / 2);
        originalTop = position.y - this.tooltip.height() - 12;
        top = originalTop < 0 ? position.y + size.y + 10 : originalTop;
        this.tooltip.css({
          left: left + (this.currentStepElement.offsetLeft || 0),
          top: top + (this.currentStepElement.offsetTop || 0)
        });
        if (originalTop < 0) {
          return this.tooltip.addClass('bottom').removeClass('top left right');
        } else {
          return this.tooltip.addClass('top').removeClass('bottom left right');
        }
      } else {
        this.tooltip.css({
          top: position.y - ~~(this.tooltip.height() / 2) + ~~(size.y / 2) + (this.currentStepElement.offsetTop || 0)
        });
        if (pos === 'left') {
          this.tooltip.css({
            left: position.x - this.tooltip.width() - 10 + (this.currentStepElement.offsetLeft || 0)
          });
          return this.tooltip.addClass('left').removeClass('bottom top right');
        } else {
          this.tooltip.css({
            left: position.x + size.x + 10 + (this.currentStepElement.offsetLeft || 0)
          });
          return this.tooltip.addClass('right').removeClass('bottom top left');
        }
      }
    };

    /*
        *
        * _setTooltip, internal method, to set the tooltip guide for the element to the proper offset
        *
        * @param position, the position object of the current element
        * @param size, the size object of the current element
        *
        *
    */

    PageTour.prototype._setTooltip = function(position, size) {
      var guide, o, step;
      o = this.options;
      step = this.steps[this.currentStep];
      guide = step.description;
      this.tooltip.show();
      this.tooltip.find("." + o.prefix + "-step-prev, ." + o.prefix + "-step-next, ." + o.prefix + "-step-close").hide();
      if (this.currentStep >= 0) {
        this.tooltip.find("." + o.prefix + "-step-next, ." + o.prefix + "-step-prev").show();
      }
      if (this.currentStep === 0) {
        this.tooltip.find("." + o.prefix + "-step-prev").hide();
      }
      if (this.currentStep === this.steps.length - 1) {
        this.tooltip.find("." + o.prefix + "-step-close").show() && this.tooltip.find("." + o.prefix + "-step-next").hide();
      }
      this.tooltip.find("." + o.prefix + "-step-tooltip-description").html(guide);
      return this._setTooltipPosition(size, position);
    };

    /*
        *
        * _doStep, internal method, to create the step for each element
        *
    */

    PageTour.prototype._doStep = function() {
      var currStep, marginBottom, marginTop, originalPosition, position, scrollTopOffset, size, winTop, _tmp_last_element, _tmp_last_step,
        _this = this;
      _tmp_last_element = this.currentElement;
      _tmp_last_step = this.currentStepElement;
      currStep = this.steps[this.currentStep];
      winTop = $(window).scrollTop();
      this.currentStepElement = currStep;
      this.currentElement = $(currStep.selector);
      if (this.currentElement.length !== 0) {
        originalPosition = this.currentElement.offset();
        marginTop = typeof currStep.margin_top !== 'undefined' ? currStep.margin_top : 0;
        marginBottom = typeof currStep.margin_bottom !== 'undefined' ? currStep.margin_bottom : 0;
        size = {
          x: this.currentElement.outerWidth(),
          y: this.currentElement.outerHeight() + marginBottom + marginTop
        };
        position = {
          x: originalPosition.left,
          y: originalPosition.top - marginTop - winTop
        };
        this._setMask(position, size);
        scrollTopOffset = this.tooltip.hasClass('bottom') ? this.tooltip.offset().top - size.y - 20 : this.tooltip.offset().top - 10;
        if (!(!!this.currentStepElement.fixed)) {
          $('html, body').stop().animate({
            scrollTop: scrollTopOffset - 20
          }, 500);
        }
        return setTimeout(function() {
          _this.tooltip.find("." + _this.options.prefix + "-step-next").focus();
          return _this.tooltip.find("." + _this.options.prefix + "-step-close").focus();
        }, 50);
      } else {
        this.currentStepElement = _tmp_last_step;
        this.currentElement = _tmp_last_element;
        return console.log('use a valid selector, luke!');
      }
    };

    /*  
    *
    * _nextStep, internal method, to go to the next tour step
    *
    */

    PageTour.prototype._nextStep = function() {
      if (this.currentStep < this.steps.length - 1) {
        this.currentStep++;
        this._doStep();
      }
      return false;
    };

    /*
        *
        * _prevStep, internal method, to go to the previous tour step
        *
    */

    PageTour.prototype._prevStep = function() {
      if (this.currentStep >= 0) {
        this.currentStep--;
        this._doStep();
      }
      return false;
    };

    /*
        *
        * PUBLIC METHODS
        *
        * Pretty self explanatory
        *
    */

    PageTour.prototype.start = function() {
      if (!this.started) {
        $(document.body).trigger("" + this.options.prefix + "Started").addClass("" + this.options.prefix + "-body-on");
        this._setDocumentHeight();
        this.started = true;
        this.masks.wrapper.show().stop().fadeTo(500, 1);
        if (this.currentStep !== -1) this.currentStep--;
        this._nextStep();
      }
      return this;
    };

    PageTour.prototype.restart = function() {
      $(document.body).trigger("" + this.options.prefix + "Restarted");
      this.started = true;
      this.masks.wrapper.fadeTo(500, 1);
      this.masks.wrapper.css('display', 'block');
      this.currentStep = -1;
      this.currentElement = null;
      this.currentStepElement = null;
      this._nextStep();
      return this;
    };

    PageTour.prototype.close = function() {
      var _this = this;
      this.started = false;
      this.tooltip.find("." + this.options.prefix + "-step-hide").tooltip('hide');
      this.masks.wrapper.stop().fadeTo(500, 0, function() {
        _this.masks.wrapper.hide();
        return $(document.body).trigger("" + _this.options.prefix + "Closed").removeClass("" + _this.options.prefix + "-body-on");
      });
      return this;
    };

    return PageTour;

  })();
  return $.extend({
    pageTour: function(s, o) {
      if (o == null) o = {};
      return new PageTour(s, o);
    }
  });
})(jQuery);