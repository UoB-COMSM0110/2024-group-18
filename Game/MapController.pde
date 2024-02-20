// Generating the map and drawing the static items. 
import java.util.List;

class MapController{
  String[] map;
  List<Item> staticItems;
  List<Item> dynamicItems;
  
  public MapController(String mapName){
    map = loadStrings(mapName);
  }
  
  public void generateMap(){
    for(int i=0;i<map.length;i++){
      println(map[i]);
      for(int j=0;j<map[i].length();j++){
        if(map[i].charAt(j)==1){
          
        }else if(map[i].charAt(j)==0){
          
        }
      }
    }
  }
}
