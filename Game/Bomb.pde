class Bomb extends GameObject {
  float speed=8;
  PVector velocity= new PVector(0, speed);
  boolean isOnGround=false;
  float explodeTime=30;

  PImage explode[] = new PImage[8];
  int index=0;
  int deIndex=explode.length-1;
  int frame=0;

  /* Creates a new bomb object with an X coordinate - creates images for animation.  */
  public Bomb(float x) {
    super(x, 0, 60, 80);
    this.currentImage=loadImage("./assets/Dynamic/bomb.png");
    for (int i=1; i<=8; i++) {
      explode[i-1]=loadImage("./assets/Dynamic/explode"+i+".png");
    }
  }

  /* Resets the bomb position.  */
  public void reset() {
    currentImage=loadImage("./assets/Dynamic/bomb.png");
    float left_edge = 150;
    float right_edge = 200;
    float x = left_edge+((float)Math.random()*(width-100-right_edge));
    location.set(x+50, 0);
    velocity.y=speed;
  }

  /* Triggers the de-explosion animation.*/
  public boolean deExplode() {
    if (frame%3==0) {

      deIndex--;
      if (deIndex<0) {
        deIndex=explode.length-1;
        isOnGround=false;
        currentImage=loadImage("./assets/Dynamic/bomb.png");
        return true;
      }
      currentImage=explode[deIndex];
    }
    frame++;
    return false;
  }

  /* Triggers the explosion animation.*/
  public boolean explode() {
    if (frame%3==0) {
      index++;
      if (index>=explode.length) {
        index=0;
        return true;
      }
      currentImage=explode[index];
    }
    frame++;
    return false;
  }

  /* Checks if the object collides with another object.*/
  public boolean checkCollision(GameObject obj) {
    if (location.x-objectWidth/2<obj.location.x+obj.objectWidth/2&&
      location.x+objectWidth/2>obj.location.x-obj.objectWidth/2&&
      location.y-objectHeight/2<obj.location.y+obj.objectHeight/2&&
      location.y+objectHeight/2>obj.location.y-obj.objectHeight/2) {
      // colliding
      return true;
    }
    // no collision
    return false;
  }

  /* Places the bomb in relation to the given object. */
  public void setBombLocation(GameObject obj) {
    // on platform
    if (location.y+objectHeight/2>obj.location.y-obj.objectHeight/2&&velocity.y>=0) {
      location.set(location.x, obj.location.y-obj.objectHeight/2-objectHeight/2);
      velocity.set(0, 0);
      isOnGround=true;
    }
  }
}
