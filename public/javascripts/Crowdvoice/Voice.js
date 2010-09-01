Class(Crowdvoice, 'Voice')({
    currentId: '',
    loadingInterval: null,

    arrangeContents: function() {
            if ($(".voice_content_link_image").length == 0) {
                $('#grid').masonry({
                  singleMode: true,
                  animate: true,
                  resizeable: false,
                  itemSelector: '.box.media'
                });
            } else {
                $(".voice_content_link_image").load(function() {
                    $('#grid').masonry({
                      singleMode: true,
                      animate: false,
                      resizeable: false,
                      itemSelector: '.box.media'
                    });
                });
            }
        },
    loading: function(options) {
        options = options || {};
        var that = this;
        if($('.loading-overlay').size() == 0) {
            $('body').append('<div class="loading-overlay"><div /></div>');
            if($('body').height() < $(window).height()) {
                $('.loading-overlay').css('height', $(window).height());
            } else {
                $('.loading-overlay').css('height', $('body').height());
            }
            var counter = 1;
            var doLoad = function() {
                $('.loading-overlay div').css({
                    "margin-top" : ($(window).height()/2 - 30),
                    "display" : "block",
                    "background-position" : "0 -" + (counter * 66) + 'px'
                });
                counter = ++counter == 8 ? 0 : counter;
            };
            this.loadingInterval = setInterval(doLoad, 150);
            if (options.closeOnClick === true) {
                $('.loading-overlay').click(function() {
                    $(this).unbind('click');
                    that.loaded();
                });
            }
        }
    },
    
    loaded: function() {
      clearInterval(this.loadingInterval);
      $('.loading-overlay').remove();
    }
});
