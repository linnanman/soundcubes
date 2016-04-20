import processing.serial.*;
import jp.nyatla.nyar4psg.*;
import java.io.*;
import processing.video.*;
import java.util.*;
import processing.net.*;
import ddf.minim.*;

//Settings
boolean useSerial = false;
String cameraName = "Microsoft LifeCam VX-1000"; //Microsoft LifeCam Front, HD WebCam, FaceTime-HD-kamera (sisäinen), Microsoft LifeCam VX-1000
boolean tangibleInterface = true;
boolean developer = true;

int port = 5204;
int minimum_dia = 50; //min diameter for marker, to avoid false marker recognitions

Server server;    
Server testserver;  
Client testclient;
Minim minim;
AudioPlayer player;
Cubes cubes;
State state;
Timer timer;


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

// Camera image width and height
int camWidth = 640;
int camHeight = 480;
Serial serialPort;

void setup() {
  if (useSerial) {
    String serialPortName = Serial.list()[0];
    println("Using COM port: " + serialPortName);
    serialPort = new Serial(this, serialPortName, 9600);
  }
  else {
    serialPort = null;
  }
  
  
  
  cameraParameterFile = dataPath(cameraParameterFile);
  patternPath = dataPath(patternPath);
  size(1280, 720);
  nya = new MultiMarker(this, camWidth, camHeight, cameraParameterFile, NyAR4PsgConfig.CONFIG_DEFAULT);
  nya.setLostDelay(15);
  String[] patterns = loadPatternFilenames(patternPath);
  for (int i = 0; i < numMarkers; ++i) {
    println("Adding marker: " + patterns[i]);
    nya.addARMarker(patternPath + "/" + patterns[i], 80);
  }
  
  // Camera name is hardcoded, since we're most likely using the Surface Pro 3 front camera.
  cam = new Capture(this, camWidth, camHeight, cameraName, 30); //DroidCam Source 3, Microsoft LifeCam Front
  cam.start();
  
  server = new Server(this, port); 
  minim = new Minim(this);
  player = minim.loadFile("null.wav");
  cubes = new Cubes();
  this.timer = new Timer();
  
  doSetup();
  
}

void draw() {
  //logic
  if (cam.available() == true) {
    cam.read();
  
    nya.detect(cam);

    doLogic();
    serverAction();
  }
}