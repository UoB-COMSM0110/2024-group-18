Player player;
PlayerController playerController;
// Each one generate a map for one level, will need 2 more
Map map;

int level;
PImage background01;

void setup() {
  size(1600, 900);
  background01=loadImage("./assets/Background/Blue.png");

  level=1;

  player = new Player();
  playerController = new PlayerController(player);
  map = new Map("./maps/map1.txt");
  // Store map items in list from mapController
  map.generateMap();
}

void draw() {
  // Generate background based on level
  if (level==1) {
    generateBackground(background01);
  }
  // Generate map based on level
  map.displayMap(level);
  // Show player animation and location
  playerDraw();
}

void playerDraw() {

  // The Method updatelocation is changed to take mapController as an input
  playerController.updateLocation(map);
  playerController.updateAnimation();
  if (keyPressed) {
    playerController.movementControl();
  } else {
    playerController.movementReset();
    player.applyGravity(); //--> moved to top of method
  }
}

void generateBackground(PImage bg) {
  for (int i=0; i<15; i++) {
    for (int j=0; j<10; j++) {
      image(bg, i*128, j*128, 128, 128);
    }
  }
}
