import 'path.dart';
import 'node.dart';
import '../geo/geo_utils.dart';

class Track {
  final Path outbound;
  final Path inbound;

  Track(Path pOutbound, Path pInbound)
      : outbound = pOutbound,
        inbound = pInbound {
    if (pOutbound == null || pOutbound.nodes.isEmpty) {
      throw ArgumentError.value(
          pOutbound, "pOutbound", "cannot be null or empty");
    }
    if (pInbound == null || pInbound.nodes.isEmpty) {
      throw ArgumentError.value(
          pOutbound, "pInbound", "cannot be null or empty");
    }

    final Node firstOutboundNode = pOutbound.nodes.first;
    final Node lastOutboundNode = pOutbound.nodes.last;
    final Node firstInboundNode = pInbound.nodes.first;
    final Node lastInboundNode = pInbound.nodes.last;

    if (!GeoUtils.sameLocation(
        firstOutboundNode.latLong, lastInboundNode.latLong)) {
      throw ArgumentError.value(pOutbound, "pOutbound",
          "first outbound node is not the same location as last inbound node");
    }

    // FIXME
//    if (!GeoUtils.sameLocation(
//        lastOutboundNode.latLong, firstInboundNode.latLong)) {
//      throw ArgumentError.value(pOutbound, "pOutbound",
//          "last outbound node is not the same location as first inbound node");
//    }
  }

  double getCost() {
    return outbound.totalCost + inbound.totalCost;
  }

  List<Node> getNodes() {
    return List<Node>()..addAll(outbound.nodes)..addAll(inbound.nodes);
  }

  String asGeoJson() {
    final StringBuffer geoJson = StringBuffer();
    geoJson.write('{"type": "LineString","coordinates": [');
    for (Node node in getNodes()) {
      geoJson.write('[' +
          node.latLong.long.decimal.toString() +
          ',' +
          node.latLong.lat.decimal.toString() +
          '],');
    }
    return geoJson.toString().substring(0, geoJson.length - 1) + "]}";
  }
}
