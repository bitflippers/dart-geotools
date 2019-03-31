import 'bounding_box.dart';
import 'canvas.dart';
import 'node.dart';
import 'dart:convert';

class Tile {
  BoundingBox boundingBox;
  Canvas canvas;
  Set<Node> nodes;

  void withCanvas(int pHeight, int pWidth) {
    canvas = Canvas(pHeight, pWidth);
  }

  void withBoundingBox(
      double pMinlong, double pMaxlong, double pMinlat, double pMaxlat) {
    boundingBox = BoundingBox.fromDecimal(pMinlong, pMaxlong, pMinlat, pMaxlat);
    _checkNodesInBounds(nodes);
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
    _checkNodesInBounds(pNodes);
    this.nodes = pNodes;
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
          if (nodeUnderAnalysis.latLong.lat.decimal ==
              node.latLong.lat.decimal) {
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
}
