import 'node.dart';
import 'path.dart';
import 'next_node_candidates_rater.dart';

class LeastVisited extends NextNodeCandidatesRater {
  @override
  void rateNodes(final Set<Node> pNextNodeCandidates,
      final Map<Node, double> pRatings, final Path pCurrentPath) {
    super.rateNodesArgumentCheck(pNextNodeCandidates, pRatings, pCurrentPath);
    for (Node nextNodeCandidate in pNextNodeCandidates) {
      final int occurrences =
          _getOccurrences(nextNodeCandidate.id, pCurrentPath.nodes);
      final double currentRating = pRatings[nextNodeCandidate];
      pRatings[nextNodeCandidate] = currentRating - occurrences;
    }
  }

  int _getOccurrences(final int pNodeId, final List<Node> pNodes) {
    int result = 0;
    for (Node node in pNodes) {
      if (node.id == pNodeId) {
        result++;
      }
    }
    return result;
  }
}
