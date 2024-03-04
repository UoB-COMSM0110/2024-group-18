// Include every attributtes needed for item
class Item extends GameObject {
  boolean ifStatic;
  boolean ifHurt; // TODO: we should clean up unused parameters.
  boolean ifTriggered;
  boolean situation;
  int itemNum;
  
  int index=0;
  int frame=0;
  PImage[] onAnimation;
  PImage[] offAnimation;
  PImage[] currentAnimation;

  public Item(int itemNum, float x, float y, float objectWidth, float objectHeight,
    boolean ifStatic, boolean ifHurt, boolean ifTriggered) {
    super(x, y, objectWidth, objectHeight);
    this.itemNum = itemNum;
    this.ifStatic = ifStatic;
    this.ifHurt = ifHurt;
    this.ifTriggered = ifTriggered;
    situation=false;
    
    if(itemNum==8){
      // add button animation
      onAnimation=new PImage[4];
      onAnimation[0]=loadImage("./assets/Static/Button/button1.gif");
      onAnimation[1]=loadImage("./assets/Static/Button/button2.gif");
      onAnimation[2]=loadImage("./assets/Static/Button/button3.gif");
      onAnimation[3]=loadImage("./assets/Static/Button/button4.gif");
      offAnimation=new PImage[4];
      offAnimation[0]=loadImage("./assets/Static/Button/button4.gif");
      offAnimation[1]=loadImage("./assets/Static/Button/button3.gif");
      offAnimation[2]=loadImage("./assets/Static/Button/button2.gif");
      offAnimation[3]=loadImage("./assets/Static/Button/button1.gif");
    }
  }
  
  public void setCurrentImage(String image){
    this.currentImage=loadImage(image);
  }
  
  public void checkTriggerAnimation(){
    if(itemNum==8){
      // button
      selectButtonStatus();
      displayButtonImage();
    }
  }
  
  public void selectButtonStatus(){
    if(ifTriggered){
      currentAnimation=onAnimation;
    }else{
      currentAnimation=offAnimation;
    }
  }
  
  public void displayButtonImage(){
    if(frame%2==0){
      currentImage=currentAnimation[index];
      index++;
      if(index>=currentAnimation.length){
        index=currentAnimation.length-1;
      }
    }
    frame++;
  }

  // for debugging
  public String toString() {
    return " x= "+ this.location.x +
      " y= "+ this.location.y +  " item num= "+ this.itemNum + " height= "+
      this.objectHeight +  " width= "+ this.objectWidth;
  }

  public void setSituation(boolean f) {
    situation=f;
  }
}
