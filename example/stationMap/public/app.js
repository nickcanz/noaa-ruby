$(document).ready(function () {
  var center = new google.maps.LatLng(40, -75);
  var opts = {
    zoom: 8,
    center: center,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  var map = new google.maps.Map(document.getElementById("map"), opts);

  var markers = [];

  google.maps.event.addListener(map, 'dragend', function () {
    var center = map.getCenter();
    $.each(markers, function (idx, marker) {
      marker.setMap(null);
    });
    $.ajax({
      url: 'stations',
      data: {
        lat: center.lat(),
        lng: center.lng()
      },
      success: function (stations) {
        markers = [];
        $.each(stations, function (idx, station) {
          var loc= station.location;
          markers.push(
            new google.maps.Marker({
              position: new google.maps.LatLng(loc.lat, loc.lon),
              map: map,
              title: station.name
            })
          );
        });
      },
      dataType: 'json'
    });
  });

  google.maps.event.trigger(map, 'dragend');
});
