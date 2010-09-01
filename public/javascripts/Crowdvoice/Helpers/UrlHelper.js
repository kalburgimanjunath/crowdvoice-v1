Module(Crowdvoice.Helpers, 'UrlHelper')({
    formatUrl: function(url, params) {
        params = params || {};
        var chunker = /\{:(\w+)\}/g,
            parts = [],
            m;
        while((m = chunker.exec(url)) !== null) {
            parts.push(m[1]);
        }
        $.each(parts, function(i) {
            url = url.replace('{:' + this + '}', params[this]);
        });
        return url;
    }
});
