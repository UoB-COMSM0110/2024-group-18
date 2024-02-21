Player player;
Controller controller;

void setup() {
    player = new Player();
    // todo rename to playController
    controller = new Controller(player);
    // todo add mapController.
    size(1600,900);
    stroke(255); 
}

void draw() {
    background(255);
    image(player.image,player.location.x,player.location.y);
    
    player.changeLocation();
}

void keyPressed() {
    controller.keyPressed();
}
