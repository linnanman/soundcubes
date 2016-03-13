
class Location {
  public int x; 
  public int y;
  
  public Location(int x, int y) {
    this.x = x;
    this.y = y;
  }
}

// return location array
Location[] getLocations() {
  Location[] locations = {};
  
  for (int i = 0; i < numMarkers; ++i) {
    if (!nya.isExistMarker(i)) { continue; }
    PVector[] cornerPositions = nya.getMarkerVertex2D(i);
    PVector centerPosition = new PVector(0, 0);
    for (int j = 0; j < cornerPositions.length; ++j) {
      PVector cornerPosition = cornerPositions[j];
      centerPosition.add(cornerPosition);
    }
    centerPosition.mult(0.25);
    locations[locations.length-1] = new Location((int)centerPosition.x, (int)centerPosition.y);
  }
  return locations;
}