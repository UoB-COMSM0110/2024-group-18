class Laser{
  PVector location;
  PVector velocity;
  float laserLength=100;
  float laserHeight=5;
  boolean ifOut;
  float randomX;
  
  public Laser(){
    ifOut=false;
    randomX=random(0,1);
    if(randomX>0.5){
      location=new PVector(0,random(0,height/2));
      velocity=new PVector(random(1,3),0);
    }else{
      location=new PVector(width,random(0,height/2));
      velocity=new PVector(random(-3,-1),0);
    }
  }
  public void checkOutOfBorder(){
     if(randomX>0.5){
       if(location.x>=width+150){
         ifOut=true;
       }
     }else{
       if(location.x<-150){
         ifOut=true;
       }
     }
  }

}
