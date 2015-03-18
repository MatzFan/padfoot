function GetMap(locations, colours, letters, refs, descriptions) {

  pinInfoBox = null;
  pinLayer = new Microsoft.Maps.EntityCollection(); // global
  infoboxLayer = new Microsoft.Maps.EntityCollection(); // global

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

  for (var i=0,  len=locations.length; i < len; i++) {
    var lat = locations[i][0]; var lng = locations[i][1];
    var loc = new Microsoft.Maps.Location(lat, lng);
    var pushpinOptions = {
      icon: "../assets/pin_" +colours[i]+ ".png",
      text: letters[i],
      // textOffset: new Microsoft.Maps.Point(3, 3)
    }
    title = refs[i];
    description = descriptions[i];
    // pin = createPin(loc, title, description, pushpinOptions);

    var pin = new Microsoft.Maps.Pushpin(loc, pushpinOptions);
    pin.Title = title;
    pin.Description = description;
    Microsoft.Maps.Events.addHandler(pin, 'click', displayInfobox);
    pinLayer.push(pin);

    pinInfobox = new Microsoft.Maps.Infobox(new Microsoft.Maps.Location(0, 0), {visible: false });
    Microsoft.Maps.Events.addHandler(map, 'viewchange', hideInfobox);

    infoboxLayer.push(pinInfobox);
  }
  map.entities.push(pinLayer);
  map.entities.push(infoboxLayer);
}

function addDrawingTools() {
  Microsoft.Maps.registerModule("DrawingToolsModule", "../assets/DrawingToolsModule.js");
  Microsoft.Maps.loadModule("DrawingToolsModule", {
    callback: function () {
      var drawingTools = new DrawingTools.DrawingManager(map, {
        toolbarContainer: document.getElementById('toolbarContainer'),
        toolbarOptions: {
          drawingModes: ['circle', 'erase'],
          // drawingModes: ['polygon', 'circle', 'rectangle', 'erase'],
          styleTools: []
        }, events: {
          drawingEnded: function(s) {
            containedApps(s);
            drawingTools.setDrawingMode(null); // exit mode when drawing finished
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
  var center = shape.ShapeInfo.center;
  var radius = shape.ShapeInfo.radius * 1000; // meters
  $.getJSON( "within.json", {lat: center.latitude, long: center.longitude, radius: radius})
    .done(function(data) {
      $.each(data, function(i, data) { plotPin(data); });
    });
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
  var location = new Microsoft.Maps.Location(data.lat, data.long);
  var pin = createPin(location, data.ref, data.desc, null);
  pinLayer.push(pin);
}

function createPin(location, title, description, pushpinOptions) {
  pushpinOptions = $.extend({}, pushpinOptions, {text: 'A'});
  var pin = new Microsoft.Maps.Pushpin(location, pushpinOptions);
  pin.Background = Microsoft.Maps.Color(100,255,0,0);
  pin.FontSize = 20.0;
  pin.Title = title;
  pin.Description = description;
  Microsoft.Maps.Events.addHandler(pin, 'click', displayInfobox);
  return pin;
}

function displayInfobox(e) {
  pinInfobox.setOptions({title: e.target.Title, description: e.target.Description, visible:true, offset: new Microsoft.Maps.Point(0,15)});
  pinInfobox.setLocation(e.target.getLocation());
}

function hideInfobox(e) {
  pinInfobox.setOptions({ visible: false });
}
