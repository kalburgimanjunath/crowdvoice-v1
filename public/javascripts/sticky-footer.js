$(document).ready(function(){
	jQuery(window).bind('load', function(){
			$('.content').css('min-height', $(window).height() - 140);
	});
	
	jQuery(window).bind('resize', function(){
			$('.content').css('min-height', $(window).height() - 140);
	});
});