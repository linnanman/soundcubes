

void playSound(String file, boolean interrupt, boolean sameagain) {
  //lastPlayed = 
  //System.out.println("playing sound");
  AudioMetaData meta = player.getMetaData();
  
  if (meta.fileName().equals(file) && sameagain == false) {
    return;
  }
  
  if (interrupt) {
    if ( player.isPlaying() ) {player.pause();}
      player = minim.loadFile(file);
      player.play(); 
  }
  else {
      if ( !player.isPlaying() ) {
        player = minim.loadFile(file);
        player.play(); 
      }
  }
  

   
}