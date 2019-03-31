import 'lat_long.dart';
import 'dart:convert';

class Node {
  final int id;
  final LatLong latLong;
  final Set<int> neighbours;

  Node.fromDecimalLatLong(int pId, double pLat, double pLong)
      : id = pId,
        latLong = LatLong.fromDecimal(pLat, pLong),
        neighbours = Set() {
    if (pId == null || pId < 0) {
      throw ArgumentError.value(pId, "pId", "must be >= 0");
    }
  }

  Node.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        latLong = LatLong.fromDecimal(json['lat'], json['long']),
        neighbours = _decodeNeighbours(json);

  Map<String, dynamic> toJson() {
    if (neighbours.isEmpty) {
      return {
        'id': id,
        'lat': latLong.lat.decimal,
        'long': latLong.long.decimal
      };
    } else {
      return {
        'id': id,
        'lat': latLong.lat.decimal,
        'long': latLong.long.decimal,
        'neighbours': jsonEncode(this.neighbours.toList()),
      };
    }
  }

  bool operator ==(o) => o is Node && id == o.id;

  int get hashCode => id.hashCode;

  addNeighbor(final int pNodeToAdd) {
    if (pNodeToAdd == null) {
      throw ArgumentError.value(pNodeToAdd, "pNodeToAdd", "cannot be null");
    }

    if (pNodeToAdd == id) {
      throw ArgumentError.value(
          pNodeToAdd, "pNodeToAdd", "cannot add node as neighbor to itself");
    }

    this.neighbours.add(pNodeToAdd);
  }

  String asJsonString() {
    return jsonEncode(this);
  }

  static Set<int> _decodeNeighbours(Map<String, dynamic> json) {
    final Set<int> result = Set<int>();
    final String source = json['neighbours'];
    if (source != null) {
      final Set<dynamic> decodeResult = jsonDecode(source).toSet();
      for (dynamic d in decodeResult) {
        result.add(d);
      }
    }
    return result;
  }
}
