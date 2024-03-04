// Include every attributes needed for player
class Player extends GameObject {
  PVector velocity;
  PVector acceleration;
  boolean isOnGround;
  float speed = 9.0;
  boolean facingRight;
  boolean isJumping;
  float gravity = 2;
  float jumpPower = -30;
  float jumpDirectionalSpeed = 10.0;
  float airControl = 5.0;

  int index=0;
  int frame=0;
  PImage[] idleLeft = new PImage[11];
  PImage[] idleRight = new PImage[11];
  PImage[] runLeft = new PImage[12];
  PImage[] runRight = new PImage[12];
  PImage[] jumpLeft = new PImage[1];
  PImage[] jumpRight = new PImage[1];
  PImage[] fallLeft = new PImage[1];
  PImage[] fallRight = new PImage[1];
  PImage[] disappear = new PImage[7];
  PImage[] current_animation;

  public Player() {
    super(120, 500, 60, 60);
    currentImage = loadImage("./assets/Player/run/Run_0.gif");
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    isOnGround = true;
    facingRight = true;

    idleLeft[0]=loadImage("./assets/Player/idle/idleleft_01.gif");
    idleLeft[1]=loadImage("./assets/Player/idle/idleleft_02.gif");
    idleLeft[2]=loadImage("./assets/Player/idle/idleleft_03.gif");
    idleLeft[3]=loadImage("./assets/Player/idle/idleleft_04.gif");
    idleLeft[4]=loadImage("./assets/Player/idle/idleleft_05.gif");
    idleLeft[5]=loadImage("./assets/Player/idle/idleleft_06.gif");
    idleLeft[6]=loadImage("./assets/Player/idle/idleleft_07.gif");
    idleLeft[7]=loadImage("./assets/Player/idle/idleleft_08.gif");
    idleLeft[8]=loadImage("./assets/Player/idle/idleleft_09.gif");
    idleLeft[9]=loadImage("./assets/Player/idle/idleleft_10.gif");
    idleLeft[10]=loadImage("./assets/Player/idle/idleleft_11.gif");

    idleRight[0]=loadImage("./assets/Player/idle/idleright_01.gif");
    idleRight[1]=loadImage("./assets/Player/idle/idleright_02.gif");
    idleRight[2]=loadImage("./assets/Player/idle/idleright_03.gif");
    idleRight[3]=loadImage("./assets/Player/idle/idleright_04.gif");
    idleRight[4]=loadImage("./assets/Player/idle/idleright_05.gif");
    idleRight[5]=loadImage("./assets/Player/idle/idleright_06.gif");
    idleRight[6]=loadImage("./assets/Player/idle/idleright_07.gif");
    idleRight[7]=loadImage("./assets/Player/idle/idleright_08.gif");
    idleRight[8]=loadImage("./assets/Player/idle/idleright_09.gif");
    idleRight[9]=loadImage("./assets/Player/idle/idleright_10.gif");
    idleRight[10]=loadImage("./assets/Player/idle/idleright_11.gif");

    runLeft[0]=loadImage("./assets/Player/run/RunToLeft_0.gif");
    runLeft[1]=loadImage("./assets/Player/run/RunToLeft_1.gif");
    runLeft[2]=loadImage("./assets/Player/run/RunToLeft_2.gif");
    runLeft[3]=loadImage("./assets/Player/run/RunToLeft_3.gif");
    runLeft[4]=loadImage("./assets/Player/run/RunToLeft_4.gif");
    runLeft[5]=loadImage("./assets/Player/run/RunToLeft_5.gif");
    runLeft[6]=loadImage("./assets/Player/run/RunToLeft_6.gif");
    runLeft[7]=loadImage("./assets/Player/run/RunToLeft_7.gif");
    runLeft[8]=loadImage("./assets/Player/run/RunToLeft_8.gif");
    runLeft[9]=loadImage("./assets/Player/run/RunToLeft_9.gif");
    runLeft[10]=loadImage("./assets/Player/run/RunToLeft_10.gif");
    runLeft[11]=loadImage("./assets/Player/run/RunToLeft_11.gif");

    runRight[0]=loadImage("./assets/Player/run/Run_0.gif");
    runRight[1]=loadImage("./assets/Player/run/Run_1.gif");
    runRight[2]=loadImage("./assets/Player/run/Run_2.gif");
    runRight[3]=loadImage("./assets/Player/run/Run_3.gif");
    runRight[4]=loadImage("./assets/Player/run/Run_4.gif");
    runRight[5]=loadImage("./assets/Player/run/Run_5.gif");
    runRight[6]=loadImage("./assets/Player/run/Run_6.gif");
    runRight[7]=loadImage("./assets/Player/run/Run_7.gif");
    runRight[8]=loadImage("./assets/Player/run/Run_8.gif");
    runRight[9]=loadImage("./assets/Player/run/Run_9.gif");
    runRight[10]=loadImage("./assets/Player/run/Run_10.gif");
    runRight[11]=loadImage("./assets/Player/run/Run_11.gif");

    jumpLeft[0]=loadImage("./assets/Player/jump&fall/JumpLeft.png");
    jumpRight[0]=loadImage("./assets/Player/jump&fall/JumpRight.png");
    fallLeft[0]=loadImage("./assets/Player/jump&fall/FallLeft.png");
    fallRight[0]=loadImage("./assets/Player/jump&fall/FallRight.png");
  }

  public void updateAnimation() {
    selectStatus();
    displayImage();
  }

  public void selectStatus() {
    if (velocity.x>0) {
      facingRight=true;
      if (velocity.y>0) {
        index=0;
        current_animation=fallRight;
      } else if (velocity.y<0) {
        index=0;
        current_animation=jumpRight;
      } else {
        current_animation=runRight;
      }
    } else if (velocity.x<0) {
      facingRight=false;
      if (velocity.y>0) {
        index=0;
        current_animation=fallLeft;
      } else if (velocity.y<0) {
        index=0;
        current_animation=jumpLeft;
      } else {
        current_animation=runLeft;
      }
    } else {
      // v=0
      if (velocity.y>0) {
        index=0;
        current_animation=facingRight?fallRight:fallLeft;
      } else if (velocity.y<0) {
        index=0;
        current_animation=facingRight?jumpRight:jumpLeft;
      } else {
        if (index>=idleLeft.length) {
          index=0;
        }
        current_animation=facingRight?idleRight:idleLeft;
      }
    }
  }

  public void displayImage() {
    if (frame%2==0) {
      currentImage=current_animation[index];
      index=(index+1)%current_animation.length;
    }
    frame++;
  }

  public void applyGravity() {
    if (!this.isOnGround) {
      this.acceleration.y = this.gravity;
    } else {
      this.acceleration.y = 0;
    }
  }
}
