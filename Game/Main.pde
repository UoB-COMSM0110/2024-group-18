Player player;
PlayerController playerController;
AlternativeController alternativeController;
Map map;

float lag=0;
int level;
PImage startScreen;
PImage title;
PImage setting;
PImage control;
boolean showControlBar=false;
boolean showDisabilityDetails=false;
boolean showSettingBar=false;
PImage controlOption;
PImage levelOption1;
PImage levelOption2;
PImage levelOption3;
PImage background01;
PImage resetButton;
PImage disabilityButton;
PImage clock;
float time=0;
float time_x;
float time_y;
ControlType controlMode=ControlType.NORMAL;
boolean ifGameOver=false;
boolean ifLevelPass=false;
boolean ifMapGenerated=false;
int ESCAPE_KEYCODE=27;

float xPos, ypos;
float xSpeed=0.8, ySpeed=0.8;
int xDirection=1, yDirection=1;

int hintLag = 0;
int moveLag = 0;
int invertLag = 0;
boolean ifRestarted = false;
PImage moveHint;
PImage jumpHint;
PImage reviewHint;

PFont font;


enum ControlType {
  NORMAL, DISABLED
}

// this function duplicates work above, but is important because
// we need it when we reset the game.
void initializeGlobalVariablesToStartingValues() {
  lag = 0;
  time = 0;
  hintLag = 0;
  moveLag = 0;
  invertLag = 0;

  ifGameOver = false;
  ifLevelPass = false;
  ifMapGenerated = false;
  ifRestarted = false;

  showControlBar = false;
  showDisabilityDetails = false;
  showSettingBar = false;
  controlMode = ControlType.NORMAL;

  xSpeed = 0.8;
  ySpeed = 0.8;
  xDirection = 1;
  yDirection = 1;

  time_x = 0;
  time_y = 0;
}

void setup() {
  initializeGlobalVariablesToStartingValues();
  size(1600, 900);
  xPos=width/2;
  ypos=height/2+20;
  font=createFont("./assets/PressStart2P-Regular.ttf", 20);
  textFont(font);
  fill(0);
  title=loadImage("./assets/Background/title.png");
  startScreen=loadImage("./assets/Background/startup.png");
  setting=loadImage("./assets/Background/setting.png");
  control=loadImage("./assets/Background/control.png");
  controlOption=loadImage("./assets/Background/control_key.png");
  background01=loadImage("./assets/Background/star.jpeg");
  clock = loadImage("./assets//Clock.png");
  levelOption1 = loadImage("./assets/Background/level1.png");
  levelOption2 = loadImage("./assets/Background/level2.png");
  levelOption3 = loadImage("./assets/Background/level3.png");
  disabilityButton=loadImage("./assets/Background/disabled.png");

  resetButton = loadImage("./assets/Background/reset.png");
  level=-2;

  moveHint = loadImage("./assets/Hint/moveHint.png");
  jumpHint = loadImage("./assets/Hint/jumpHint.png");
  reviewHint = loadImage("./assets/Hint/reviewHint.png");

  player = new Player();
  playerController = new PlayerController(player);
  map = new Map("./maps/map1.txt", 1);
  // Store map items in list from mapController
  map.generateMap();
  alternativeController = new AlternativeController(this, playerController);
}

void draw() {
  imageMode(CENTER);
  if (level==-2) {
    showTitle();
  } else if (level==-1) {
    generateStartUI();
  }
  // Generate background based on level
  else if (level==0) {
    generateStory();
  } else {
    if (level==1) {
      showBackground();
    } else if (level==2) {
      if (!ifMapGenerated) {
        map=new Map("./maps/map2.txt", 2);
        ifMapGenerated=true;
        map.generateMap();
        map.placeBomb();
        player.location.x = 100; // ensure the player starts at the correct location for level 2.
      }
      showBackground();
      map.displayBomb(time);
    } else if (level==3) {
      map=new Map("./maps/map3.txt", 3);
    }
    placeClock();

    // Generate map based on level
    map.displayMap();
    // Show player animation and location
    playerDraw();
    checkGameStatus();
  }
  if (level!=-2 && level<0) {
    generateMenuUI();
  }
  if (level > 0 && level <=3) {
    generateInGameUI();
  }
  if (level == 1) {
    generateHint();
  }
}

void showBackground() {
  image(background01, 800, 450, 1600, 900);
}

void checkGameStatus() {
  if (playerController.checkGameOver(map, level)) {
    player.ifDead=true;
    fill(0);
    if (playerController.deadByHitPreviousPlayer) {
      fill(255);
      text("PARADOX! \nYou collided with your past self!\nClick to restart", 450, 400);
    } else {
      fill(255);
      text("Game over!", 650, 400);
      text("Click to restart", 580, 450);
    }
    ifGameOver=true;
  }

  if (playerController.ifGameWin) {
    fill(255);
    text("Congratulations. You passed this level!!\nClick to continue.", 650, 400);
    ifLevelPass=true;
  }
}

void generateStory() {
  fill(0);
  rect(0, 0, 1600, 900);
  fill(255);
  String story1 = "You are an astronaut, stuck in unknown space, \n unable to get home.";
  String story2 = "Before you is a button, a door, \n and a mysterious machine that seems to have something to do with \n TIME REVERSAL.\n Could these be your ticket out?";
  text(story1, 200, 450);
  text(story2, 50, 650);
  text("Press any key to continue...", 200, 800);
}

void showTitle() {
  image(startScreen, 800, 450, 1630, 930);
  fill(0, 0, 0, 255-lag*8);
  rect(0, 0, 1600, 900);
  image(title, 800, 450-lag*10, 1000, 500);
  if (lag==25) {
    level=-1;
  }
  lag++;
}

void generateInGameUI() {
  image(resetButton, 1500, 100, 100, 100);
  image(control, 1350, 100, 100, 100);
  if (showControlBar) {
    image(controlOption, 1300, 320, 200, 300);
  }
}

void generateMenuUI() {
  image(setting, 1500, 100, 100, 100);
  image(control, 1350, 100, 100, 100);
  if (showControlBar) {
    image(controlOption, 1300, 320, 200, 300);
  }
  image(disabilityButton, 1200, 100, 100, 100);

  if (showSettingBar) {
    image(levelOption1, 1500, 220, 180, 100);
    image(levelOption2, 1500, 320, 180, 100);
    image(levelOption3, 1500, 420, 180, 100);
  }
  if(showDisabilityDetails){
      fill(0);
      text("Accessibility mode activated: \n You may now control the character without a keyboard, \n by leaning your body left and right, and making a noise to jump.",100,500);
  }
}

void generateStartUI() {
  xPos=xPos+(xSpeed*xDirection);
  ypos=ypos+(ySpeed*yDirection);
  if (xPos>width/2+30||xPos<width/2-30) {
    xDirection*=-1;
  }
  if (ypos>height/2+30||ypos<height/2-30) {
    yDirection*=-1;
  }
  image(startScreen, xPos, ypos, 1630, 930);

  textSize(40);
  fill(0);
  image(title, 800, 200, 1000, 500);
  textSize(20);
  noStroke();
  fill(0, 0, 0, 80);
  rect(300, 770, 1000, 40);
  fill(255);
  text("press any key to start", 600, 800);
}

void generateHint() {
  if (moveLag < 5) {
    moveLag++;
  }
  // move hint
  if (moveLag >= 5 && !playerController.hasMoved) {
    image(moveHint, 800, 450, 385, 31);
  }
  if (playerController.hasMoved && !playerController.hasJumped) {
    image(jumpHint, 800, 450, 323, 32);
  }
  if (moveLag <= 50 && playerController.hasJumped && playerController.hasMoved) {
    image(reviewHint, 800, 100, 448, 32);
    moveLag++;
  }
  // portal hint
  boolean isDoorOpen = false;
  PVector boothLocation = new PVector(0, 0);
  for (Item item : map.dynamicItems) {
    if (item.itemNum == 7) {
      isDoorOpen = item.situation;
    }
    if (item.itemNum == 9) {
      boothLocation = item.location;
    }
  }
  if (!isDoorOpen && playerController.hasPressed && hintLag == 0) {
    hintLag = 1;
  }
  if (hintLag >0 && hintLag <= 200 && !playerController.ifShadowGenerated) {
    if (hintLag < 20) {
      image(loadImage("./assets/Hint/oh-no.png"), 800, 300, 144, 40);
    } else if (hintLag < 55) {
      image(loadImage("./assets/Hint/leave.png"), 800, 350, 692, 32);
    } else if (hintLag <= 100) {
      image(loadImage("./assets/Hint/someone.png"), 800, 400, 860, 38);
    } else {
      image(loadImage("./assets/Hint/booth.png"), boothLocation.x, boothLocation.y-100, 412, 26);
    }
    hintLag++;
  }
  if (playerController.ifShadowGenerated && hintLag>0 && invertLag == 0) {
    invertLag = 1;
  }
  if (invertLag > 0 && invertLag < 100 && !ifGameOver && !ifLevelPass) {
    if (invertLag < 15) {
      image(loadImage("./assets/Hint/wow.png"), 800, 300, 167, 36);
    } else if (invertLag < 55) {
      image(loadImage("./assets/Hint/reverse-time.png"), 800, 350, 809, 39);
    } else {
      image(loadImage("./assets/Hint/someoneneed.png"), 800, 400, 797, 39);
    }
    invertLag++;
  }
}

void playerDraw() {
  if (controlMode==ControlType.DISABLED) {
    alternativeController.control();
    playerController.movementControl();
  }
  // The Method updatelocation is changed to take mapController as an input
  playerController.updateLocation(map);
  playerController.interactDynamicItems(map);
  if (level==2||level==3) {
    playerController.checkBomb(map);
  }
  playerController.updateAnimation();
  player.updateAnimation();
  if (!ifLevelPass) {
    playerController.displayShadow();
  }
  player.velocity.add(player.acceleration);
  player.location.add(player.velocity);
}

void keyPressed() {
  if (level==-1) {
    level=0;
  } else if (level==0) {
    level=1;
  }
  if (!ifGameOver||ifLevelPass) {
    playerController.movementControl();
  }
  if (keyCode == ESCAPE_KEYCODE) {
    resetToMainMenu();
  }
  if (ifGameOver) {
    restartLevel();
  }
}

void resetToMainMenu() {
  key = 0;
  lag=25;
  setup();
  level=-1; // this skips past the opening animation.
}



void keyReleased() {
  if (keyCode == UP||key=='w') {
    return;
  }
  playerController.movementReset();
}

void settingBarClicked() {
  if (level>0) {
    return; // new levels cannot be launched from inside levels.
  }
  if (mouseX>1450&&mouseX<1550
    &&mouseY>50&&mouseY<150) {
    if (showSettingBar) {
      setting=loadImage("./assets/Background/setting.png");
      showSettingBar=false;
    } else {
      setting=loadImage("./assets/Background/setting2.png");
      showSettingBar=true;
    }
  }
}

void controlBarClicked() {
  if (mouseX>1300&&mouseX<1400
    &&mouseY>50&&mouseY<150) {
    if (showControlBar) {
      control=loadImage("./assets/Background/control.png");
      showControlBar=false;
    } else {
      control=loadImage("./assets/Background/control2.png");
      showControlBar=true;
    }
  }
}

void resetButtonClicked() {
  if (level<=0) {
    return; // reset button only applies within a level.
  }
  if (mouseX>1450&&mouseX<1550
    &&mouseY>50&&mouseY<150) {
    restartLevel();
  }
}

void settingBarOptionClicked() {
  if (showSettingBar) {
    // Select Tutorial
    if (mouseX>1400&&mouseX<1650
      &&mouseY>165&&mouseY<270) {
      level=1;
    }
    // Select Easy
    if (mouseX>1400&&mouseX<1650
      &&mouseY>270&&mouseY<365) {
      level=2;
    }
    // Select Hard
    if (mouseX>1400&&mouseX<1650
      &&mouseY>365&&mouseY<460) {
      level=3;
    }
  }
}

void disabilityButtonClicked() {
  if (mouseX>1150&&mouseX<1250
    &&mouseY>50&&mouseY<150) {
    if (showDisabilityDetails) {
      disabilityButton=loadImage("./assets/Background/disabled.png");
      controlMode=ControlType.NORMAL;
      showDisabilityDetails=false;
    } else {
      disabilityButton=loadImage("./assets/Background/disabled2.png");
      controlMode=ControlType.DISABLED;
      showDisabilityDetails=true;
    }
  }
}


void mousePressed() {
  controlBarClicked();
  settingBarClicked();
  disabilityButtonClicked();
  settingBarOptionClicked();
  resetButtonClicked();

  if (ifGameOver) {
    restartLevel();
  }

  if (ifLevelPass) {
    level++;
    ifLevelPass=false;
    playerController.refresh(map);
  }
}

public void restartLevel() {
  hintLag = 0;
  moveLag = 0;
  invertLag = 0;
  time=0;
  playerController = new PlayerController(player);
  alternativeController= new AlternativeController(this, playerController);
  player.ifDead=false;
  player.index=0;
  player.location.set(120, 500);
  player.velocity.set(0, 0);
  playerController.deadByHitPreviousPlayer=false;
  ifGameOver=false;
  ifRestarted = true;
  if (level==2||level==3) {
    map.ifBombInverse=false;
    map.bombList.clear();
    map.placeBomb();
  }
}

public void placeClock() {
  image(clock, 100, 100, 300, 300);
  stroke(255, 204, 204);
  strokeWeight(5);
  time_x=30*sin(time);
  time_y=30*cos(time);
  line(100, 100, 100+time_x, 100-time_y);
  if (!ifLevelPass) {
    if (playerController.ifShadowGenerated) {
      time-=0.008;
    } else {
      time+=0.008;
    }
  }
}
