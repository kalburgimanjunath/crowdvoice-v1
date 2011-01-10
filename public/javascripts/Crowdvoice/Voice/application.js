jQuery.fn.fadeToggle = function(speed, easing, callback) { return this.animate({ opacity: 'toggle' }, speed, easing, callback); }; jQuery.fn.blindToggle = function(speed, easing, callback) { var h = this.height() + parseInt(this.css('paddingTop')) + parseInt(this.css('paddingBottom')); return this.animate({ marginTop: parseInt(this.css('marginTop')) < 0 ? 0: -h }, speed, easing, callback); }; jQuery.fn.clickOutside = function(callback) { var outside = 1, self = $(this); self.cb = callback; this.click(function() { outside = 0; }); $(document).click(function() { outside && self.cb(); outside = 1; }); return $(this); };

var currentOffset = 0;

$(document).ready(function() {
    if($('.participate-voting').is(':visible')) {
        $('.header.relative').css({
            paddingTop: 40
        });
        $('.fixed-logo').css({
            marginTop: 40
        });
    }

    $('.community > div').hover(function() {
        $('.support-layer', this).show();
    }, function() {
        $('.support-layer', this).hide();
    });

    var carousel = new Crowdvoice.Carousel();
    Crowdvoice.Voice.arrangeContents();

    $('input[type="text"]').focus(function() {
        if (this.value == this.defaultValue) {
            this.value = '';
        }
        if (this.value != this.defaultValue) {
            this.select();
        }
    });

    $('input[type="text"]').blur(function() {
        if ($.trim(this.value) == '')
        this.value = (this.defaultValue ? this.defaultValue: '');
    });

    $('.show-tweets').click(function() {
        $('#tweets').slideToggle('medium');
        $(this).toggleClass('active');
        if ($(this).hasClass('active')) {
            $(this).find('strong').text('Hide tweets');
        } else {
            $(this).find('strong').text('Show tweets');
        }
        return false;
    });

    $('.close, .close-announ').click(function() {
        $(this).parent().slideToggle('medium');
        if($(this).parent().hasClass('participate-voting')) {
            $('.header.relative').animate({
                paddingTop: ''
            }, 'medium');
            $('.fixed-logo').animate({
                marginTop: 2
            }, 'medium');
        }
        return false;
    });

    $('.select > .button').click(function() {
        $('.dropdown:visible').not($(this).siblings('.dropdown')).hide();
        $('.button.active').not(this).removeClass('active');
        $(this).siblings('.dropdown').fadeToggle('fast');
        $(this).toggleClass('active');
        return false;
    });

    $('.select').clickOutside(function() {
        $(this).find('.dropdown').hide();
        $(this).find('.button').removeClass('active');
    });

    $('.box.media').live('mouseenter', function() {
        $(this).find('.overlap.command').animate({
            'opacity': '1'
        }, 'fast');
        if ($(this).hasClass('pending')) {
            $(this).find('.overlap.opacity').animate({
                'opacity': '0'
            }, 'fast', function(){
                $(this).hide();
            });
        }
    });

    $('.box.media').live('mouseleave', function() {
        $(this).find('.overlap.command').animate({
            'opacity': '0'
        }, 'fast');
        if ($(this).hasClass('pending')) {
            $(this).find('.overlap.opacity').animate({
                'opacity': '0.5'
            }, 'fast', function(){
                $(this).show();
            });
        }
    });

    $('#content_url').attr("autocomplete", "off");

    $('.post-url.tooltip .dropdown').click(function() {
        Crowdvoice.Voice.Content.hideMessage();
        return false;
    });

    var ajaxBusy = false;
    var nextAjaxURL = "";
    var currentURL = "";

    $('#content_url').keyup(function() {
        $('.active.tooltip').removeClass('active');
        if($(this).val() && Crowdvoice.Voice.Content.validateUrl($(this).val())) {
            var contentType = Crowdvoice.Voice.Content.detectType($(this).val());
            $('#new_content > ul.url > .' + contentType + '.tooltip').addClass('active');
            //$('#new_content > ul.url > .' + contentType + '.tooltip .dropdown').hide();

            if (contentType == "link") {
                var url = $("#content_url").val();

                if (currentURL == url) { return; }

                currentURL = url;

                if (url.length < 7) { return };
                if (url.split('.').length < 2) { return };

                if (ajaxBusy) {
                    nextAjaxURL = url;
                    return;
                }

                ajaxBusy = true;
                parseURL(url);
            }
        }
    });

    function parseURL(url) {
        $('.carousel-image').find("img:not('.carousel-loader')").hide();
        $('.carousel-loader').show();

        $("#link_title").val("");
        $("#link_description").val("");
        $("#link_image").val("");

        $.ajax({
            url: "/link/remote_page_info.json?url=" + encodeURIComponent(url),
            error: function() {
                ajaxBusy = false;

                if (nextAjaxURL != "") {
                    var tempURL = nextAjaxURL;
                    nextAjaxURL = "";
                    parseURL(tempURL);
                }
            },
            success: function(data, status, xhr) {
                $('.carousel-image').find("img:not('.carousel-loader')").show();
                $('.carousel-loader').hide();

                carousel.loadHash(data);

                $("#link_title").val(carousel.title);
                $("#link_description").val(carousel.description);
                $("#link_image").val(carousel.current() == $(".carousel-loader").attr("src") ? "" : carousel.current());

                $('#carousel_right_arrow').unbind();
                $('#carousel_right_arrow').click(function () {
                    $('#img_74dd65a7c6').attr('src', carousel.next());
                    $('.carousel-counter').text(carousel.label());
                    $("#link_image").val(carousel.current());
                });

                $('#carousel_left_arrow').unbind();
                $('#carousel_left_arrow').click(function () {
                    $('#img_74dd65a7c6').attr('src', carousel.prev());
                    $('.carousel-counter').text(carousel.label());
                    $("#link_image").val(carousel.current());
                });

                // wait a bit before doing another ajax call
                setTimeout(function() {
                    ajaxBusy = false;

                    if (nextAjaxURL != "") {
                        var tempURL = nextAjaxURL;
                        nextAjaxURL = "";
                        parseURL(tempURL);
                    }
                }, 2000);
            },
            dataType: "json"
        });
    }


    $('#new_content').bind('submit', function(){
        var url = $('#content_url').val();
        if(Crowdvoice.Voice.Content.validateUrl(url)) {
            Crowdvoice.Voice.loading();
        } else {
            Crowdvoice.Voice.Content.showMessage({
                msg: 'Enter a valid URL'
            });
            return false;
        }
    });

    // set click listener to filter checkboxes
    $('.filter_voice_cb, .limit_voice_rb').change(function() {
        // reset offset of more button, since content changed
        var more = $('.more-content');
        var nextOffset = 1;
        var form = $(this).parents('form');

        if(more.length > 0) {
            var qs = $.queryString(location.pathname + '/offset/' + nextOffset, { filters_form: 0 });
            var newqs = $.queryString(qs, form.serialize(), 1);

            more.attr('href', newqs);
        }
        Crowdvoice.Voice.loading();
        $(this).parents('form').submit();
    });

    $('.copyright.tooltip').hover(function() {
        var dd = $(this).find('.dropdown');
        dd.css({
            marginLeft: '-' + dd.width() + 'px'
        }).show();
    }, function() {
        $(this).find('.dropdown').hide();
    });

    $('ul.url > li.tooltip').hover(function(){
        if(!$(this).hasClass('active')){
            $('.dropdown.info', this).show();
        }
        }, function(){
            $('.dropdown.info', this).hide();
    });

    $('.more-content').click(function() {
        var filters = $('.filter_voice_cb:checked').map(function() { return this.value; }).toArray();
        var limit = $('.limit_voice_rb:checked').map(function() { return this.value; }).toArray()[0];

        var url = $.queryString(this.href, {
            filter: filters,
            limit: limit
        });

        Crowdvoice.Voice.loading();
        $.getScript(url);
        return false;
    });

    $('.close-announ').click(function(event){
        $(this).parent().slideUp('slow');
        event.preventDefault();
    });

    $('.voice-index').click(function() {
        $('.video-listing').slideToggle('fast');
        $(this).toggleClass('active');
        return false;
    });
});
