function GetBingMap() {
  // pinLayer = new Microsoft.Maps.EntityCollection(); // global
  // infoboxLayer = new Microsoft.Maps.EntityCollection(); // global
  var mapOptions = {
    credentials:'AutjcX00ethCZF2CQURexruteEwuFxvWJ6BVywEvyDv5BIaOO3vfhrH59O_rnLFd',
    center: new Microsoft.Maps.Location(49.210, -2.135), // 49.225, -2.135 is Digimap center
    zoom: 13,
    mapTypeId: Microsoft.Maps.MapTypeId.aerial
  }
  map = new Microsoft.Maps.Map(document.getElementById('mapDiv'), mapOptions); // make map global
  // NO LONGER NEEDED IN V8?
  // map.getMode().setOptions({ drawShapesInSingleLayer: true }); // THANK F*CK FOR SO : http://stackoverflow.com/questions/21737320/bing-maps-7-polygon-events-not-firing-when-pushed-to-entitycollection

  addDrawingTools();
  $(window).load(function() { addNavMenuButtons(); }); // add custom nav buttons when all DOM elements loaded
  
  var pinData = gon.data;
  $.each(pinData, function(i, data) { plotPin(data); });

  pinInfobox = new Microsoft.Maps.Infobox(new Microsoft.Maps.Location(0, 0), {visible: false });

  pinInfobox.setMap(map); // V8

  Microsoft.Maps.Events.addHandler(map, 'viewchange', hideInfobox);
  // infoboxLayer.push(pinInfobox);
  map.entities.push(pinInfobox);

  // map.entities.push(pinLayer);
  // map.entities.push(infoboxLayer);
  return map;
}

function addDrawingTools() {
  Microsoft.Maps.registerModule("DrawingToolsModule", "../assets/DrawingToolsModule.js");
  Microsoft.Maps.loadModule("DrawingToolsModule", {
    callback: function () {
      drawingTools = new DrawingTools.DrawingManager(map, { // global var
        toolbarContainer: document.getElementById('toolbarContainer'),
        toolbarOptions: {
          drawingModes: ['circle', 'polygon', 'rectangle', 'erase'], styleTools: [] },
          events: {
          drawingEnded: function(s) {
            containedApps(s);
            if(s.ShapeInfo.type == 'circle' || s.ShapeInfo.type == 'rectangle') {
              drawingTools.setDrawingMode(null); // NOT FOR POLY - creates infinite loop!!!!!!!!
            }
          },
          drawingErased: function (s) {
            drawingTools.setDrawingMode(null); // exit mode when drawing finished
          }
        }
      });
    }
  });
}

function containedApps(shape) {
  var locs;
  if(shape.ShapeInfo.type === 'circle') {
    var center = shape.ShapeInfo.center;
    var radius = shape.ShapeInfo.radius * 1000; // meters
    $.getJSON( "within_circle.json", {lat: center.latitude, long: center.longitude, radius: radius})
      .done(function(data) {
        $.each(data, function(i, data) { plotPin(data, shape); });
      });
  } else {
    var longs = [];
    var lats = [];
    var locs = shape.getLocations();
    $.each(locs, function(i, values) { lats.push(values.latitude) });
    $.each(locs, function(i, values) { longs.push(values.longitude) });
    $.getJSON( "within_polygon.json", {lats: lats, longs: longs})
      .done(function(data) {
        $.each(data, function(i, data) { plotPin(data, shape); });
      });
  }
}

function addNavMenuButtons() {
  $('.NavBar_modeSelectorControlContainer').css('width', '220px'); // widen from 190 to fit buttons
  $($('.NavBar_modeSelectorControlContainer')[0]).append(
  $('<span>').addClass('NavBar_separator')).append(
  $('<a>').attr('href', '#').addClass('NavBar_button').append(
  $('<span>').html( 'View in table').click(showPlottedAppsInTable) ));
}

function showPlottedAppsInTable() {
  var token = $('meta[name="csrf-token"]').attr("content");
  var refs = [];
  for(var i=0; i < drawingTools.shapeLayer.getLength(); i++) { // gets polygons & pushpins
    var ref = drawingTools.shapeLayer.get(i).Title;
    if(typeof ref !== 'undefined') { refs.push(htmlEscape(ref)); } // polygons do not have Title attribute
  }
  $('<form action="index" method="POST">' +
    '<input type="hidden" name="refs" value="' + refs + '">' + // comma-separated list
    '<input type="hidden" name="authenticity_token" value="' + token + '">' +
    '</form>').submit();
}

// function toggleMenuBar() {
//   if($('body').css('padding-top') === '35px') {
//     $('body').css('padding-top', '0px');
//   } else { $('body').css('padding-top', '35px'); }
//   $('.navbar-fixed-top').toggle();
// }

function plotPin(data, shape) {
  var pushpinOptions = {icon: "../assets/pin_" +data.colour+ ".png", text: data.letter}
  var location = new Microsoft.Maps.Location(data.lat, data.long);
  var pin = new Microsoft.Maps.Pushpin(location, pushpinOptions);

  pin.Title = data.infoboxTitle; // set in mappable module
  pin.Description = data.infoboxContent; // set in mappable module

  Microsoft.Maps.Events.addHandler(pin, 'click', displayInfobox);
  //V8 BREAKS 'In V8, add pushpin to a Layer and add right click event to the layer.'
  // Microsoft.Maps.Events.addHandler(pin, 'rightclick', removePin);
  if(typeof shape === 'undefined') {
    map.entities.push(pin);
  } else {
    drawingTools.shapeLayer.push(pin); // associate the pins to the shape layer
  }
}

function displayInfobox(e) {
  var pin = e.target;
  var ref = pin.Title;
  var pushpinFrameHTML = '<div class="infobox">'+
                            '<a class="infobox_close" href="javascript:hideInfobox()"><img src="../assets/close.png"/></a>'+
                            '<div class="infobox_content">{content}</div>'+
                          '</div>'+
                          '<div class="infobox_pointer"><img src="../assets/pointer_shadow.png"></div>';
  var html = '<span class="infobox_title"><a href="javascript:addDesriptionToInfobox(\'' + ref + '\')">' + ref + '</a></span><br/>' + pin.Description;
  // var html = '<span class="infobox_title">' + pin.Title + '</span><br/>' + pin.Description;
  pinInfobox.setOptions({
    visible:true,
    offset: new Microsoft.Maps.Point(-33, 30), // was 0, 15
    htmlContent: pushpinFrameHTML.replace('{content}', html)
  });
  pinInfobox.setLocation(e.target.getLocation());
  // $(".infobox").dotdotdot(); // ellipsisify :) - no longer needed with re-sizing infoboxes
}

function addDesriptionToInfobox(ref) {
  $.getJSON("description.json", {ref: ref}, function(data) {
    var html = '<br><div class="description">' + data + '</div>';
    $('.infobox_content').append(html);
  });
}

function hideInfobox(e) {
  pinInfobox.setOptions({ visible: false });
}

function removePin(e) { // try to remove pin from whichever layer it was added to
  map.entities.remove(e.target);
  drawingTools.shapeLayer.remove(e.target);
}
