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

    $.fn.setOptActive = function() {
        var id = $('#slides li:first').attr('id');
        var id_next = $('#slides li:first + li').attr('id');
        if(id){
            $('.active-voices ul li').eq(id.split('_')[1]).removeClass('active');
            $('.active-voices ul li').eq(id_next.split('_')[1]).addClass('active');
        }
    };
    
    $('.copyright.tooltip').hover(function() {
        var dd = $(this).find('.dropdown');
        dd.css({
            marginLeft: '-' + dd.width() + 'px',
            marginTop: '-' + dd.height() + 'px'
        }).show();
    }, function() {
        $(this).find('.dropdown').hide();
    });
    
    /******** No animation, changed by hover on li *************/
    $('.voices').wrapAll('<div class="slides" style="width: 4000px; overflow: hidden; position: absolute; left: -800px;"/>');
    $('.voices').css({'left':'0', 'width': '800px', 'float': 'left'});
    $('.voices li').css({'position':'absolute', left: 0, 'top':'0'}).not(':last').each(function(i) {
        $(this).css({'left': (i + 1) * 800});
    });
    
    $('.active-voices ul li a').mouseover(function() {
        var ix = $(this).parent('li').index();
        var leftImg = ix == 0 ? ':last' : ':nth-child(' + ix + ')';
        var rightImg = (ix + 1) == $('.voices li').length ? 0 : ix + 1;
        $('.voices li')
        .not(leftImg + ', ' + ':eq(' + ix + '), ' + ':nth-child(' + rightImg + ')')
        .each(function(i) {
            $(this).css({'left': (i + ix + 1) * 800})
        });
        $('.voices li' + leftImg).css({'left': 0});
        $('.voices li').eq(ix).css({'left': 800});
        $('.voices li').eq(rightImg).css({'left': 1600});

        $('.active-voices ul li.active').removeClass('active');
        $(this).parent('li').addClass('active');
        $('.copyright .mc').html($('.voices li').eq(ix).find('.copy').html())
    });
    
    $('.pageSlide').pageSlide({
        height: '85%',
        modal: true,
        label: 'Back to voice',
        collectionSelector: '.grid > .link .url a',
        copyUrlImgPath: '/images/ps/copyurl_icon.png',
        viewOrigImgPath: '/images/ps/vieworiginal_icon.png'
      });

    /******************************* SlideShow Start *************************************/
    //animations scroll, fade_same_time, fade_random, fade_one_by_one;
    // var animation = "fade_one_by_one";
    // var size = $('.voices').children().size();
    // if(size > 1){
    //  if(animation == "fade_one_by_one" || animation == 'fade_random'){
    //      $('.voices').wrapAll('<div class="slides" style="width: 4000px; overflow: hidden; position: absolute; left: -800px;"/>');
    //      $('.voices').css({'left':'0', 'width': '800px', 'float': 'left'});
    //      $('.voices li').css({'position':'absolute', 'left':'0', 'top':'0'});
    //      var voices = $('.voices');
    //      voices.clone().appendTo(".slides");
    //      voices.clone().appendTo(".slides");
    //      $('.voices').eq(0).children('li:first').before($('.voices').eq(0).children('li:last'));
    //      $('.voices').eq(2).children('li:last').after($('.voices').eq(2).children().eq(0));
    //      $('.voices li:first-child ~ li').css('opacity', '0');
    //      var counters = {0 : 0, 1 : 0, 2 : 0};
    //      var order = new Array(0, 2, 1); //Animate slides in this order
    //      if(animation == 'fade_one_by_one'){
    //          function animate_one_by_one(i){
    //              j = counters[i];
    //              $('.voices').eq(order[i]).children().eq(j).animate({opacity: 0}, 2000, function () {
    //                  var next = (j+1) >= size ? 0 : (j+1);
    //                  $('.voices').eq(order[i]).children().eq(next).animate({opacity: 1.0}, 2000);
    //                  if(order[i] == 1){
    //                      $('.active-voices ul li').eq(j).removeClass('active');
    //                      $('.active-voices ul li').eq(next).addClass('active');
    //                  }
    //                  j++;
    //                  counters[i] = j >= size ? 0 : j;
    //                  i++;
    //                  i = i > 2 ? 0 : i;
    //                  setTimeout(function() {
    //                      animate_one_by_one(i);
    //                  }, order[i]==1 ? 5000 : 2000);
    //              });
    //          }
    //          setTimeout(function() {animate_one_by_one(0);}, 2000);
    //      }
    //      else {
    //          function animate_random_slide(i, j){
    //              $('.voices').eq(i).children().eq(j).animate({opacity: 0}, 2000, function () {
    //                  var next = (j+1) >= size ? 0 : (j+1)
    //                  $('.voices').eq(i).children().eq(next).animate({opacity: 1.0}, 2000);
    //                  j++;
    //                  j = j >= size ? 0 : j;
    //                  setTimeout(function() {
    //                      animate_random_slide(i, j)
    //                  }, 5000);
    //              });
    //          }
    // 
    //          setTimeout(function(){
    //              animate_random_slide(0, 0);
    //              setTimeout(function(){
    //                  animate_random_slide(2, 0);
    //                  setTimeout(function(){
    //                      animate_random_slide(1, 0);
    //                  }, 5000);
    //              }, 5000);
    //          }, 5000);
    //      }
    //  }
    //  else if(animation == 'scroll' || animation == 'fade_same_time'){
    //      var speed = 8000;
    //      var run = setInterval('rotate()', speed);
    //      var item_width = $('#slides li').outerWidth();
    //      var left_value = item_width * (-1);
    // 
    //      $('#slides li:first').before($('#slides li:last')); //move the last item before first item, just in case user click prev button
    //      $('#slides ul').css({'left' : left_value}); //set the default item to the correct position
    // 
    //      $('#prev').click(function() { //if user clicked on prev button
    //          var left_indent = parseInt($('#slides ul').css('left')) + item_width; //get the right position
    //          $('#slides ul:not(:animated)').animate({'left' : left_indent}, 2000,function(){
    //              $('#slides li:first').before($('#slides li:last'));
    //              $('#slides ul').css({'left' : left_value}); //set the default item to correct position
    //          });
    //          return false;
    //      });
    // 
    //      $('#next').click(function() {
    //          var left_indent = parseInt($('#slides ul').css('left')) - item_width;
    //          if(animation == 'fade_same_time'){
    //              $('#slides ul:not(:animated)').animate({opacity: 0}, 500, function () {
    //                  $('#slides li:last').after($('#slides li:first'));
    //                  $(this).setOptActive();
    //                  $('#slides ul').css({'left' : left_value});
    //                  $('#slides ul').animate({opacity: 1.0}, 500);
    //              });
    //          }else{
    //              $('#slides ul:not(:animated)').animate({'left' : left_indent}, 2000, function () {
    //                  $('#slides li:last').after($('#slides li:first'));
    //                  $(this).setOptActive();
    //                  $('#slides ul').css({'left' : left_value});
    //              });
    //          }
    //          return false;
    //      });
    // 
    //      function rotate() {
    //          $('#next').click();
    //      }
    //      /*
    //      $('#slides').hover(
    //          function() {clearInterval(run);},
    //          function() {run = setInterval('rotate()', speed);   }
    //      );
    //      */
    //  }
    // }
    /******************************* SlideShow End *************************************/
    /*
    jQuery(window).bind('load', function(){
            $('.homepage').css('min-height', $(window).height() - 36);
    });

    jQuery(window).bind('resize', function(){
            $('.homepage').css('min-height', $(window).height() - 36);
    });
    */
    //$('.request-link a').each(function() {
        // $(this).pageSlide({
       // height: '85%',
       // modal: true,
       // label: 'Back to voice',
       // collectionSelector: '.grid > .link .url a',
       // copyUrlImgPath: '/images/ps/copyurl_icon.png',
       // viewOrigImgPath: '/images/ps/vieworiginal_icon.png'
     // });
    //});
});

//a simple function to click next link, a timer will call this function, and the rotation will begin :)
function rotate() {
    $('#next').click();
}
