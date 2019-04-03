import 'path.dart';
import 'next_node_candidates_rater.dart';
import 'node.dart';
import 'path_completed_evaluator.dart';
import 'edge_cost_calculator.dart';

class PathFinder {
  Map<int, Node> nodes;
  final List<NextNodeCandidatesRater> nodeRaters;
  final PathCompletedEvaluator pathCompletedEvaluator;
  final Path _path;
  final Node initialNode;
  final EdgeCostCalculator edgeCostCalculator;

  PathFinder(
      final Set<Node> pNodes,
      final List<NextNodeCandidatesRater> pNodeRaters,
      final PathCompletedEvaluator pPathCompletedEvaluator,
      final Node pInitialNode,
      final EdgeCostCalculator pEdgeCostCalculator)
      : nodeRaters = pNodeRaters,
        pathCompletedEvaluator = pPathCompletedEvaluator,
        _path = Path(),
        initialNode = pInitialNode,
        edgeCostCalculator = pEdgeCostCalculator {
    if (pNodes == null || pNodes.isEmpty) {
      throw ArgumentError.value(
          pNodes, "pNodes", "must contain at least one node");
    }
    if (pNodeRaters == null || pNodeRaters.isEmpty) {
      throw ArgumentError.value(pNodeRaters, "pNodeRaters",
          "must contain at least one next node rater");
    }
    if (pathCompletedEvaluator == null) {
      throw ArgumentError.value(
          pathCompletedEvaluator, "pathCompletedEvaluator", "cannot be null");
    }
    if (pInitialNode == null) {
      throw ArgumentError.value(pInitialNode, "pInitialNode", "cannot be null");
    }
    if (!pNodes.contains(pInitialNode)) {
      throw ArgumentError.value(
          pInitialNode, "pInitialNode", "inital node not in nodes");
    }
    if (pEdgeCostCalculator == null) {
      throw ArgumentError.value(
          pEdgeCostCalculator, "pEdgeCostCalculator", "cannot be null");
    }
    _setNodesMap(pNodes);
  }

  _setNodesMap(final Set<Node> pNodesSet) {
    nodes = Map<int, Node>();
    for (Node node in pNodesSet) {
      nodes[node.id] = node;
    }
  }

  Path path() {
    _path.initialNode(initialNode);
    Node currentNode = initialNode;
    bool pathCompleted = pathCompletedEvaluator.isCompleted(_path);
    do {
      final Set<Node> neighbors = _getNeighbors(currentNode.neighbours);
      final Map<Node, double> ratings = _getInitialRatings(neighbors);
      for (NextNodeCandidatesRater nextNodeCandidatesRater in nodeRaters) {
        nextNodeCandidatesRater.rateNodes(neighbors, ratings, _path);
      }
      final Node nextNode = _getNextNode(ratings);
      _path.addNodeToPath(
          nextNode, edgeCostCalculator.cost(currentNode, nextNode));
      currentNode = nextNode;
      pathCompleted = this.pathCompletedEvaluator.isCompleted(_path);
    } while (!pathCompleted);

    return _path;
  }

  Set<Node> _getNeighbors(final Set<int> pNeighborIds) {
    final Set<Node> result = Set<Node>();
    for (int neighborId in pNeighborIds) {
      result.add(nodes[neighborId]);
    }
    return result;
  }

  Map<Node, double> _getInitialRatings(final Set<Node> pNeighbors) {
    final Map<Node, double> result = Map<Node, double>();
    for (Node node in pNeighbors) {
      result[node] = 0;
    }
    return result;
  }

  Node _getNextNode(Map<Node, double> pRatings) {
    Node result;
    double highestRating;
    final Iterable<Node> nodes = pRatings.keys;
    for (Node node in nodes) {
      final double rating = pRatings[node];
      if (highestRating == null) {
        highestRating = rating;
        result = node;
      } else {
        if (rating > highestRating) {
          result = node;
          highestRating = rating;
        }
      }
    }
    return result;
  }
}
