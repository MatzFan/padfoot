var map; // **global**
var markers = []; // **global**

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
  addViewInTableButton();
  document.getElementById('find-locations').onclick = findLocations;
}


function findLocations() {
  var search_string = document.getElementById('search-string').value;
  if(search_string == '') {
    alert('Please enter some search text');
    return;
  }
  var results = $.getJSON( "map/find_location", {search_string: search_string})
    .done(function(results) {
      var geometry = results[0].geometry
      var attributes = results[0].attributes
      var location = geometry.location;
      map.setCenter(location);
      map.setZoom(16)
      var marker = new google.maps.Marker({
        map: map, // RELIES ON GLOBAL VARAIABLE NAMESPACE!!!!!!!!!!!!
        position: location,
        title: attributes.Add1
      });
  });
}


function addDrawingTools() {
  var drawingManager = new google.maps.drawing.DrawingManager({
    drawingControl: true,
    drawingControlOptions: {
      position: google.maps.ControlPosition.TOP_CENTER,
      drawingModes: ['circle', 'polygon', 'rectangle']
    },
    circleOptions: {strokeColor: 'red'},
    polygonOptions: {strokeColor: 'red'},
    rectangleOptions: {strokeColor: 'red'}
  });
  google.maps.event.addListener(drawingManager, 'overlaycomplete', function(event) {
    drawingManager.setDrawingMode(null); // exit drawing mode
    containedApps(event.overlay);
  });
  drawingManager.setMap(map);
}


function addViewInTableButton() {
  var viewInTableDiv = document.createElement('div');
  var viewInTableControl = new viewInTableButton(viewInTableDiv);
  viewInTableDiv.index = 1;
  map.controls[google.maps.ControlPosition.TOP_CENTER].push(viewInTableDiv);
}


function viewInTableButton(div) {
  // Set CSS for the control border.
  var controlUI = document.createElement('div');
  controlUI.style.backgroundColor = '#fff';
  controlUI.style.border = '2px solid #fff';
  controlUI.style.borderRadius = '3px';
  controlUI.style.boxShadow = '0 2px 6px rgba(0,0,0,.3)';
  controlUI.style.cursor = 'pointer';
  controlUI.style.marginBottom = '22px';
  controlUI.style.textAlign = 'center';
  controlUI.title = 'Click to view plotted applications in table';
  div.appendChild(controlUI);
  // Set CSS for the control interior.
  var controlText = document.createElement('div');
  controlText.style.color = 'rgb(25,25,25)';
  controlText.style.fontFamily = 'Roboto,Arial,sans-serif';
  controlText.style.fontSize = '16px';
  controlText.style.lineHeight = '38px';
  controlText.style.paddingLeft = '5px';
  controlText.style.paddingRight = '5px';
  controlText.innerHTML = 'View in table';
  controlUI.appendChild(controlText);
  // Setup the click event listener
  controlUI.addEventListener('click', function() {
    showPlottedAppsInTable();
  });
}


function showPlottedAppsInTable() {
  if(markers.length == 0) {
    alert('There are no applications plotted on the map - draw a shape to plot them');
    return;
  }
  var token = $('meta[name="csrf-token"]').attr("content");
  var refs = $.map(markers, function(marker) { return marker.title; });
  $('<form action="index" method="POST">' +
    '<input type="hidden" name="refs" value="' + refs + '">' + // comma-separated list
    '<input type="hidden" name="authenticity_token" value="' + token + '">' +
    '</form>').appendTo('body').submit(); // Chrome 56 fix
}


function containedApps(shape) {
  if(shape instanceof google.maps.Circle) {
    var center = shape.getCenter();
    var radius = shape.getRadius();
    plotMarkersInCircle(center.lat(), center.lng, radius);
  } else if(shape instanceof google.maps.Rectangle) {
    var bounds = shape.getBounds().toJSON();
    lats = [bounds.north, bounds.north, bounds.south, bounds.south, bounds.north]; // close shape
    longs = [bounds.west, bounds.east, bounds.east, bounds.west, bounds.west]; // close shape
    plotMarkersInPoly(lats,longs);
  } else if(shape instanceof google.maps.Polygon) {
    var pathArray = shape.getPath().getArray();
    var len = pathArray.length;
    var lats = [pathArray[len -1].lat()]; // last point, to close shape
    var longs = [pathArray[len -1].lng()]; // last point, to close shape
    $.each(pathArray, function(i, values) { lats.push(values.lat()); });
    $.each(pathArray, function(i, values) { longs.push(values.lng()); });
    plotMarkersInPoly(lats, longs);
  } else {
    throw new Error("shape type not supported");
  }
}


function plotMarkersInCircle(lat, long, radius) {
  $.getJSON( "within_circle.json", {lat: lat, long: long, radius: radius})
    .done(function(data) {
      $.each(data, function(i, data) {
        var marker = plotMarker(data);
      });
    });
}


function plotMarkersInPoly(lats, longs) {
  $.getJSON( "within_polygon.json", {lats: lats, longs: longs})
    .done(function(data) {
      $.each(data, function(i, data) {
        var marker = plotMarker(data);
      });
    });
}


function plotMarker(data) {
  var markerIcon = {
    url: "../assets/pin_" + data.colour + ".png",
    labelOrigin: new google.maps.Point(13,14) // offset
  };
  var marker = new google.maps.Marker({
    map: map,
    position: new google.maps.LatLng(data.lat, data.long),
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
  markers.push(marker); // add to global array
}
