function GetGoogleMap(pinData) {
  var center = {lat: 49.210, lng: -2.135};
  var map = new google.maps.Map(document.getElementById('mapDiv'), {
    zoom: 13,
    center: center,
    mapTypeId: 'satellite'
  });
  // $.each(pinData, function(i, data) { plotPin(data); });
}

