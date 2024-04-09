import java.util.*;

class PastPlayer extends GameObject {
  LinkedList<PreviousState> stateCollection;
  boolean ifShow=false; // this is used to determine whether to show previous player iteration (i.e. when they touch time machine)
  int listFrame=0;

  public PastPlayer(float x, float y, float objectWidth, float objectHeight) {
    super(x, y, objectWidth, objectHeight);
    stateCollection = new LinkedList<>();
    currentImage = loadImage("./assets/Player/run/Run_0.gif");
  }

  public void storeState(PVector location, PImage animation) {
    if (listFrame%  2 == 0) { // used to perform an action on every even numbered frame
      stateCollection.push(new PreviousState(new PVector(location.x, location.y), animation));
    }
    listFrame++;
  }

  public void accessPastState() {
    if (listFrame%2==0 && stateCollection.size()>0) {
      PreviousState pastState = stateCollection.pop();
      this.location.set(pastState.location);
      this.currentImage = pastState.animation;
    }
    listFrame++;
  }
  
  public void refresh(){
    stateCollection.clear();
  }
}
