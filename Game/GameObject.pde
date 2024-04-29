// This is the main object of the game which is subclassed to create 
//real game objects (players, Items etc.)
abstract class GameObject {
  PVector location;
  PImage currentImage;
  float objectWidth;
  float objectHeight;
  
  /* Create a Game Object with height, width, and X Y coordinates. */
  public GameObject(float x, float y, float objectWidth, float objectHeight) {
    this.location=new PVector(x, y);
    this.objectWidth=objectWidth;
    this.objectHeight=objectHeight;
  }
}
