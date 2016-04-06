

void playSound(String file, boolean overwrite) {
  //lastPlayed = 
  System.out.println("playing sound");
  if (overwrite) {
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