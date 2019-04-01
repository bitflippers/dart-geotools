import 'node.dart';
import 'path.dart';
import 'next_node_candidates_rater.dart';
import '../geo/geo_utils.dart';

class CloserToTarget extends NextNodeCandidatesRater {
  final Node targetNode;

  CloserToTarget(final Node pTargetNode) : targetNode = pTargetNode {
    if (pTargetNode == null) {
      throw ArgumentError.value(pTargetNode, "pTargetNode", "cannot be null");
    }
  }

  @override
  void rateNodes(final Set<Node> pNextNodeCandidates,
      final Map<Node, double> pRatings, final Path pCurrentPath) {
    super.rateNodesArgumentCheck(pNextNodeCandidates, pRatings, pCurrentPath);
    for (Node nextNodeCandidate in pNextNodeCandidates) {
      final double distanceToTarget = GeoUtils.distanceInMeters(
          nextNodeCandidate.latLong, targetNode.latLong);
      final double currentRating = pRatings[nextNodeCandidate];
      pRatings[nextNodeCandidate] = currentRating - distanceToTarget;
    }
  }
}
