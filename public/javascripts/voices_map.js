var map;

function initialize() {
  var initialLocation;
  var geocoder;
  var options = {
    zoom: 4,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  $('#voices_map').height($(window).height());
  map = new google.maps.Map($('#voices_map')[0], options);

  // W3C geolocation
  if(navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(position) {
      initialLocation = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
      map.setCenter(initialLocation);
    }, handleNoGeoLocation);
  // Try Google Gears geolocation
  } else if(google.gears) {
    var geo = google.gears.factory.create('beta.geolocation');
    geo.getCurrentPosition(function(position) {
      initialLocation = new google.maps.LatLng(position.latitude, position.longitude);
      map.setCenter(initalLocation);
    }, handleNoGeoLocation);
  // Browser doesn't support geolocation
  } else {
    handleNoGeoLocation();
  }

  geocoder = new google.maps.Geocoder();

  for(var j = 0; j < voice_locations.length; j++) {
    var voices = voice_locations[j];
    for(var country in voices) {
      if(voices.hasOwnProperty(country)) {
        var content = '';
        for(var i = 0; i < voices[country].length; i++) {
          var link = ' - <a href="/' + voices[country][i].slug + '">View voice</a><br/>';
          content += '<strong>' + voices[country][i].title + '</strong>' + link;
        }
        var info = new google.maps.InfoWindow({content: content, maxWidth: 300});
        geocoder.geocode({address: country}, function(results) {
          if(results) {
            var marker = new google.maps.Marker({
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

function handleNoGeoLocation() {
  initialLocation = new google.maps.LatLng(0, 0);
  map.setCenter(initialLocation);
  map.setZoom(2);
}

function loadScript() {
  var script = $('<script type="text/javascript" />');
  script.attr('src', "http://maps.google.com/maps/api/js?sensor=false&callback=initialize");
  $('body').append(script);
}

$(window).load(loadScript);
