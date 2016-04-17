char pressedKey;
PImage notes;
PImage sound;
PFont fontLobster;
PFont fontKarla;

void doSetup() {
  
  this.state = new State("start");
  notes = loadImage("data/notes.png");
  sound = loadImage("data/sound.png");
  fontLobster = createFont("Lobster 1.4.otf", 60);
  fontKarla = createFont("Karla-Regular.ttf", 40);
  textAlign(CENTER, CENTER);
}

void doLogic() {
  
  background(53, 53, 53); // black background
  cubes.updateCubes(); 
  
  switch ( this.state.getState() ) {
   
  case "start":
   turnOnLed();
   image(notes, 450, 280);
   //textSize(30);
   fill(31, 181, 183);
   textFont(fontLobster);
   text("SoundCubes", 640, 150);
   textFont(fontKarla);
   text("Click and press space to start", 640, 550);
   if (pressedKey == ' ') { 
     this.state.setState("stage1"); 
   }
   break;
     
   case "stage1":
     image(cam, 100, 100);
     /*this.timer.setTimer("Stage 1 -text", 2000);
     if (this.timer.isGoing("Stage 1 -text")) {
       text("Stage 1: Find C", 200, 500);
     }*/
     fill(255);
     text("Stage 1: Find C", 1000, 120);
     //Play note C as the task begins and each time the button is clicked for help
     drawHelpButton();
     
     if (cubes.isCubeOnCamera(1)) { //if cube no 1 is on camera
        playSound("notes/c.wav", false, false); 
        text("Correct! Fantastic!", 200, 500);
        turnOnLed();     
        this.state.setStateTimer("stage2", 2000);
     }
       
      
     //drawCenterPoints(cubes.getCubesOnCamera());
     //drawOrder(cubes.getCubesOnCamera());
     break;
     
   case "stage2":
     image(cam, 0, 0);
     rect(0,0,100,100);
     
     this.timer.setTimer("Stage 2 -text", 2000);
     if (this.timer.isGoing("Stage 2 -text")) {
       text("Stage 2: Find D", 200, 500);
     }
     
      if (cubes.isCubeOnPhone(2)) { //if cube no 1 is on phone
        playSound("horn.wav", false, true);
        turnOnBuzzer();
      }
    
     if (cubes.cameraArrayEquals(new int[] {2, 3})) { //if exactly cubes 2 and 3 are on camera in this order
        playSound("duck.wav", false, true);
        turnOffLedAndBuzzer();
     }
      
     drawCenterPoints(cubes.getCubesOnCamera());
     drawOrder(cubes.getCubesOnCamera());
     break;
  }
    
  
}


void keyPressed() {
  //System.out.println(key);
  pressedKey = key;
}

void keyReleased() {
  pressedKey = '\0';
}


void turnOnLed() {
  if (useSerial)
    serialPort.write("2,0\r\n");
}

void turnOnBuzzer() {
  if (useSerial)
    serialPort.write("1,0\r\n");
}

void turnOffLedAndBuzzer() {
  if (useSerial)
    serialPort.write("0,0\r\n");
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