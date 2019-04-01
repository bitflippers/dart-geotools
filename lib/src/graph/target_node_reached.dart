import 'path.dart';
import 'node.dart';
import 'path_completed_evaluator.dart';

class TargetNodeReached extends PathCompletedEvaluator {
  final Node targetNode;

  TargetNodeReached(final Node pTargetNode) : targetNode = pTargetNode {
    if (pTargetNode == null) {
      throw ArgumentError.value(pTargetNode, "pTargetNode", "cannot be null");
    }
  }

  @override
  bool isCompleted(final Path pPath) {
    super.isCompletedArgumentCheck(pPath);
    if (pPath.nodes.isNotEmpty) {
      return pPath.nodes.last == targetNode;
    } else {
      return false;
    }
  }
}
