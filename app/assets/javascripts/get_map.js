function GetMap(locations) {

  var pinLayer = new Microsoft.Maps.EntityCollection();

  var mapOptions = {
    credentials:'AutjcX00ethCZF2CQURexruteEwuFxvWJ6BVywEvyDv5BIaOO3vfhrH59O_rnLFd',
    center: new Microsoft.Maps.Location(49.21042016382462, -2.1445659365234615),
    zoom: 12,
    mapTypeId: Microsoft.Maps.MapTypeId.aerial
  };
  var map = new Microsoft.Maps.Map(document.getElementById('mapDiv'), mapOptions);

  for (var i=0,  len=locations.length; i < len; i++) {
    var lat = locations[i][0]; var lng = locations[i][1];
    var loc = new Microsoft.Maps.Location(lat, lng);
    var pushpinOptions = {};
      // icon: 'https://www.google.com/mapfiles/ms/micons/' + plot_icon_colours[i] + '.png', text: plot_categories[i], textOffset: new Microsoft.Maps.Point(3, 3)};
    var pin = new Microsoft.Maps.Pushpin(loc, pushpinOptions);
    pinLayer.push(pin);
  }
  map.entities.push(pinLayer);
}
