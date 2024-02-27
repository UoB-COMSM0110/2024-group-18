Player player;
PlayerController playerController;
// Each one generate a map for one level, will need 2 more
MapController mapController;

int level;
PImage background01;

void setup(){
  size(1600,900);
  background01=loadImage("./assets/Background/Blue.png");
  
  level=1;
  
  player = new Player();
  playerController = new PlayerController(player);
  mapController = new MapController("./maps/map1.txt");
  // Store map items in list from mapController
  mapController.generateMap();
}

void draw(){
  // Generate background based on level
  if(level==1){
    generateBackground(background01);
  }
  // Show player animation and location
  playerDraw();
  // Generate map based on level
  mapController.displayMap(level);
}

void playerDraw(){
  // The Method updatelocation is changed to take mapController as an input
  playerController.updateLocation(mapController);
  playerController.updateAnimation();
  if(keyPressed){
    playerController.movementControl();
  }else{
    playerController.movementReset();
    player.applyGravity(); //--> this now effects collisions for some reason
  }
}

void generateBackground(PImage bg){
  for(int i=0;i<15;i++){
    for(int j=0;j<10;j++){
      image(bg,i*128,j*128,128,128);
    }
  }
}
