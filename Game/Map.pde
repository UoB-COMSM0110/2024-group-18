// Generating the map and drawing the static items.
import java.util.List;

class Map {
  String[] map;
  List<Item> staticItems = new ArrayList<>();
  List<Item> dynamicItems = new ArrayList<>();
  PImage[] bgSet = new PImage[6];

  public Map(String mapName) {
    map = loadStrings(mapName);
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
          Item item = new Item(map[i].charAt(j)-'0', j*w+w/2, i*h+h/2,w,h, w, h, true, false, false);
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
          Item item = new Item(map[i].charAt(j)-'0', (j*cellWidth) - offsetX, (i*cellHeight) - offsetY,w,h, w, h, true, false, false);
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
          Item item = new Item(map[i].charAt(j)-'0', (j*cellWidth) - offsetX, (i*cellHeight) - offsetY, w,h,w, h, true, false, false);
          item.setCurrentImage("./assets/Static/Button/button1.gif");
          //staticItems.add(item);
          dynamicItems.add(item);

        }
        // time machine
        else if (map[i].charAt(j)=='9') {
          float w=200;
          float h=200;
          int cellWidth = 40;
          int cellHeight = 43; // for some reason 40 here resulted in the object being placed too low... Not sure why.
          float offsetX = (w - cellWidth) / 2;
          float offsetY = (h - cellHeight) / 2;
          Item item = new Item(map[i].charAt(j)-'0', (j*cellWidth) - offsetX, (i*cellHeight) - offsetY,80,h, w, h, true, false, false);
          item.setCurrentImage("./assets/Static/TimeMachine/time1.png");
          //staticItems.add(item);
          dynamicItems.add(item);
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
      
    }
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
  public void displayDynamicItems(){
    for(int i=0;i<dynamicItems.size();i++){
      Item item = dynamicItems.get(i);
      item.checkTriggerAnimation();
      image(item.currentImage,item.location.x,item.location.y,item.imageWidth,item.imageHeight);
      
  }
}
}
