function GetMap(locations, colours, letters, refs, descriptions) {

  var pinLayer = new Microsoft.Maps.EntityCollection();
  var infoboxLayer = new Microsoft.Maps.EntityCollection();

  var mapOptions = {
    credentials:'AutjcX00ethCZF2CQURexruteEwuFxvWJ6BVywEvyDv5BIaOO3vfhrH59O_rnLFd',
    center: new Microsoft.Maps.Location(49.210, -2.135), // 49.225, -2.135 is Digimap center
    zoom: 13,
    mapTypeId: Microsoft.Maps.MapTypeId.aerial
  }
  var map = new Microsoft.Maps.Map(document.getElementById('mapDiv'), mapOptions);

  $(window).load(function() { addNavMenuButtons(); }); // add nav button when all DOM elements loaded

  for (var i=0,  len=locations.length; i < len; i++) {
    var lat = locations[i][0]; var lng = locations[i][1];
    var loc = new Microsoft.Maps.Location(lat, lng);
    var pushpinOptions = {
      icon: "../assets/marker_" +colours[i]+ ".png",
      text: letters[i],
      textOffset: new Microsoft.Maps.Point(3, 3)
    }
    title = refs[i];
    description = descriptions[i];
    pin = createPin(loc, title, description, pushpinOptions);
    pinInfobox = new Microsoft.Maps.Infobox(new Microsoft.Maps.Location(0, 0), {visible: false });

    Microsoft.Maps.Events.addHandler(map, 'viewchange', hideInfobox);
    Microsoft.Maps.Events.addHandler(map, 'rightclick', nearestApp);

    pinLayer.push(pin);
    infoboxLayer.push(pinInfobox);
  }
  map.entities.push(pinLayer);
  map.entities.push(infoboxLayer);
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

function createPin(location, title, description, pushpinOptions) {
  var pin = new Microsoft.Maps.Pushpin(location, pushpinOptions);
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

function nearestApp(e) {
  if (e.targetType == "map") {
    var map  = e.target;
    var point = new Microsoft.Maps.Point(e.getX(), e.getY());
    var loc = map.tryPixelToLocation(point);
    $.get( "nearest.json", { latitude: loc.latitude, longitude: loc.longitude } )
      .done(function(data) {
        var app_loc = new Microsoft.Maps.Location(data.lat, data.long);
        var pin = createPin(app_loc, data.app_ref, data.description, null);
        Microsoft.Maps.Events.addHandler(pin, 'rightclick', function(mouseEvent) {
          map.entities.remove(mouseEvent.target);
        });
      map.entities.push(pin);
    });
  }
}
