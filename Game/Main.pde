Player player;
Controller controller;

void setup() {
    player = new Player();
    // todo rename to playController
    controller = new Controller(player);
    // todo add mapController.
    size(1600,900);
    background(255);
    stroke(255); 
}

void draw() {
    image(player.image,player.location.x,player.location.y);
    
    player.velocity.add(player.accelarate);
    player.location.add(player.velocity);
}

void keyPressed() {
    controller.keyPressed();
}
