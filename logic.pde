char pressedKey;
PImage arrow;
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

Chords chords;
Chord randomChord;
boolean chordPlayed;
boolean firstNoteCorrect = false;
boolean secondNoteCorrect = false;
boolean thirdNoteCorrect = false;

int calibrState;
int calibrWidth;
int calibrHeight;
List<int[]> calibrations;
PrintWriter output;

void doSetup() {



  this.state = new State("start");
  this.chordPlayed = false;
  //sound = loadImage("data/sound.png");
  arrow = loadImage("data/arrow.png");

  fontLobster = createFont("Lobster 1.4.otf", 80);
  fontLobster_smaller = createFont("Lobster 1.4.otf", 35);
  fontKarla = createFont("Karla-Regular.ttf", 35);
  textAlign(CENTER, CENTER);

  this.readCalibrations();

  /*
  int xdivider = 200;
   int ydivider = 200;
   this.cube3Area = new XYArea(0,xdivider,0,ydivider);
   this.cube2Area = new XYArea(xdivider+1,xdivider+xdivider,0,ydivider);
   this.cube1Area = new XYArea(xdivider+xdivider+1,1000,0,ydivider);
   this.difficultyLevelArea = new XYArea(0, xdivider, ydivider+1, 1000);
   this.playTaskAgainArea = new XYArea(xdivider+1,xdivider+xdivider,ydivider+1,1000);
   this.playCubeArea =  new XYArea(xdivider+xdivider+1,1000,ydivider+1,1000);
   */
  notes = new Notes(this.cubes);
  randomNote = notes.randomNote();

  chords = new Chords(notes.C, notes.E, notes.G);
  randomChord = chords.getRandomChord();

  //calibration variables
  this.calibrWidth = 100;
  this.calibrHeight = 100;
  this.calibrState = 1;
  this.calibrations = new ArrayList<int[]>();
}

void doLogic(PImage cameraImage) {
  background(53, 53, 53); // black background
  cubes.updateCubes(); 

  //tangible user interface stuff:
  if (tangibleInterface) {
    //play a single cube
    Cube cubeToPlay = cubes.isAnyCubeOnCamera(this.playCubeArea);
    if (cubeToPlay != null) {
      Note toPlay = notes.getNote(cubeToPlay);
      if (toPlay != null)
        playSound(toPlay.soundfile, false, false);
      //System.out.println("cubetoplay");
    }

    //play task again
    Cube taskToPlay = cubes.isAnyCubeOnCamera(this.playTaskAgainArea);
    if (taskToPlay != null) {
      playSound(randomNote.soundfile, false, false);
      //System.out.println("tasktoplay");
    }
   

    //change difficulty level
    Cube difficultyCube = cubes.isAnyCubeOnCamera(this.difficultyLevelArea);
    if (difficultyCube != null) {
      //change difficult level
      if (difficultyCube.equals(cubes.getCube(1)))
        this.state.setState("learning");
      if (difficultyCube.equals(cubes.getCube(5))) //todo
        this.state.setState("easy"); 
      if (difficultyCube.equals(cubes.getCube(6))) //todo
        this.state.setState("normal");
      if (difficultyCube.equals(cubes.getCube(8))) //todo
        this.state.setState("hard");
    }
    
    //no cube at all
    if (cubes.isAnyCubeOnCamera(this.difficultyLevelArea) == null &&
        cubes.isAnyCubeOnCamera(this.playTaskAgainArea) == null &&
        cubes.isAnyCubeOnCamera(this.playCubeArea) == null &&
        cubes.isAnyCubeOnCamera(this.cube1Area) == null &&
        cubes.isAnyCubeOnCamera(this.cube2Area) == null &&
        cubes.isAnyCubeOnCamera(this.cube3Area) == null) {
      playSound("null.wav", false, false);
    }
    
    
  }


  switch ( this.state.getState() ) {

  case "start":
    //turnOnLed();
    changeLed(0,0,0);

    this.runonce.clearAll();
    
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
        this.runonce.clearAll();
      }
      if (mouseX > easy.x && mouseX < easy.x+easy.width && mouseY > easy.y && mouseY < easy.y+easy.height) {
        this.state.setState("easy");
        this.runonce.clearAll();
      }
      if (mouseX > normal.x && mouseX < normal.x+normal.width && mouseY > normal.y && mouseY < normal.y+normal.height) {
        this.state.setState("normal");
        this.runonce.clearAll();
      }
      if (mouseX > advanced.x && mouseX < advanced.x+advanced.width && mouseY > advanced.y && mouseY < advanced.y+advanced.height) {
        this.runonce.clearAll();
        this.state.setState("hard");
      }
    }
    break;

  case "learning":
    image(cameraImage, 100, 150);
    fill(255);
    textFont(fontLobster_smaller);
    text("Learning Mode", 260, 70);
    textFont(fontKarla);
    text("Find " + randomNote.name, 1000, 170);
    //Play note C as the task begins and each time the button is clicked for help TODO
    drawBackButton();
    if (mousePressed) {
      if (mouseX > 100 && mouseX < 140 && mouseY > 50 && mouseY < 90) {
        this.state.setState("start");
      }
    }

    image(randomNote.image, 900, 300);
    
    if (this.runonce.runOnce("playNote")) {
      playSound(randomNote.soundfile, true, false); 
    }

    
    //correct cube
    if (cubes.isCubeOnCamera(randomNote.cube.number, this.cube1Area) ||
      cubes.isCubeOnCamera(randomNote.cube.number, this.cube2Area) ||
      cubes.isCubeOnCamera(randomNote.cube.number, this.cube3Area)
      ) { //if cube is on camera
      playSound(randomNote.soundfile, false, false); 
      changeLed(1,1,1);
      text("Correct! Fantastic!", 200, 500);
      changeLed(2,2,2);
      //turnOnLed();
      //Pick new random note
      this.timer.setTimer("learning-correct", 2000);
      if (this.timer.isOver("learning-correct")) {
        //System.out.println("over");
        Note newRandomNote = notes.randomNote();
        while (newRandomNote.equals(randomNote))
          newRandomNote = notes.randomNote();
        randomNote = newRandomNote;
        this.timer.removeTimer("learning-correct");
        this.runonce.remove("playNote");
        changeLed(0,0,0);
      }
    }

    //drawMarkers();
    drawCenterPoints(cubes.getCubesOnCamera());
    if (drawCubeCorners)
      drawCornerPoints(cubes.getCubesOnCamera());
    //drawOrder(cubes.getCubesOnCamera());

    break;

  case "easy":
    image(cameraImage, 100, 150);
    fill(255);
    textFont(fontLobster_smaller);
    text("Easy Mode", 230, 70);
    textFont(fontKarla);
    text("Find the Correct Note", 1000, 170);
    drawBackButton();
    if (mousePressed) {
      if (mouseX > 100 && mouseX < 140 && mouseY > 50 && mouseY < 90) {
        this.state.setState("start");
      }
    }
    if (this.runonce.runOnce("playNote"))
      playSound(randomNote.soundfile, false, false); 

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

  case "normal":
    image(cameraImage, 100, 150);
    fill(255);
    textFont(fontLobster_smaller);
    text("Normal Mode", 250, 70);
    textFont(fontKarla);
    text("Find the Correct Chord", 1000, 170);
    image(randomChord.image, 900, 200);
    changeLed(firstNoteCorrect ? 2 : 1, secondNoteCorrect ? 2 : 1, thirdNoteCorrect ? 2 : 1);

    if (!chordPlayed) {
      playSound(randomChord.firstNote.soundfile, false, false);  

      this.timer.setTimer("chord-first", 1500);
      this.timer.setTimer("chord-second", 3000);
      if (this.timer.isOver("chord-first")) {
        playSound(randomChord.secondNote.soundfile, true, false);
        this.timer.removeTimer("chord-first");
      }
      if (this.timer.isOver("chord-second")) {
        playSound(randomChord.thirdNote.soundfile, true, false);
        this.timer.removeTimer("chord-second");
        chordPlayed = true;
      }
    }

    if (cubes.isCubeOnCamera(randomChord.firstNote.cube.number, this.cube1Area)) { //if cube is on camera
    if (this.runonce.runOnce("playFirst")) {
      playSound(randomChord.firstNote.soundfile, false, false); 
    }
      text("First note is correct!", 1000, 400);
      //turnOnLed(); 
      firstNoteCorrect = true;
    }
    if (cubes.isCubeOnCamera(randomChord.secondNote.cube.number, this.cube2Area)) { //if cube is on camera
    if (this.runonce.runOnce("playSecond")) {
      playSound(randomChord.secondNote.soundfile, false, false);
    }
      text("Second note is correct!", 1000, 450);
      //turnOnLed(); 
      secondNoteCorrect = true;
    }
    if (cubes.isCubeOnCamera(randomChord.thirdNote.cube.number, this.cube3Area)) { //if cube is on camera
    if (this.runonce.runOnce("playThird")) {
      playSound(randomChord.thirdNote.soundfile, false, false); 
    }
      text("Third note is correct!", 1000, 500);
      //turnOnLed(); 
      thirdNoteCorrect = true;
    }

    if (firstNoteCorrect && secondNoteCorrect && thirdNoteCorrect) {
      //this.runonce.runOnce("playChord");
      if (this.runonce.runOnce("playChord")) {
        playChord(randomChord); 
      }
      
      text("All notes are correct! Fantastic!", 1000, 600);
      //TODO: Play new chord
    }

    drawBackButton();
    if (mousePressed) {
      if (mouseX > 100 && mouseX < 140 && mouseY > 50 && mouseY < 90) {
        this.state.setState("start");
      }
    }

    drawCenterPoints(cubes.getCubesOnCamera());
    drawOrder(cubes.getCubesOnCamera());
    break;

  case "hard":
    image(cameraImage, 100, 150);
    fill(255);
    textFont(fontLobster_smaller);
    text("Advanced Mode", 260, 70);
    textFont(fontKarla);
    text("Find the Correct Chord", 1000, 170);

    if (!chordPlayed) {
      playChord(randomChord);
      chordPlayed = true;
    }
    
    if (cubes.isCubeOnCamera(randomChord.firstNote.cube.number, this.cube1Area)) { //if cube is on camera
    if (this.runonce.runOnce("playFirst-hard")) {
      playSound(randomChord.firstNote.soundfile, false, false); 
    }
      text("First note is correct!", 1000, 400);
      //turnOnLed(); 
      firstNoteCorrect = true;
    }
    if (cubes.isCubeOnCamera(randomChord.secondNote.cube.number, this.cube2Area)) { //if cube is on camera
    if (this.runonce.runOnce("playSecond-hard")) {
      playSound(randomChord.secondNote.soundfile, false, false); 
    }
      text("Second note is correct!", 1000, 450);
      //turnOnLed(); 
      secondNoteCorrect = true;
    }
    if (cubes.isCubeOnCamera(randomChord.thirdNote.cube.number, this.cube3Area)) { //if cube is on camera
    if (this.runonce.runOnce("playThird-hard")) {
      playSound(randomChord.thirdNote.soundfile, false, false); 
    }
      text("Third note is correct!", 1000, 500);
      //turnOnLed(); 
      thirdNoteCorrect = true;
    }

    if (firstNoteCorrect && secondNoteCorrect && thirdNoteCorrect) {
      //this.runonce.runOnce("playChord");
      if (this.runonce.runOnce("playChord")) {
        playChord(randomChord); 
      }
      
      text("All notes are correct! Fantastic!", 1000, 600);
      //TODO: Play new chord
    }
    drawBackButton();
    if (mousePressed) {
      if (mouseX > 100 && mouseX < 140 && mouseY > 50 && mouseY < 90) {
        this.state.setState("start");
      }
    }

    drawCenterPoints(cubes.getCubesOnCamera());
    drawOrder(cubes.getCubesOnCamera());
    break;
  case "calibration":
    image(cameraImage, 100, 150);
    fill(255, 100);
    textFont(fontLobster_smaller);
    text("Calibration mode", 200, 70);
    textFont(fontKarla);
    if (this.calibrState == 1) {
      text("Cube 1\nclick\nscroll\nspace+scroll", 1000, 170);
    }
    if (this.calibrState == 2) {
      text("Cube 2\nclick\nscroll\nspace+scroll", 1000, 170);
    }
    if (this.calibrState == 3) {
      text("Cube 3\nclick\nscroll\nspace+scroll", 1000, 170);
    }
    if (this.calibrState == 4) {
      text("Play cube\nclick\nscroll\nspace+scroll", 1000, 170);
    }
    if (this.calibrState == 5) {
      text("Play task again\nclick\nscroll\nspace+scroll", 1000, 170);
    }
    if (this.calibrState == 6) {
      text("Difficulty level\nclick\nscroll\nspace+scroll", 1000, 170);
    }
    rect(mouseX-calibrWidth/2, mouseY-calibrHeight/2, calibrWidth, calibrHeight);
    break;
  }

  if (this.developer && this.state.getState() != "start") {
    drawArea(this.cube1Area);
    drawArea(this.cube2Area);
    drawArea(this.cube3Area);
    drawArea(this.playCubeArea);
    drawArea(this.playTaskAgainArea);
    drawArea(this.difficultyLevelArea);
    drawLines();
  }
}


void keyPressed() {
  //System.out.println(key);
  if (key == 'c' && this.state.getState() != "calibration") {
    this.state.setState("calibration");
  }
  //System.out.println(key);
  pressedKey = key;
}

void keyReleased() {
  pressedKey = '\0';
}



void mouseClicked() {
  System.out.println("X: "+(mouseX-100)+"and Y:"+(mouseY-150));

  /* calibration */
  if (this.state.getState() == "calibration") {
    //System.out.println("kalibr");
    int[] xy = new int[4];
    xy[0] = mouseX-(this.calibrWidth/2)-100;
    xy[1] = xy[0]+this.calibrWidth;
    xy[2] = mouseY-(this.calibrHeight/2)-150;
    xy[3] = xy[2]+this.calibrHeight;
    //System.out.println(xy[0] + " " + xy[1] + " " + xy[2] + " " + xy[3]);
    this.calibrations.add(xy);
    this.calibrState++;

    // save calibration
    if (this.calibrState == 7) {
      output = createWriter("data/positions.txt"); 
      for (int q=0; q< this.calibrations.size(); q++) {
        output.println(this.calibrations.get(q)[0] + " " + this.calibrations.get(q)[1] + " " + this.calibrations.get(q)[2] + " " + this.calibrations.get(q)[3]); // Write the coordinate to the file
      }
      output.flush(); // Writes the remaining data to the file
      output.close(); // Finishes the file
      readCalibrations();
      this.state.setState("start");
      this.calibrations = new ArrayList<int[]>();
      this.calibrState = 1;
    }
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if (pressedKey == ' ') {
    if (e < 0)
      this.calibrHeight = this.calibrHeight + 10;
    if (e > 0)
      this.calibrHeight = this.calibrHeight - 10;
  } else {
    if (e < 0)
      this.calibrWidth = this.calibrWidth + 10;
    if (e > 0)
      this.calibrWidth = this.calibrWidth - 10;
  }
}

void changeLed(int first, int second, int third) {
  if (useSerial)
    serialPort.write(first+","+second+","+third+"\r\n");
}

void readCalibrations() {
  /* read calibrations */
  BufferedReader reader;
  reader = createReader("data/positions.txt");    
  String line;
  String[] linesplit;
  try {
    line = reader.readLine();

    linesplit = line.split(" ");
    this.cube1Area = new XYArea(Integer.parseInt(linesplit[0]), Integer.parseInt(linesplit[1]), Integer.parseInt(linesplit[2]), Integer.parseInt(linesplit[3]));
    line = reader.readLine();
    linesplit = line.split(" ");
    this.cube2Area = new XYArea(Integer.parseInt(linesplit[0]), Integer.parseInt(linesplit[1]), Integer.parseInt(linesplit[2]), Integer.parseInt(linesplit[3]));
    line = reader.readLine();
    linesplit = line.split(" ");
    this.cube3Area = new XYArea(Integer.parseInt(linesplit[0]), Integer.parseInt(linesplit[1]), Integer.parseInt(linesplit[2]), Integer.parseInt(linesplit[3]));
    line = reader.readLine();
    linesplit = line.split(" ");
    this.playCubeArea = new XYArea(Integer.parseInt(linesplit[0]), Integer.parseInt(linesplit[1]), Integer.parseInt(linesplit[2]), Integer.parseInt(linesplit[3]));
    line = reader.readLine();
    linesplit = line.split(" ");
    this.playTaskAgainArea = new XYArea(Integer.parseInt(linesplit[0]), Integer.parseInt(linesplit[1]), Integer.parseInt(linesplit[2]), Integer.parseInt(linesplit[3]));
    line = reader.readLine();
    linesplit = line.split(" ");
    this.difficultyLevelArea = new XYArea(Integer.parseInt(linesplit[0]), Integer.parseInt(linesplit[1]), Integer.parseInt(linesplit[2]), Integer.parseInt(linesplit[3]));
  } 
  catch (IOException e) {
    e.printStackTrace();
    exit();
  }
}

/*
void turnOnBuzzer() {
 if (useSerial)
 serialPort.write("1,0\r\n");
 }
 
 void turnOffLedAndBuzzer() {
 if (useSerial)
 serialPort.write("0,0\r\n");
 }
 */
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