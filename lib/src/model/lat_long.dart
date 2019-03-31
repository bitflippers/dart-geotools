class LatLong {
  final double lat, long;

  LatLong.fromDecimal(double pLat, double pLong)
      : lat = pLat,
        long = pLong {
    if (pLat == null || pLat < -90 || pLat > 90) {
      throw ArgumentError.value(pLat, "pLat", "must be >= -90 and <= 90");
    }
    if (pLong == null || pLong < -180 || pLong > 180) {
      throw ArgumentError.value(pLong, "pLong", "must be >= -180 and <= 180");
    }
  }

  LatLong.fromJson(Map<String, dynamic> json)
      : lat = json['lat'],
        long = json['long'];

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'long': long,
      };
}
