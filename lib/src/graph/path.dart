import 'node.dart';

class Path {
  final List<Node> nodes;
  double totalCost;

  Path()
      : nodes = List<Node>(),
        totalCost = 0;

  addNodeToPath(final Node pNode, final double pCostIncrement) {
    if (pNode == null) {
      throw ArgumentError.value(pNode, "pNode", "cannot be null");
    }
    if (pCostIncrement == null) {
      throw ArgumentError.value(
          pCostIncrement, "pCostIncrement", "cannot be null");
    }
    nodes.add(pNode);
    totalCost += pCostIncrement;
  }
}
