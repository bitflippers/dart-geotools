class Node {
  final int id;
  final double lat,  lon;
  final Set<int> neighbours;

  Node(int pId, double pLat, double pLon, Set<int> pNeighbours): id = pId, lat = pLat, lon = pLon, neighbours = pNeighbours{

    if (pId == null){
      throw ArgumentError.value(pId, "pId", "must be a bool or a String");
    }




    }

  bool operator ==(o) => o is Node && id == o.id;
  int get hashCode => id.hashCode;
}