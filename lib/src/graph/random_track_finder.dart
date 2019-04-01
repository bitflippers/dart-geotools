import 'node.dart';
import 'pathfinder.dart';
import 'next_node_candidates_rater.dart';
import 'least_visited.dart';
import 'path_completed_evaluator.dart';
import 'target_cost_reached.dart';
import 'closer_to_target.dart';
import 'target_node_reached.dart';
import 'path.dart';
import 'track.dart';
import 'distance_meters_cost_calculator.dart';
import 'dart:math';

class RandomTrackFinder {
  final double _trackLengthInMeters;
  final Set<Node> _nodes;

  PathFinder _outboundPathFinder;
  PathFinder _inboundPathFinder;

  Path _outboundPath;
  Path _inboundPath;

  RandomTrackFinder(final double pTrackLengthInMeters, final Set<Node> pNodes)
      : _trackLengthInMeters = pTrackLengthInMeters,
        _nodes = pNodes {
    if (pTrackLengthInMeters == null) {
      throw ArgumentError.value(
          pTrackLengthInMeters, "pTrackLengthInMeters", "cannot be null");
    }
    if (pNodes == null) {
      throw ArgumentError.value(pNodes, "pNodes", "cannot be null");
    }
  }

  Track randomTrack() {
    _setOutboundPathFinder();
    _outboundPath = _outboundPathFinder.path();
    _setInboundPathFinder(_outboundPath.nodes.last, _outboundPath.nodes.first);
    _inboundPath = _inboundPathFinder.path();
    return Track(_outboundPath, _inboundPath);
  }

  _setOutboundPathFinder() {
    final List<NextNodeCandidatesRater> nextNodeCandidatesRaters =
        List<NextNodeCandidatesRater>()..add(LeastVisited());
    final PathCompletedEvaluator pathCompletedEvaluator =
        TargetCostReached(_trackLengthInMeters);
    final Node initialNode = _getRandomNode(_nodes);
    _outboundPathFinder = PathFinder(_nodes, nextNodeCandidatesRaters,
        pathCompletedEvaluator, initialNode, DistanceMetersCostCalculator());
  }

  _setInboundPathFinder(final Node pInitialNode, final Node pTargetNode) {
    final List<NextNodeCandidatesRater> nextNodeCandidatesRaters =
        List<NextNodeCandidatesRater>()
          ..add(CloserToTarget(pTargetNode))
          ..add(LeastVisited());
    final PathCompletedEvaluator pathCompletedEvaluator =
        TargetNodeReached(pTargetNode);
    _inboundPathFinder = PathFinder(_nodes, nextNodeCandidatesRaters,
        pathCompletedEvaluator, pInitialNode, DistanceMetersCostCalculator());
  }

  static Node _getRandomNode(final Set<Node> pNodes) {
    final List<Node> nodes = pNodes.toList();
    final int randomIndex = Random().nextInt(nodes.length);
    return nodes[randomIndex];
  }
}
