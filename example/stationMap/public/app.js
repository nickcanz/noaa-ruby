$(document).ready(function () {
  var center = new google.maps.LatLng(40, -75);
  var opts = {
    zoom: 8,
    center: center,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  var map = new google.maps.Map(document.getElementById("map"), opts);
});
