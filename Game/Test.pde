class Test {

  /* Tests various aspects of the game. */
  Test() {
  }

  void test() {
    // bomb
    testBombInitialization();
    testDeExplode();
    testExplode();
    //previous state
    testPreviousState();
    // playercontroller
    testMovementControl();
    // player
    testMovementAndAnimations();
    // Map
    testGenerateMap();
    testPlaceBomb();
    // Item
    testAnimationToggle();
    testSetSituation();
  }

  // Test animation toggling for a button
  void testAnimationToggle() {
    Item button = new Item(8, 100, 100, 50, 50, 50, 50, false, false, false);

    // Simulate the button being triggered
    button.ifTriggered = true;
    button.checkTriggerAnimation();
    assert button.currentImage.equals(button.onAnimation[0]) :
    "Button should start with the first frame of onAnimation";
  }

  // Test setting the situation of an item
  void testSetSituation() {
    Item item = new Item(7, 150, 150, 60, 60, 60, 60, true, false, false);
    item.setSituation(true);
  assert item.situation :
    "Situation should be true when set to true";
    item.setSituation(false);
  assert !item.situation :
    "Situation should be false when set to false";
  }


  // Test generating the map and placing items correctly
  void testGenerateMap() {
    Map gameMap = new Map("maps/map1.txt", 1);
    gameMap.generateMap();
    assert !gameMap.staticItems.isEmpty() :
    "Static items should be loaded";
    assert !gameMap.dynamicItems.isEmpty() :
    "Dynamic items should be loaded";
  }

  // Test placing and resetting a bomb
  void testPlaceBomb() {
    Map gameMap = new Map("level1.txt", 1);
    gameMap.placeBomb();
  assert gameMap.bomb != null :
    "Bomb should be placed";
    gameMap.freshBomb();
    assert gameMap.bombList.isEmpty() :
    "Bomb list should be cleared after refreshing";
  }




  // Test movement and animations
  void testMovementAndAnimations() {
    Player player = new Player();

    // Test moving right on ground
    player.velocity.x = 6.0f; // Player is moving right
    player.velocity.y = 0; // Not jumping or falling
    player.updateAnimation();
  assert player.current_animation == player.runRight :
    "Animation should be runRight";
  assert player.facingRight :
    "Facing direction should be right";

    // Test jumping right
    player.velocity.y = -30; // Player is jumping
    player.updateAnimation();
  assert player.current_animation == player.jumpRight :
    "Animation should be jumpRight";

    // Reset and test moving left on ground
    player.velocity.x = -6.0f; // Player is moving left
    player.velocity.y = 0; // Not jumping or falling
    player.updateAnimation();
  assert player.current_animation == player.runLeft :
    "Animation should be runLeft";
  assert !player.facingRight :
    "Facing direction should be left";

    // Test falling left
    player.velocity.y = 2; // Player is falling
    player.updateAnimation();
  assert player.current_animation == player.fallLeft :
    "Animation should be fallLeft";
  }


  // Test movement control logic
  void testMovementControl() {
    Player testPlayer = new Player(); 
    PlayerController controller = new PlayerController(testPlayer);

    // Simulate key press for moving right
    controller.inputRight = true;
    controller.movementControl();
  assert controller.movingRight :
    "Player should be moving right";
  assert !controller.movingLeft :
    "Player should not be moving left";

    // Reset and test jumping while on ground
    controller.inputRight = false;
    controller.inputUp = true;
    testPlayer.isOnGround = true;
    controller.movementControl();
  assert controller.isJumping :
    "Player should be jumping";
  assert !testPlayer.isOnGround :
    "Player should not be on ground after jumping";
  }


  void testPreviousState() {
    // Test Initialization
    PVector testVector = new PVector(1.0f, 2.0f);
    PImage testImage = new PImage(); 

    PreviousState state = new PreviousState(testVector, testImage);
  assert state.location == testVector :
    "Location should be the same as initialized";
  assert state.animation == testImage :
    "Animation should be the same as initialized";

    // Test Null Initialization
    PreviousState nullState = new PreviousState(null, null);
  assert nullState.location == null :
    "Location should be null";
  assert nullState.animation == null :
    "Animation should be null";
  }


  void testBombInitialization() {
    Bomb bomb = new Bomb(100);
  assert bomb.currentImage != null :
    "Initial bomb image should not be null.";
  assert bomb.objectWidth == 60 :
    "Initial width should be 60.";
  assert bomb.objectHeight == 80 :
    "Initial height should be 80.";
  assert bomb.speed == 6 :
    "Speed should be initialized to 6.";
  }

  void testDeExplode() {
    Bomb bomb = new Bomb(100);
    bomb.frame = 3;  // Set frame to a multiple of 3 to trigger deExplode
    boolean result = bomb.deExplode();
  assert !result :
    "DeExplode should return false when not all images have been used.";
  assert bomb.deIndex == bomb.explode.length - 2 :
    "DeIndex should decrement by one.";
  }

  void testExplode() {
    Bomb bomb = new Bomb(100);
    bomb.frame = 3;  // Set frame to a multiple of 3 to trigger explode
    boolean result = bomb.explode();
  assert !result :
    "Explode should return false when not all images have been used.";
  assert bomb.index == 1 :
    "Index should increment by one.";
  }
}
