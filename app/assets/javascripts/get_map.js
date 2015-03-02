function GetMap(locations, colours, letters, refs, descriptions) {

  var pinLayer = new Microsoft.Maps.EntityCollection();
  var infoboxLayer = new Microsoft.Maps.EntityCollection();

  var mapOptions = {
    credentials:'AutjcX00ethCZF2CQURexruteEwuFxvWJ6BVywEvyDv5BIaOO3vfhrH59O_rnLFd',
    center: new Microsoft.Maps.Location(49.210, -2.135), // 49.225, -2.135 is Digimap center
    zoom: 13,
    mapTypeId: Microsoft.Maps.MapTypeId.aerial
  };
  var map = new Microsoft.Maps.Map(document.getElementById('mapDiv'), mapOptions);

  for (var i=0,  len=locations.length; i < len; i++) {
    var lat = locations[i][0]; var lng = locations[i][1];
    var loc = new Microsoft.Maps.Location(lat, lng);
    var pushpinOptions = {
      icon: "../assets/marker_" +colours[i]+ ".png",
      text: letters[i],
      textOffset: new Microsoft.Maps.Point(3, 3)
    };
    var pin = new Microsoft.Maps.Pushpin(loc, pushpinOptions);
    pin.Title = refs[i];
    pin.Description = descriptions[i];
    pinInfobox = new Microsoft.Maps.Infobox(new Microsoft.Maps.Location(0, 0), {visible: false });

    Microsoft.Maps.Events.addHandler(pin, 'click', displayInfobox);
    Microsoft.Maps.Events.addHandler(map, 'viewchange', hideInfobox);

    pinLayer.push(pin);
    infoboxLayer.push(pinInfobox);
  }
  map.entities.push(pinLayer);
  map.entities.push(infoboxLayer);
}

// define supporting fuctions

function displayInfobox(e) {
  pinInfobox.setOptions({title: e.target.Title, description: e.target.Description, visible:true, offset: new Microsoft.Maps.Point(0,15)});
  pinInfobox.setLocation(e.target.getLocation());
}

function hideInfobox(e)
{
  pinInfobox.setOptions({ visible: false });
}
