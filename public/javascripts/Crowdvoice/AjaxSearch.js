Class(Crowdvoice,'AjaxSearch')({
	prototype : {		
		text_field: null,
		search_div: null,
		current_search: "",
		options: {
				position: "bottom",
				close_container: null,
				close_active_image: '',
				close_inactive_image: '',
				preloader: null
		},
		MAX_CHARS_COUNT: 1,
		_activated: false,
		
    initialize: function (text_field, parent, options) {
			var self = this;
			
			this.text_field = $(text_field);
			
			if (options) $.extend(this.options, options);
			
			// initially hide the preloader
			if (this.options.preloader) this.options.preloader.hide();
			
			// setup the close button, if there's one
			if (this.options.close_container.length) {
				if (this.options.close_inactive_image == '') {
					this.options.close_container.hide();
				} else {
					$(this.options.close_container).attr('src', this.options.close_inactive_image);
				}
				
				this.options.close_container.click(function() {
					//if (self._activated) {
						self.deactivate(self.text_field.val() != '');
						self.text_field.blur();
					//}
				});
			}
			
			// create and position search results div
			
			this.search_div = $(document.createElement('div'));
			this.search_div.addClass('search-results');

			var height = $(parent).height();//this.text_field.parent().height();
			var width = $(parent).width();//this.text_field.parent().width();
			
			this.search_div.css({width: width+'px'});
			
			switch(this.options.position) {
				case 'top':
					this.search_div.css({left: '0px', bottom: height+'px'});
				break;
				case 'bottom':
					this.search_div.css({left: '0px', top: height+'px'});
				break;
			}
			
			parent.css('position', 'relative');
			parent.append(this.search_div);
			
			// disable default form behaviour
			/*
			var form = self.text_field.parents('form');
			if (form) {
				form.bind('submit', function() {
					if (self.text_field.val() != '') {
						self.deactivate(true);
					}

					return false;
				});
			}
			*/
			// setup the text field so it understands keydown event			
			
			this.text_field.bind(
				{
					keyup: function() {
						var text = $.trim($(this).val());
						
						if (text == '' && self._activated) {
							self.deactivate(true);
						}
						
						self.updateCloseButton();
						
						if (text == self.current_search || text == '' || text.length < self.MAX_CHARS_COUNT) return;
						
						self.current_search = text;
						
						if (self.options.preloader) self.options.preloader.show();
						if (self.options.close_container) self.options.close_container.hide();
						
						$.get('/?search='+text, function(data) {
							self.activate(data);
							if (self.options.preloader) self.options.preloader.hide();
							if (self.options.close_container) self.options.close_container.show();
						});
					},
					focus: function() {
						if ($(this).val() != '') {
							self.activate();
						}
					},
					blur: function() {
						self.deactivate();
					}
				}
			);
		},
		activate: function(data) {
			if (data) this.search_div.html(data);
			this.search_div.fadeIn();
			this._activated = true;
		},
		deactivate: function(clear) {
			this.search_div.fadeOut();
			
			if (clear && clear == true) {
				this.text_field.val('');
				
				this.updateCloseButton();
			}
			
			this._activated = false;
		},
		updateCloseButton: function() {
			if ($(this.options.close_container).length) {
				if (this.text_field.val() == '') {
					if (this.options.close_inactive_image == "") {
						$(this.options.close_container).hide();
					} else {
						$(this.options.close_container).show();
						$(this.options.close_container).attr('src', this.options.close_inactive_image);
					}
				} else {
					if (this.options.close_active_image == "") {
						$(this.options.close_container).hide();
					} else {
						$(this.options.close_container).show();
						$(this.options.close_container).attr('src', this.options.close_active_image);
					}
				}
			}
		}	
  }
});
