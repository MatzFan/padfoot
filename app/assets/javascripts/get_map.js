function GetMap(pinData) {
  // pinLayer = new Microsoft.Maps.EntityCollection(); // global
  // infoboxLayer = new Microsoft.Maps.EntityCollection(); // global
  var mapOptions = {
    credentials:'AutjcX00ethCZF2CQURexruteEwuFxvWJ6BVywEvyDv5BIaOO3vfhrH59O_rnLFd',
    center: new Microsoft.Maps.Location(49.210, -2.135), // 49.225, -2.135 is Digimap center
    zoom: 13,
    mapTypeId: Microsoft.Maps.MapTypeId.aerial
  }
  map = new Microsoft.Maps.Map(document.getElementById('mapDiv'), mapOptions); // make map global
  map.getMode().setOptions({ drawShapesInSingleLayer: true }); // THANK F*CK FOR SO : http://stackoverflow.com/questions/21737320/bing-maps-7-polygon-events-not-firing-when-pushed-to-entitycollection

  addDrawingTools();
  $(window).load(function() { addNavMenuButtons(); }); // add custom nav buttons when all DOM elements loaded

  $.each(pinData, function(i, data) { plotPin(data); });

  pinInfobox = new Microsoft.Maps.Infobox(new Microsoft.Maps.Location(0, 0), {visible: false });
  Microsoft.Maps.Events.addHandler(map, 'viewchange', hideInfobox);
  // infoboxLayer.push(pinInfobox);
  map.entities.push(pinInfobox);



  addParishes();


  // map.entities.push(pinLayer);
  // map.entities.push(infoboxLayer);
}

function addParishes() {
  $.getJSON("parishes.json")
    .done(function(parishes) {
      $.each(parishes, function(i, rings) {
        $.each(rings, function(i, ringCoords) {
          plotPoly(ringCoords);
        });
      });
    });
}

function plotPoly(coordsArray) {
  var locs = [];
  $.each(coordsArray, function(i, arr) {
    locs.push(new Microsoft.Maps.Location(arr[0], arr[1]));
  });
  var polygoncolor = new Microsoft.Maps.Color(0, 0, 0, 255);
  var poly = new Microsoft.Maps.Polygon(locs, {fillColor: polygoncolor});
  map.entities.push(poly);
}

function addDrawingTools() {
  Microsoft.Maps.registerModule("DrawingToolsModule", "../assets/DrawingToolsModule.js");
  Microsoft.Maps.loadModule("DrawingToolsModule", {
    callback: function () {
      var drawingTools = new DrawingTools.DrawingManager(map, {
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
        $.each(data, function(i, data) { plotPin(data); });
      });
  } else {
    var longs = [];
    var lats = [];
    var locs = shape.getLocations();
    $.each(locs, function(i, values) { lats.push(values.latitude) });
    $.each(locs, function(i, values) { longs.push(values.longitude) });
    $.getJSON( "within_polygon.json", {lats: lats, longs: longs})
      .done(function(data) {
        $.each(data, function(i, data) { plotPin(data); });
      });
  }
}

function addNavMenuButtons() {
  $('.NavBar_modeSelectorControlContainer').css('width', '220px'); // widen from 190 to fit buttons
  $($('.NavBar_modeSelectorControlContainer')[0]).append(
  $('<span>').addClass('NavBar_separator')).append(
  $('<a>').attr('href', '#').addClass('NavBar_button').append(
  $('<span>').html( 'Show/Hide menu').click(toggleMenuBar) ));
}

function toggleMenuBar() {
  if($('body').css('padding-top') === '60px') {
    $('body').css('padding-top', '0px');
  } else { $('body').css('padding-top', '60px'); }
  $('.navbar-fixed-top').toggle();
}

function plotPin(data) {
  var pushpinOptions = {icon: "../assets/pin_" +data.colour+ ".png", text: data.letter}
  var location = new Microsoft.Maps.Location(data.latitude, data.longitude);
  var pin = new Microsoft.Maps.Pushpin(location, pushpinOptions);
  pin.Title = data.title;
  pin.Description = data.description;
  Microsoft.Maps.Events.addHandler(pin, 'click', displayInfobox);
  // pinLayer.push(pin);
  map.entities.push(pin);
}

function displayInfobox(e) {
  pinInfobox.setOptions({title: e.target.Title, description: e.target.Description, visible:true, offset: new Microsoft.Maps.Point(0,15)});
  pinInfobox.setLocation(e.target.getLocation());
}

function hideInfobox(e) {
  pinInfobox.setOptions({ visible: false });
}
