$(function() {
    setTimeout(function() {
        var flash = $('.flash');
        var hideTimeout = setTimeout(function() {
            if(flash.is(':visible')) {
                flash.hide('slide', {direction: 'up'});
            }
        }, 5000);
        flash.show('blind').click(function() {
            if($(this).is(':visible')) {
                $(this).hide('slide', {direction: 'up'});
                clearTimeout(hideTimeout);
            }
            return false;
        });
    }, 1000);
});



function loadZeroClipboard( id, oncomplete ){
  ZeroClipboard.setMoviePath( '/swfs/ZeroClipboard.swf' );
  window.clip = new ZeroClipboard.Client();
  window.clip.addEventListener('complete', function (client, text) {
    oncomplete(client, text);
  });
  window.clip.setHandCursor(true);
  gb = document.getElementById(id);
  window.clip.glue(gb, gb);
}

function setZeroClipboardText( text ){
  window.clip.setText(text);
}
