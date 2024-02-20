class Item extends GameObject{
  boolean ifStatic;
  boolean ifHurt;
  boolean ifTriggered;
  
  public Item(float x,float y,float objectWidth,float objectHeight,
  boolean ifStatic, boolean ifHurt, boolean ifTriggered){
    super(x,y,objectWidth,objectHeight);
    this.ifStatic = ifStatic;
    this.ifHurt = ifHurt;
    this.ifTriggered = ifTriggered;
  }
  
}
