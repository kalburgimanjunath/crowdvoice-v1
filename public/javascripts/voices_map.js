var map;
var geocoder;
var infos = [];

function initialize() {
  var initialLocation = new google.maps.LatLng(0 ,0);
  var options = {
    zoom: 2,
    center: initialLocation,
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    scrollwheel: false
  };
  geocoder = new google.maps.Geocoder();
  map = new google.maps.Map($('#voices_map')[0], options);

  for(var j = 0; j < voice_locations.length; j++) {
    var voices = voice_locations[j];
    for(var country in voices) {
      if(voices.hasOwnProperty(country)) {
        geocodeVoice(country, voices[country]);
      }
    }
  }
}

function createPin(position, title, labeltext, infowindow) {
  var marker = new google.maps.Marker({
    icon: "/images/pin.png",
    map: map,
    position: position,
    title: title
  });
  var label = new MarkerLabel({map: map, label: labeltext});
  label.bindTo('position', marker, 'position');
  google.maps.event.addListener(marker, 'click', function() {
    for(var k = 0; k < infos.length; k++) {
      infos[k].close();
    }
    infowindow.open(map, marker);
  });
}

function geocodeVoice(country, voices) {
  var content = '<ul class="country-voices">';
  var title = voices.length + ' voice(s) in ' + country;
  for(var i = 0; i < voices.length; i++) {
    var link = ' <a href="/' + voices[i].slug + '">' + voices[i].title + '</a>';
    content += '<li>' + link + '</li>';
  }
  content += '</ul>';
  var info = new google.maps.InfoWindow({content: content, maxWidth: 400});
  infos.push(info);
  if(voices[0].latitude !== null && voices[0].longitude !== null) {
    var pos = new google.maps.LatLng(voices[0].latitude, voices[0].longitude);
    createPin(pos, title, voices.length, info);
  } else {
    geocoder.geocode({address: country}, function(results, statusResponse) {
      if(statusResponse == "OK" && !results[0].partial_match) {
        createPin(results[0].geometry.location, title, voices.length, info);
      }
    });
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
      initialize();
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
