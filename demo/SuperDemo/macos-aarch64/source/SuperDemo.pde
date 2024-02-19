Player player;
Shadow shadow;
Laser laser[]=new Laser[5];
float playTime=0;
Platform platform1;

void setup(){
  size(500,500);
  player=new Player();
  shadow=new Shadow();
  platform1=new Platform();

  for(int i=0;i<laser.length;i++){
    laser[i]=new Laser();
  }
}

void draw(){
  background(255);
  fill(205,133,63);
  rect(0,height/2+14,1000,100);
  
  PFont font=createFont("./assets/PressStart2P-Regular.ttf",20);
  textFont(font);
  text("Pixel Adventure",10,30);
  text("HP:"+(int)player.hpPoint,10,460);
  text(playTime+"ms",360,460);
  if(player.skillCooldown>0){
    text("Skill Cooldown:"+player.skillCooldown,10,480);
  }else{
    text("Skill Ready",10,480);
  }
  
  rect(platform1.location.x,platform1.location.y,platform1.platformWidth,platform1.platformHeight);
  
  imageMode(CENTER);
  shadow.updateLocation(player.location);
  image(shadow.image,shadow.location.x,shadow.location.y);
  player.updateAnimation();
  if(player.hpProtect){
    fill(166,205,231);
    stroke(166,205,231);
    ellipse(player.location.x,player.location.y,30,35);
  }
  image(player.image,player.location.x,player.location.y);

  
  
  
  player.velocity.add(player.accelarate);
  player.location.add(player.velocity);
  
  if(player.location.y>height/2){
    player.location.set(player.location.x,height/2);
    player.canJump=true;
  }
  
  if(player.castFlag){
    player.velocity.set(0,0);
    player.location.set(shadow.location.x,shadow.location.y);
    player.skillCooldown+=20; 
    player.castFlag=false;
  }
  
  fill(255,0,0);
  noStroke();
  for(int i=0;i<laser.length;i++){
    rect(laser[i].location.x,laser[i].location.y,laser[i].laserLength,laser[i].laserHeight);
    laser[i].location.add(laser[i].velocity.x,laser[i].velocity.y);
    player.checkLaserCollision(laser[i]);
    laser[i].checkOutOfBorder();
    if(laser[i].ifOut){
      laser[i]=new Laser();
      laser[i].ifOut=false;
    }
  }
  fill(0);
  if(player.hpPoint<=0){
    text("Game Over",width/2-90,height/2);
    text("Click mouse to restart",width/2-220,height/2+40);
  }
  if(player.hpPoint>0){
    playTime+=1;
  }
  
  checkPlatformCollision(player,platform1);
  if(player.location.y-player.playerHeight/2>platform1.location.y+platform1.platformHeight&&player.platformTouched){
      player.platformTouched=false;
    }
  // end of draw()
}

public void checkPlatformCollision(Player player,Platform platform){
  
  if(player.location.x-player.playerWidth/2<platform.location.x+platform.platformWidth&&
  player.location.x+player.playerWidth/2>platform.location.x&&
  player.location.y-player.playerHeight/2<platform.location.y+platform.platformHeight&&
  player.location.y+player.playerHeight/2>platform.location.y){
    // colliding
    text("collision test",100,100);
    if(player.location.y+player.playerHeight/2>platform.location.y&&player.velocity.y>=0){
      player.location.set(player.location.x,platform.location.y-player.playerHeight/2);
      player.velocity.set(player.velocity.x,0);
      player.canJump=true;
    }
    if(player.location.y-player.playerHeight/2<platform.location.y+platform.platformHeight&&!player.platformTouched&&
    player.velocity.y<0){
      player.location.set(player.location.x,platform.location.y+platform.platformHeight+player.playerHeight/2);
      player.velocity.set(player.velocity.x,0);
      player.platformTouched=true;
    } 
    
  }
}

void keyPressed(){
  boolean right=keyCode==RIGHT;
  boolean left=keyCode==LEFT;
  boolean up=keyCode==UP;
  boolean skill=key==' ';
  if(up&&right&&player.canJump){
    player.velocity.add(player.speed,-player.strength);
    player.canJump=false;
  }else if(up&&left&&player.canJump){
    player.velocity.add(-player.speed,-player.strength);
    player.canJump=false;
  }else if(skill){
    if(player.skillCooldown<=0){
      player.skillFlag=true; 
    }
  }else{
    if(up&&player.canJump){
      player.velocity.set(player.velocity.x,-player.strength);
      player.canJump=false;
    }
    if(right){
      player.velocity.set(player.speed,0);
    }
    if(left){
      player.velocity.set(-player.speed,0);
    }
  }
}

void keyReleased(){
  player.velocity.set(0,player.velocity.y);
  
}

void mouseClicked(){
  if(player.hpPoint<=0){
    player.hpPoint=3;
    playTime=0;
  }
}
