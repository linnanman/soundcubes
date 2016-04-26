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

boolean taskChordPlayed = false;

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
    /*
      play single cube -slot
      */
    Cube cubeToPlay = cubes.isAnyCubeOnCamera(this.playCubeArea);
    if (cubeToPlay != null) {
      
      Note toPlay = notes.getNote(cubeToPlay);
      if (toPlay != null) {
        this.timer.setTimer("cubeToPlay", 1500);
        if (this.timer.isOver("cubeToPlay") && this.runonce.runOnce("cubeToPlay")) {
          speak("The cube is:");
          System.out.println("joojooo");
          this.timer.setTimer("cubeToPlay2", 1500);
          
        }
        if (this.timer.isOver("cubeToPlay2") && this.runonce.runOnce("cubeToPlay2")) {
          playSound(toPlay.soundfile, true , true);
        }
        
      }
      //System.out.println("cubetoplay");
    }
    else {
      this.timer.removeTimer("cubeToPlay");
      this.timer.removeTimer("cubeToPlay2");
      this.runonce.remove("cubeToPlay");
      this.runonce.remove("cubeToPlay2");
    }
    
    /*
      play task again -slot
      */
    Cube taskToPlay = cubes.isAnyCubeOnCamera(this.playTaskAgainArea);
    if (taskToPlay != null) {

        this.timer.setTimer("taskToPlay", 1500);
        if (this.timer.isOver("taskToPlay") && this.runonce.runOnce("taskToPlay")) {
          if (this.state.getState() == "learning" || this.state.getState() == "easy") {
            speak("The note is:");
          }
          else if (this.state.getState() == "normal" || this.state.getState() == "hard") {
            speak("The chord is:");
          }
          
          System.out.println("joojooo");
          this.timer.setTimer("taskToPlay2", 1500);
          
        }
        if (this.timer.isOver("taskToPlay2") && this.runonce.runOnce("taskToPlay2")) {
          System.out.println("joojoo2");
          if (this.state.getState().equals("learning") || this.state.getState().equals("easy")) {
            playSound(randomNote.soundfile, false, true);
          }
          else if (this.state.getState().equals("hard")) {
            playChord(randomChord);
          }
        }
        else if (this.timer.isOver("taskToPlay2") && this.state.getState().equals("normal")) {
          taskChordPlayed = playChordSteply(taskChordPlayed, randomChord, "taskplay");
        }
        
      }
    else {
      if ( !this.state.getState().equals("normal") || (this.state.getState().equals("normal") && this.timer.isOver("taskToPlay2")) ) {
        this.timer.removeTimer("taskToPlay");
        this.timer.removeTimer("taskToPlay2");
        this.timer.removeTimer("chord-firsttaskplay");
        this.timer.removeTimer("chord-secondtaskplay");
        this.runonce.remove("taskToPlay");
        this.runonce.remove("taskToPlay2");
        taskChordPlayed = false;
      }
    }
   

    /*
      change difficulty level -slot
      */
    Cube difficultyCube = cubes.isAnyCubeOnCamera(this.difficultyLevelArea);
    if (difficultyCube != null) {
      this.timer.setTimer("doNotChangeTooQuickly", 2000);
      //change difficult level
      if (this.timer.isOver("doNotChangeTooQuickly") && difficultyCube.equals(cubes.getCube(1)) && this.state.getState() != "learning") {
        //speak("Difficulty level is: learning");
        this.state.setState("learning");
        this.runonce.clearAll();
        this.timer.clearAll();
        chordPlayed = false;
      }
      else if (this.timer.isOver("doNotChangeTooQuickly") && difficultyCube.equals(cubes.getCube(5)) && this.state.getState() != "easy") { //todo
      //speak("Difficulty level is: easy");
        this.state.setState("easy"); 
        this.runonce.clearAll();
        this.timer.clearAll();
        chordPlayed = false;
      }
      else if (this.timer.isOver("doNotChangeTooQuickly") && difficultyCube.equals(cubes.getCube(6)) && this.state.getState() != "normal") { //todo
        //speak("Difficulty c level is: normal");
        this.state.setState("normal");
        this.runonce.clearAll();
        this.timer.clearAll();
        chordPlayed = false;
      }
      else if (this.timer.isOver("doNotChangeTooQuickly") && difficultyCube.equals(cubes.getCube(8)) && this.state.getState() != "hard") { //todo
        //speak("Difficulty level is: advanced");
        this.state.setState("hard");
        this.runonce.clearAll();
        this.timer.clearAll();
        chordPlayed = false;
      }
    }
    else {
      this.timer.removeTimer("doNotChangeTooQuickly");
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
    

    this.timer.setTimer("intro", 1000);
    if (this.timer.isOver("intro") && this.runonce.runOnce("intro"))
        speak("Please select a difficulty level");
        
    this.runonce.clearAll();
    chordPlayed = false;
    this.timer.clearAll();
    
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
        this.timer.clearAll();
        this.runonce.clearAll();
        break;
      }
    }

    image(randomNote.image, 900, 300);
    
    if (this.runonce.runOnce("dlevel"))
      speak("Difficulty level is: learning");
    
    this.timer.setTimer("anoteis", 500);
    if (this.timer.isOver("anoteis") && this.runonce.runOnce("playNote")) {
      //playSound("newNoteIs.wav", true, false); 
      speak("A note is: " + randomNote.name);
      this.timer.setTimer("noteisdelay", 1000);
      addSoundQueue(randomNote.soundfile); 
    }
    if (this.timer.isOver("noteisdelay"))
      playSoundQueue();

    
    //correct cube found
    if (cubes.isCubeOnCamera(randomNote.cube.number, this.cube1Area) ||
      cubes.isCubeOnCamera(randomNote.cube.number, this.cube2Area) ||
      cubes.isCubeOnCamera(randomNote.cube.number, this.cube3Area)
      ) { //if cube is on camera

      changeLed(1,1,1);

      text("Correct! Fantastic!", 200, 500);
      changeLed(2,2,2);
      //turnOnLed();
      //Pick new random note
      this.timer.setTimer("learning-correct", 4000);
      this.timer.setTimer("correct-sound", 1500);
      }
      
    //move on
    if (this.timer.isOver("correct-sound") && this.runonce.runOnce("speak")) {
      //playSound("thatsCorrectAwesome.wav", true, false);
      speak(getPunchline());
    }
    
    if (this.timer.isOver("learning-correct")) {
      //System.out.println("over");
      //addSoundQueue(randomNote.soundfile); 
      
      Note newRandomNote = notes.randomNote();
      while (newRandomNote.equals(randomNote))
        newRandomNote = notes.randomNote();
      randomNote = newRandomNote;
      this.timer.clearAll();
      this.runonce.clearAllExcept("dlevel");
      changeLed(1,1,1);
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
        this.timer.clearAll();
        this.runonce.clearAll();
        break;
      }
    }

    if (this.runonce.runOnce("dlevel"))
      speak("Difficulty level is: easy");
    
    this.timer.setTimer("anoteis", 500);
    if (this.timer.isOver("anoteis") && this.runonce.runOnce("playNote")) {
      //playSound("newNoteIs.wav", true, false); 
      speak("A note is:");
      this.timer.setTimer("noteisdelay", 1000);
      addSoundQueue(randomNote.soundfile); 
    }
    if (this.timer.isOver("noteisdelay"))
      playSoundQueue();
    
    //correct cube found
    if (cubes.isCubeOnCamera(randomNote.cube.number, this.cube1Area) ||
      cubes.isCubeOnCamera(randomNote.cube.number, this.cube2Area) ||
      cubes.isCubeOnCamera(randomNote.cube.number, this.cube3Area)
      ) { //if cube is on camera
      
      text("Correct! Fantastic!", 200, 500);
      changeLed(2,2,2);
      //turnOnLed();
      //Pick new random note
      this.timer.setTimer("learning-correct", 4000);
      this.timer.setTimer("correct-sound", 1500);
      }
      
    //move on
    if (this.timer.isOver("correct-sound") && this.runonce.runOnce("correct")) {
      //playSound("thatsCorrectAwesome.wav", true, false);
      speak(getPunchline());
    }
    
    if (this.timer.isOver("learning-correct")) {
      //System.out.println("over");
      //addSoundQueue(randomNote.soundfile); 
      
      Note newRandomNote = notes.randomNote();
      while (newRandomNote.equals(randomNote))
        newRandomNote = notes.randomNote();
      randomNote = newRandomNote;
      this.timer.clearAll();
      this.runonce.clearAllExcept("dlevel");
      changeLed(1,1,1);
    }
    
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
    if (drawCubeCorners)
      drawCornerPoints(cubes.getCubesOnCamera());
    //drawOrder(cubes.getCubesOnCamera());
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
    
    if (this.runonce.runOnce("dlevel"))
      speak("Difficulty level is: normal");
    
    this.timer.setTimer("achordis", 1500);
      
    if (this.timer.isOver("achordis") && this.runonce.runOnce("playNote")) {
      //playSound("newChordIs.wav", true, false); 
      speak("A chord is:");
    }
    
    
    this.timer.setTimer("chord-introduction", 3500);
    chordPlayed = playChordSteply(chordPlayed, randomChord, "real");/*
    if (!chordPlayed && this.timer.isOver("chord-introduction")) {
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
    }*/

    if (cubes.isCubeOnCamera(randomChord.firstNote.cube.number, this.cube1Area)) { //if cube is on camera
    if (this.runonce.runOnce("playFirst")) {
      //playSound(randomChord.firstNote.soundfile, false, false); 
    }
      text("First note is correct!", 1000, 400);
      //turnOnLed(); 
      firstNoteCorrect = true;
    }
    if (cubes.isCubeOnCamera(randomChord.secondNote.cube.number, this.cube2Area)) { //if cube is on camera
    if (this.runonce.runOnce("playSecond")) {
      //playSound(randomChord.secondNote.soundfile, false, false);
    }
      text("Second note is correct!", 1000, 450);
      //turnOnLed(); 
      secondNoteCorrect = true;
    }
    if (cubes.isCubeOnCamera(randomChord.thirdNote.cube.number, this.cube3Area)) { //if cube is on camera
    if (this.runonce.runOnce("playThird")) {
      //playSound(randomChord.thirdNote.soundfile, false, false); 
    }
      text("Third note is correct!", 1000, 500);
      //turnOnLed(); 
      thirdNoteCorrect = true;
    }

    if (firstNoteCorrect && secondNoteCorrect && thirdNoteCorrect) {
      //this.runonce.runOnce("playChord");
      /*if (this.runonce.runOnce("playChord")) {
        playChord(randomChord); 
      }*/
      this.timer.setTimer("chord-correct", 4000);
      this.timer.setTimer("correct-sound", 1500);
      
      text("All notes are correct! Fantastic!", 1000, 600);
      //TODO: Play new chord
    }
    
    if (this.timer.isOver("correct-sound") && this.runonce.runOnce("correct-feedback")) {
      //playSound("thatsCorrectAwesome.wav", true, false);
      speak(getPunchline());
    }
    

    if (this.timer.isOver("chord-correct")) {
      //System.out.println("over");
      //addSoundQueue(randomNote.soundfile); 
      
      chordPlayed = false;
      Chord newRandomChord = chords.getRandomChord();
      while (newRandomChord.equals(randomChord))
        newRandomChord = chords.getRandomChord();
      randomChord = newRandomChord;
      this.timer.clearAll();
      this.runonce.clearAllExcept("dlevel");
      firstNoteCorrect = false;
      secondNoteCorrect = false;
      thirdNoteCorrect = false;
    }
    
    drawBackButton();
    if (mousePressed) {
      if (mouseX > 100 && mouseX < 140 && mouseY > 50 && mouseY < 90) {
        this.state.setState("start");
        this.timer.clearAll();
        this.runonce.clearAll();
        break;
      }
    }

    //drawMarkers();
    drawCenterPoints(cubes.getCubesOnCamera());
    if (drawCubeCorners)
      drawCornerPoints(cubes.getCubesOnCamera());
    //drawOrder(cubes.getCubesOnCamera());
    break;

  case "hard":
    image(cameraImage, 100, 150);
    fill(255);
    textFont(fontLobster_smaller);
    text("Advanced Mode", 260, 70);
    textFont(fontKarla);
    text("Find the Correct Chord", 1000, 170);

        if (this.runonce.runOnce("dlevel"))
      speak("Difficulty level is: advanced");
    
    this.timer.setTimer("achordis", 1500);
      
    if (this.timer.isOver("achordis") && this.runonce.runOnce("playNote")) {
      //playSound("newChordIs.wav", true, false); 
      speak("A chord is:");
    }
    
    
    this.timer.setTimer("chord-introduction", 3500);
    if (!chordPlayed && this.timer.isOver("chord-introduction")) {
      playChord(randomChord);
      chordPlayed = true;
    }
    
    if (cubes.isCubeOnCamera(randomChord.firstNote.cube.number, this.cube1Area)) { //if cube is on camera
    if (this.runonce.runOnce("playFirst-hard")) {
      //playSound(randomChord.firstNote.soundfile, false, false); 
    }
      text("First note is correct!", 1000, 400);
      //turnOnLed(); 
      firstNoteCorrect = true;
    }
    if (cubes.isCubeOnCamera(randomChord.secondNote.cube.number, this.cube2Area)) { //if cube is on camera
    if (this.runonce.runOnce("playSecond-hard")) {
      //playSound(randomChord.secondNote.soundfile, false, false); 
    }
      text("Second note is correct!", 1000, 450);
      //turnOnLed(); 
      secondNoteCorrect = true;
    }
    if (cubes.isCubeOnCamera(randomChord.thirdNote.cube.number, this.cube3Area)) { //if cube is on camera
    if (this.runonce.runOnce("playThird-hard")) {
      //playSound(randomChord.thirdNote.soundfile, false, false); 
    }
      text("Third note is correct!", 1000, 500);
      //turnOnLed(); 
      thirdNoteCorrect = true;
    }

    if (firstNoteCorrect && secondNoteCorrect && thirdNoteCorrect) {
      //this.runonce.runOnce("playChord");
      /*if (this.runonce.runOnce("playChord")) {
        playChord(randomChord); 
      }*/
      
      this.timer.setTimer("chord-correct", 4000);
      this.timer.setTimer("correct-sound", 1500);
      
      text("All notes are correct! Fantastic!", 1000, 600);
      //TODO: Play new chord
    }
    
    if (this.timer.isOver("correct-sound") && this.runonce.runOnce("correct-feedback")) {
      //playSound("thatsCorrectAwesome.wav", true, false);
      speak(getPunchline());
    }
    

    if (this.timer.isOver("chord-correct")) {
      //System.out.println("over");
      //addSoundQueue(randomNote.soundfile); 
      chordPlayed = false;
      Chord newRandomChord = chords.getRandomChord();
      while (newRandomChord.equals(randomChord))
        newRandomChord = chords.getRandomChord();
      randomChord = newRandomChord;
      this.timer.clearAll();
      this.runonce.clearAllExcept("dlevel");
      firstNoteCorrect = false;
      secondNoteCorrect = false;
      thirdNoteCorrect = false;
    }
    
    drawBackButton();
    if (mousePressed) {
      if (mouseX > 100 && mouseX < 140 && mouseY > 50 && mouseY < 90) {
        this.state.setState("start");
        this.timer.clearAll();
        this.runonce.clearAll();
        break;
      }
    }

    drawCenterPoints(cubes.getCubesOnCamera());
    //drawOrder(cubes.getCubesOnCamera());
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
      this.timer.clearAll();
      this.runonce.clearAll();
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

// Sorry, this is an ugly hack!
// The variables are used to prevent unnecessary calls to the arduino.
int firstLedStatus = -1;
int secondLedStatus = -1;
int thirdLedStatus = -1;


void changeLed(int first, int second, int third) {
  if (firstLedStatus != first || secondLedStatus != second || thirdLedStatus != third) {
    firstLedStatus = first;
    secondLedStatus = second;
    thirdLedStatus = third;
    if (useSerial)
      serialPort.write(first+","+second+","+third+"\r\n"); //<>//
  }
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