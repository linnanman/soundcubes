class Location {
  public int x; 
  public int y;
  public int number;
  
  public Location(int x, int y, int number) {
    this.x = x;
    this.y = y;
    this.number = number;
  }
}

// return location list
List<Location> getLocations() {
  List<Location> locations = new ArrayList<Location>();
  
  for (int i = 0; i < numMarkers; ++i) {
    if (!nya.isExistMarker(i)) { continue; }
    PVector[] cornerPositions = nya.getMarkerVertex2D(i);
    PVector centerPosition = new PVector(0, 0);
    for (int j = 0; j < cornerPositions.length; ++j) {
      PVector cornerPosition = cornerPositions[j];
      centerPosition.add(cornerPosition);
    }
    centerPosition.mult(0.25);
    locations.add(new Location((int)centerPosition.x, (int)centerPosition.y, i));
  }
  return locations;
}


void doLogic(List<Location> locations, Serial serialPort) {
  for (int i = 0; i < locations.size(); ++i) {
    Location lokaatio = locations.get(i);
    
    System.out.println(lokaatio.number);
    
    //cube found
    if (lokaatio.number == 1) {
      playSound("horn.wav", false);
    }
  }
}

// This function loads .patt filenames into a list of Strings based on a full path to a directory (relies on java.io)
String[] loadPatternFilenames(String path) {
  File folder = new File(path);
  FilenameFilter pattFilter = new FilenameFilter() {
    public boolean accept(File dir, String name) {
      return name.toLowerCase().endsWith(".patt");
    }
  };
  return folder.list(pattFilter);
}