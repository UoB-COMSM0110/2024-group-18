Player player;
PlayerController playerController;
MapController mapController;

void setup(){
  // todo add mapController.
  size(1600,900);
  player = new Player();
  playerController = new PlayerController(player);
  mapController = new MapController("./maps/map1.txt");
  
  mapController.generateMap();
}

void draw(){
  background(255);
  playerDraw();
}


void playerDraw(){
  playerController.updateLocation();
  playerController.updateAnimatioon();
  if(keyPressed){
    playerController.movementControl();
  }else{
    playerController.movementReset();
  }
}
