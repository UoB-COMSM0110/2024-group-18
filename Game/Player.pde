class Player extends GameObject{
  PVector velocity;
  PVector acceleration;
  boolean ifCanJump;
  float speed=1.5;
  
  public Player(){
    super(100,500,50,50);
    currentImage = loadImage("./assets/run/Run_0.gif");
    velocity = new PVector(0,0);
    acceleration = new PVector(0,0);
    ifCanJump=true;
  }

}
