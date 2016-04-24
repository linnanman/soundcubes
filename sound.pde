

void playSound(String file, boolean interrupt, boolean sameagain) {
  //lastPlayed = 
  //System.out.println("playing sound");
  AudioMetaData meta = player.getMetaData();

  if (meta.fileName().equals(file) && sameagain == false) {
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
    }
  }
}

void playChord(String firstfile, String secondfile, String thirdfile) {
  AudioPlayer s1 = minim.loadFile(firstfile);
  AudioPlayer s2 = minim.loadFile(secondfile);
  AudioPlayer s3 = minim.loadFile(thirdfile);

  s1.play();
  s2.play();
  s3.play();
}