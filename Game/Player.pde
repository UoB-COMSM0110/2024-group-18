// Include every attributes needed for player
class Player extends GameObject{
  PVector velocity;
  PVector acceleration;
  boolean isOnGround;
  float speed = 9.0;
  boolean facingRight;
  boolean movingRight;
  boolean movingLeft;
  boolean canJump;
  float gravity = 7.5;
  float jumpPower = -45;
  float jumpDirectionalSpeed = 10.0;
  float airControl = 5.0;
  
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
