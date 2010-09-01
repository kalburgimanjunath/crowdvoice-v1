Class(Crowdvoice.Voice.Twitter, 'Controls').inherits(Widget)({
    HTML: '\
        <div class="controls">\
            <div class="go to-left"></div>\
            <div class="go to-right"></div>\
        </div>\
    ',
    
    prototype: {
        initializer: function(args){
            var that = this;
            
            this.search = args.search;
            this.prevButton = this.element.find('> .to-left');
            this.prevButton.click(function() {
                that.showNextButton();
                if(that.search.prevPage() === 1) {
                    that.hidePrevButton();
                } else {
                    that.showPrevButton();
                }
                return false;
            });
            
            this.nextButton = this.element.find('> .to-right');
            this.nextButton.click(function() {
                that.showPrevButton();
                that.search.nextPage();
                return false;
            });
        },
        
        hideNextButton: function() {
            this.nextButton.hide();
        },
        
        showNextButton: function() {
            this.nextButton.show();
        },
        
        hidePrevButton: function() {
            this.prevButton.hide();
        },
        
        showPrevButton: function() {
            this.prevButton.show();
        },
        
        disable: function() {
            this.hideNextButton();
            this.hidePrevButton();
            return this;
        },
        
        enable: function() {
            this.showNextButton();
            this.showPrevButton();
            return this;
        }
    }
});
