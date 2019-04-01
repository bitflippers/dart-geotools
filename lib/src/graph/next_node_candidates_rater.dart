import 'node.dart';
import 'path.dart';

abstract class NextNodeCandidatesRater {
  void rateNodes(final Set<Node> pNextNodeCandidates,
      final Map<Node, double> pRatings, final Path pCurrentPath);

  rateNodesArgumentCheck(final Set<Node> pNextNodeCandidates,
      final Map<Node, double> pRatings, final Path pCurrentPath) {
    if (pNextNodeCandidates == null) {
      throw ArgumentError.value(
          pNextNodeCandidates, "pNextNodeCandidates", "cannot be null");
    }
    if (pRatings == null) {
      throw ArgumentError.value(pRatings, "pRatings", "cannot be null");
    }
    if (pCurrentPath == null) {
      throw ArgumentError.value(pCurrentPath, "pCurrentPath", "cannot be null");
    }
  }
}
