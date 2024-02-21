class Player extends GameObject {

  float speed;
  float strength;
  float hpPoint;
  float skillCooldown;
  boolean canJump;
  boolean skillFlag;

  PImage idle[];
  PImage idleLeft[];
  PImage leftRun[];
  PImage rightRun[];
  PImage chronoJump[];
  PImage currentAnimation[];

  public Player() {
    location = new PVector(width / 2, height / 2 - 100); // born in the middle air of screen
    velocity = new PVector(0, 0);
    accelarate = new PVector(0, .32);

    idle = new PImage[1];
    idle[0] = loadImage("./assets/run/Run_0.gif");
    image = idle[0];
    canJump = true;
  }

  public void changeLocation() {
    player.velocity.add(player.accelarate);
    
    // todo: I think this would let players briefly go out of bounds while this method calculates?
    player.location.add(this.velocity);
    if (player.location.y>=height-40) {
      player.location.y = height-40;
    }
  }
  
}
