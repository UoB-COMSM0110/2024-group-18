// Generating the map and drawing the static items.
import java.util.List;

class Map {
  String[] map;
  List<Item> staticItems = new ArrayList<>();
  List<Item> dynamicItems = new ArrayList<>();
  PImage[] bgSet = new PImage[6];
  PImage[] mpSet = new PImage[3];

  boolean needResetFrame=false;
  int index=0;
  int frame=0;
  // only used for the exit door
  String[] currentAnimation;
  boolean ifBombInverse=false;
  int level;

  Bomb bomb;

  HashMap bombList = new HashMap<>();

  float mpSpeed = -5;

  public Map(String mapName, int level) {
    map = loadStrings(mapName);
    this.level = level;
  }

  public void freshBomb() {
    placeBomb();
    bombList.clear();
  }

  public void placeBomb() {
    float x = (float)Math.random()*(width-100);
    bomb=new Bomb(x+50);
  }

  public void displayBomb(float time) {
    image(bomb.currentImage, bomb.location.x, bomb.location.y, bomb.objectWidth, bomb.objectHeight);
    if (!ifBombInverse) {
      // normal display
      bomb.location.add(bomb.velocity);
      // falling down when touched ground
      for (Item item : staticItems) {
        if (bomb.checkCollision(item)) {
          bomb.setBombLocation(item);
        }
      }
      if (bomb.isOnGround) {
        // start explode process
        boolean f = bomb.explode();
        if (f) {
          bombList.put(time, new PVector(bomb.location.x, bomb.location.y));
          bomb.reset();
          bomb.isOnGround=false;
        }
      }
      // boundary check
      if (bomb.location.y>height) {
        bombList.put(time, new PVector(bomb.location.x, bomb.location.y));
        bomb.reset();
      }
    } else {
      // inverse display
      if (bombList.containsKey(time)) {
        PVector location = (PVector)bombList.get(time);
        bombList.remove(time);
        bomb.location.set(location);
        bomb.isOnGround=true;
      }
      if (bomb.isOnGround) {
        bomb.deExplode();
      } else {
        bomb.location.add(0, -bomb.speed);
      }
    }
  }

  public void clearMap() {
    staticItems.clear();
    dynamicItems.clear();
    index=0;
    frame=0;
  }

  // these 4 draw methods (items platforms, buttons, Time Machine)
  // are very similar. Potentially there's a way to improve this code to make simpler / shorter.
  private void drawDoor(int i, int j) {
    float w=240;
    float h=240;
    float cellWidth = 40;
    float cellHeight = 43.5;

    if (level==2) {
      w=200;
      h=200;
      cellWidth = 32;
      cellHeight = 53;
    }
    // these offsets exist because when you scale an object above the 40x40 size, the co-ordinates start to get messed up.
    float offsetX = (w - cellWidth) / 2;
    float offsetY = (h - cellHeight) / 2;
    Item item = new Item(map[i].charAt(j)-'0', (j*cellWidth) - offsetX, (i*cellHeight) - offsetY, 80, h, w, h, true, false, false);
    item.setCurrentImage("./assets/Static/Door/door1.png");
    dynamicItems.add(item);
  }

  private void drawPlatforms(int i, int j) {
    float w=40;
    float h=40;
    Item item = new Item(map[i].charAt(j)-'0', j*w+w/2, i*h+h/2, w, h, w, h, true, false, false);
    staticItems.add(item);
  }

  private void drawButtons(int i, int j) {
    float w=80;
    float h=80;
    float cellWidth = 40.5;
    float cellHeight = 45.5;
    if (level == 1) {
      cellWidth = 40;
      cellHeight = 50.5;
    }
    if (level==2) {
      cellHeight = 48;
    }
    float offsetX = (w - cellWidth) / 2;
    float offsetY = (h - cellHeight) / 2;
    Item item = new Item(map[i].charAt(j)-'0', (j*cellWidth) - offsetX, (i*cellHeight) - offsetY, 50, h, w, h, true, false, false);
    item.setCurrentImage("./assets/Static/Button/button1.gif");
    dynamicItems.add(item);
  }

  private void drawTimeMachine(int i, int j) {
    float w=200;
    float h=200;
    int cellWidth = 40;
    int cellHeight = 44;
    float offsetX = (w - cellWidth) / 2;
    float offsetY = (h - cellHeight) / 2;
    if (level==2) {
      cellHeight = 52;
    }
    if (level==3) {
      cellHeight = 43;
    }
    Item item = new Item(map[i].charAt(j)-'0', (j*cellWidth) - offsetX, (i*cellHeight) - offsetY, 80, h, w, h, true, false, false);
    item.setCurrentImage("./assets/Static/TimeMachine/time1.png");
    dynamicItems.add(item);
  }

  private void drawMovingPlatform(int i, int j) {
    float w=40;
    float h=40;
    int mpNum = 0;
    if (map[i].charAt(j) == 'l') {
      mpNum = 11;
    } else if (map[i].charAt(j) == 'm') {
      mpNum = 12;
    } else if (map[i].charAt(j) == 'r') {
      mpNum = 13;
    }
    Item item = new Item(mpNum, j*w+w/2, i*h+h/2, w, h, w, h, true, false, false);
    staticItems.add(item);
  }

  public void generateMap() {
    for (int i=0; i<map.length; i++) {
      for (int j=0; j<map[i].length(); j++) {
        if (map[i].charAt(j)>='1'&&map[i].charAt(j)<='6') {
          drawPlatforms(i, j);
        } else if (map[i].charAt(j)=='7') {
          drawDoor(i, j);
        } else if (map[i].charAt(j)=='8') {
          drawButtons(i, j);
        } else if (map[i].charAt(j)=='9') {
          drawTimeMachine(i, j);
        } else if (map[i].charAt(j)=='l' || map[i].charAt(j)=='m' || map[i].charAt(j)=='r') {
          drawMovingPlatform(i, j);
        }
      }
    }
  }

  public void loadDoorAnimation() {
    currentAnimation=new String[5];
    currentAnimation[0]="./assets/Static/Door/door1.png";
    currentAnimation[1]="./assets/Static/Door/door2.png";
    currentAnimation[2]="./assets/Static/Door/door3.png";
    currentAnimation[3]="./assets/Static/Door/door4.png";
    currentAnimation[4]="./assets/Static/Door/door5.png";
  }

  public void openDoor() {
    loadDoorAnimation();
    for (Item item : dynamicItems) {
      if (item.itemNum==7) {
        item.situation=true;
        item.setCurrentImage(currentAnimation[index]);
        index++;
        if (index>4) {
          index=4;
        }
      }
    }
  }


  public void closeDoor() {
    loadDoorAnimation();
    for (Item item : dynamicItems) {
      if (item.itemNum==7) {
        item.situation=false;
        item.setCurrentImage(currentAnimation[index]);
        index--;
        if (index<0) {
          index=0;
          item.setCurrentImage("./assets/Static/Door/door1.png");
        }
      }
    }
  }

  public void displayMap() {
    displayStaticItems();
    displayDynamicItems();
  }
  /*
  In this function only have items which can't move or trigger and will be changed based on level
   */
  public void displayStaticItems() {
    if (level==1) {
      // I wonder if it makes more sense for image URL to live in the currentImage bit of the GameObject?
      bgSet[0]=loadImage("./assets/Static/Grass1/grass1.gif");
      bgSet[1]=loadImage("./assets/Static/Grass1/grass2.gif");
      bgSet[2]=loadImage("./assets/Static/Grass1/grass3.gif");
      bgSet[3]=loadImage("./assets/Static/Grass1/grass4.gif");
      bgSet[4]=loadImage("./assets/Static/Grass1/grass5.gif");
      bgSet[5]=loadImage("./assets/Static/Grass1/grass6.gif");
    } else if (level==2) {
      bgSet[0]=loadImage("./assets/Static/Brick2/brick1.gif");
      bgSet[1]=loadImage("./assets/Static/Brick2/brick2.gif");
      bgSet[2]=loadImage("./assets/Static/Brick2/brick3.gif");
      bgSet[3]=loadImage("./assets/Static/Brick2/brick4.gif");
      bgSet[4]=loadImage("./assets/Static/Brick2/brick5.gif");
      bgSet[5]=loadImage("./assets/Static/Brick2/brick6.gif");
    } else if (level==3) {
      bgSet[0]=loadImage("./assets/Static/Brick2/brick1.gif");
      bgSet[1]=loadImage("./assets/Static/Brick2/brick2.gif");
      bgSet[2]=loadImage("./assets/Static/Brick2/brick3.gif");
      bgSet[3]=loadImage("./assets/Static/Brick2/brick4.gif");
      bgSet[4]=loadImage("./assets/Static/Brick2/brick5.gif");
      bgSet[5]=loadImage("./assets/Static/Brick2/brick6.gif");
      mpSet[0]=loadImage("./assets/Static/MovingPlatform/mp1.gif");
      mpSet[1]=loadImage("./assets/Static/MovingPlatform/mp2.gif");
      mpSet[2]=loadImage("./assets/Static/MovingPlatform/mp3.gif");
    }
    // do same with level 3
    // this logic should live somewhere else.
    //boolean buttonIsTriggered = false;
    for (int i=0; i<staticItems.size(); i++) {
      Item item = staticItems.get(i);

      //  if (item.ifTriggered == true) {
      //    buttonIsTriggered = true;
      //  }
      //if (buttonIsTriggered && item.itemNum==7) {
      //  PImage altDoor = loadImage("./assets/Static/Door/door5.png");
      //  image(altDoor, item.location.x, item.location.y, item.objectWidth, item.objectHeight);
      //} else {
      if (item.itemNum<=6) {
        image(bgSet[item.itemNum-1], item.location.x, item.location.y, item.imageWidth, item.imageHeight);
        //}
      } else {
        displayMovingPlatform(item);
      }
    }
    setMPlocation();
  }

  public void displayMovingPlatform(Item item) {
    int mpNum = item.itemNum - 11;
    image(mpSet[mpNum], item.location.x, item.location.y, item.imageWidth, item.imageHeight);
  }

  public void setMPlocation() {
    boolean ifSpeedChanged = false;
    for (Item item : staticItems) {
      if (item.itemNum >= 11 && item.itemNum <= 13) {
        if (ifMpCollide(item) && !ifSpeedChanged) {
          mpSpeed = -mpSpeed;
          ifSpeedChanged = true;
        }
        int index = staticItems.indexOf(item);
        Item updated = item;
        updated.location.x += mpSpeed;
        staticItems.set(index, updated);
      }
    }
  }

  public boolean ifMpCollide(Item item) {
    float left = item.location.x-item.objectWidth/2;
    float right = item.location.x+item.objectWidth/2;
    float top = item.location.y-item.objectHeight/2;
    float bottom = item.location.y+item.objectHeight/2;
    if (left < 0 || right > width) {
      return true;
    }
    for (Item platform : staticItems) {
      if (platform.itemNum<=6) {
        float pLeft = platform.location.x-platform.objectWidth/2;
        float pRight = platform.location.x+platform.objectWidth/2;
        float pTop = platform.location.y-platform.objectHeight/2;
        float pBottom = platform.location.y+platform.objectHeight/2;

        float overlapLeft = pRight - left;
        float overlapRight = right - pLeft;
        float overlapTop = pBottom - top;
        float overlapBottom = bottom - pTop;
        if (overlapLeft>0&&overlapRight>0&&overlapTop>0&&overlapBottom>0) {
          float minOverlap = min(overlapLeft, overlapRight, min(overlapTop, overlapBottom));
          if (minOverlap == overlapLeft&&mpSpeed<0) {
            return true;
          } else if (minOverlap == overlapRight&&mpSpeed>0) {
            return true;
          }
        }
      }
    }
    return false;
  }

  //public void mpLeftCollide(Item item) {
  //  int lIndex = staticItems.indexOf(item);
  //  Item curMP = staticItems.get(lIndex);
  //  Item updatedMP = null;
  //  while (curMP.itemNum>=11 && curMP.itemNum<=13) {
  //    curMP = staticItems.get(lIndex);
  //    updatedMP = curMP;
  //    updatedMP.location.x = updatedMP.location.x+mpSpeed;
  //    staticItems.set(lIndex, updatedMP);
  //    lIndex++;
  //  }
  //}
  /*
  This function has items won't change with levels, and has animation and special effect
   */
  public void displayDynamicItems() {
    for (int i=0; i<dynamicItems.size(); i++) {
      Item item = dynamicItems.get(i);
      item.checkTriggerAnimation();
      image(item.currentImage, item.location.x, item.location.y, item.imageWidth, item.imageHeight);
    }
  }
}
