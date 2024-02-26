// Include the logic for how character is controlled - intially just arrow keys
import java.util.Set;
import java.util.HashSet;
class PlayerController{
  Player player;

  public PlayerController(Player player){
    this.player = player;
  }
  
  public void updateAnimation(){
    image(player.currentImage,player.location.x,player.location.y,player.objectWidth,player.objectHeight);
  }
  
  public void movementControl(){
    boolean right = keyCode == RIGHT;
    boolean left = keyCode == LEFT;
    boolean up = keyCode == UP;
    //for collision test 
    boolean down = keyCode == DOWN;
    if(right){
      player.facing = true;
      player.velocity.set(player.speed,0);
    }
    if(left){
      player.facing = false;
      player.velocity.set(-player.speed,0);
    }
    //for collision test
    if(up) {
      player.velocity.set(0,-5); 
    }
    if(down) {
      player.velocity.set(0,5); 
    }
    
  }
  
  public Set<ContactType> checkCollision(MapController mapController) {
    Set<ContactType> collisions = new HashSet<>();
    for(Item item : mapController.staticItems) {
      for(float i=player.location.y;i<player.location.y+player.objectHeight-8;i++) {
        if((item.itemNum==1||item.itemNum==4)
           &&player.facing == true
           &&player.location.x+60>item.location.x
           &&player.location.x+50<item.location.x+item.objectWidth
           &&i>=item.location.y&&i<item.location.y+item.objectHeight-10){
          player.location.x = item.location.x - 50;
          player.velocity.x = 0;
          collisions.add(ContactType.RightCollision);
        }
        if((item.itemNum==3||item.itemNum==6)
           &&player.facing == false
           &&player.location.x>item.location.x
           &&player.location.x<item.location.x+item.objectWidth-10
           &&i>=item.location.y&&i<item.location.y+item.objectHeight-10){
           player.location.x = item.location.x+30;
           collisions.add( ContactType.LeftCollision);
           } 
      }
      for(float i=player.location.x;i<player.location.x+50;i++){
        if((item.itemNum==4||item.itemNum==5||item.itemNum==6)
           &&player.velocity.y <0
           &&player.location.y<item.location.y+item.objectHeight
           &&player.location.y>item.location.y
           &&i>=item.location.x&&i<item.location.x+item.objectWidth-10){
          player.location.y = item.location.y+item.objectHeight-5;
          collisions.add(ContactType.UpCollision);
        }
        if((item.itemNum==1||item.itemNum==2||item.itemNum==3)
           &&player.velocity.y >=0
           &&player.location.y+player.objectHeight<item.location.y+item.objectHeight
           &&player.location.y+player.objectHeight>item.location.y
           &&i>=item.location.x&&i<item.location.x+item.objectWidth-10){
          player.location.y = item.location.y - player.objectHeight+8;
          player.velocity.y = 0;
          collisions.add(ContactType.DownCollision);
        }
      }
    }
    if(collisions.isEmpty()) {
      collisions.add(ContactType.InAir); 
    }
    
    return collisions;
  }
  
  public void movementReset(){
    player.velocity.set(0,0);
  }
  
  // Note that the new input is added to updateLocation
  public void updateLocation(MapController mapController){
    // For collision test output
    text(player.location.x,10,10);
    text(player.location.y,80,10);
    text(checkCollision(mapController).toString(),150,10);
    text(player.facing+"",200,10);
    
    player.velocity.add(player.acceleration);
    player.location.add(player.velocity);
  }
  


}
