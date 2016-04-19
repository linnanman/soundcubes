void drawCenterPoints(List<Cube> cubes) {
  for (int i = 0; i < cubes.size(); ++i) {
    fill(31, 181, 183);
    ellipse(cubes.get(i).x, cubes.get(i).y, 20, 20);
  }
}

//draws noticed qr codes and order of them
void drawOrder(List<Cube> cubes) {
 
  //Print the order as text
  String order = "";
  for (int i = 0; i < cubes.size(); ++i) {
    order = order + (cubes.get(i).number) + ", ";
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

void drawSoundButton() {
  fill(31, 181, 183);
  ellipse(1000, 350, 60, 60);
  image(sound, 980, 335);
}