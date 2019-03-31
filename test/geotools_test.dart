import 'package:geotools/geotools.dart';
import 'package:test/test.dart';
import 'dart:convert';

void main() {
  group('LatLong', () {
    test('argumentErrors', () {
      expect(() => LatLong.fromDecimal(-91, 0), throwsArgumentError);
      expect(() => LatLong.fromDecimal(91, 0), throwsArgumentError);
      expect(() => LatLong.fromDecimal(0, -181), throwsArgumentError);
      expect(() => LatLong.fromDecimal(0, 181), throwsArgumentError);
      expect(() => LatLong.fromDecimal(0, null), throwsArgumentError);
      expect(() => LatLong.fromDecimal(null, 0), throwsArgumentError);
    });
    test('fromDecimal', () {
      expect(LatLong.fromDecimal(1, 2).lat.decimal, equals(1));
      expect(LatLong.fromDecimal(1, 2).long.decimal, equals(2));
    });
    test('asJsonString', () {
      expect(LatLong.fromDecimal(1, 2).asJsonStringDecimal(),
          equals('{"lat":1.0,"long":2.0}'));
    });
  });

  group('Node', () {
    test('argumentErrors', () {
      expect(() => Node.fromDecimalLatLong(null, 0, 0), throwsArgumentError);
      expect(() => Node.fromDecimalLatLong(-1, 0, 0), throwsArgumentError);
      expect(() => Node.fromDecimalLatLong(0, null, 0), throwsArgumentError);
      expect(() => Node.fromDecimalLatLong(0, 0, null), throwsArgumentError);
      expect(() => Node.fromDecimalLatLong(0, -91, 0), throwsArgumentError);
      expect(() => Node.fromDecimalLatLong(0, 91, 0), throwsArgumentError);
      expect(() => Node.fromDecimalLatLong(0, 0, -181), throwsArgumentError);
      expect(() => Node.fromDecimalLatLong(0, 0, 181), throwsArgumentError);
    });
    test('fromDecimalLatLong', () {
      expect(Node.fromDecimalLatLong(1, 2, 3).id, equals(1));
      expect(Node.fromDecimalLatLong(1, 2, 3).latLong.lat.decimal, equals(2));
      expect(Node.fromDecimalLatLong(1, 2, 3).latLong.long.decimal, equals(3));
    });
    test('asJsonString', () {
      expect(Node.fromDecimalLatLong(1, 2, 3).asJsonString(),
          equals('{"id":1,"latLong":{"lat":2.0,"long":3.0}}'));
    });
    test('addNeighborToNode', () {
      final Node node = Node.fromDecimalLatLong(1, 2, 3);
      node.addNeighbor(2);
      expect(node.neighbours.length, equals(1));
      expect(node.neighbours.contains(2), isTrue);
      expect(() => node.addNeighbor(1), throwsArgumentError);
      node.addNeighbor(2);
      expect(node.neighbours.length, equals(1));
      expect(node.neighbours.contains(2), isTrue);
      node.addNeighbor(3);
      expect(node.neighbours.length, equals(2));
      expect(node.neighbours.contains(2), isTrue);
      expect(node.neighbours.contains(3), isTrue);
    });
  });

  group('Canvas', () {
    test('argumentErrors', () {
      expect(() => Canvas(null, 0), throwsArgumentError);
      expect(() => Canvas(0, null), throwsArgumentError);
      expect(() => Canvas(-1, 0), throwsArgumentError);
      expect(() => Canvas(0, -1), throwsArgumentError);
    });
    test('Canvas', () {
      expect(Canvas(1, 2).height, equals(1));
      expect(Canvas(1, 2).width, equals(2));
    });
  });

  group('BoundingBox', () {
    test('argumentErrors', () {
      expect(() => BoundingBox.fromDecimal(null, 0, 0, 0), throwsArgumentError);
      expect(() => BoundingBox.fromDecimal(0, null, 0, 0), throwsArgumentError);
      expect(() => BoundingBox.fromDecimal(0, 0, null, 0), throwsArgumentError);
      expect(() => BoundingBox.fromDecimal(0, 0, 0, null), throwsArgumentError);
      expect(() => BoundingBox.fromDecimal(-91, 0, 0, 0), throwsArgumentError);
      expect(() => BoundingBox.fromDecimal(91, 0, 0, 0), throwsArgumentError);
      expect(() => BoundingBox.fromDecimal(0, -91, 0, 0), throwsArgumentError);
      expect(() => BoundingBox.fromDecimal(0, 91, 0, 0), throwsArgumentError);
      expect(() => BoundingBox.fromDecimal(0, 0, -181, 0), throwsArgumentError);
      expect(() => BoundingBox.fromDecimal(0, 0, 181, 0), throwsArgumentError);
      expect(() => BoundingBox.fromDecimal(0, 0, 0, -181), throwsArgumentError);
      expect(() => BoundingBox.fromDecimal(0, 0, 0, 181), throwsArgumentError);
      expect(() => BoundingBox.fromDecimal(2, 1, 0, 180), throwsArgumentError);
      expect(() => BoundingBox.fromDecimal(1, 2, 2, 1), throwsArgumentError);
    });
    test('BoundingBox', () {
      expect(BoundingBox.fromDecimal(1, 2, 3, 4).minlong.decimal, equals(1));
      expect(BoundingBox.fromDecimal(1, 2, 3, 4).maxlong.decimal, equals(2));
      expect(BoundingBox.fromDecimal(1, 2, 3, 4).minlat.decimal, equals(3));
      expect(BoundingBox.fromDecimal(1, 2, 3, 4).maxlat.decimal, equals(4));
    });
  });

  group('Tile', () {
    test('argumentErrors', () {
      expect(() => Tile().withNodes(null), throwsArgumentError);
      expect(() => Tile().withNodes(Set<Node>()), throwsArgumentError);
      final Node nodeA1 = Node.fromDecimalLatLong(1, 2, 3);
      final Node nodeA2 = Node.fromDecimalLatLong(2, 2, 3);
      final Set<Node> nodesA = Set<Node>()..add(nodeA1)..add(nodeA2);
      expect(() => Tile().withNodes(nodesA), throwsArgumentError);
      final Node nodeB1 = Node.fromDecimalLatLong(1, -10, 3);
      final Set<Node> nodesB = Set<Node>()..add(nodeB1);
      expect(
          () => Tile()
            ..withNodes(nodesB)
            ..withCanvas(768, 1024)
            ..withBoundingBox(0, 10, -5, 5),
          throwsArgumentError);
      final Node nodeC1 = Node.fromDecimalLatLong(1, 6, 3);
      final Set<Node> nodesC = Set<Node>()..add(nodeC1);
      expect(
          () => Tile()
            ..withNodes(nodesC)
            ..withCanvas(768, 1024)
            ..withBoundingBox(0, 10, -5, 5),
          throwsArgumentError);
      final Node nodeD1 = Node.fromDecimalLatLong(1, 5, -1);
      final Set<Node> nodesD = Set<Node>()..add(nodeD1);
      expect(
          () => Tile()
            ..withNodes(nodesD)
            ..withCanvas(768, 1024)
            ..withBoundingBox(0, 10, -5, 5),
          throwsArgumentError);
      final Node nodeE1 = Node.fromDecimalLatLong(1, 5, 11);
      final Set<Node> nodesE = Set<Node>()..add(nodeE1);
      expect(
          () => Tile()
            ..withNodes(nodesE)
            ..withCanvas(768, 1024)
            ..withBoundingBox(0, 10, -5, 5),
          throwsArgumentError);
    });
    test('Tile', () {
      final Node node1 = Node.fromDecimalLatLong(1, -5, 0);
      final Node node2 = Node.fromDecimalLatLong(2, 5, 10);
      final Node node3 = Node.fromDecimalLatLong(3, 1, 3);
      final Set<Node> nodes = Set<Node>()..add(node1)..add(node2)..add(node3);
      final Tile tile = Tile()
        ..withNodes(nodes)
        ..withCanvas(768, 1024)
        ..withBoundingBox(0, 10, -5, 5);
      expect(tile.nodes.length, equals(3));
      expect(tile.nodes.contains(node1), isTrue);
      expect(tile.nodes.contains(node2), isTrue);
      expect(tile.nodes.contains(node3), isTrue);
      expect(tile.boundingBox.minlong.decimal, equals(0));
      expect(tile.boundingBox.maxlong.decimal, equals(10));
      expect(tile.boundingBox.minlat.decimal, equals(-5));
      expect(tile.boundingBox.maxlat.decimal, equals(5));
      final Tile tileFromJson = Tile()
        ..withNodesFromJsonString(jsonEncode(nodes.toList()));
      expect(jsonEncode(nodes.toList()),
          equals(jsonEncode(tileFromJson.nodes.toList())));
    });
  });
}
