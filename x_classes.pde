class Timer {
  
  private Hashtable<String, Long> timers;
  
  public Timer() {
    this.timers = new Hashtable<String, Long>();
  }
  
  public void setTimer(String name, long delayms) {
    if (!this.timers.containsKey(name))
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
  public boolean onCamera;
  public boolean onPhone;
  
  public Cube(int x, int y, int number) {
    this.x = x;
    this.y = y;
    this.number = number;
    onCamera = false;
    onCamera = false;
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
      }
      else {
        PVector[] cornerPositions = nya.getMarkerVertex2D(i);
        PVector centerPosition = new PVector(0, 0);
        for (int j = 0; j < cornerPositions.length; ++j) {
          PVector cornerPosition = cornerPositions[j];
          centerPosition.add(cornerPosition);
        }
        centerPosition.mult(0.25);
        list.get(i).onCamera = true;
        list.get(i).x = (int)centerPosition.x;
        list.get(i).y = (int)centerPosition.y;
        
      }
    }
  }
  
  public Cube getCube(int i) {
    return this.list.get(i);  
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
  
  public ModeButton(int x, int y, String text) {
    this.x = x;
    this.y = y;
    this.text = text;
    this.width = 300;
    this.height = 150;
    this.radius = 7;
  }
  
  public void drawButton() {
    fill(31, 181, 183);
    rect(this.x, this.y, this.width, this.height, this.radius);
    fill(255);
    
    text(this.text, this.x+150, this.y+67);
  }
}