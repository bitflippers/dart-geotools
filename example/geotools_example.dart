import 'package:geotools/geotools.dart';
import 'dart:convert';

main() {
  final Tile tile = Tile()
    ..withNodesFromJsonString(
        '[{"id":1,"latLong":{"lat":2.0,"long":3.0},"neighbours":"[2,3]"},{"id":2,"latLong":{"lat":3.0,"long":3.0}},{"id":3,"latLong":{"lat":1.0,"long":3.0}}]');

  print(jsonEncode(tile.nodes.toList()));
}
