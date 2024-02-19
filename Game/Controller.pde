
class Controller{

Player player;

public Controller(Player player){
    this.player = player;
}

void keyPressed(){
  boolean right=keyCode==RIGHT;
  boolean left=keyCode==LEFT;
  boolean up=keyCode==UP;
  boolean skill=key==' ';

  if(right){
    player.velocity.x=1;
  }
}
}
