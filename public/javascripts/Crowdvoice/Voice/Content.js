Class(Crowdvoice.Voice, 'Content').includes(Crowdvoice.Helpers.UrlHelper)({
    DETECT_URL: '/{:id}/contents/detect?url={:url}',
    URL_REGEX: /^((https?):\/\/)?([_a-z\d\-]+(\.[_a-z\d\-]+)+)(([_a-z\d\-\\.\/]+[_a-z\d\-\\\/])+)*/i,
    YT_REGEX: /^((https?):\/\/)?(?:www\.)?youtube\.com\/watch\?v=[^&]/i,
    VIMEO_REGEX: /^((https?):\/\/)?(?:www\.)?vimeo\.com\/(?:.*#)?(\d+)/i,
    FLICKR_REGEX: /^((https?):\/\/)?(?:www\.)?(?:flickr|twitpic)\.com\/photos\/[-\w@]+\/\d+/i,
    TWITPIC_REGEX: /^((https?):\/\/)?(?:www\.)?(?:twitpic)\.com\/\w+/i,
    IMGEXT_REGEX: /\.(jpe?g|png|gif)$/i,
    currentMessage: null,

    buildUrl: function(url) {
        return this.formatUrl(this.DETECT_URL, {
            id: Crowdvoice.Voice.currentId,
            url: encodeURIComponent(url)
        });
    },

    bindPrettyPhoto: function(e) {
      return e.prettyPhoto({showTitle: false, allowresize: false});
    },

    bindPageSlide: function(elm, options) {
      elm.pageSlide($.extend({
        height: '85%',
        modal: true,
        label: 'Back to voice',
        collectionSelector: '.grid > .link .url a',
        copyUrlImgPath: '/images/ps/copyurl_icon.png',
        viewOrigImgPath: '/images/ps/vieworiginal_icon.png'
      }, options || {}));
    },

    detectType: function(url, callback) {
        var contentType = 'link';

        if(this.YT_REGEX.test(url) || this.VIMEO_REGEX.test(url)) {
            contentType = 'video';
        } else if(this.isImage(url)) {
            contentType = 'image';
        }
        return contentType;
    },

    isImage: function(url) {
        return this.FLICKR_REGEX.test(url) ||
            this.TWITPIC_REGEX.test(url) ||
            this.IMGEXT_REGEX.test(url);
    },

    validateUrl: function(url) {
        return this.URL_REGEX.test(url);
    },

    showMessage: function(args) {
        args.title = args.title || 'Oops!';
        $('.post-url.tooltip').addClass('active');
        $('.post-url.tooltip > .dropdown .mc > h2').text(args.title);
        $('.post-url.tooltip > .dropdown .mc > p').text(args.msg);
        $('.ps_message p').text(args.msg);
        $('.ps_message').show();
        $('.pp_msg').text(args.msg).fadeIn();

        this.currentMessage = setTimeout(function() {
            $('.post-url.tooltip').removeClass('active');
            $('.ps_message').hide();
        }, 6000);
    },

    hideMessage: function() {
        $('.post-url.tooltip').removeClass('active');
        clearTimeout(this.currentMessage);
        this.currentMessage = null;
    }
});
