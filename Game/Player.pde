// Include every attributes needed for player
class Player extends GameObject{
  PVector velocity;
  PVector acceleration;
  boolean ifCanJump;
  float speed=10;
  // facing right is true, facing left is false
  boolean facing;
  
  public Player(){
    super(100,500,60,60);
    currentImage = loadImage("./assets/Player/run/Run_0.gif");
    velocity = new PVector(0,0);
    acceleration = new PVector(0,0);
    ifCanJump=true;
    facing = true;
  }

}
