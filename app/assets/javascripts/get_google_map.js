var map; // **global**

function getGoogleMap() {
  var center = {lat: 49.210, lng: -2.135}; // Digimap center
  map = new google.maps.Map(document.getElementById('mapDiv'), {
    zoom: 13,
    center: center,
    mapTypeId: 'satellite'
  });
  var pinData = gon.data;
  $.each(pinData, function(i, data) { plotMarker(data); });
  addDrawingTools();
}


function addDrawingTools() {
  var drawingManager = new google.maps.drawing.DrawingManager({
    drawingMode: google.maps.drawing.OverlayType.POLYGON,
    drawingControl: true,
    drawingControlOptions: {
      position: google.maps.ControlPosition.TOP_CENTER,
      drawingModes: ['circle', 'polygon', 'rectangle']
    }
  });
  drawingManager.setMap(map);
}


function plotMarker(data) {
  var markerIcon = {
    url: "../assets/pin_" + data.colour + ".png",
    labelOrigin: new google.maps.Point(13,14)
  }
  var marker = new google.maps.Marker({
    map: map,
    position: new google.maps.LatLng(data.latitude, data.longitude),
    title: data.infoboxTitle,
    icon: markerIcon,
    label: {
      text: data.letter,
      color: "#ffffff", // white
      fontWeight: 'bold'
    }
  });
  var infowindow = new google.maps.InfoWindow({
    content: data.infoboxContent
  });
  marker.addListener('click', function() {
    infowindow.open(map, marker);
  });
  marker.setMap(map);
}

