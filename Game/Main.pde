Player player;
PlayerController playerController;
MapController mapController;

int level;
PImage background01;

void setup(){
  // todo add mapController.
  size(1600,900);
  background01=loadImage("./assets/Background/Blue.png");

  level=1;
  
  player = new Player();
  playerController = new PlayerController(player);
  mapController = new MapController("./maps/map1.txt");
  
  mapController.generateMap();
}

void draw(){
  generateBackground(background01);
  
  playerDraw();
  mapController.displayMap(level);
}

void playerDraw(){
  playerController.updateLocation();
  playerController.updateAnimation();
  if(keyPressed){
    playerController.movementControl();
  }else{
    playerController.movementReset();
  }
}

void generateBackground(PImage bg){
  for(int i=0;i<15;i++){
    for(int j=0;j<10;j++){
      image(bg,i*128,j*128,128,128);
    }
  }
}
