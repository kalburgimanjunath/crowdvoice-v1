var map;

function initialize() {
  var initialLocation = new google.maps.LatLng(0 ,0);
  var geocoder = new google.maps.Geocoder();
  var options = {
    zoom: 2,
    center: initialLocation,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  map = new google.maps.Map($('#voices_map')[0], options);

  for(var j = 0; j < voice_locations.length; j++) {
    var voices = voice_locations[j];
    for(var country in voices) {
      if(voices.hasOwnProperty(country)) {
        var content = '<ul class="country-voices">';
        for(var i = 0; i < voices[country].length; i++) {
          var link = ' <a href="/' + voices[country][i].slug + '">' + voices[country][i].title + '</a>';
          content += '<li>' + link + '</li>';
        }
        content += '</ul>';
        var info = new google.maps.InfoWindow({content: content, maxWidth: 400});
        geocoder.geocode({address: country}, function(results) {
          if(results) {
            var marker = new google.maps.Marker({
              icon: "/images/pin.png",
              map: map,
              position: results[0].geometry.location,
              title: voices[country].length + ' voices in ' + country
            });
            google.maps.event.addListener(marker, 'click', function() {
              info.open(map, marker);
            });
          }
        });
      }
    }
  }
}

function loadScript() {
  var script = $('<script type="text/javascript" />');
  script.attr('src', "http://maps.google.com/maps/api/js?sensor=false&callback=initialize");
  $('body').append(script);
}

$(function() {
  $('#voices_map').height($(window).height() - $('.footer').outerHeight() - $('.mid-footer').outerHeight() + 5);

  $('.show-map').click(function() {
    $('#voices_map, .hide-map').show();
    $('.voices-list, .show-map').hide();
    $('.mid-footer .title').text('VOICES ON THE MAP');
    if(!map) {
      loadScript();
    }
    $.scrollTo('#voices_map', 800);
  });

  $('.hide-map').click(function() {
    $('#voices_map').hide('blind', {duration: 800, direction: 'vertical'}, function() {
      $('.hide-map').hide();
      $('.voices-list, .show-map').show();
      $('.mid-footer .title').text('VOICE INDEX');
    });
  });
});
