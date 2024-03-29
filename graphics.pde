void drawCenterPoints(List<Cube> cubes) {
  //translate(100, 150);

  for (int i = 0; i < cubes.size(); ++i) {
    fill(31, 181, 183);
    ellipse((cubes.get(i).x+100), (cubes.get(i).y+150), 20, 20);
  }
}

void drawCornerPoints(List<Cube> cubes) {
  //translate(100, 150);

  for (int i = 0; i < cubes.size(); ++i) {
    fill(31, 181, 83);
    for (int k=0; k<4; k++) {
      ellipse(cubes.get(i).corners[k][0]+100, cubes.get(i).corners[k][1]+150, 20, 20);
      textSize(20);
      text(k, cubes.get(i).corners[k][0]+100, cubes.get(i).corners[k][1]+150+20);
    }
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
    if (!nya.isExistMarker(i)) { 
      continue;
    }
    PVector[] cornerPositions = nya.getMarkerVertex2D(i);
    PVector centerPosition = new PVector(0, 0);
    for (int j = 0; j < cornerPositions.length; ++j) {
      PVector cornerPosition = cornerPositions[j];
      centerPosition.add(cornerPosition);
      fill(0, 255, 0);
      ellipse(cornerPosition.x+100, cornerPosition.y+150, 15, 15);
    }
    centerPosition.mult(0.25);
    fill(255, 0, 0);
    ellipse(centerPosition.x+100, centerPosition.y+150, 20, 20);
  }
}


void drawArea(XYArea area) {
  pushMatrix();
  translate(100, 150);
  int Awidth = area.xMax-area.xMin;
  int Aheight = area.yMax-area.yMin;

  noFill();
  rect(area.xMin, area.yMin, Awidth, Aheight);
  popMatrix();
}

void drawAreas() {
  if (showAreaBoxes) {
    drawArea(this.cube1Area);
    drawArea(this.cube2Area);
    drawArea(this.cube3Area);
    drawArea(this.playCubeArea);
    drawArea(this.playTaskAgainArea);
    drawArea(this.difficultyLevelArea); 
  }
     
}
void drawLines() {
  
  if (developer) {
    for (int i=1; i<13; i++) {
      if (i % 2 == 0)
        stroke(200, 100, 100);
  
      line(50*i+100, 0+150, 50*i+100, 500+150);
      stroke(255);
    }
    for (int i=1; i<10; i++) {
      if (i % 2 == 0)
        stroke(200, 100, 100);
  
      line(0+100, 50*i+150, 650+100, 50*i+150);
      stroke(255);
    }
  }
}

void drawBackButton() {
  fill(31, 181, 183);
  ellipse(120, 70, 40, 40);
  image(arrow, 108, 63);
}