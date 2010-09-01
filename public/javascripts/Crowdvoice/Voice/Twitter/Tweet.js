Class(Crowdvoice.Voice.Twitter, 'Tweet').inherits(Widget)({
    HTML: '\
        <div class="tweet">\
            <p class="entry"></p>\
        </div>\
    ',
    
    prototype: {
        initializer: function(args) {
            this.result = args.result;
            this.voice_id = args.voice_id;
            this.entry = this.element.find('> .entry');
            this.entry.html(this.convertSpecialText(this.result.text));
            this.retweetButton = new Crowdvoice.Voice.Twitter.Retweet({
                tweet_id: this.result.id,
                voice_id: this.voice_id
            });
            this.retweetButton.render(this.element);
            return this;
        },
        
        remove: function() {
            this.element.remove();
            return this;
        },
        
        convertSpecialText: function(text) {
          // detect @username en #hashtag
          text = text.replace(/(^|\s)@(\w+)/g, "$1<a href='http://www.twitter.com/$2' class='pageSlide'>@$2</a>");
          text = text.replace(/(^|\s)#(\w+)/g, "$1<a href='http://search.twitter.com/search?q=%23$2' class='pageSlide'>#$2</a>");
          
          // detect URL's
          text = text.replace(/(^|\s)(http:\/\/[^\s]*)/g, "$1<a href='$2' class='pageSlide'>$2</a>");
          
          return text;
        }
    }
});
