class Bomb extends GameObject {
  float speed=8;
  PVector velocity= new PVector(0, speed);
  boolean isOnGround=false;
  float explodeTime=30;

  PImage explode[] = new PImage[8];
  int index=0;
  int deIndex=explode.length-1;
  int frame=0;

  public Bomb(float x) {
    super(x, 0, 60, 80);
    this.currentImage=loadImage("./assets/Dynamic/bomb.png");

    explode[0]=loadImage("./assets/Dynamic/explode1.png");
    explode[1]=loadImage("./assets/Dynamic/explode2.png");
    explode[2]=loadImage("./assets/Dynamic/explode3.png");
    explode[3]=loadImage("./assets/Dynamic/explode4.png");
    explode[4]=loadImage("./assets/Dynamic/explode5.png");
    explode[5]=loadImage("./assets/Dynamic/explode6.png");
    explode[6]=loadImage("./assets/Dynamic/explode7.png");
    explode[7]=loadImage("./assets/Dynamic/explode8.png");
  }

  public void reset() {
    currentImage=loadImage("./assets/Dynamic/bomb.png");
    float x = (float)Math.random()*(width-100);
    location.set(x+50, 0);
    velocity.y=speed;
  }

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



  public boolean checkCollision(GameObject obj) {

    if (location.x-objectWidth/2<obj.location.x+obj.objectWidth/2&&
      location.x+objectWidth/2>obj.location.x-obj.objectWidth/2&&
      location.y-objectHeight/2<obj.location.y+obj.objectHeight/2&&
      location.y+objectHeight/2>obj.location.y-obj.objectHeight/2) {
      // colliding
      return true;
    }
    return false; // no collision
  }

  public void setBombLocation(GameObject obj) {
    // on platform
    if (location.y+objectHeight/2>obj.location.y-obj.objectHeight/2&&velocity.y>=0) {
      location.set(location.x, obj.location.y-obj.objectHeight/2-objectHeight/2);
      velocity.set(0, 0);
      isOnGround=true;
    }
  }
}
