void drawCenterPoints(List<Cube> cubes) {
  translate(100, 150);
  
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


void drawArea(XYArea area) {
  int Awidth = area.xMax-area.xMin;
  int Aheight = area.yMax-area.yMin;
  
  noFill();
  rect(area.xMin, area.yMin, Awidth, Aheight);
}

void drawLines() {
  for (int i=1;i<13;i++) {
    if (i %2 == 0)
      stroke(200,100,100);
    line(50*i,0, 50*i, 500);
    stroke(255);
  }
  for (int i=1;i<10;i++) {
    if (i %2 == 0)
      stroke(200,100,100);
    line(0,50*i, 650, 50*i);
    stroke(255);
  }
}

void drawBackButton() {
  fill(31, 181, 183);
  ellipse(120, 70, 40, 40);
  image(arrow, 108, 63);
}