import 'package:geotools/src/model/lat_long.dart';

class Node {
  final int id;
  final LatLong latLong;
  Set<int> neighbours;

  Node.fromDecimalLatLong(int pId, double pLat, double pLong)
      : id = pId,
        latLong = LatLong.fromDecimal(pLat, pLong) {
    if (pId == null || pId < 0) {
      throw ArgumentError.value(pId, "pId", "must be >= 0");
    }
  }

  Node.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        latLong = json['latLong'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'latLong': latLong,
      };

  bool operator ==(o) => o is Node && id == o.id;

  int get hashCode => id.hashCode;
}
