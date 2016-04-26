String soundQueue = "";

int punchlinePoint = 0;
String[] punchlines = { 
                    "You are correct! Awesome!" ,
                    "Correct! You are unlimited!",
                    "Correct! Patience pays!",
                    "Correct! Be proud of who you are!",
                    "Intelligence and Intuition are two friends.",
                    "Correct! You have an ear for music!"
                };

String getPunchline() {
   return this.punchlines[punchlinePoint++%punchlines.length]; 
}

void playSound(String file, boolean interrupt, boolean sameagain) {
  //lastPlayed = 
  //System.out.println("playing sound");
  AudioMetaData meta = player.getMetaData();

  if (meta.fileName() == file && sameagain == false) {
    return;
  }

  if (interrupt) {
    if ( player.isPlaying() ) {
      player.pause();
    }
    player = minim.loadFile(file);
    player.play();
  } else {
    if ( !player.isPlaying() ) {
      player = minim.loadFile(file);
      player.play();
      System.out.println(file);
    }
  }
}

void addSoundQueue(String file) {

  soundQueue = file;
}

void playSoundQueue() {
  if (this.soundQueue != "" && !player.isPlaying()) {
    player = minim.loadFile(this.soundQueue);
    player.play();
    System.out.println(this.soundQueue);
    this.soundQueue = "";
  }
}



void playChord(Chord chord) {
  String firstfile = chord.firstNote.soundfile;
  String secondfile = chord.secondNote.soundfile;
  String thirdfile = chord.thirdNote.soundfile;
  AudioPlayer s1 = minim.loadFile(firstfile);
  AudioPlayer s2 = minim.loadFile(secondfile);
  AudioPlayer s3 = minim.loadFile(thirdfile);

  s1.play();
  s2.play();
  s3.play();
}

boolean playChordSteply(boolean chordPlayed, Chord randomChord, String unique) {
  
  if (!chordPlayed && this.timer.isOver("chord-introduction")) {
      playSound(randomChord.firstNote.soundfile, false, false);  

      this.timer.setTimer("chord-first"+unique, 1500);
      this.timer.setTimer("chord-second"+unique, 3000);
      if (this.timer.isOver("chord-first"+unique)) {
        playSound(randomChord.secondNote.soundfile, true, false);
        this.timer.removeTimer("chord-first"+unique);
        System.out.println("second");
      }
      if (this.timer.isOver("chord-second"+unique)) {
        playSound(randomChord.thirdNote.soundfile, true, false);
        this.timer.removeTimer("chord-second"+unique);
        System.out.println("third");
        return true;
      }
      
    }
   return chordPlayed;
}

void speak(String speak) {
  if (speakToUser)
   tts.speak(speak);
}