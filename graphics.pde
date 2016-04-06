void drawCenterPoints(List<Location> locations) {
  for (int i = 0; i < locations.size(); ++i) {
    fill(255, 0, 0);
    ellipse(locations.get(i).x, locations.get(i).y, 20, 20);
  }
}

//draws noticed qr codes and order of them
void drawOrder(List<Location> locations) {
  
  //Order the list by x
  Collections.sort(locations, new Comparator<Location>() {
        public int compare(Location o1, Location o2) {
            return o2.x < o1.x ? 1 : -1;
        }
    });
 
  
  //Print the order as text
  String order = "";
  for (int i = 0; i < locations.size(); ++i) {
    order = order + (locations.get(i).number+1) + ", ";
  }
  fill(255);
  textSize(30);
  text(order, 200, 600);
  

}

// drawMarkers draws red circles on the center of detected markers,
// and green circles on the corners.
void drawMarkers() {
  for (int i = 0; i < numMarkers; ++i) {
    if (!nya.isExistMarker(i)) { continue; }
    PVector[] cornerPositions = nya.getMarkerVertex2D(i);
    PVector centerPosition = new PVector(0, 0);
    for (int j = 0; j < cornerPositions.length; ++j) {
      PVector cornerPosition = cornerPositions[j];
      centerPosition.add(cornerPosition);
      fill(0, 255, 0);
      ellipse(cornerPosition.x, cornerPosition.y, 15, 15);
    }
    centerPosition.mult(0.25);
    fill(255, 0, 0);
    ellipse(centerPosition.x, centerPosition.y, 20, 20);
  }
}