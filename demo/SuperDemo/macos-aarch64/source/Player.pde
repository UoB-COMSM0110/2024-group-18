class Player{
  PVector location;
  PVector velocity;
  PVector accelarate;
  
  float speed;
  float strength;
  float hpPoint; 
  float skillCooldown;
  
  PImage idle[];
  PImage idleLeft[];
  PImage leftRun[];
  PImage rightRun[];
  PImage chronoJump[];
  PImage currentAnimation[];
  PImage image;
  
  int index;
  int skillIndex;
  boolean canJump;
  float friction;
  int frame;
  boolean faceRight;
  boolean skillFlag;
  boolean castFlag;
  
  float collisonTop;
  boolean hpProtect;
  float protectSecond;
  
  float playerWidth=22;
  float playerHeight=26;
  
  boolean platformTouched;

  
  public Player(){
    location=new PVector(width/2,height/2-100); // born in the middle air of screen
    velocity=new PVector(0,0);
    accelarate=new PVector(0,.32);
    
    speed=2;
    strength=10;
    hpPoint=3;
    index=0;
    skillIndex=0;
    friction=0.3;
    frame=0;
    faceRight=true;
    skillCooldown=10;
    skillFlag=false;
    castFlag=false;
    hpProtect=false;
    protectSecond=20;
    platformTouched=false;


    
    idle=new PImage[1];
    idle[0]=loadImage("./assets/run/Run_0.gif");
    idleLeft=new PImage[1];
    idleLeft[0]=loadImage("./assets/run/RunToLeft_11.gif");
    
    leftRun=new PImage[12];
    leftRun[0]=loadImage("./assets/run/RunToLeft_11.gif");
    leftRun[1]=loadImage("./assets/run/RunToLeft_10.gif");
    leftRun[2]=loadImage("./assets/run/RunToLeft_9.gif");
    leftRun[3]=loadImage("./assets/run/RunToLeft_8.gif");
    leftRun[4]=loadImage("./assets/run/RunToLeft_7.gif");
    leftRun[5]=loadImage("./assets/run/RunToLeft_6.gif");
    leftRun[6]=loadImage("./assets/run/RunToLeft_5.gif");
    leftRun[7]=loadImage("./assets/run/RunToLeft_4.gif");
    leftRun[8]=loadImage("./assets/run/RunToLeft_3.gif");
    leftRun[9]=loadImage("./assets/run/RunToLeft_2.gif");
    leftRun[10]=loadImage("./assets/run/RunToLeft_1.gif");
    leftRun[11]=loadImage("./assets/run/RunToLeft_0.gif");
    
    rightRun=new PImage[12];
    rightRun[0]=loadImage("./assets/run/Run_0.gif");
    rightRun[1]=loadImage("./assets/run/Run_1.gif");
    rightRun[2]=loadImage("./assets/run/Run_2.gif");
    rightRun[3]=loadImage("./assets/run/Run_3.gif");
    rightRun[4]=loadImage("./assets/run/Run_4.gif");
    rightRun[5]=loadImage("./assets/run/Run_5.gif");
    rightRun[6]=loadImage("./assets/run/Run_6.gif");
    rightRun[7]=loadImage("./assets/run/Run_7.gif");
    rightRun[8]=loadImage("./assets/run/Run_8.gif");
    rightRun[9]=loadImage("./assets/run/Run_9.gif");
    rightRun[10]=loadImage("./assets/run/Run_10.gif");
    rightRun[11]=loadImage("./assets/run/Run_11.gif");
    
    chronoJump=new PImage[7];
    chronoJump[0]=loadImage("./assets/chronoJump/Desappearing-(96x96)_01.gif");
    chronoJump[1]=loadImage("./assets/chronoJump/Desappearing-(96x96)_02.gif");
    chronoJump[2]=loadImage("./assets/chronoJump/Desappearing-(96x96)_03.gif");
    chronoJump[3]=loadImage("./assets/chronoJump/Desappearing-(96x96)_04.gif");
    chronoJump[4]=loadImage("./assets/chronoJump/Desappearing-(96x96)_05.gif");
    chronoJump[5]=loadImage("./assets/chronoJump/Desappearing-(96x96)_06.gif");
    chronoJump[6]=loadImage("./assets/chronoJump/Desappearing-(96x96)_07.gif");
    
    currentAnimation=idle;
  }
  
  public void updateAnimation(){
    if(skillFlag){
      castSkill();
    }else{
      selectFacing();
    }
    displayImage();
  }
  
  public void selectFacing(){
    if(velocity.x>0){
      faceRight=true;
      currentAnimation=rightRun;
    }else if(velocity.x<0){
      faceRight=false;
      currentAnimation=leftRun;
    }else{
      index=0;
      if(faceRight){
        currentAnimation=idle;
      }else{
        currentAnimation=idleLeft;
      }
      
    }
  }
  
  public void displayImage(){
    if(frame%6==0){
      image=currentAnimation[index];
      if(skillFlag&&index>=currentAnimation.length-1){
        skillFlag=false;
        castFlag=true;
      }
      index=(index+1)%currentAnimation.length;
      skillCooldown-=1;
      if(skillCooldown<0){
        skillCooldown=0;
      }
    }
    frame++; 
  }
  
  public void castSkill(){
      currentAnimation=chronoJump;
  }
  
  public void checkLaserCollision(Laser laser){
     if(location.x-16<laser.location.x+laser.laserLength&&
     location.x+16>laser.location.x&&
     location.y-16<laser.location.y+laser.laserHeight&&
     location.y+16>laser.location.y&&hpProtect==false){
       hpPoint--;
       hpProtect=true;
     }
     if(hpProtect){
       protectSecond--;
     }
     if(protectSecond==0){
       hpProtect=false;
       protectSecond=100;
     }
  }
  
  
  
  
  
  
  
  
}
