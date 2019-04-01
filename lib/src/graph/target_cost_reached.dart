import 'path.dart';
import 'path_completed_evaluator.dart';

class TargetCostReached extends PathCompletedEvaluator {
  final double targetCost;

  TargetCostReached(final double pTargetCost) : targetCost = pTargetCost {
    if (pTargetCost == null) {
      throw ArgumentError.value(pTargetCost, "pTargetCost", "cannot be null");
    }
  }

  @override
  bool isCompleted(final Path pPath) {
    super.isCompletedArgumentCheck(pPath);
    return pPath.totalCost >= targetCost;
  }
}
