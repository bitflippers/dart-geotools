import 'package:geotools/geotools.dart';

main() {
  final Node node1 = Node.fromDecimalLatLong(1, -5, 0);
  final Node node2 = Node.fromDecimalLatLong(2, 5, 10);
  final Node node3 = Node.fromDecimalLatLong(3, 1, 3);
  node1.addNeighbor(node2.id);
  node1.addNeighbor(node3.id);
  final Set<Node> nodes = Set<Node>()..add(node1)..add(node2)..add(node3);
  final Tile tile = Tile()
    ..withNodes(nodes)
    ..withCanvas(768, 1024)
    ..withBoundingBox(0, 10, -5, 5);

  print(tile.nodesAsJsonString());
}
