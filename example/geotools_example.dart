import 'package:geotools/geotools.dart';
import 'dart:io';

main() {
  // Geo stuff...

  final LatLong eiffelTower = LatLong.fromDecimal(48.85805556, 2.29416667);
  final LatLong statueOfLiberty = LatLong.fromDecimal(40.68972222, 72.04444444);
  final LatLong eiffelTowerDuplicate =
      LatLong.fromDecimal(48.85805556, 2.29416667);

  print(eiffelTower
      .asJsonStringDecimal()); // prints {"lat":48.85805556,"long":2.29416667}

  print(eiffelTower
      .asGeoJson()); // prints {"type":"Point", "coordinates":[2.29416667,48.85805556]}

  print(GeoUtils.distanceInMeters(
      eiffelTower, statueOfLiberty)); // prints 5384207.973601257

  GeoUtils.sameLocation(eiffelTower, eiffelTowerDuplicate); // prints true

  final Latitude plazaMayorMaxLatitude = Latitude.fromDecimal(40.415780);
  final Latitude plazaMayorMinLatitude = Latitude.fromDecimal(40.415013);
  final Longitude plazaMayorMaxLongitude = Longitude.fromDecimal(-3.706646);
  final Longitude plazaMayorMinLongitude = Longitude.fromDecimal(-3.708113);
  final BoundingBox plazaMayor = BoundingBox.fromDecimal(
      plazaMayorMinLongitude.decimal,
      plazaMayorMaxLongitude.decimal,
      plazaMayorMinLatitude.decimal,
      plazaMayorMaxLatitude.decimal);

  print(plazaMayor
      .asGeoJson()); // prints {"type":"Polygon","coordinates":[[[-3.708113,40.415013],[-3.706646,40.415013],[-3.706646,40.41578],[-3.708113,40.41578],[-3.708113,40.415013]]]}

  // Graph stuff...

  final File luxembourg = File(
      'test/luxembourg.json'); // [{"id": 3895896119, "lat": 49.615311, "long": 6.1297125, "neighbours": [4321295305 ] }, {"id": 74998906, "lat": 49.6134879, "long": 6.1295215, "neighbours": [4083207920, 4083207905 ] },...

  luxembourg.readAsString().then((String contents) {
    final Tile tile = Tile()..withNodesFromJsonString(contents);
    final double targetTrackDistanceInMeters = 5000;
    tile.generateRandomTrack(targetTrackDistanceInMeters);
    final double trackLengthInMeters = tile.getRandomTrack().getCost();
    print("Track length in meters: " + trackLengthInMeters.toString());
    print(tile.getTrackAsGeoJson());
  });

  // Canvas stuff

  luxembourg.readAsString().then((String contents) {
    final Latitude luxembourgMaxLatitude = Latitude.fromDecimal(49.61515);
    final Latitude luxembourgMinLatitude = Latitude.fromDecimal(49.60804);
    final Longitude luxembourgMaxLongitude = Longitude.fromDecimal(6.13790);
    final Longitude luxembourgMinLongitude = Longitude.fromDecimal(6.12092);
    final BoundingBox luxembourg = BoundingBox.fromDecimal(
        luxembourgMinLongitude.decimal,
        luxembourgMaxLongitude.decimal,
        luxembourgMinLatitude.decimal,
        luxembourgMaxLatitude.decimal);
    print(luxembourg.asGeoJson());
    final Tile tile = Tile()
      ..withNodesFromJsonString(contents)
      ..withBoundingBox(luxembourg)
      ..withCanvas(4095, 6275);
    final double targetTrackDistanceInMeters = 1000;
    tile.generateRandomTrack(targetTrackDistanceInMeters);
    final double trackLengthInMeters = tile.getRandomTrack().getCost();
    print("Track length in meters: " + trackLengthInMeters.toString());
    print(tile.getRandomTrack().asGeoJson());
    print(tile.getTrackAsSvgPolyline());
  });
}
