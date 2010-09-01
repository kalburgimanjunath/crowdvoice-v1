Class('Widget')({
    HTML: '<div></div>',
    
    prototype: {
        initialize: function(args) {
            this.element = $(this.constructor.HTML);
            if(typeof this.initializer === 'function') {
                this.initializer(args || {});
            }
            return this;
        },
        
        render: function(target) {
            target.append(this.element);
            return this;
        }
    }
});
