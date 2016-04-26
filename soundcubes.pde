import processing.serial.*;
import jp.nyatla.nyar4psg.*;
import java.io.*;
import processing.video.*;
import java.util.*;
import processing.net.*;
import ddf.minim.*;
import guru.ttslib.*;
import java.lang.reflect.Method;

//Settings
boolean useSerial = false;
boolean mirrorImage = false;
String cameraName = "Microsoft LifeCam VX-1000"; //Microsoft LifeCam Front, HD WebCam, FaceTime-HD-kamera (sisäinen), Microsoft LifeCam VX-1000, FaceTime HD Camera (Built-in)
boolean tangibleInterface = true;
int markerSideFactor = 6; //to avoid false markers
int minimum_dia = 60; //min diameter for marker, to avoid false marker recognitions
boolean limitToFive = true;

//developer features
boolean developer = false;
boolean printFoundMarkers = false;
boolean drawCubeCorners = false;

int port = 5204;
// Number of markers to detect.
int numMarkers = 13;

Server server;    
Server testserver;  
Client testclient;
Minim minim;
AudioPlayer player;
Cubes cubes;
State state;
Timer timer;
RunOnce runonce;
TTS tts;

// front_camera_para.dat contains calibration data about Surface Pro 3 front camera.
// Despite calibration data being camera-specific, the same calibration data should
// more or less work with other webcams, since we're only interested in the 2D coordinates
// of the detected markers.
String cameraParameterFile = "front_camera_para.dat";
// patternPath contains data about the available tracking markers.
String patternPath = "ARToolKit_Patterns";
MultiMarker nya;
Capture cam;




// Camera image width and height
int camWidth = 640;
int camHeight = 480;
Serial serialPort;

void setup() {
  if (useSerial) {
    String serialPortName = Serial.list()[0];
    println("Using COM port: " + serialPortName);
    serialPort = new Serial(this, serialPortName, 9600);
  } else {
    serialPort = null;
  }



  cameraParameterFile = dataPath(cameraParameterFile);
  patternPath = dataPath(patternPath);
  size(1280, 720);
  nya = new MultiMarker(this, camWidth, camHeight, cameraParameterFile, NyAR4PsgConfig.CONFIG_DEFAULT);
  nya.setLostDelay(15);
  String[] patterns = loadPatternFilenames(patternPath);
  
  if (!limitToFive) {
    for (int i = 0; i < numMarkers; ++i) {
      println("Adding marker: " + patterns[i]);
      nya.addARMarker(patternPath + "/" + patterns[i], 80);
    }
  }
  //5 only
  else {
    nya.addARMarker(patternPath + "/" + "4x4_01.patt", 80);
    nya.addARMarker(patternPath + "/" + "4x4_05.patt", 80);
    nya.addARMarker(patternPath + "/" + "4x4_06.patt", 80);
    nya.addARMarker(patternPath + "/" + "4x4_08.patt", 80);
    nya.addARMarker(patternPath + "/" + "4x4_10.patt", 80);
  }

  // Camera name is hardcoded, since we're most likely using the Surface Pro 3 front camera.
  cam = new Capture(this, camWidth, camHeight, cameraName, 30);
  cam.start();

  //server = new Server(this, port); 
  minim = new Minim(this);
  player = minim.loadFile("null.wav");
  cubes = new Cubes();
  tts = new TTS();
  this.timer = new Timer();
  this.runonce = new RunOnce();

  doSetup();
}

void draw() {
  //logic
  if (cam.available() == true) {
    cam.read();
    PImage processedImage = cam.copy();
    if (mirrorImage) {
      for (int x = 0; x < processedImage.width; ++x) {
        for (int y = 0; y < processedImage.height; ++y) {
          color originalColor = cam.get(cam.width - x, y);
          processedImage.set(x, y, originalColor);
        }
      }
    }

    try {
      nya.detect(processedImage);
    }
    catch (Exception e) {
    }
    doLogic(processedImage);
    //serverAction();
  }
}