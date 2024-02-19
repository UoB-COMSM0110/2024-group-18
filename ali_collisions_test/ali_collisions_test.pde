
ArrayList<Thing> things = new ArrayList<Thing>();
Thing player = new Thing(10, 10, 255, 0, 0);

void setup() {
  size(640, 360);
  noStroke();

  for (int i=0; i<10; i++) {
    float x = random(20, 620);
    float y = random(20, 340);
    int r = (int)random(255);
    int g = (int)random(255);
    int b = (int)random(255);

    things.add(new Thing(x, y, r, g, b));
  }
}

void draw() {
  background(255);
  for (Thing t : things) {
    t.display();
  }
  player.display();
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      player.update(player.get_x(), player.get_y()-10, things);
    } else if (keyCode == DOWN) {
      player.update(player.get_x(), player.get_y()+10, things);
    } else if (keyCode == LEFT) {
      player.update(player.get_x()-10, player.get_y(), things);
    } else if (keyCode == RIGHT) {
      player.update(player.get_x()+10, player.get_y(), things);
    }
  }
}
