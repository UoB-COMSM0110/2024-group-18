PVector location;
PVector velocity;
PVector accelarate;

float diameter=60;

float friction=0.7;
float bounce=0.5;

boolean canJump=false;

void setup(){
  size(600,400);
  
  location=new PVector(300,200);
  velocity=new PVector(0,0);
  accelarate=new PVector(0,0.32);
}

void draw(){
  background(0);
  circle(location.x,location.y,diameter);
  
  velocity.add(accelarate);
  location.add(velocity);
  
  if(location.y+diameter/2>height){
    location.set(location.x,height-diameter/2);
    velocity.set(velocity.x*friction,-velocity.y*bounce);
    canJump=true;
  }
}

void keyPressed(){
  boolean right=keyCode==RIGHT;
  boolean left=keyCode==LEFT;
  boolean up=keyCode==UP;
  
  if(up&&right&&canJump){
    velocity.add(5,-10);
    canJump=false;
  }else if(up&&left&&canJump){
    velocity.add(-5,-10);
    canJump=false;
  }else{
    if(up&&canJump){
      velocity.add(0,-10);
      canJump=false;
    }
    if(right){
      velocity.add(5,0);
    }
    if(left){
      velocity.add(-5,0);
    }
  }

}
