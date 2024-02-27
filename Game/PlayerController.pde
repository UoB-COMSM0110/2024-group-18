// Include the logic for how character is controlled - intially just arrow keys
import java.util.Set;
import java.util.HashSet;

class PlayerController {
  Player player;

  public PlayerController(Player player) {
    this.player = player;
  }

  public void updateAnimation() {
    image(player.currentImage, player.location.x, player.location.y, player.objectWidth, player.objectHeight);
  }

  public void movementControl() {

    player.movingRight = keyCode == RIGHT;
    player.movingLeft = keyCode == LEFT;
    player.isJumping = (keyCode == UP || key == 32) && player.isOnGround;

    if (player.isJumping) {
      player.velocity.y = player.jumpPower;
      player.isOnGround = false;
    }

    if (player.movingRight) {
      player.facingRight = true;
      if (!player.isOnGround) {
        player.velocity.x += player.airControl;
      } else {
        player.velocity.x = player.speed;
      }
    } else if (player.movingLeft) {
      player.facingRight = false;
      if (!player.isOnGround) {
        player.velocity.x -= player.airControl;
      } else {
        player.velocity.x = -player.speed;
      }
    }
  }

private void gameBoundaryCheck(){
  
      // todo what is the underlying logic behind these numbers, and how can we encode it into GameObject ITSELF.
      if(player.location.x<player.objectWidth/4){
        player.location.x=player.objectWidth/4;
      }
      if(player.location.x>width-player.objectWidth){
        player.location.x=width-player.objectWidth;
      }
      if(player.location.y>height-player.objectWidth/4){
        player.location.y=height/2; // this resets the player into the screen middle. IT's for testing while we fix this bug.
      } 
      // I've deliberately not added a check for going out of bounds at the top.

}


  public Set<ContactType> checkCollision(MapController mapController) {
    Set<ContactType> collisions = new HashSet<>();
    
    // check fo collisions with the boundary of the actual game.
    this.gameBoundaryCheck();
      
    // check for collisions with other ojbects.
    for (Item item : mapController.staticItems) {
      // check for right and left collisions.
      for (float i=player.location.y; i<player.location.y+player.objectHeight-8; i++) {
        if ((item.itemNum==1||item.itemNum==4) // is one of two brick types (not sure why only checks for 2 blocks)
          &&player.facingRight == true
          &&player.location.x+60>item.location.x
          &&player.location.x+50<item.location.x+item.objectWidth
          // TODO: Magic number - is the 10 because the player size is 10?
          &&i>=item.location.y&&i<item.location.y+item.objectHeight-10) {
          player.location.x = item.location.x - 50;
          player.velocity.x = 0;
          collisions.add(ContactType.RightCollision);
        }
        if ((item.itemNum==3||item.itemNum==6 ) // is one of two brick types (not sure why only checks for 2?)
          &&player.facingRight == false
          &&player.location.x>item.location.x
          &&player.location.x<item.location.x+item.objectWidth-10
          &&i>=item.location.y&&i<item.location.y+item.objectHeight-10) {
          player.location.x = item.location.x+30;
          collisions.add( ContactType.LeftCollision);
        }

        // BUTTON RELATED CODE:
        // prevent player from walking through button on the right. (the only difference between this code and above is that I use object width.
        // we need to prevent so much duplication here.)
        if ((item.itemNum==8)
          &&player.facingRight == false
          &&player.location.x>item.location.x
          &&player.location.x<item.location.x+item.objectWidth-10
          &&i>=item.location.y&&i<item.location.y+item.objectHeight-10) {
          player.location.x = item.location.x+item.objectWidth; // todo, this is slightly too large, it causes you to bump off the button too aggressively.
          // we should maybe define a variable "buttonWidthBounce" or something like that?
          collisions.add( ContactType.LeftCollision);
        }
        // same thing for the button left collisions.
        if ((item.itemNum==8)
          &&player.facingRight == true
          &&player.location.x+60>item.location.x
          &&player.location.x+50<item.location.x+item.objectWidth
          // TODO: Magic number - is the 10 because the player size is 10?
          &&i>=item.location.y&&i<item.location.y+item.objectHeight-10) {
          player.location.x = item.location.x - 50; // TODO: is 50 right here?
          player.velocity.x = 0;
          collisions.add(ContactType.RightCollision);
        }
      }
      // check for up and down collisions.
      for (float i=player.location.x; i<player.location.x+50; i++) {
        if ((item.itemNum==4||item.itemNum==5||item.itemNum==6) // is lower level brick
          &&player.velocity.y <0
          &&player.location.y<item.location.y+item.objectHeight
          &&player.location.y>item.location.y
          &&i>=item.location.x&&i<item.location.x+item.objectWidth-10) {
          player.location.y = item.location.y+item.objectHeight-5;
          collisions.add(ContactType.UpCollision);
        }
        if ((item.itemNum>=1 && item.itemNum<=3 ) // is upper level brick
          &&player.velocity.y >=0
          &&player.location.y+player.objectHeight<item.location.y+item.objectHeight
          &&player.location.y+player.objectHeight>item.location.y
          &&i>=item.location.x&&i<item.location.x+item.objectWidth-10) {
          player.location.y = item.location.y - player.objectHeight+8;
          player.velocity.y = 0;
          collisions.add(ContactType.DownCollision);
        }
        if (item.itemNum==8) {
          // TODO: do we need to check for collisions with buttons from below?
          //(ideally that should be caught already since they should always be on a block.)
          if (player.velocity.y >=0
            &&player.location.y+player.objectHeight<item.location.y+item.objectHeight
            &&player.location.y+player.objectHeight>item.location.y
            &&i>=item.location.x&&i<item.location.x+item.objectWidth) {
            // TODO: we need to get the maths of the boxes right here as
            //I can't reduce this +20 number without causing weirdness as the player 'bounces' ie: is moved by various collision boxes.
            player.location.y = item.location.y - player.objectHeight+20;
            player.velocity.y = 0;
            collisions.add(ContactType.DownCollision);
            item.ifTriggered = true; // TODO: this is never set back to false. Also this is probably a terrible place for this logic?
            println("DOOR");
          }
        }
      }
    }
    if (collisions.isEmpty()) {
      collisions.add(ContactType.InAir);
    }

    return collisions;
  }

  public void movementReset() {
    player.velocity.set(0, 0);
  }

  // Note that the new input is added to updateLocation
  public void updateLocation(MapController mapController) {
    Set<ContactType> collision = checkCollision(mapController);
    // For collision test output
    text(player.location.x, 10, 10);
    text(player.location.y, 80, 10);
    text(checkCollision(mapController).toString(), 150, 10);
    text(player.facingRight+"", 200, 10);

    if (collision.contains(ContactType.DownCollision)) {
      player.isOnGround = true;
    } else if (collision.contains(ContactType.InAir)) {
      player.isOnGround = false;
    }

    if (!player.isOnGround) {
      player.applyGravity();
    }

    player.velocity.add(player.acceleration);
    player.location.add(player.velocity);
  }
}
