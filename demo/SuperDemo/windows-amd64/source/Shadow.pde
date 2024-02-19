class Shadow{
  PVector location;
  PVector locationRecord[];
  int index;
  int frame;
  PImage image;
  
  public Shadow(){
    location=new PVector(width/2,height/2-100);
    locationRecord=new PVector[5];
    
    index=0;
    
    image=loadImage("./assets/chronoJump/Desappearing-(96x96)_01.gif");
  }
  public void updateLocation(PVector data){
    if(frame%30==0){
      locationRecord[index]=new PVector(data.x,data.y);
      if(index==locationRecord.length-1){
        location.set(data.x,data.y);
      }
      index=(index+1)%locationRecord.length;
    }
    frame++;
  }
  
  
}
