
class Controller {

  Player player;

  public Controller(Player player) {
    this.player = player;
  }

  void keyPressed() {
    boolean right=keyCode==RIGHT;
    boolean left=keyCode==LEFT;
    boolean up=keyCode==UP;
    boolean skill=key==' ';

    if (right) {
      player.velocity.x=1;
    }
    if (left) {
      player.velocity.x=-1;
    }
    if (up) {
      // todo: add the can jump stuff so users can't double jump
      player.velocity.set(player.velocity.x,-10);
    }
    if (skill) {
      // TODO
    }
  }
}
