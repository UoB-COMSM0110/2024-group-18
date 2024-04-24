class Test {

  /* Tests various aspects of the game. */
  Test() {
  }

  void test() {
    // bomb tests
    testBombInitialization();
    testDeExplode();
    testExplode();
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
