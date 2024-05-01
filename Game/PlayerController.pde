// Include the logic for how character is controlled - intially just arrow keys
import java.util.Set;
import java.util.HashSet;

class PlayerController {
  Player player;
  PastPlayer pastSelf;

  boolean ifPastSelfGenerated=false;
  boolean ifGameWin=false;

  boolean movingRight=false;
  boolean movingLeft=false;
  boolean isJumping=false;

  // flag for hint in tutorial
  boolean hasPressed = false;
  boolean hasMoved = false;
  boolean hasJumped = false;
  boolean deadByBomb=false;
  boolean deadByHitPreviousPlayer=false;

  // these are for the alternative controller.
  boolean inputLeft = false;
  boolean inputRight = false;
  boolean inputUp = false;

  // these are for enhanced collision check
  float staticItemHeight = 0;
  float staticItemWidth = 0;
  boolean ifTopCollide = false;
  boolean ifLeftCollide = false;
  boolean ifRightCollide = false;

  boolean ifMovingPlatformReverse = false;
  boolean isOnMovingPlatform = false;


  public PlayerController(Player player) {
    this.player = player;
    pastSelf = new PastPlayer(0, 0, 20, 60);
  }

  public void updateAnimation() {
    if (player.current_animation==player.disappear) {
      image(player.currentImage, player.location.x, player.location.y, 120, 120);
    } else {
      image(player.currentImage, player.location.x, player.location.y, 60, 60);
    }
  }



  // maps valid keypresses to movement
  public void movementControl() {
    movingRight = keyCode == RIGHT || key == 'D' || inputRight==true;
    movingLeft = keyCode == LEFT || key == 'A'|| inputLeft==true;
    isJumping = (keyCode == UP || key == 'W' || inputUp==true) && player.isOnGround;
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
        hasJumped = true;
      }
      if (movingRight) {
        player.velocity.set(player.speed, player.velocity.y);
        hasMoved = true;
      }
      if (movingLeft) {
        player.velocity.set(-player.speed, player.velocity.y);
        hasMoved = true;
      }
    }
  }

  // if there has been a collision between the player and a bomb then return true
  public boolean checkBomb(Map map) {
    if (checkCollision(map.bomb)) {
      return true;
    }
    return false;
  }

  // returns true if the player is colliding with a stuctrue or item
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

  public void getCollisionStatus(Item obj) {
    movingRight = keyCode == RIGHT || key == 'd' || inputRight==true;
    movingLeft = keyCode == LEFT || key == 'a'|| inputLeft==true;
    staticItemHeight = obj.objectHeight;
    staticItemWidth = obj.objectWidth;
    float playerLeft = player.location.x - player.objectWidth / 2;
    float playerRight = player.location.x + player.objectWidth / 2;
    float playerTop = player.location.y - player.objectHeight / 2;
    float playerBottom = player.location.y + player.objectHeight / 2;

    float objLeft = obj.location.x - obj.objectWidth / 2;
    float objRight = obj.location.x + obj.objectWidth / 2;
    float objTop = obj.location.y - obj.objectHeight / 2;
    float objBottom = obj.location.y + obj.objectHeight / 2;

    float overlapLeft = objRight - playerLeft;
    float overlapRight = playerRight - objLeft;
    float overlapTop = objBottom - playerTop;
    float overlapBottom = playerBottom - objTop;

    float minOverlap = min(overlapLeft, overlapRight, min(overlapTop, overlapBottom));
    if (minOverlap == overlapLeft && movingLeft) {
      ifLeftCollide = true;
    } else if (minOverlap == overlapRight && movingRight) {
      ifRightCollide = true;
    } else if (minOverlap == overlapTop) {
      ifTopCollide = true;
    }
  }

  public boolean checkPastSelfCollision(GameObject obj) {
    if (pastSelf.location.x-pastSelf.objectWidth/2<obj.location.x+obj.objectWidth/2&&
      pastSelf.location.x+pastSelf.objectWidth/2>obj.location.x-obj.objectWidth/2&&
      pastSelf.location.y-pastSelf.objectHeight/2<obj.location.y+obj.objectHeight/2&&
      pastSelf.location.y+pastSelf.objectHeight/2>obj.location.y-obj.objectHeight/2) {
      // colliding
      return true;
    }
    return false; // no collision
  }

  public void resetCollisionStatus() {
    ifTopCollide = false;
    ifLeftCollide = false;
    ifRightCollide = false;
  }

  public void setPlayerLocation(Item obj) {
    if (ifTopCollide) {
      // keep droping when not through the platform
      return;
    } else if (ifLeftCollide) {
      player.location.set(obj.location.x+obj.objectWidth/2+player.objectWidth/2, player.location.y);
      resetCollisionStatus();
      return;
    } else if (ifRightCollide) {
      player.location.set(obj.location.x-obj.objectWidth/2-player.objectWidth/2, player.location.y);
      resetCollisionStatus();
      return;
    }
    // stand on platform
    if (player.location.y+player.objectHeight/2>obj.location.y-obj.objectHeight/2&&player.velocity.y>=0) {
      if (!(obj.itemNum>=11&&obj.itemNum<=13)) {
        isOnMovingPlatform = false;
      }
      if (!isOnMovingPlatform) {
        player.location.set(player.location.x, obj.location.y-obj.objectHeight/2-player.objectHeight/2);
        if (obj.itemNum>=11&&obj.itemNum<=13) {
          isOnMovingPlatform = true;
        }
      } else if (isOnMovingPlatform) {
        player.location.set(player.location.x+obj.movingPace, obj.location.y-obj.objectHeight/2-player.objectHeight/2);
      }
      player.velocity.set(player.velocity.x, 0);
      player.isOnGround=true;
    }
  }

  public void movementReset() {
    player.velocity.set(0, player.velocity.y);
  }

  // Note that the new input is added to updateLocation
  public void updateLocation(Map map) {
    boolean ifCollide = false;
    for (Item item : map.staticItems) {
      // check collision for player
      if (checkCollision(item)) {
        ifCollide = true;
        getCollisionStatus(item);
        setPlayerLocation(item);
      }
    }
    if (!ifCollide) {
      resetCollisionStatus();
    }
    // ScreenLeft limit
    if (player.location.x-player.objectWidth/2<0) {
      player.location.set(player.objectWidth/2, player.location.y);
    }
    // ScreenRight limit
    if (player.location.x+player.objectWidth/2>width) {
      //text("right", 100, 200);
      player.location.set(width-player.objectWidth/2, player.location.y);
    }
  }

  public void interactDynamicItems(Map map) {
    for (Item item : map.dynamicItems) {
      if (checkCollision(item)) {
        // all dynamic things including button, doors
        if (item.itemNum==7) {
          // door
          if (item.situation) {
            ifGameWin=true;
          } else {
            ifGameWin=false;
          }
        } else if (item.itemNum==8) {
          // buttons
          map.openDoor();
          hasPressed = true;
        } else if (item.itemNum==9) {
          // time machine
          if (!ifPastSelfGenerated) {
            ifPastSelfGenerated=true;
            map.ifBombInverse=true;
            if (player.location.x<item.location.x) {
              player.location.set(item.location.x+40, item.location.y+40);
            } else {
              player.location.set(item.location.x-40, item.location.y+40);
            }


            pastSelf.location.set(item.location.x, item.location.y+40);
            if (!ifMovingPlatformReverse) {
              map.revertMP();
              ifMovingPlatformReverse = true;
            }
          }
        }
      }

      // all interatctions between past player and items
      if (checkPastSelfCollision(item)) {
        if (item.itemNum==8) {
          // buttons
          map.openDoor();
        }
      }

      if (!checkCollision(item)&&!checkPastSelfCollision(item)) {
        if (item.itemNum==8) {
          map.closeDoor();
        }
      }
    }
  }

  public boolean shadowAndPlayerCollide() {
    if (!ifPastSelfGenerated) {
      return false;
    }
    if (checkCollision(pastSelf)) {
      return true;
    }
    return false;
  }

  public boolean checkGameOver(Map map, int level) {
    if (ifPastSelfGenerated&&pastSelf.stateCollection.size()==0) { //<>//
      pastSelf.refresh();
      return true;
    }
    if (player.location.y>height) {
      pastSelf.refresh();
      return true;
    }
    if (shadowAndPlayerCollide()) {
      deadByHitPreviousPlayer=true;
      player.velocity.set(0,0);
      player.acceleration.set(0,0);
      return true;
    }
    if (level==2||level==3) {
      if (checkBomb(map)||deadByBomb) {
        deadByBomb=true;
        return true;
      }
    }

    return false;
  }

  public void displayPastSelf() {
    if (!ifPastSelfGenerated) {
      pastSelf.storeState(player.location, player.currentImage);
    }

    if (ifPastSelfGenerated && !ifGameOver) {
      pastSelf.accessPastState();
      image(pastSelf.currentImage, pastSelf.location.x, pastSelf.location.y+5, 60, 60);
    }
  }

  public void refresh(Map map) {
    ifGameOver=false;
    ifGameWin=false;
    ifPastSelfGenerated=false;
    deadByBomb=false;
    map.ifBombInverse=false;
    pastSelf.refresh();
  }
}
