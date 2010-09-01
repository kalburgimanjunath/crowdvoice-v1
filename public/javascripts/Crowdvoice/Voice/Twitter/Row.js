Class(Crowdvoice.Voice.Twitter, 'Row').inherits(Widget)({
    HTML: '<div class="row"></div>',
    
    prototype: {
        tweets: [],
        
        initializer: function(args) {
            var that = this;
            this.voice_id = args.voice_id;
        },
        
        update: function(tweets) {
            var that = this;
            this._clearTweets();
            $.each(tweets, function() {
                var tweet = new Crowdvoice.Voice.Twitter.Tweet({
                    result: this,
                    voice_id: that.voice_id
                });
                that.tweets.push(tweet);
                tweet.render(that.element);
            });
            this.element.queue(function() {
                $(this).fadeIn();
                $(this).dequeue();
            });
        },
        
        _clearTweets: function() {
            this.element.fadeOut();
            $.each(this.tweets, function() {
                this.remove();
            });
            
            this.tweets = [];
        }
    }
});
