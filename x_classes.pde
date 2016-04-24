class XYArea {
  public int xMin;
  public int xMax;
  public int yMin;
  public int yMax;
  
  public XYArea(int xMin, int xMax, int yMin, int yMax) {
    this.xMin = xMin;
    this.xMax = xMax;
    this.yMin = yMin;
    this.yMax = yMax;
  }
  
 
}


class Timer {
  
  private Hashtable<String, Long> timers;
  
  public Timer() {
    this.timers = new Hashtable<String, Long>();
  }
  
  public void removeTimer(String name) {
    this.timers.remove(name);
  }
  
  public void setTimer(String name, long delayms) {
    if (!this.timers.containsKey(name))
      this.timers.put(name, System.currentTimeMillis()+delayms);
  }
  
  public void setNewTimer(String name, long delayms) {
    if (this.timers.containsKey(name))
      this.timers.remove(name);
    this.timers.put(name, System.currentTimeMillis()+delayms);
  }
  
  public boolean isGoing(String name) {
    if (this.timers.get(name) > System.currentTimeMillis()) {
      return true;
    }
    return false;
  }
  
  public boolean isOver(String name) {
    return !this.isGoing(name);
  }
  
}

  

class State {
  private String oldState;
  private String newState;
  private long changeTime;
  
  public State(String string) {
    this.oldState = string;
    this.newState = "";
  }
  
  public String getState()  {
    if (newState != "" && System.currentTimeMillis() > this.changeTime) {
      this.oldState = this.newState;
      this.newState = "";
    }
    return this.oldState;
  }
  
  public void setState(String state)  {
    this.oldState = state;
  }
  
  public void setStateTimer(String state, int delayms)  {
    if (this.newState == state)
      return;
      
    this.changeTime = System.currentTimeMillis()+delayms;
    this.newState = state;
  }
  
}

class Cube {
  public int x; 
  public int y;
  public int number;
  public float dia;
  public boolean onCamera;
  public boolean onPhone;
  
  public Cube(int x, int y, int number) {
    this.x = x;
    this.y = y;
    this.number = number;
    onCamera = false;
    onPhone = false;
  }
}
  
  
class Cubes {
  
  
  public List<Cube> list;
  
  
  public Cubes() {
    
    List<Cube> list = new ArrayList<Cube>();
    
    
    
    for (int i = 0; i < numMarkers; ++i) {
      list.add(new Cube(0, 0, i+1));
    }
    this.list = list;
  }
  
  public void updateCubes() {

    for (int i = 0; i < this.list.size(); ++i) {
      if (!nya.isExistMarker(i)) { 
        list.get(i).onCamera = false;
        list.get(i).x = 0;
        list.get(i).y = 0;
        list.get(i).dia = 0;
      }
      else {
        PVector[] cornerPositions = nya.getMarkerVertex2D(i);
        PVector centerPosition = new PVector(0, 0);
        float dia = 0;
        
        for (int j = 0; j < cornerPositions.length; ++j) {
          PVector cornerPosition = cornerPositions[j];
          centerPosition.add(cornerPosition);
        }
        centerPosition.mult(0.25);
        
        for (int j = 0; j < cornerPositions.length; ++j) {
          PVector cornerPosition = cornerPositions[j];
          PVector diaVector = new PVector(0, 0);
          diaVector.add(cornerPosition);
          diaVector.sub(centerPosition);
          dia += diaVector.mag();
          
        }
        

        if (dia > minimum_dia) {
          list.get(i).onCamera = true;
          list.get(i).x = (int)centerPosition.x;
          list.get(i).y = (int)centerPosition.y;
          list.get(i).dia = dia; 
          System.out.println(dia);
        }
        else {
          list.get(i).onCamera = false;
          list.get(i).x = (int)centerPosition.x;
          list.get(i).y = (int)centerPosition.y;
          list.get(i).dia = dia; 
        }
        
      }
    }
  }
  
  public Cube getCube(int i) {
    return this.list.get(i-1);  
  }
  
  public int[] getCubesOnCameraArray() {
    List<Cube> list = this.getCubesOnCamera();
    int[] arrayban = new int[list.size()];
    
    for (int i=0;i<list.size();i++) {
      arrayban[i] = list.get(i).number;
    }
    return arrayban;
    
  }
  
  public boolean cameraArrayEquals(int[] arrayban) {
    int[] compare = this.getCubesOnCameraArray();
    if (compare.length != arrayban.length) {
      return false;
    }
    for (int i=0;i<compare.length;i++) {
      if (compare[i] != arrayban[i]) {
         return false;
      }
    }
    return true;
    
  }
  
  public List<Cube> getCubesOnCamera() {
    List<Cube> list = new ArrayList<Cube>();
    
    Collections.sort(list, new Comparator<Cube>() {
        public int compare(Cube o1, Cube o2) {
            return o2.x < o1.x ? 1 : -1;
        }
    });
    
    for (int i=0;i<this.list.size();i++) {
      if (this.list.get(i).onCamera)
        list.add(this.list.get(i));
    }
    return list;
    
  }
  
  public boolean isCubeOnCamera(int number) {
    number = number-1;
  
    if (list.size() <= number)
      return false;
      
    return this.list.get(number).onCamera; 
  }
  
  public Cube isAnyCubeOnCamera(int xMin, int xMax, int yMin, int yMax) {
  

    for (int i=0;i<this.list.size();i++) {
      if (this.list.get(i).x > xMin && this.list.get(i).y > yMin && this.list.get(i).x < xMax && this.list.get(i).y < yMax && this.list.get(i).onCamera) {
          return this.list.get(i);
      }
    }
    return null;
    
  }
  
  public Cube isAnyCubeOnCamera(XYArea xyarea) {
  
    for (int i=0;i<this.list.size();i++) {
      if (this.list.get(i).x > xyarea.xMin && this.list.get(i).y > xyarea.yMin && this.list.get(i).x < xyarea.xMax && this.list.get(i).y < xyarea.yMax && this.list.get(i).onCamera) {
          //System.out.println(this.list.get(i).x + " " + this.list.get(i).y);
          return this.list.get(i);
      }
    }
    return null;
    
  }
  
  public boolean isCubeOnCamera(int number, XYArea xyarea) {
    number = number-1;
  
    if (list.size() <= number)
      return false;
      
    if (this.list.get(number).x < xyarea.xMin)
      return false;
    if (this.list.get(number).y < xyarea.yMin)
      return false;
    if (this.list.get(number).x > xyarea.xMax)
      return false;
    if (this.list.get(number).y > xyarea.yMax)
      return false;
      
    return this.list.get(number).onCamera; 
  }
  
  public boolean isCubeOnCamera(int number, int xMin, int xMax, int yMin, int yMax) {
    number = number-1;
  
    if (list.size() <= number)
      return false;
      
    if (this.list.get(number).x < xMin)
      return false;
    if (this.list.get(number).y < yMin)
      return false;
    if (this.list.get(number).x > xMax)
      return false;
    if (this.list.get(number).y > yMax)
      return false;
      
    return this.list.get(number).onCamera; 
  }
  
  public boolean isCubeOnPhone(int number) {
    number = number-1;
  
    if (list.size() <= number)
      return false;
      
    return this.list.get(number).onPhone; 
  }
  
}

class ModeButton {
  public int x;
  public int y;
  public String text;
  public int width;
  public int height;
  public int radius;
  public boolean clicked;
  
  public ModeButton(int x, int y, String text) {
    this.x = x;
    this.y = y;
    this.text = text;
    this.width = 300;
    this.height = 150;
    this.radius = 7;
    this.clicked = false;
  }
  
  public void drawButton() {
    if (!clicked) {
      fill(31, 181, 183);
      rect(this.x, this.y, this.width, this.height, this.radius);
      fill(255);
      text(this.text, this.x+150, this.y+67);
    } else {
      fill(255);
      rect(this.x, this.y, this.width, this.height, this.radius);
      fill(31, 181, 183);
      text(this.text, this.x+150, this.y+67);
    }
  }
  
  public void setClicked() {
    this.clicked = true;
  }
  
  public void setDefault() {
    this.clicked = false;
  }
  
}

class Note {
  public String name;
  public PImage image;
  public String soundfile;
  public Cube cube;
  
  public Note(String name, PImage image, Cube cube, String soundfile) {
    this.name = name;
    this.image = image;
    this.cube = cube;
    this.soundfile = soundfile;
  }
}

class Notes {
  
  public PImage C_image;
  public PImage E_image;
  public PImage F_image;
  public PImage G_image;
  public Random rand;
  public Note C;
  public Note E;
  public Note F;
  public Note G;
  
  public Notes(Cubes cubes) {
    C_image = loadImage("data/Middle_C.png");
    E_image = loadImage("data/E.png");
    F_image = loadImage("data/F.png");
    G_image = loadImage("data/G.png");
    C = new Note("C", C_image, cubes.getCube(1), "notes/c.wav");
    E = new Note("E", E_image, cubes.getCube(5), "notes/e.wav");
    F = new Note("F", F_image, cubes.getCube(6), "notes/f.wav");
    G = new Note("G", G_image, cubes.getCube(8), "notes/g.wav");
    rand = new Random();
  }
  
  public Note randomNote() {
    List<Note> list = new ArrayList<Note>();
    list.add(C);
    list.add(E);
    list.add(F);
    list.add(G);
    Note randomNote = list.get(rand.nextInt(list.size()));
    return randomNote;
  }
  
  public Note getNote(Cube cube) {
    return null; //todo
  }

}