void setup() {
  size(500, 500);
}

void draw() {
  background(0);

  float rectOneX = width/2;
  float rectOneY = height/2;
  float rectOneWidth = 50;
  float rectOneHeight = 50;

  float rectTwoX = mouseX;
  float rectTwoY = mouseY;
  float rectTwoWidth = 100;
  float rectTwoHeight = 100;

  if (rectOneX < rectTwoX + rectTwoWidth &&
    rectOneX + rectOneWidth > rectTwoX &&
    rectOneY < rectTwoY + rectTwoHeight &&
    rectOneHeight + rectOneY > rectTwoY) {
    //colliding!
    fill(255, 0, 0);
  } else {
    //not colliding!
    fill(0, 255, 0);
  }

  rect(rectOneX, rectOneY, rectOneWidth, rectOneHeight);
  rect(rectTwoX, rectTwoY, rectTwoWidth, rectTwoHeight);
}
