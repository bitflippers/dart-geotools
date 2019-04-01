import 'package:geotools/geotools.dart';
import 'dart:io';

main() {
  File('test/luxembourg.json').readAsString().then((String contents) {
    final Tile tile = Tile()..withNodesFromJsonString(contents);
    print("loaded: " + tile.nodes.length.toString() + " nodes");

    final RandomTrackFinder randomTrackFinder =
        RandomTrackFinder(10000, tile.nodes);

    print('Searching for random track...');

    final Track track = randomTrackFinder.randomTrack();

    print('Done !');

    print("Track length in meters: " + track.getCost().toString());

    final StringBuffer geoJson = StringBuffer();
    final List<Node> trackNodes = track.getNodes();
    geoJson.write('{"type": "LineString","coordinates": [');
    for (Node node in trackNodes) {
      geoJson.write('[' +
          node.latLong.long.decimal.toString() +
          ',' +
          node.latLong.lat.decimal.toString() +
          '],');
    }
    print(geoJson.toString().substring(0, geoJson.length - 1) + "]}");
  });
}
