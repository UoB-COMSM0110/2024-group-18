class Player extends GameObject{
  PVector velocity;
  PVector acceleration;
  boolean ifCanJump;
  int speed=2;
  
  public Player(){
    super(width/2,height/2,50,50);
    currentImage = loadImage("./assets/run/Run_0.gif");
    velocity = new PVector(0,0);
    acceleration = new PVector(0,0);
    ifCanJump=true;
  }

}
