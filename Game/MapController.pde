// Generating the map and drawing the static items.
import java.util.List;

class MapController {
  String[] map;
  List<Item> staticItems = new ArrayList<>();
  List<Item> dynamicItems = new ArrayList<>();
  PImage[] bgSet = new PImage[9];

  public MapController(String mapName) {
    map = loadStrings(mapName);
  }

  public void generateMap() {
    for (int i=0; i<map.length; i++) {
      // TODO: there's a LOT of duplicative code here. Consider how to handle it.
       // TODO: make the numbers ENUMs so this is more readable.
      for (int j=0; j<map[i].length(); j++) {
        // platforms
        if (map[i].charAt(j)>='1'&&map[i].charAt(j)<='6') {
          float w=40;
          float h=40;
          Item item = new Item(map[i].charAt(j)-'0', j*w, i*h, w, h, true, false, false);
          staticItems.add(item);
          // doors
        } else if (map[i].charAt(j)=='7') {
          float w=120;
          float h=120;
          int cellWidth = 40;
          int cellHeight = 39; // for some reason 40 here resulted in the object being placed too low... Not sure why.
          // these offsets exist because when you scale an object above the 40x40 size, the co-ordinates start to get messed up.
          float offsetX = (w - cellWidth) / 2;
          float offsetY = (h - cellHeight) / 2;
          Item item = new Item(map[i].charAt(j)-'0', (j*cellWidth) - offsetX, (i*cellHeight) - offsetY, w, h, true, false, false);
          staticItems.add(item);
        }
        // buttons
        else if (map[i].charAt(j)=='8') {
          float w=80;
          float h=80;
          int cellWidth = 40;
          int cellHeight = 40; //  weirdly 40 works perfectly here...
          float offsetX = (w - cellWidth) / 2;
          float offsetY = (h - cellHeight) / 2;
          Item item = new Item(map[i].charAt(j)-'0', (j*cellWidth) - offsetX, (i*cellHeight) - offsetY, w, h, true, false, false);
          staticItems.add(item);
        }
        // time machine
        else if (map[i].charAt(j)=='9') {
          float w=160;
          float h=160;
          int cellWidth = 40;
          int cellHeight = 39; // for some reason 40 here resulted in the object being placed too low... Not sure why.
          float offsetX = (w - cellWidth) / 2;
          float offsetY = (h - cellHeight) / 2;
          Item item = new Item(map[i].charAt(j)-'0', (j*cellWidth) - offsetX, (i*cellHeight) - offsetY, w, h, true, false, false);
          staticItems.add(item);
        }
      }
    }
  }

  public void displayMap(int level) {
    displayStaticItems(level);
  }

  public void displayStaticItems(int level) {
    if (level==1) {
      // I wonder if it makes more sense for image URL to live in the currentImage bit of the GameObject?
      bgSet[0]=loadImage("./assets/Static/Grass1/grass1.gif");
      bgSet[1]=loadImage("./assets/Static/Grass1/grass2.gif");
      bgSet[2]=loadImage("./assets/Static/Grass1/grass3.gif");
      bgSet[3]=loadImage("./assets/Static/Grass1/grass4.gif");
      bgSet[4]=loadImage("./assets/Static/Grass1/grass5.gif");
      bgSet[5]=loadImage("./assets/Static/Grass1/grass6.gif");
      bgSet[6]=loadImage("./assets/Static/Door/door1.png");
      bgSet[7]=loadImage("./assets/Static/Button/button1.gif");
      bgSet[8]=loadImage("./assets/Static/TimeMachine/time1.png");
    }
    for (int i=0; i<staticItems.size(); i++) {
      Item item = staticItems.get(i);
      image(bgSet[item.itemNum-1], item.location.x, item.location.y, item.objectWidth, item.objectHeight);
    }
  }
}
