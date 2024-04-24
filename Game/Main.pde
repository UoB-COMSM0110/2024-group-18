import java.text.*;
/* All useful classes needed on main*/
Player player;
PlayerController playerController;
AlternativeController alternativeController;
Map map;
/* Variables used for .log output*/
PrintWriter output;
int outputFrame=0;
/* Variables for main game logic*/
float lag;
int level;
PImage startScreen;
PImage title;
PImage setting;
PImage control;
boolean showControlBar;
boolean showDisabilityDetails;
boolean showDisabilityError;
boolean showSettingBar;
PImage controlOption;
PImage levelOption1;
PImage levelOption2;
PImage levelOption3;
PImage background01;
PImage background02;
PImage resetButton;
PImage disabilityButton;
PImage clock;
float time;
float time_x;
float time_y;
ControlType controlMode;
boolean ifGameOver;
boolean ifLevelPass;
boolean ifMapGenerated;
int ESCAPE_KEYCODE=27;
/* Variables for startup screen*/
float xPos, ypos;
float xSpeed, ySpeed;
int xDirection, yDirection;
/* Variables for hint in tutorial level*/
int hintLag;
int moveLag;
int invertLag;
boolean ifRestarted;
PImage moveHint;
PImage jumpHint;
PImage reviewHint;
/* Variabls for font in game*/
PFont font;
/* Variables for disability mode*/
boolean isLoadingAlternative = false;
int alternativeLag = 0;
/* Variables to check system type*/
int alphaValue = 0;
boolean isLinux = false;
int endStart = 1200;
/* Define game mode in enum*/
enum ControlType {
  NORMAL, DISABLED
}
/* To initiate the game variables, also used to reset the game when restart*/
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
  showDisabilityError = false;
  showSettingBar = false;
  controlMode = ControlType.NORMAL;
  xSpeed = 0.4;
  ySpeed = 0.4;
  xDirection = 1;
  yDirection = 1;
  time_x = 0;
  time_y = 0;
}
/* To initiate variables which just need to be generated by once*/
void setup() {
  size(1600, 900, P2D);
  fill(0);
  output=createWriter("./logs/test"+getTime()+".log");
  initializeGlobalVariablesToStartingValues();
  xPos=width/2;
  ypos=height/2+20;
  font=createFont("./assets/PressStart2P-Regular.ttf", 20);
  textFont(font);
  title=loadImage("./assets/Background/title.png");
  startScreen=loadImage("./assets/Background/titleBackground.png");
  setting=loadImage("./assets/Background/setting.png");
  control=loadImage("./assets/Background/control.png");
  controlOption=loadImage("./assets/Background/control_key.png");
  background01=loadImage("./assets/Background/star.jpeg");
  background02=loadImage("./assets/Background/star2.jpeg"); // need to make this image correct size
  clock = loadImage("./assets/Background/clock-asset.png");
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
  // After initiate everything, the start time and message will print out in log file
  output.println(getTime()+" INFO: program started");
}

void draw() {
  try {
    // use || to contain other kind of loading, check system type and if it supports disability mode
    if (isLoadingAlternative || isLinux) {
      loading();
      return;
    }
    // End of the whole game
    if (playerController.ifGameWin && level == 3) {
      showEnd();
      return;
    }
    // Set main focus of all image on center, which helps location set and collision check 
    imageMode(CENTER);
    // logic for stage and level change
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
          // Initiate variables for easy level
          map=new Map("./maps/map2.txt", 2);
          ifMapGenerated=true;
          map.generateMap();
          map.placeBomb();
          player.location.x = 100; // ensure the player starts at the correct location for level 2.
        }
        showBackground();
        map.displayBomb(time);
      } else if (level==3) {
        // Initiate variables for hard level
        if (!ifMapGenerated) {
          map=new Map("./maps/map3.txt", 3);
          ifMapGenerated=true;
          map.generateMap();
          map.placeBomb();
          player.location.x = 100; // ensure the player starts at the correct location for level 2.
        }
        showBackground();
        map.displayBomb(time);
      }
      placeClock();

      map.displayMap();
      playerDraw();
      checkGameStatus();
    }
    // Show UI on top based on different stages and levels
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
  // Output game status per 10 sec, and output every exception met on game
  catch(Exception e) {
    String time=getTime();
    StackTraceElement[] info = e.getStackTrace();
    output.println(time+": BUG occurred ---> "+e.getMessage());
    for (int i=0; i<info.length; i++) {
      output.println("At line "+info[i].getLineNumber()+" in function "+info[i].getMethodName());
    }
  }
  if (outputFrame%100==0) {
    String time=getTime();
    output.println(time+" INFO: program running");
    // TODO: test everyting in draw, output results for testing
    output.flush();
  }
  outputFrame++;
}

/* Show the game end screen when hard level finished */
public void showEnd() {
  fill(0, alphaValue);
  rect(0, 0, width, height);
  if (alphaValue < 150) {
    alphaValue++;
  } else {
    image(loadImage("./assets/End/members.png"), width/2, endStart);
    image(loadImage("./assets/End/details.png"), width/2, endStart+height);
    image(loadImage("./assets/End/thanks.png"), width/2, endStart+2*height);
    image(loadImage("./assets/End/esc.png"), width/2, height-30);
    if (endStart > - height-500) {
      endStart -= 2;
    }
  }
}

/* Get current time from system for log */
public String getTime() {
  SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH-mm-ss");
  Date date = new Date(System.currentTimeMillis());
  return format.format(date);
}

/* Show loading and inform screen when meet requirement */
void loading() {
  if (isLoadingAlternative) {
    image(loadImage("./assets/Background/loadingDisability.png"), width/2, height/2);
  } else if (isLinux) {
    image(loadImage("./assets/Background/LinuxErr.png"), width/2, height/2);
  }
}

/* Show background during game */
void showBackground() {
  if (level != 3) {
    image(background01, 800, 450, 1600, 900);
  } else {
    image(background02, 800, 450, 1600, 900);
  }
}

/* check how player died during game and present a specific death message*/
void checkGameStatus() {
  if (playerController.checkGameOver(map, level)) {
    player.ifDead=true;
    fill(0);
    if (playerController.deadByHitPreviousPlayer) {
      image(loadImage("./assets/Background/paradox.png"), width/2, height/2);
    } else {
      image(loadImage("./assets/Background/gameOver.png"), width/2, height/2);
    }
    time=0;
    ifGameOver=true;
  }
  // handle when this level passed
  if (playerController.ifGameWin&&level<3) {
    image(loadImage("./assets/Background/nextLevel.png"), width/2, height/2);
    ifLevelPass=true;
  }
}

/* Generate story when first entering the game */
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

/* Show title before game startup */
void showTitle() {
  image(startScreen, 800, 450, 1630, 930);
  fill(0, 0, 0, 255-lag*8);
  rect(0, 0, 1600, 900);
  image(title, 800, 450-lag*10, 1000, 500);
  if (lag==25) {
    level=-1;
  }
  lag+=0.5;
}

/* Generate UI botton on the right top of the screen during game*/
void generateInGameUI() {
  image(resetButton, 1500, 100, 100, 100);
  image(control, 1350, 100, 100, 100);
  if (showControlBar) {
    image(controlOption, 1300, 320, 200, 300);
  }
  if (showDisabilityError) {
    text("true", 500, 500);
    image(loadImage("./assets/Background/disableErr.png"), width/2, height/2);
  }
}

/* Generate UI botton on the right top of the screen before level start*/
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
  if (showDisabilityDetails) {
    //fill(0);
    //text("Accessibility mode activated: \n You may now control the character without a keyboard, \n by leaning your body left and right, and making a noise to jump.", 100, 500);
    if (alternativeLag <= 100) {
      image(loadImage("./assets/Background/disableDetail.png"), width/2, height/2);
      alternativeLag++;
    }
  }
  if (showDisabilityError) {
    //fill(0);
    //text("Something went wrong, your computer may not support disability mode, check the README page.", 100, 500);
    image(loadImage("./assets/Background/disableErr.png"), width/2, height/2);
  }
}

/* logic for dynamic startup screen */
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

/* Generate hint in tutorial level */
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
  if (hintLag >0 && hintLag <= 200 && !playerController.ifPastSelfGenerated) {
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
  if (playerController.ifPastSelfGenerated && hintLag>0 && invertLag == 0) {
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

/* main logic for player */
void playerDraw() {
  if (controlMode==ControlType.DISABLED) {
    try {
      alternativeController.control();
    }
    catch (Exception e) {
      showDisabilityError=true;
    }
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
    playerController.displayPastSelf();
  }
  player.velocity.add(player.acceleration);
  player.location.add(player.velocity);
}

/* All logic triggerred by clicked on any key */
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
}

/* Retrun to main menu during game */
void resetToMainMenu() {
  key = 0;
  lag=25;
  setup();
  alternativeController=null;
  level=-1; // this skips past the opening animation.
}

/* Logic for movement, ensure player can keep moving after jumped */
void keyReleased() {
  if (keyCode == UP||key=='w') {
    return;
  }
  playerController.movementReset();
}

/* Logic when clicked the button on UI area */
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

/* Used to show control bar after clicked button */
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

/* Restart the level after clicked refresh button */
void resetButtonClicked() {
  if (level<=0) {
    return; // reset button only applies within a level.
  }
  if (mouseX>1450&&mouseX<1550
    &&mouseY>50&&mouseY<150) {
    restartLevel();
  }
}

/* Logic for level choosing */
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

// Logic after clicked disability mode
void disabilityButtonClicked() {
  if (mouseX>1150&&mouseX<1250
    &&mouseY>50&&mouseY<150) {
    if (platformNames[platform]=="linux") {
      // print("DISABILITY MODE NOT SUPPORTED ON LINUX.");
      //image(loadImage("./assets/Background/LinuxErr.png"), width/2, height/2);
      isLinux = true;
      return;
    }
    if (isLinux == true) {
      isLinux = false;
      return;
    }
    if (showDisabilityDetails) {
      disabilityButton=loadImage("./assets/Background/disabled.png");
      controlMode=ControlType.NORMAL;
      showDisabilityDetails=false;
      alternativeLag = 0;
    } else {
      disabilityButton=loadImage("./assets/Background/disabled2.png");
      controlMode=ControlType.DISABLED;
      if (alternativeController==null) {
        isLoadingAlternative = true;
        PApplet app = this;
        new Thread(new Runnable() {
          public void run() {
            try {
              alternativeController = new AlternativeController(app, playerController);
            }
            catch (Exception e) {
              showDisabilityError=true;
              return;
            }
            isLoadingAlternative = false;
          }
        }
        ).start();
      }
      showDisabilityDetails=true;
    }
  }
}

/* Logic for mousing pressing button area */
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
    time=0;
    ifLevelPass=false;
    playerController.refresh(map);
  }
}

/* Logic for restart level when game over and restart the game by player */
public void restartLevel() {
  hintLag = 0;
  moveLag = 0;
  invertLag = 0;
  time=0;
  playerController = new PlayerController(player);
  if (controlMode==ControlType.DISABLED) {
    try {
      alternativeController= new AlternativeController(this, playerController);
    }
    catch(Exception e) {
      showDisabilityError=true;
    }
  }
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
  alphaValue = 0;
  endStart = 1200;
}

/* Logic for the clock on left top of the screen, as a reminder for time inverse */
public void placeClock() {
  image(clock, width/2, 100, 300, 300);
  fill(0);
  int hour = getHour();
  int minute = getMinute();
  
  // Format hour with leading zero if necessary
  if (hour < 10) {
    text("0" + hour, width/2 - 60, 110);
  } else {
    text(hour, width/2 - 60, 110);
  }
  
  // Format minute with leading zero if necessary
  if (minute < 10) {
    text("0" + minute, width/2 + 20, 110);
  } else {
    text(minute, width/2 + 20, 110);
  }
  
  // Time manipulation logic
  if (!ifLevelPass) {
    if (playerController.ifPastSelfGenerated) {
      time -= 0.008;
    } else {
      time += 0.008;
    }
  }
}

private int getHour(){
  return (int)time;
}

private int getMinute(){
  return (int)((time-(int)time)*60);
}
