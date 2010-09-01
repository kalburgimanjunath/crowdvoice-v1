Class(Crowdvoice.Voice.Twitter, 'Search').inherits(Crowdvoice.Helpers.UrlHelper)({
    BASE_URL: 'http://search.twitter.com/search.json?q={:query}&result_type=recent&rpp={:rpp}&page={:page}',
    RESULTS_PER_PAGE: 6,
    
    prototype: {
        url: null,
        topRow: null,
        divider: null,
        bottomRow: null,
        controls: null,
        is_last_page: false,
        perform_callback: null,
        
        initialize: function(args) {
            this.query = args.query;
            this.voice_id = args.voice_id;
            this.page = 1;
            this._buildUrl();
            
            this.topRow = new Crowdvoice.Voice.Twitter.Row({
                voice_id: this.voice_id
            });
            this.divider = new Crowdvoice.Voice.Twitter.Divider();
            this.bottomRow = new Crowdvoice.Voice.Twitter.Row({
                voice_id: this.voice_id
            });
            this.controls = new Crowdvoice.Voice.Twitter.Controls({
                search: this
            });
        },
        
        _buildUrl: function() {
            this.url = this.constructor.formatUrl(this.constructor.BASE_URL, {
                query: encodeURIComponent(this.query),
                rpp: this.constructor.RESULTS_PER_PAGE,
                page: this.page
            });
            return this.url;
        },
        
        perform: function(callback) {
            this.controls.disable();
            this.perform_callback = callback;
            $.ajax({
                url: this.url,
                context: this,
                success: function(search) {
                    this.topRow.update(search.results.splice(0, 3));
                    this.bottomRow.update(search.results);
                    if(typeof callback === 'function') {
                        callback.apply(this, [search]);
                    }
                    this.controls.enable();
                    if(this.page === 1) {
                        this.controls.hidePrevButton();
                    }
                    if(!search.hasOwnProperty('next_page')) {
                        this.controls.hideNextButton();
                    }
                },
                dataType: 'jsonp'
            });
        },
        
        prevPage: function() {
            this.page--;
            this._updatePage();
            return this.page;
        },
        
        nextPage: function() {
            this.page++;
            this._updatePage();
            return this.page;
        },
        
        _updatePage: function() {
            this._buildUrl();
            this.perform(this.perform_callback);
        },
        
        render: function(target) {
            this.target = target;
            this.topRow.render(target);
            this.divider.render(target);
            this.bottomRow.render(target);
            this.controls.render(target);
            return this;
        }
    }
});
