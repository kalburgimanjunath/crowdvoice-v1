var geocoder = new google.maps.Geocoder();

$(function() {
  $('#voice_location').change(function() {
    geocoder.geocode({address: this.value}, function(results, statusResponse) {
      if(statusResponse == "OK" && results && !results[0].partial_match) {
        $('#voice_latitude').val(results[0].geometry.location.lat());
        $('#voice_longitude').val(results[0].geometry.location.lng());
      } else {
        $('#voice_latitude, #voice_longitude').val('');
      }
    });
  });
});

