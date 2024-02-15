class Platform{
  PVector location;
  float platformWidth;
  float platformHeight;
  
  public Platform(){
    float x=random(100,  400);
    float y=random(150,height/2-50);
    location=new PVector(x,y);
    platformWidth=random(100,200);
    platformHeight=20;
  }
  
  

}
