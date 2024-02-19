class Thing {
  float x, y;
  int r, g, b;

  // Contructor
  Thing(float x, float y, int r, int g, int b) {
    this.x = x;
    this.y = y;
    this.r = r;
    this.b = b;
    this.g = g;
  }

  void update(float x, float y) {
    this.x = x;
    this.y = y;
  }

  // this one also does a collision check
  // todo magic number 20, actually the hitbox would be part of the constructor.
  void update(float x, float y, ArrayList<Thing> things) {
    for (Thing t : things) {
      if (this.causes_collision(t, x, y)) {
        return;
      }
    }
    this.x = x;
    this.y = y;
  }

  // this func could be improved. There's copy paste.
  boolean causes_collision(Thing t, float x, float y) {
    if (
    // top left
      (x>t.get_x() && x<t.get_x()+20
      && y>t.get_y() && y<t.get_y()+20)
      // top right
      ||
      (x+20>t.get_x() && x+20<t.get_x()+20
      && y>t.get_y() && y<t.get_y()+20)
      // bottom left
      ||
      (x>t.get_x() && x<t.get_x()+20
      && y+20>t.get_y() && y+20<t.get_y()+20)
      // bottom right
      ||
      (x+20>t.get_x() && x+20<t.get_x()+20
      && y+20>t.get_y() && y+20<t.get_y()+20)
      )
    {
      return true;
    }
    return false;
  }

  float get_x() {
    return this.x;
  }

  float get_y() {
    return this.y;
  }

  void display() {
    fill(r, g, b);
    rect(x, y, 20, 20);
  }
}
