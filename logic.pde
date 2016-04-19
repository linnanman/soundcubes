char pressedKey;
PImage sound;
PFont fontLobster;
PFont fontLobster_smaller;
PFont fontKarla;

void doSetup() {
  
  this.state = new State("start");
  sound = loadImage("data/sound.png");
  fontLobster = createFont("Lobster 1.4.otf", 80);
  fontLobster_smaller = createFont("Lobster 1.4.otf", 35);
  fontKarla = createFont("Karla-Regular.ttf", 35);
  textAlign(CENTER, CENTER);
}

void doLogic() {
  
  background(53, 53, 53); // black background
  cubes.updateCubes(); 
  
  switch ( this.state.getState() ) {
   
  case "start":
   turnOnLed();
   
   // Logo
   fill(255);
   textFont(fontLobster);
   text("SoundCubes", 640, 150);
   
   // Mode selection
   textFont(fontKarla);
   ModeButton learning = new ModeButton(315, 250, "Learning Mode");
   learning.drawButton();
   ModeButton easy = new ModeButton(655, 250, "Easy Mode");
   easy.drawButton();
   ModeButton normal = new ModeButton(315, 450, "Normal Mode");
   normal.drawButton();
   ModeButton advanced = new ModeButton(655, 450, "Advanced Mode");
   advanced.drawButton();
   if (mousePressed) {
     if (mouseX > learning.x && mouseX < learning.x+learning.width && mouseY > learning.y && mouseY < learning.y+learning.height) {
       this.state.setState("stage1");
     }
     if (mouseX > easy.x && mouseX < easy.x+easy.width && mouseY > easy.y && mouseY < easy.y+easy.height) {
       this.state.setState("stage2");
     }
   }
   break;
     
   case "stage1":
     image(cam, 100, 150);
     fill(255);
     textFont(fontLobster_smaller);
     text("Learning Mode", 200, 70);
     textFont(fontKarla);
     text("Find C", 1000, 170);
     //Play note C as the task begins and each time the button is clicked for help TODO
     drawSoundButton();
     
     if (cubes.isCubeOnCamera(1)) { //if cube no 1 is on camera
        playSound("notes/c.wav", false, false); 
        text("Correct! Fantastic!", 200, 500);
        turnOnLed();     
        //Pick new random note
        //this.state.setStateTimer("stage2", 2000);
     }
       
      
     drawCenterPoints(cubes.getCubesOnCamera());
     drawOrder(cubes.getCubesOnCamera());
     break;
     
   case "stage2":
     image(cam, 100, 100);
     fill(255);
     
     /*this.timer.setTimer("Stage 2 -text", 2000);
     if (this.timer.isGoing("Stage 2 -text")) {
       text("Stage 2: Find D", 200, 500);
     }*/
     
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