import 'lat_long.dart';

class BoundingBox {
  final Longitude minlong, maxlong;
  final Latitude minlat, maxlat;

  BoundingBox.fromDecimal(
      double pMinlong, double pMaxlong, double pMinlat, double pMaxlat)
      : minlong = Longitude.fromDecimal(pMinlong),
        maxlong = Longitude.fromDecimal(pMaxlong),
        minlat = Latitude.fromDecimal(pMinlat),
        maxlat = Latitude.fromDecimal(pMaxlat) {
    if (pMinlong >= pMaxlong) {
      throw ArgumentError.value(
          minlong, "pMinlong", "pMinlong must be < pMaxlong");
    }
    if (pMinlat >= pMaxlat) {
      throw ArgumentError.value(
          minlong, "pMinlat", "pMinlat must be < pMaxlat");
    }
  }

  String asGeoJson() {
    return '{"type":"Polygon","coordinates":[[[' +
        minlong.decimal.toString() +
        ',' +
        minlat.decimal.toString() +
        '],[' +
        maxlong.decimal.toString() +
        ',' +
        minlat.decimal.toString() +
        '],[' +
        maxlong.decimal.toString() +
        ',' +
        maxlat.decimal.toString() +
        '],[' +
        minlong.decimal.toString() +
        ',' +
        maxlat.decimal.toString() +
        '],[' +
        minlong.decimal.toString() +
        ',' +
        minlat.decimal.toString() +
        ']]]}';
  }
}
