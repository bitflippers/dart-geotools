import 'dart:convert';
import 'package:geotools/src/model/lat_long.dart';
import 'package:geotools/src/model/node.dart';

String latLongAsJsonString(double pLat, double pLon) {
  return jsonEncode(LatLong.fromDecimal(pLat, pLon));
}

String nodeAsJsonString(int pId, double pLat, double pLon) {
  return jsonEncode(Node.fromDecimalLatLong(pId, pLat, pLon));
}
