Class(Crowdvoice,'Carousel')({

    prototype : {

        description : 'No description set.',
        title : 'No title set.',
        index : 0,
        images : [],
        picture: null,
        DEFAULT_IMAGE: "http://c1736512.cdn.cloudfiles.rackspacecloud.com/link-default.png",

        initialize : function (image) {
            this.picture = $(document.createElement("img"));
            this.picture.css({"float": "left", "width": 89});
            this.picture.attr({"id": "img_74dd65a7c6"});
            this.picture.attr({"src": ""});
            $(".carousel-image").append(this.picture);
        },

        loadHash : function (hash) {
            this.index = 0;
            this.title = hash.title;
            this.description = hash.description;
            this.images = [];
            this.picture.attr("src", this.DEFAULT_IMAGE);

            //filter out the images that are useful
            var self = this;

            for (var i = 0; i < hash.images.length; i++) {
               var imgurl = hash.images[i];
               var img = new Image();
               img.src = imgurl;

               img.onload = function() {
                   if (this.width >= 50 && this.height >= 50) {
                       self.addImage(this.src);
                       if (self.images.length >= 1 && self.picture.attr("src") == self.DEFAULT_IMAGE) {
                           var src = self.current();

                           if (src != "") {
                               self.picture.show();
                               self.picture.attr("src", self.current());
                               $("#link_image").val(self.current());
                               self.update();
                           }
                       }
                   }
               };
            }

            this.update();
        },

        addImage : function(img_src) {
            this.images.push(img_src);
            this.update();
        },

        next : function () {
            this.index++;
            if (this.index >= this.images.length) { this.index = this.images.length -1 };
            return this.current();
        },

        prev : function () {
            this.index--;
            if (this.index < 0) { this.index = 0 };
            return this.current();
        },

        current : function () {
            return this.images.length == 0 ? this.DEFAULT_IMAGE : this.images[this.index] ;
        },

        label : function () {
            return this.images.length == 0 ? "no images found" : (this.index + 1) + " of " + this.images.length;
        },

        serialize : function () {
            return ({
                'description' : this.description,
                'title' : this.title,
                'images' : this.images,
                'current' : this.current()
            });
        },
        update : function() {
            $('.carousel-counter').text(this.label());
        }
    }
});
