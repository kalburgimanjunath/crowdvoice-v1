Class(Crowdvoice.Voice.Twitter, 'Retweet')
    .includes(Crowdvoice.Helpers.UrlHelper)
    .inherits(Widget)({
    HTML: '<a href="#" class="right">RE-TWEET</a>',
    TITLE: 'RE-TWEET',
    HTML_CLASS: 're-tweet',
    BASE_URL: '/{:voice_id}/share/retweet/{:tweet_id}',
    
    prototype: {
        tweet_id: null,
        
        initializer: function(args) {
            this.voice_id = args.voice_id;
            this.tweet_id = args.tweet_id;
            this.element.attr({
                title: this.constructor.TITLE,
                href: this.constructor.formatUrl(this.constructor.BASE_URL, {
                    voice_id: this.voice_id,
                    tweet_id: this.tweet_id
                })
            }).addClass(this.constructor.HTML_CLASS);
        }
    }
});
