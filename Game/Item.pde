// Include every attributtes needed for item
class Item extends GameObject {
  boolean ifStatic;
  boolean ifHurt; // TODO: we should clean up unused parameters.
  boolean ifTriggered;
  boolean situation;
  int itemNum;

  public Item(int itemNum, float x, float y, float objectWidth, float objectHeight,
    boolean ifStatic, boolean ifHurt, boolean ifTriggered) {
    super(x, y, objectWidth, objectHeight);
    this.itemNum = itemNum;
    this.ifStatic = ifStatic;
    this.ifHurt = ifHurt;
    this.ifTriggered = ifTriggered;
    situation=false;
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
