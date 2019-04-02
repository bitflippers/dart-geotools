import '../geo/bounding_box.dart';
import '../geo/geo_utils.dart';
import 'canvas.dart';
import '../graph/node.dart';
import '../graph/track.dart';
import '../graph/random_track_finder.dart';
import 'dart:convert';

class Tile {
  BoundingBox boundingBox;
  Canvas canvas;
  Set<Node> nodes;
  Track _track;
  double _ratioLat;
  double _ratioLon;

  void withCanvas(int pHeight, int pWidth) {
    canvas = Canvas(pHeight, pWidth);
  }

  void withBoundingBox(final BoundingBox pBoundingBox) {
    boundingBox = pBoundingBox;
    // FIXME
    //_checkNodesInBounds(nodes);
  }

  void withNodesFromJsonString(String pNodesJsonString) {
    if (pNodesJsonString == null || pNodesJsonString.isEmpty) {
      throw ArgumentError.value(
          pNodesJsonString, "pNodesJsonString", "cannot be empty or null");
    }
    final List<Node> deserializedNodes = List<Node>();
    List<dynamic> nodesAsDynamic = jsonDecode(pNodesJsonString);
    for (dynamic nodeAsDynamic in nodesAsDynamic) {
      deserializedNodes.add(Node.fromJson(nodeAsDynamic));
    }
    withNodes(deserializedNodes.toSet());
  }

  void withNodes(Set<Node> pNodes) {
    if (pNodes == null || pNodes.isEmpty) {
      throw ArgumentError.value(
          pNodes, "pNodes", "must contain at least one node");
    }
    _checkDuplicateLatLong(pNodes);
    // FIXME
    //_checkNodesInBounds(pNodes);
    nodes = pNodes;
  }

  void _checkNodesInBounds(Set<Node> pNodes) {
    if (boundingBox != null && nodes != null && nodes.isNotEmpty) {
      for (Node nodeUnderAnalysis in pNodes) {
        if (nodeUnderAnalysis.latLong.lat.decimal <
                boundingBox.minlat.decimal ||
            nodeUnderAnalysis.latLong.lat.decimal >
                boundingBox.maxlat.decimal ||
            nodeUnderAnalysis.latLong.long.decimal <
                boundingBox.minlong.decimal ||
            nodeUnderAnalysis.latLong.long.decimal >
                boundingBox.maxlong.decimal) {
          throw ArgumentError.value(
              pNodes,
              "pNodes",
              "node with id: " +
                  nodeUnderAnalysis.id.toString() +
                  " is out of bounds ! minlat: " +
                  boundingBox.minlat.decimal.toString() +
                  " maxlat: " +
                  boundingBox.maxlat.decimal.toString() +
                  " minlong: " +
                  boundingBox.minlong.decimal.toString() +
                  " maxlong: " +
                  boundingBox.maxlong.decimal.toString());
        }
      }
    }
  }

  void _checkDuplicateLatLong(Set<Node> pNodes) {
    for (Node nodeUnderAnalysis in pNodes) {
      for (Node node in pNodes) {
        if (nodeUnderAnalysis.id != node.id) {
          if (GeoUtils.sameLocation(nodeUnderAnalysis.latLong, node.latLong)) {
            throw ArgumentError.value(
                nodeUnderAnalysis,
                "nodeUnderAnalysis",
                "more than one node with lat: " +
                    nodeUnderAnalysis.latLong.long.decimal.toString() +
                    " long: " +
                    nodeUnderAnalysis.latLong.long.decimal.toString());
          }
        }
      }
    }
  }

  String nodesAsJsonString() {
    return jsonEncode(nodes.toList());
  }

  generateRandomTrack(final double pTargetTrackDistanceInMeters) {
    _track =
        RandomTrackFinder(pTargetTrackDistanceInMeters, nodes).randomTrack();
  }

  Track getRandomTrack() {
    if (_track == null) {
      throw ArgumentError.value(
          _track, "_track", "track is null ! call generateRandomTrack first !");
    }
    return _track;
  }

  String getTrackAsGeoJson() {
    if (_track == null) {
      throw ArgumentError.value(
          _track, "_track", "track is null ! call generateRandomTrack first !");
    }
    return _track.asGeoJson();
  }

  String getTrackAsSvgPolyline() {
    if (_track == null) {
      throw ArgumentError.value(
          _track, "_track", "track is null ! call generateRandomTrack first !");
    }

    _ratioLat = canvas.height /
        (boundingBox.maxlat.decimal - boundingBox.minlat.decimal);
    _ratioLon = canvas.width /
        (boundingBox.maxlong.decimal - boundingBox.minlong.decimal);

    final StringBuffer stringBuffer = StringBuffer();
    stringBuffer.write('<polyline points="');
    for (Node node in _track.getNodes()) {
      final CanvasCoordinate canvasCoordinate = _getCanvasCoordinate(node);
      stringBuffer.write(canvasCoordinate.x.toString() +
          "," +
          canvasCoordinate.y.toString() +
          " ");
    }
    stringBuffer.write('" style="fill:none;stroke:blue;stroke-width:3" />');
    return stringBuffer.toString();
  }

  CanvasCoordinate _getCanvasCoordinate(final Node pNode) {
    final double lat = pNode.latLong.lat.decimal;
    final double lon = pNode.latLong.long.decimal;

    final double x = (lon - boundingBox.minlong.decimal) * _ratioLon;
    final double y =
        canvas.height - ((lat - boundingBox.minlat.decimal) * _ratioLat);

    return CanvasCoordinate(x, y);
  }
}
