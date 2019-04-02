import 'dart:convert';
import 'dart:math';

class LatLong {
  final Latitude lat;
  final Longitude long;

  LatLong.fromDecimal(double pLat, double pLong)
      : lat = Latitude.fromDecimal(pLat),
        long = Longitude.fromDecimal(pLong);

  LatLong.fromJson(Map<String, dynamic> json)
      : lat = Latitude.fromDecimal(json['lat']),
        long = Longitude.fromDecimal(json['long']);

  Map<String, dynamic> toJson() => {'lat': lat.decimal, 'long': long.decimal};

  String asJsonStringDecimal() {
    return jsonEncode(this);
  }

  String asGeoJson() {
    return '{"type":"Point", "coordinates":[' +
        long.decimal.toString() +
        ',' +
        lat.decimal.toString() +
        ']}';
  }
}

class Latitude {
  final double decimal;

  Latitude.fromDecimal(double pValue) : decimal = pValue {
    if (pValue == null || pValue < -90 || pValue > 90) {
      throw ArgumentError.value(pValue, "pValue", "must be >= -90 and <= 90");
    }
  }

  double get radians {
    return decimal / 180 * pi;
  }
}

class Longitude {
  final double decimal;

  Longitude.fromDecimal(double pValue) : decimal = pValue {
    if (pValue == null || pValue < -180 || pValue > 180) {
      throw ArgumentError.value(pValue, "pValue", "must be >= -180 and <= 180");
    }
  }

  double get radians {
    return decimal / 180 * pi;
  }
}
