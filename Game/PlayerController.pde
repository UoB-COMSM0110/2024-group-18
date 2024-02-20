// Include the logic for how character is controlled - intially just arrow keys
class PlayerController{
  Player player;

  public PlayerController(Player player){
    this.player = player;
  }
  
  public void updateAnimatioon(){
    image(player.currentImage,player.location.x,player.location.y);
  }
  
  public void movementControl(){
    boolean right = keyCode == RIGHT;
    boolean left = keyCode == LEFT;
    if(right){
      player.velocity.set(1,0);
    }
    if(left){
      player.velocity.set(-1,0);
    }
    
  }
  
  public void movementReset(){
    player.velocity.set(0,0);
  }
  
  public void updateLocation(){
    player.velocity.add(player.acceleration);
    player.location.add(player.velocity);
  }
  

}
