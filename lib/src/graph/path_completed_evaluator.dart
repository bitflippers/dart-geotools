import 'path.dart';

abstract class PathCompletedEvaluator {
  bool isCompleted(final Path pPath);

  isCompletedArgumentCheck(final Path pPath) {
    if (pPath == null) {
      throw ArgumentError.value(pPath, "pPath", "cannot be null");
    }
  }
}
