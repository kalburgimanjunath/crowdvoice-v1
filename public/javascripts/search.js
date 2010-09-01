$(document).ready(function(){
	$.fn.clearDefault = function(){
		return this.each(function(){
			var default_value = $(this).val();
			$(this).focus(function(){
				if ($(this).val() == default_value){
					$(this).val("");
					$(this).css('color', '#333333');
				}
			});
			$(this).blur(function(){
				if ($(this).val() == ""){
					$(this).val(default_value);
					$(this).css('color', '#a9a9a9');
				}
			});
			this.setAttribute("autocomplete", "off");
		});
   };
	$('#search').clearDefault();
	
	jQuery(window).bind('load', function(){
			$('.voices > ul').css('min-height', $(window).height() - 207);
	});
	
	jQuery(window).bind('resize', function(){
			$('.voices > ul').css('min-height', $(window).height() - 207);
	});
});