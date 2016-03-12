import jp.nyatla.nyar4psg.*;
import java.io.*;
import processing.video.*;

// front_camera_para.dat contains calibration data about Surface Pro 3 front camera.
// Despite calibration data being camera-specific, the same calibration data should
// more or less work with other webcams, since we're only interested in the 2D coordinates
// of the detected markers.
String cameraParameterFile = "front_camera_para.dat";
// patternPath contains data about the available tracking markers.
String patternPath = "ARToolKit_Patterns";
MultiMarker nya;
Capture cam;

// Number of markers to detect.
int numMarkers = 13;

void setup() {
  cameraParameterFile = dataPath(cameraParameterFile);
  patternPath = dataPath(patternPath);
  size(1280, 720);
  nya = new MultiMarker(this, 640, 480, cameraParameterFile, NyAR4PsgConfig.CONFIG_DEFAULT);
  nya.setLostDelay(1);
  String[] patterns = loadPatternFilenames(patternPath);
  for (int i = 0; i < numMarkers; ++i) {
    println("Adding marker: " + patterns[i]);
    nya.addARMarker(patternPath + "/" + patterns[i], 80);
  }
  
  // Camera name is hardcoded, since we're most likely using the Surface Pro 3 front camera.
  //cam = new Capture(this, 640, 480, "Microsoft LifeCam Front", 30);
  cam = new Capture(this, 640, 480, "Microsoft LifeCam HD-5000", 30);
  cam.start();
}

void draw() {
  background(0);
  if (cam.available() == true) {
    cam.read();
  }
  image(cam, 0, 0);
  nya.detect(cam);
  drawMarkers();
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