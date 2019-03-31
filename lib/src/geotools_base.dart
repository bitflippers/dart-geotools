
import 'dart:convert';
import 'package:geotools/src/model/lat_long.dart';

String latLongAsJson(double pLat, double pLon){
  return jsonEncode(LatLong.fromDecimal(pLat,pLon));
}