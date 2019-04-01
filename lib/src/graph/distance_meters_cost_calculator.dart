import 'node.dart';
import 'edge_cost_calculator.dart';
import '../geo/geo_utils.dart';

class DistanceMetersCostCalculator extends EdgeCostCalculator {
  @override
  double cost(final Node pSource, final Node pDestination) {
    super.costArgumentCheck(pSource, pDestination);
    return GeoUtils.distanceInMeters(pSource.latLong, pDestination.latLong);
  }
}
