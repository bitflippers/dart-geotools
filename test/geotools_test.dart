import 'package:geotools/geotools.dart';
import 'package:test/test.dart';
import 'dart:convert';

void main() {
  group('LatLong', () {
    test('argumentErrors', () {
      // Out of bounds
      expect(() => LatLong.fromDecimal(-91, 0), throwsArgumentError);
      expect(() => LatLong.fromDecimal(91, 0), throwsArgumentError);
      expect(() => LatLong.fromDecimal(0, -181), throwsArgumentError);
      expect(() => LatLong.fromDecimal(0, 181), throwsArgumentError);
      // null
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
      // null
      expect(() => Node.fromDecimalLatLong(null, 0, 0), throwsArgumentError);
      expect(() => Node.fromDecimalLatLong(-1, 0, 0), throwsArgumentError);
      expect(() => Node.fromDecimalLatLong(0, null, 0), throwsArgumentError);
      expect(() => Node.fromDecimalLatLong(0, 0, null), throwsArgumentError);
      // out of bounds
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
          equals('{"id":1,"lat":2.0,"long":3.0}'));
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
      // null
      expect(() => Canvas(null, 0), throwsArgumentError);
      expect(() => Canvas(0, null), throwsArgumentError);
      // out of bounds
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
      // null
      expect(() => BoundingBox.fromDecimal(null, 0, 0, 0), throwsArgumentError);
      expect(() => BoundingBox.fromDecimal(0, null, 0, 0), throwsArgumentError);
      expect(() => BoundingBox.fromDecimal(0, 0, null, 0), throwsArgumentError);
      expect(() => BoundingBox.fromDecimal(0, 0, 0, null), throwsArgumentError);
      // out of bounds
      expect(() => BoundingBox.fromDecimal(-91, 0, 0, 0), throwsArgumentError);
      expect(() => BoundingBox.fromDecimal(91, 0, 0, 0), throwsArgumentError);
      expect(() => BoundingBox.fromDecimal(0, -91, 0, 0), throwsArgumentError);
      expect(() => BoundingBox.fromDecimal(0, 91, 0, 0), throwsArgumentError);
      expect(() => BoundingBox.fromDecimal(0, 0, -181, 0), throwsArgumentError);
      expect(() => BoundingBox.fromDecimal(0, 0, 181, 0), throwsArgumentError);
      expect(() => BoundingBox.fromDecimal(0, 0, 0, -181), throwsArgumentError);
      expect(() => BoundingBox.fromDecimal(0, 0, 0, 181), throwsArgumentError);
      // min,max errors
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
      // null
      expect(() => Tile().withNodes(null), throwsArgumentError);
      // empty
      expect(() => Tile().withNodes(Set<Node>()), throwsArgumentError);
      // duplicate location
      final Node nodeA1 = Node.fromDecimalLatLong(1, 2, 3);
      final Node nodeA2 = Node.fromDecimalLatLong(2, 2, 3);
      final Set<Node> nodesA = Set<Node>()..add(nodeA1)..add(nodeA2);
      expect(() => Tile().withNodes(nodesA), throwsArgumentError);
      // FIXME
//      // node out of bounds - lat too south
//      final Node nodeB1 = Node.fromDecimalLatLong(1, -10, 3);
//      final Set<Node> nodesB = Set<Node>()..add(nodeB1);
//      expect(
//          () => Tile()
//            ..withNodes(nodesB)
//            ..withCanvas(768, 1024)
//            ..withBoundingBox(0, 10, -5, 5),
//          throwsArgumentError);
//      // node out of bounds - lat too north
//      final Node nodeC1 = Node.fromDecimalLatLong(1, 6, 3);
//      final Set<Node> nodesC = Set<Node>()..add(nodeC1);
//      expect(
//          () => Tile()
//            ..withNodes(nodesC)
//            ..withCanvas(768, 1024)
//            ..withBoundingBox(0, 10, -5, 5),
//          throwsArgumentError);
//      // node out of bounds - long too east
//      final Node nodeD1 = Node.fromDecimalLatLong(1, 5, -1);
//      final Set<Node> nodesD = Set<Node>()..add(nodeD1);
//      expect(
//          () => Tile()
//            ..withNodes(nodesD)
//            ..withCanvas(768, 1024)
//            ..withBoundingBox(0, 10, -5, 5),
//          throwsArgumentError);
//      // node out of bounds - long too west
//      final Node nodeE1 = Node.fromDecimalLatLong(1, 5, 11);
//      final Set<Node> nodesE = Set<Node>()..add(nodeE1);
//      expect(
//          () => Tile()
//            ..withNodes(nodesE)
//            ..withCanvas(768, 1024)
//            ..withBoundingBox(0, 10, -5, 5),
//          throwsArgumentError);
//    });
//    test('Tile', () {
//      final Node node1 = Node.fromDecimalLatLong(1, -5, 0);
//      final Node node2 = Node.fromDecimalLatLong(2, 5, 10);
//      final Node node3 = Node.fromDecimalLatLong(3, 1, 3);
//      node1.addNeighbor(node2.id);
//      node1.addNeighbor(node3.id);
//      final Set<Node> nodes = Set<Node>()..add(node1)..add(node2)..add(node3);
//      final Tile tile = Tile()
//        ..withNodes(nodes)
//        ..withCanvas(768, 1024)
//        ..withBoundingBox(0, 10, -5, 5);
//      expect(tile.nodes.length, equals(3));
//      expect(tile.nodes.contains(node1), isTrue);
//      expect(tile.nodes.contains(node2), isTrue);
//      expect(tile.nodes.contains(node3), isTrue);
//      expect(tile.boundingBox.minlong.decimal, equals(0));
//      expect(tile.boundingBox.maxlong.decimal, equals(10));
//      expect(tile.boundingBox.minlat.decimal, equals(-5));
//      expect(tile.boundingBox.maxlat.decimal, equals(5));
      // FIXME
//      final Tile tileFromJson = Tile()
//        ..withNodesFromJsonString(jsonEncode(nodes.toList()));
//      expect(
//          tile.nodesAsJsonString(), equals(tileFromJson.nodesAsJsonString()));
    });
  });

  group('Path', () {
    test('argumentErrors', () {
      // null
      final Node node1 = Node.fromDecimalLatLong(1, -5, 0);
      expect(() => Path().addNodeToPath(node1, null), throwsArgumentError);
      expect(() => Path().addNodeToPath(null, 0), throwsArgumentError);
    });
    test('Path', () {
      final Path path = Path();
      expect(path.totalCost, equals(0));
      expect(path.nodes, isNotNull);
      expect(path.nodes, isEmpty);
      final Node node1 = Node.fromDecimalLatLong(1, -5, 0);
      path.addNodeToPath(node1, 3);
      expect(path.totalCost, equals(3));
      expect(path.nodes, isNotNull);
      expect(path.nodes, isNotEmpty);
      expect(path.nodes.length, equals(1));
      final Node node2 = Node.fromDecimalLatLong(2, 5, 10);
      path.addNodeToPath(node2, 5);
      expect(path.totalCost, equals(8));
      expect(path.nodes, isNotNull);
      expect(path.nodes, isNotEmpty);
      expect(path.nodes.length, equals(2));
      expect(path.nodes.first, equals(node1));
      expect(path.nodes.last, equals(node2));
    });
  });

  group('Track', () {
    test('argumentErrors', () {
      // null
      expect(() => Track(Path(), null), throwsArgumentError);
      expect(() => Track(null, Path()), throwsArgumentError);
      // First outbound != Last inbound
      final Node aOutboundNode1 = Node.fromDecimalLatLong(1, -5, 0);
      final Node aOutboundNode2 = Node.fromDecimalLatLong(2, -15, 0);
      final Path aOutboundPath = Path()
        ..addNodeToPath(aOutboundNode1, 0)
        ..addNodeToPath(aOutboundNode2, 0);
      final Node aInboundNode1 = Node.fromDecimalLatLong(2, -15, 0);
      final Node aInboundNode2 = Node.fromDecimalLatLong(3, -6, 0);
      final Path aInboundPath = Path()
        ..addNodeToPath(aInboundNode1, 0)
        ..addNodeToPath(aInboundNode2, 0);
      expect(() => Track(aOutboundPath, aInboundPath), throwsArgumentError);
      // Last outbound != First inbound
      final Node bOutboundNode1 = Node.fromDecimalLatLong(1, -5, 0);
      final Node bOutboundNode2 = Node.fromDecimalLatLong(2, -15, 0);
      final Path bOutboundPath = Path()
        ..addNodeToPath(bOutboundNode1, 0)
        ..addNodeToPath(bOutboundNode2, 0);
      final Node bInboundNode1 = Node.fromDecimalLatLong(3, -16, 0);
      final Node bInboundNode2 = Node.fromDecimalLatLong(1, -5, 0);
      final Path bInboundPath = Path()
        ..addNodeToPath(bInboundNode1, 0)
        ..addNodeToPath(bInboundNode2, 0);
      //expect(() => Track(bOutboundPath, bInboundPath), throwsArgumentError);
    });
    test('Track', () {
      final Node aOutboundNode1 = Node.fromDecimalLatLong(1, -5, 0);
      final Node aOutboundNode2 = Node.fromDecimalLatLong(2, -15, 0);
      final Path aOutboundPath = Path()
        ..addNodeToPath(aOutboundNode1, 12)
        ..addNodeToPath(aOutboundNode2, 5);
      final Node aInboundNode1 = Node.fromDecimalLatLong(2, -15, 0);
      final Node aInboundNode2 = Node.fromDecimalLatLong(1, -5, 0);
      final Path aInboundPath = Path()
        ..addNodeToPath(aInboundNode1, -3)
        ..addNodeToPath(aInboundNode2, 1);
      final Track track = Track(aOutboundPath, aInboundPath);
      expect(track.getNodes(), isNotNull);
      expect(track.getNodes().length, equals(4));
      expect(track.getCost(), equals(15));
      expect(track.getNodes().first, aOutboundNode1);
      expect(track.getNodes().last, aInboundNode2);
    });
  });

  group('PathFinder', () {
    test('argumentErrors', () {
      // null
      final Node node1 = Node.fromDecimalLatLong(1, -5, 0);
      final Node node2 = Node.fromDecimalLatLong(2, 5, 10);
      final Node node3 = Node.fromDecimalLatLong(3, 1, 3);
      node1.addNeighbor(node2.id);
      node1.addNeighbor(node3.id);
      final Set<Node> nodes = Set<Node>()..add(node1)..add(node2)..add(node3);
      expect(
          () => PathFinder(
              null,
              List<NextNodeCandidatesRater>()..add(LeastVisited()),
              null,
              null,
              null),
          throwsArgumentError);
      expect(() => PathFinder(null, null, TargetCostReached(0), null, null),
          throwsArgumentError);
      expect(
          () => PathFinder(null, null, null, node1, null), throwsArgumentError);
      // empty nodes
      expect(
          () => PathFinder(
              Set<Node>(),
              List<NextNodeCandidatesRater>()..add(LeastVisited()),
              TargetCostReached(0),
              node1,
              DistanceMetersCostCalculator()),
          throwsArgumentError);
      // empty node raters
      expect(
          () => PathFinder(nodes, List<NextNodeCandidatesRater>(),
              TargetCostReached(0), node1, DistanceMetersCostCalculator()),
          throwsArgumentError);
      // node not in nodes
      final Node node4 = Node.fromDecimalLatLong(4, 2, 3);
      expect(
          () => PathFinder(
              nodes,
              List<NextNodeCandidatesRater>()..add(LeastVisited()),
              TargetCostReached(0),
              node4,
              DistanceMetersCostCalculator()),
          throwsArgumentError);
    });
    test('PathFinder', () {
      final Node node1 = Node.fromDecimalLatLong(1, -5, 0);
      final Node node2 = Node.fromDecimalLatLong(2, 5, 10);
      final Node node3 = Node.fromDecimalLatLong(3, 1, 3);
      node1.addNeighbor(node2.id);
      node1.addNeighbor(node3.id);
      final Set<Node> nodes = Set<Node>()..add(node1)..add(node2)..add(node3);
      final List<NextNodeCandidatesRater> nodeRaters =
          List<NextNodeCandidatesRater>()..add(LeastVisited());
      final PathCompletedEvaluator pathCompletedEvaluator =
          TargetCostReached(0);
      final Node initialNode = node1;
      final PathFinder pathFinder = PathFinder(nodes, nodeRaters,
          pathCompletedEvaluator, initialNode, DistanceMetersCostCalculator());
      expect(pathFinder.nodes.length, equals(nodes.length));
      expect(pathFinder.nodes.containsKey(node1.id), isTrue);
      expect(pathFinder.nodes.containsKey(node2.id), isTrue);
      expect(pathFinder.nodes.containsKey(node3.id), isTrue);
    });
  });

  group('LeastVisited', () {
    test('argumentErrors', () {
      // null
      expect(
          () =>
              LeastVisited().rateNodes(Set<Node>(), Map<Node, double>(), null),
          throwsArgumentError);
      expect(() => LeastVisited().rateNodes(null, Map<Node, double>(), Path()),
          throwsArgumentError);
      expect(() => LeastVisited().rateNodes(Set<Node>(), null, Path()),
          throwsArgumentError);
    });
    test('LeastVisited', () {
      final Node nodeA = Node.fromDecimalLatLong(1, 5, 10);
      final Node nodeB = Node.fromDecimalLatLong(2, 1, 3);
      final Map<Node, double> pRatings = Map<Node, double>();
      pRatings[nodeA] = 0;
      pRatings[nodeB] = 0;
      final Set<Node> neighborNodes = Set<Node>();
      neighborNodes.add(nodeA);
      neighborNodes.add(nodeB);
      // no nodes visited
      Path path = Path();
      LeastVisited().rateNodes(neighborNodes, pRatings, path);
      expect(pRatings.length, equals(2));
      expect(pRatings.containsKey(nodeA), isTrue);
      expect(pRatings.containsKey(nodeB), isTrue);
      expect(pRatings[nodeA], equals(0));
      expect(pRatings[nodeB], equals(0));
      // A visited once, B never
      path.addNodeToPath(nodeA, 0);
      LeastVisited().rateNodes(neighborNodes, pRatings, path);
      expect(pRatings.length, equals(2));
      expect(pRatings.containsKey(nodeA), isTrue);
      expect(pRatings.containsKey(nodeB), isTrue);
      expect(pRatings[nodeA], equals(-1));
      expect(pRatings[nodeB], equals(0));
    });
  });

  group('TargetCostReached', () {
    test('argumentErrors', () {
      // null
      expect(() => TargetCostReached(null), throwsArgumentError);
      expect(() => TargetCostReached(0).isCompleted(null), throwsArgumentError);
    });
    test('TargetCostReached', () {
      final Node nodeA = Node.fromDecimalLatLong(1, 5, 10);
      final Node nodeB = Node.fromDecimalLatLong(2, 1, 3);
      final Node nodeC = Node.fromDecimalLatLong(3, 4, 3);
      final PathCompletedEvaluator pathCompletedEvaluator =
          TargetCostReached(7);
      Path path = Path();
      path.addNodeToPath(nodeA, 3);
      expect(pathCompletedEvaluator.isCompleted(path), isFalse);
      path.addNodeToPath(nodeB, 4);
      expect(pathCompletedEvaluator.isCompleted(path), isTrue);
      path.addNodeToPath(nodeC, 4);
      expect(pathCompletedEvaluator.isCompleted(path), isTrue);
    });
  });

  group('TargetNodeReached', () {
    test('argumentErrors', () {
      // null
      expect(() => TargetNodeReached(null), throwsArgumentError);
    });
    test('TargetNodeReached', () {
      final Node nodeA = Node.fromDecimalLatLong(1, 5, 10);
      final Node nodeB = Node.fromDecimalLatLong(2, 1, 3);
      final PathCompletedEvaluator pathCompletedEvaluator =
          TargetNodeReached(nodeB);
      Path path = Path();
      path.addNodeToPath(nodeA, 3);
      expect(pathCompletedEvaluator.isCompleted(path), isFalse);
      path.addNodeToPath(nodeB, 4);
      expect(pathCompletedEvaluator.isCompleted(path), isTrue);
    });
  });

  group('GeoUtils', () {
    test('argumentErrors', () {
      // null
      expect(() => GeoUtils.sameLocation(LatLong.fromDecimal(1, 2), null),
          throwsArgumentError);
      expect(() => GeoUtils.sameLocation(null, LatLong.fromDecimal(1, 2)),
          throwsArgumentError);
      expect(() => GeoUtils.distanceInMeters(LatLong.fromDecimal(1, 2), null),
          throwsArgumentError);
      expect(() => GeoUtils.distanceInMeters(null, LatLong.fromDecimal(1, 2)),
          throwsArgumentError);
    });
    test('distanceInMeters', () {
      LatLong a = LatLong.fromDecimal(49.630441, 6.275918);
      LatLong b = LatLong.fromDecimal(49.633776, 6.266391);
      expect(GeoUtils.distanceInMeters(a, b), equals(779.9369256011878));
      expect(GeoUtils.distanceInMeters(b, a), equals(779.9369256011878));
    });
    test('sameLocation', () {
      LatLong a = LatLong.fromDecimal(49.630441, 6.275918);
      LatLong b = LatLong.fromDecimal(49.633776, 6.266391);
      LatLong c = LatLong.fromDecimal(49.630441, 6.275918);
      expect(GeoUtils.sameLocation(a, b), isFalse);
      expect(GeoUtils.sameLocation(a, c), isTrue);
    });
  });

  group('CloserToTarget', () {
    test('argumentErrors', () {
      // null
      expect(
          () => CloserToTarget(Node.fromDecimalLatLong(0, 0, 0))
              .rateNodes(Set<Node>(), Map<Node, double>(), null),
          throwsArgumentError);
      expect(
          () => CloserToTarget(Node.fromDecimalLatLong(0, 0, 0))
              .rateNodes(null, Map<Node, double>(), Path()),
          throwsArgumentError);
      expect(
          () => CloserToTarget(Node.fromDecimalLatLong(0, 0, 0))
              .rateNodes(Set<Node>(), null, Path()),
          throwsArgumentError);
      expect(
          () => CloserToTarget(null)
              .rateNodes(Set<Node>(), Map<Node, double>(), Path()),
          throwsArgumentError);
    });
    test('CloserToTarget', () {
      final Node nodeTarget = Node.fromDecimalLatLong(1, 5, 10);
      final Node nodeA = Node.fromDecimalLatLong(2, 5, 11);
      final Node nodeB = Node.fromDecimalLatLong(3, 5, 15);
      final Map<Node, double> pRatings = Map<Node, double>();
      pRatings[nodeA] = 0;
      pRatings[nodeB] = 0;
      final Set<Node> neighborNodes = Set<Node>();
      neighborNodes.add(nodeA);
      neighborNodes.add(nodeB);
      CloserToTarget(nodeTarget).rateNodes(neighborNodes, pRatings, Path());
      expect(pRatings.length, equals(2));
      expect(pRatings.containsKey(nodeA), isTrue);
      expect(pRatings.containsKey(nodeB), isTrue);
      expect(pRatings[nodeA] > pRatings[nodeB], isTrue);
    });
  });

  // TODO: PathFinder.path() implement and test
  // TODO: DistanceMetersCostCalculator implement and test

// TODO: RandomTrackFinder: implement
// TODO: RandomTrackFinder: test
// TODO: PathFinder: implement timeout
// TODO: PathFinder: test timeout

// TODO: LatLong.asGeoJson
// TODO: BoundingBox.asGeoJson
}
