// Generating the map and drawing the static items.
import java.util.List;

class Map {
  String[] map;
  List<Item> staticItems = new ArrayList<>();
  List<Item> dynamicItems = new ArrayList<>();
  PImage[] bgSet = new PImage[6];

  boolean needResetFrame=false;
  int index=0;
  int frame=0;
  // only used for the exit door
  String[] currentAnimation;
  boolean ifBombInverse=false;

  Bomb bomb;

  HashMap bombList = new HashMap<>();

  public Map(String mapName) {
    map = loadStrings(mapName);
  }
  
  public void freshBomb(){
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
     if(bombList.containsKey(time)){
       PVector location = (PVector)bombList.get(time);
       bombList.remove(time);
       bomb.location.set(location);
       bomb.isOnGround=true;
     } 
     if(bomb.isOnGround){
       bomb.deExplode();
     }else{
       bomb.location.add(0,-bomb.speed);
      
     }
     
     
    }
  }

  public void clearMap() {
    staticItems.clear();
    dynamicItems.clear();
    index=0;
    frame=0;
  }
  /*
   I changed width and height from int to float, which would be more accurate to place in map
   Buttons, doors should be stored in dynamic items to check trigger more efficiently
   */
  public void generateMap() {
    for (int i=0; i<map.length; i++) {
      // TODO: there's a LOT of duplicative code here. Consider how to handle it.
      // TODO: make the numbers ENUMs so this is more readable.
      for (int j=0; j<map[i].length(); j++) {
        // platforms
        if (map[i].charAt(j)>='1'&&map[i].charAt(j)<='6') {
          float w=40;
          float h=40;
          Item item = new Item(map[i].charAt(j)-'0', j*w+w/2, i*h+h/2, w, h, w, h, true, false, false);
          staticItems.add(item);
          // doors
        } else if (map[i].charAt(j)=='7') {
          float w=240;
          float h=240;
          float cellWidth = 40;
          float cellHeight = 43.5; // for some reason 40 here resulted in the object being placed too low... Not sure why.
          // these offsets exist because when you scale an object above the 40x40 size, the co-ordinates start to get messed up.
          float offsetX = (w - cellWidth) / 2;
          float offsetY = (h - cellHeight) / 2;
          Item item = new Item(map[i].charAt(j)-'0', (j*cellWidth) - offsetX, (i*cellHeight) - offsetY, 80, h, w, h, true, false, false);
          item.setCurrentImage("./assets/Static/Door/door1.png");
          //staticItems.add(item);
          dynamicItems.add(item);
        }
        // buttons
        else if (map[i].charAt(j)=='8') {
          float w=80;
          float h=80;
          float cellWidth = 40;
          float cellHeight = 42.5; //  weirdly 40 works perfectly here...
          float offsetX = (w - cellWidth) / 2;
          float offsetY = (h - cellHeight) / 2;
          Item item = new Item(map[i].charAt(j)-'0', (j*cellWidth) - offsetX, (i*cellHeight) - offsetY, 50, h, w, h, true, false, false);
          item.setCurrentImage("./assets/Static/Button/button1.gif");
          //staticItems.add(item);
          dynamicItems.add(item);
        }
        // time machine
        else if (map[i].charAt(j)=='9') {
          float w=200;
          float h=200;
          int cellWidth = 40;
          int cellHeight = 44; // for some reason 40 here resulted in the object being placed too low... Not sure why.
          float offsetX = (w - cellWidth) / 2;
          float offsetY = (h - cellHeight) / 2;
          Item item = new Item(map[i].charAt(j)-'0', (j*cellWidth) - offsetX, (i*cellHeight) - offsetY, 80, h, w, h, true, false, false);
          item.setCurrentImage("./assets/Static/TimeMachine/time1.png");
          //staticItems.add(item);
          dynamicItems.add(item);
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

  public void displayMap(int level) {
    displayStaticItems(level);
    displayDynamicItems();
  }
  /*
  In this function only have items which can't move or trigger and will be changed based on level
   */
  public void displayStaticItems(int level) {
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
      image(bgSet[item.itemNum-1], item.location.x, item.location.y, item.imageWidth, item.imageHeight);
      //}
    }
  }
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
