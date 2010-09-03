/*
 * $.helpTip
 *
 * Show a collection of tooltips to new users of your site
 * to help them understand the elements of the page.
 *
 * Options:
 * - ttl integer Time to live for the cookie to don't prompt to user, in days. Default is 30 days.
 * - tips array Collection of tips to show in your page. Each tip is a hash with these options:
 *     - highlight string CSS selector of the item you want to highlight.
 *     - title string Tittle for the tip to display.
 *     - text string Text to display in the tooltip.
 *     - xy hash Hash containing x, y adjusting for position
 *     - position string Overrides absolute position for cases when fixed is needed
 *     - side string top|bottom|left|right position of the blue dot.
 *
 * Freshout - http://freshout.us
 * Edgar J. Suárez
 */
;jQuery(function($) {
    $.helpTip = function(options) {
        var settings = $.extend({
            ttl: 30,
            tips: []
        }, options);

        var tips = {};

        var cookiesJar = {
            addCookie: function(name, value, days) {
                var expire = '';
                if(days) {
                    var date = new Date();
                    date.setTime(date.getTime() + (days*24*60*60*1000));
                    expires = '; expires=' + date.toGMTString();
                }
                document.cookie = name + '=' + value + '; expires=' + expires + '; path=/';
            },

            readCookie: function(name) {
                var nameEQ = name + '=';
                var part = document.cookie.split(';');
                for(var i = 0; i < part.length; i++) {
                    var c = part[i];
                    while(c.charAt(0) == ' ') {
                        c = c.substring(1, c.length);
                    }
                    if(c.indexOf(nameEQ) == 0) {
                        return c.substring(nameEQ.length, c.length);
                    }
                }
                return null;
            }
        };

        function _setTtlCookie() {
            cookiesJar.addCookie('_helpTipPrompted', '1', settings.ttl);
        }

        function prompted() {
            return cookiesJar.readCookie('_helpTipPrompted') !== null;
        }

        function _buildTips() {
            for(var i = 0; i < settings.tips.length; i++) {
                if(!tips[settings.tips[i].highlight]) {
                    settings.tips[i].xy = settings.tips[i].xy || {};
                    settings.tips[i].xy.x = settings.tips[i].xy.x || 0;
                    settings.tips[i].xy.y = settings.tips[i].xy.y || 0;
                    var tip = new $.helpTip.Tip(settings.tips[i].title, settings.tips[i].text, settings.tips[i].xy, settings.tips[i].position);
                    tip.render(settings.tips[i].highlight, settings.tips[i].side || 'bottom');
                    tips[settings.tips[i].highlight] = tip;
                }
            }
        }
        
        function _showCloseAllButton() {
            if($('.close-dottips').size() === 0) {
                $('body').append('<a class="close-dottips">Close all help indicators</a>');
                $('.close-dottips').click(function() {
                    $('.helptip-dottip').add(this).fadeOut('fast');
                    return false;
                });
            } else {
                $('.close-dottips').fadeIn('fast');
            }
        }

        function _showTips() {
            for(var key in tips) {
                if(tips.hasOwnProperty(key)) {
                    tips[key].show('fast');
                }
            }
            _showCloseAllButton();
        }

        function startTour() {
            _buildTips();
            $.helpTip.overlay.hide();
            _showTips();
            _setTtlCookie();
        }

        function _init() {
            $.helpTip.options = settings;
            if($('.helptip-modal').size() === 0) {
                $('body').append($.helpTip.overlay.template);
                $('.helptip-modal .tuto-ok > a').click(startTour);
                $('.helptip-modal .tuto-close').click($.helpTip.overlay.hide);
                $('.helptip-modal .tuto-no > a').click(function() {
                    $.helpTip.overlay.hide();
                    _setTtlCookie();
                });
            }
            if(!prompted()) {
                $.helpTip.overlay.show();
            }
        }

        _init();
    };

    $.helpTip.Tip = function(title, text, xy, position) {
        var that = this;
        var template = '\
          <div class="helptip-dottip dt-blue">\
            <div class="dottip-container">\
              <div class="arrowtip"></div>\
              <div class="boxtip">\
                <a href="#" title="Close" class="close-tip">x</a>\
                <h4>{{title}}</h4>\
                <p>{{text}}</p>\
              </div>\
            </div>\
          </div>';
        this.element = $(template.replace('{{title}}', title).replace('{{text}}', text));
        if(position === 'fixed' || position === 'relative') {
            this.element.css('position', position);
        }

        var instanceMethods = {
            render: function(highlight, side) {
                highlight = typeof(highlight) === 'string' ? $(highlight) : highlight;
                that.element.find('.boxtip > .close-tip').click(function() {
                    that.hide();
                    return false;
                });
                that.element.addClass('dt-' + side);
                $('body').append(that.element);
                that.element.hover(that.bringFront, that.bringBack);
                this.align(highlight);
            },
            align: function(highlight) {
                var bodywidth = $('body').width(),
                    bodyheight = $('body').height();
                var left = highlight.offset().left,
                    top = highlight.offset().top;
                var w = that.element.find('.boxtip').outerWidth();
                var x2 = w + left,
                    y2 = that.element.find('.boxtip').outerHeight() + top;

                that.element.css({
                    left: left + that.xy.x,
                    top: top + that.xy.y
                });
                if(x2 > bodywidth) {
                    left = (bodywidth) - x2;
                    that.element.find('.boxtip').css({
                        left: left + that.xy.x
                    });
                }
            },
            bringFront: function() {
                that.element.css('z-index', 9999);
            },
            bringBack: function() {
                that.element.css('z-index', 9998);
            },
            show: function(speed) {
                that.element.fadeIn(speed);
            },
            hide: function() {
                that.element.fadeOut('fast');
            }
        };

        $.extend(this, instanceMethods, {xy: xy});

        return {
            data: {
                title: this.title,
                text: this.text
            },
            align: this.align,
            bringTop: this.bringTop,
            render: this.render,
            show: this.show,
            element: this.element
        };
    };

    $.helpTip.overlay = {
        template: '\
            <div class="helptip-modal">\
                <div class="helptip-tuto">\
                    <a class="tuto-close" href="#" title="Close">Close</a>\
                    <div class="tuto-content">\
                        <h1>You\'re new!</h1>\
                        <span>Let us show you around</span>\
                        <ul>\
                            <li class="tuto-ok"><a href="#" title="Ok, Sure!">Ok, Sure!</a></li>\
                            <li class="tuto-no"><a href="#" title="No, Thanks">No, Thanks</a></li>\
                        </ul>\
                    </div>\
                </div>\
            </div>',
        show: function() {
            $('.helptip-modal').fadeIn('fast');
            return false;
        },
        hide: function() {
            $('.helptip-modal').fadeOut('fast');
            return false;
        }
    };
});

