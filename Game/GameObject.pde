// Including basic attributes for all things
abstract class GameObject{
  PVector location;
  PImage currentImage;
  float objectWidth;
  float objectHeight;
  
  public GameObject(float x,float y, float objectWidth, float objectHeight){
    this.location=new PVector(x,y);
    this.objectWidth=objectWidth;
    this.objectHeight=objectHeight;
  }
}
