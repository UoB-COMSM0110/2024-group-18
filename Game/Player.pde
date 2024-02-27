// Include every attributes needed for player
class Player extends GameObject{
  PVector velocity;
  PVector acceleration;
  boolean isOnGround;
  float speed = 9.0;
  // facing right is true, facing left is false
  boolean facingRight;
  float gravity = 7.5;
  float jumpPower = -15;
  float jumpDirectionalSpeed;
  float airControl = 0.4;
  
  public Player(){
    super(100,500,60,60);
    currentImage = loadImage("./assets/Player/run/Run_0.gif");
    velocity = new PVector(0,0);
    acceleration = new PVector(0,0);
    isOnGround = true;
    facingRight = true;
  }
  
  public void applyGravity() {
    if(!this.isOnGround) {
      this.velocity.y += this.gravity;
    }
  }

}
