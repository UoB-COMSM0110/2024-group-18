// Include the logic for how character is controlled - intially just arrow keys
import java.util.Set;
import java.util.HashSet;

class PlayerController {
  Player player;
  PastPlayer shadow;
  
  boolean ifShadowGenerated=false;

  boolean movingRight=false;;
  boolean movingLeft=false;
  boolean isJumping=false;
  
  public PlayerController(Player player) {
    this.player = player;
    shadow= new PastPlayer(0,0,20,60);
  }

  public void updateAnimation() {
    image(player.currentImage, player.location.x, player.location.y, 60, 60);
  }

  public void movementControl() {
    // add wasd as control just for feel better when do testing :)
    movingRight = keyCode == RIGHT || key == 'd';
    movingLeft = keyCode == LEFT || key == 'a';
    isJumping = (keyCode == UP || key == 'w') && player.isOnGround;
    if (isJumping && movingRight) {
      player.velocity.add(player.speed, player.jumpPower);
      player.isOnGround = false;
    } else if (isJumping && movingLeft) {
      player.velocity.add(-player.speed, player.jumpPower);
      player.isOnGround = false;
    } else {
      if (isJumping) {
        player.velocity.set(player.velocity.x, player.jumpPower);
        player.isOnGround = false;
      }
      if (movingRight) {
        player.velocity.set(player.speed, player.velocity.y);
      }
      if (movingLeft) {
        player.velocity.set(-player.speed, player.velocity.y);
      }
    }
  }

  public boolean checkCollision(GameObject obj) {
    if (player.location.x-player.objectWidth/2<obj.location.x+obj.objectWidth/2&&
      player.location.x+player.objectWidth/2>obj.location.x-obj.objectWidth/2&&
      player.location.y-player.objectHeight/2<obj.location.y+obj.objectHeight/2&&
      player.location.y+player.objectHeight/2>obj.location.y-obj.objectHeight/2) {
      // colliding
      
      return true;
    }
    return false; // no collision
  }
  
  public void setPlayerLocation(GameObject obj) {
    // stand
    if (player.location.y+player.objectHeight/2>obj.location.y-obj.objectHeight/2&&player.velocity.y>=0) {
      player.location.set(player.location.x, obj.location.y-obj.objectHeight/2-player.objectHeight/2);
      player.velocity.set(player.velocity.x, 0);
      player.isOnGround=true;
    }
    // reach top
    if (player.location.y-player.objectHeight/2<=obj.location.y+obj.objectHeight/2&&!player.platformTouched&&
      player.velocity.y<0) {
      player.location.set(player.location.x, obj.location.y+obj.objectHeight/2+player.objectHeight/2);
      player.velocity.set(player.velocity.x, 0);
      player.platformTouched=true;
    }
    if(player.location.y-player.objectHeight/2>obj.location.y+obj.objectHeight/2&&player.platformTouched){
      player.platformTouched=false;
    }
  }
  public void movementReset() {
    player.velocity.set(0, player.velocity.y);
  }

  // Note that the new input is added to updateLocation
  public void updateLocation(Map map) {
    for (Item item : map.staticItems) {
      if (checkCollision(item)) {
        setPlayerLocation(item);
      }
    }
  }
  
  public void interactDynamicItems(Map map){
    for(Item item : map.dynamicItems){
      if(checkCollision(item)){
        // all dynamic things including button, doors
        if(item.itemNum==7){
          // door
          
        }else if(item.itemNum==8){
          // buttons
          
        }else if(item.itemNum==9){
          // time machine
          text("collision test", 100, 100);
          if(!ifShadowGenerated){
            ifShadowGenerated=true;
            shadow.location.set(item.location.x,item.location.y+40);
          }
        }
      }
    }
  }
  
  public void displayShadow(){
    if(!ifShadowGenerated){
      shadow.storeLocation(player.location);
    }
    
    if(ifShadowGenerated){
      shadow.releaseLocation();
      image(shadow.currentImage,shadow.location.x,shadow.location.y,60,60);
    }
    
    
    
  }
}
