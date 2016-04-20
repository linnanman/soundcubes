char pressedKey;
PImage sound;
PFont fontLobster;
PFont fontLobster_smaller;
PFont fontKarla;

XYArea cube1Area;
XYArea cube2Area;
XYArea cube3Area;
XYArea playCubeArea;
XYArea playTaskAgainArea;
XYArea difficultyLevelArea;

Notes notes;
Note randomNote;

void doSetup() {
  
  this.state = new State("start");
  sound = loadImage("data/sound.png");
  fontLobster = createFont("Lobster 1.4.otf", 80);
  fontLobster_smaller = createFont("Lobster 1.4.otf", 35);
  fontKarla = createFont("Karla-Regular.ttf", 35);
  textAlign(CENTER, CENTER);
  
  int xdivider = 200;
  int ydivider = 200;
  this.cube3Area = new XYArea(0,xdivider,0,ydivider);
  this.cube2Area = new XYArea(xdivider+1,xdivider+xdivider,0,ydivider);
  this.cube1Area = new XYArea(xdivider+xdivider+1,1000,0,ydivider);
  this.difficultyLevelArea = new XYArea(0, xdivider, ydivider+1, 1000);
  this.playTaskAgainArea = new XYArea(xdivider+1,xdivider+xdivider,ydivider+1,1000);
  this.playCubeArea =  new XYArea(xdivider+xdivider+1,1000,ydivider+1,1000);

  notes = new Notes(this.cubes);
  randomNote = notes.randomNote();

  
}

void doLogic() {
  
  background(53, 53, 53); // black background
  cubes.updateCubes(); 
  
  //tangible user interface stuff:
  if (tangibleInterface) {
    //play a single cube
    Cube cubeToPlay = cubes.isAnyCubeOnCamera(this.playCubeArea);
    if (cubeToPlay != null) {
      playSound("notes/c.wav", false, true); 
    }
    
    //play task again
    Cube taskToPlay = cubes.isAnyCubeOnCamera(this.playTaskAgainArea);
    if (taskToPlay != null) {
      playSound(randomNote.soundfile, false, true); 
    }
    
    //play task again
    Cube difficultyCube = cubes.isAnyCubeOnCamera(this.difficultyLevelArea);
    if (difficultyCube != null) {
      //change difficult level
      if (difficultyCube.equals(cubes.getCube(1)))
        this.state.setState("learning");
      if (difficultyCube.equals(cubes.getCube(2))) //todo
        this.state.setState("easy"); 
      if (difficultyCube.equals(cubes.getCube(3))) //todo
        this.state.setState("normal");
      if (difficultyCube.equals(cubes.getCube(4))) //todo
        this.state.setState("hard");
    }
  }
  
  
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
       this.state.setState("learning");
     }
     if (mouseX > easy.x && mouseX < easy.x+easy.width && mouseY > easy.y && mouseY < easy.y+easy.height) {
       this.state.setState("easy");
     }
     if (mouseX > normal.x && mouseX < normal.x+normal.width && mouseY > normal.y && mouseY < normal.y+normal.height) {
       this.state.setState("normal");
     }
     if (mouseX > advanced.x && mouseX < advanced.x+advanced.width && mouseY > advanced.y && mouseY < advanced.y+advanced.height) {
       this.state.setState("hard");
     }
   }
   break;
     
   case "learning":
     image(cam, 100, 150);
     fill(255);
     textFont(fontLobster_smaller);
     text("Learning Mode", 200, 70);
     textFont(fontKarla);
     text("Find " + randomNote.name, 1000, 170);
     //Play note C as the task begins and each time the button is clicked for help TODO
     image(randomNote.image, 900, 300);
     drawSoundButton();
     
     if (cubes.isCubeOnCamera(randomNote.cube.number, this.cube1Area) ||
       cubes.isCubeOnCamera(randomNote.cube.number, this.cube2Area) ||
       cubes.isCubeOnCamera(randomNote.cube.number, this.cube3Area)
       ) { //if cube is on camera
        playSound(randomNote.soundfile, false, true); 
        text("Correct! Fantastic!", 200, 500);
        turnOnLed();     
        //Pick new random note
        this.timer.setTimer("learning-correct", 2000);
        if (this.timer.isOver("learning-correct")) {
          //System.out.println("over");
          Note newRandomNote = notes.randomNote();
          while (newRandomNote.equals(randomNote))
            newRandomNote = notes.randomNote();
          randomNote = newRandomNote;
          this.timer.removeTimer("learning-correct");
        }
     }
       
      
     drawCenterPoints(cubes.getCubesOnCamera());
     drawOrder(cubes.getCubesOnCamera());
     break;
     
   case "easy":
     image(cam, 100, 150);
     fill(255);
     textFont(fontLobster_smaller);
     text("Easy Mode", 180, 70);
     textFont(fontKarla);
     text("Find the Correct Note", 1000, 170);
     drawSoundButton();
     
     // The program picks a random note and plays it
     // If the right cube is picked and showed to the camera, the green led turns on and the note is played. A new random note is picked!
     // If the wrong cube is picked and showed to the camera, the buzzer sounds and the wrong note is played so that the player can compare the wrong note to the right one
     
     
     /*if (cubes.isCubeOnPhone(2)) { //if cube no 1 is on phone
        playSound("horn.wav", false, true);
        turnOnBuzzer();
      }
    
     if (cubes.cameraArrayEquals(new int[] {2, 3})) { //if exactly cubes 2 and 3 are on camera in this order
        playSound("duck.wav", false, true);
        turnOffLedAndBuzzer();
     }*/
      
     drawCenterPoints(cubes.getCubesOnCamera());
     drawOrder(cubes.getCubesOnCamera());
     break;
     
     case "stage3":
     image(cam, 100, 150);
     fill(255);
     textFont(fontLobster_smaller);
     text("Normal Mode", 190, 70);
     textFont(fontKarla);
     text("Find the Correct Chord", 1000, 170);
     drawSoundButton();
     
     drawCenterPoints(cubes.getCubesOnCamera());
     drawOrder(cubes.getCubesOnCamera());
     break;
     
     case "stage4":
     image(cam, 100, 150);
     fill(255);
     textFont(fontLobster_smaller);
     text("Advanced Mode", 200, 70);
     textFont(fontKarla);
     text("Find the Correct Chord", 1000, 170);
     drawSoundButton();
     
     drawCenterPoints(cubes.getCubesOnCamera());
     drawOrder(cubes.getCubesOnCamera());
     break;
  }
    
  if (this.developer) {
    drawArea(this.playCubeArea);
    drawLines();
  }
}


void keyPressed() {
  //System.out.println(key);
  pressedKey = key;
}

void keyReleased() {
  pressedKey = '\0';
}

void mouseClicked() {
  System.out.println("X: "+(mouseX-100)+"and Y:"+(mouseY-150));
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