import 'node.dart';

abstract class EdgeCostCalculator {
  double cost(final Node pSource, final Node pDestination);

  costArgumentCheck(final Node pSource, final Node pDestination) {
    if (pSource == null) {
      throw ArgumentError.value(pSource, "pSource", "cannot be null");
    }
    if (pDestination == null) {
      throw ArgumentError.value(pDestination, "pDestination", "cannot be null");
    }
  }
}
