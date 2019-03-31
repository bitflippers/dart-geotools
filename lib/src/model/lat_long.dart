class LatLong {

  final double lat,  lon;

  LatLong.fromDecimal(double pLat, double pLon): this.lat = pLat, this.lon = pLon{

    if (pLat == null || pLat < -90 || pLat > 90){
      throw ArgumentError.value(pLat, "pLat", "must be >= -90 and <= 90");
    }

    if (pLon == null || pLon < -180 || pLon > 180){
      throw ArgumentError.value(pLon, "pLon", "must be >= -180 and <= 180");
    }

  }


  LatLong.fromJson(Map<String, dynamic> json)
      : this.lat = json['lat'],
        this.lon = json['lon'];

  Map<String, dynamic> toJson() =>
      {
        'lat': this.lat,
        'lon': this.lon,
      };


}
