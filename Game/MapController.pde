// Generating the map and drawing the static items. 
import java.util.List;

class MapController{
  String[] map;
  List<Item> staticItems = new ArrayList<>();
  List<Item> dynamicItems = new ArrayList<>();
  PImage[] bgSet = new PImage[6];
  
  public MapController(String mapName){
    map = loadStrings(mapName);
  }
  
  public void generateMap(){
    for(int i=0;i<map.length;i++){
      for(int j=0;j<map[i].length();j++){
        if(map[i].charAt(j)>='1'&&map[i].charAt(j)<='6'){
          float w=40;
          float h=40;
          Item item = new Item(map[i].charAt(j)-'0',j*w,i*h,w,h,true,false,false);
          staticItems.add(item);
        }else if(map[i].charAt(j)=='0'){
          
        }
      }
    }
  }
  
  public void displayMap(int level){
    displayStaticItems(level);
  }
  
  public void displayStaticItems(int level){
    if(level==1){
      bgSet[0]=loadImage("./assets/Static/Grass1/grass1.gif");
      bgSet[1]=loadImage("./assets/Static/Grass1/grass2.gif");
      bgSet[2]=loadImage("./assets/Static/Grass1/grass3.gif");
      bgSet[3]=loadImage("./assets/Static/Grass1/grass4.gif");
      bgSet[4]=loadImage("./assets/Static/Grass1/grass5.gif");
      bgSet[5]=loadImage("./assets/Static/Grass1/grass6.gif");
    }
    for(int i=0;i<staticItems.size();i++){
      Item item = staticItems.get(i);
      image(bgSet[item.itemNum-1],item.location.x,item.location.y,40,40);
      //rect(item.location.x,item.location.y,item.objectWidth,item.objectHeight);
    }
  }
}
