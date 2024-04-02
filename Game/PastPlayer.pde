import java.util.*;

class PastPlayer extends GameObject {
  LinkedList<PVector> locationCollection;
  boolean ifShow=false;

  int listFrame=0;

  public PastPlayer(float x, float y, float objectWidth, float objectHeight) {
    super(x, y, objectWidth, objectHeight);
    locationCollection = new LinkedList<>();
    currentImage = loadImage("./assets/Player/run/Run_0.gif");
  }

  public void storeLocation(PVector location) {
    if (listFrame%2==0) {
      locationCollection.push(new PVector(location.x,location.y));
    }
    listFrame++;
  }

  public void releaseLocation() {
    if (listFrame%2==0&&locationCollection.size()>0) {
      PVector location = locationCollection.pop();
      this.location.set(location);
    }
    listFrame++;
  }
  
  public void refresh(){
    locationCollection.clear();
  }
}
