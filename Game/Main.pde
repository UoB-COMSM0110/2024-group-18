Player player;
PlayerController playerController;
// Each one generate a map for one level, will need 2 more
Map map;
Map map2;
Map map3;
String story1 = "You are an astronaut, stuck in unknown space, \n unable to get home.";
String story2 = "Before you lie a button, a door, \n and a mysterious machine that seems to have something to do with \n TIME TRAVEL.\n Could these be your ticket out?";

float lag=0;
int level;
PImage startScreen;
PImage title;
PImage setting;
PImage control;
boolean showControlBar=false;
boolean showSettingBar=false;
PImage controlOption;
PImage levelOption1;
PImage levelOption2;
PImage levelOption3;
PImage background01;
PImage clock;
float time=0;
float time_x;
float time_y;
int controlMode=1;  // 1:WASD  2:arrow keys
boolean ifGameOver=false;
boolean ifLevelPass=false;
boolean ifMapGenerated=false;

float xPos, ypos;
float xSpeed=0.8, ySpeed=0.8;
int xDirection=1, yDirection=1;

PFont font;
void setup() {
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

  level=-2;

  player = new Player();
  playerController = new PlayerController(player);
  map = new Map("./maps/map2.txt");
  // Store map items in list from mapController
  map.generateMap();
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
      //generateBackground(background01);
      image(background01,800,450,1600,900);
    }else if(level==2){
      if(!ifMapGenerated){
        map=new Map("./maps/map2.txt");
        ifMapGenerated=true;
        map.generateMap();
      }
      
      image(background01,800,450,1600,900);
    }else if(level==3){
      // should do same with level2
      map=new Map("./maps/map3.txt");
      image(background01,800,450,1600,900);
    }
    placeClock();

    // Generate map based on level
    map.displayMap(level);
    // Show player animation and location
    playerDraw();
    checkGameStatus();
  }
  if (level!=-2) {
    generateNormalUI();
  }
}

void checkGameStatus() {
  if (playerController.checkGameOver()) {
    fill(0);
    text("Game over!", 650, 400);
    text("Click to restart", 580, 450);
    ifGameOver=true;
  }

  if (playerController.ifGameWin) {
    text("Congratulations. You passed this level!!", 650, 400);
    ifLevelPass=true;
  }
}

void generateStory() {
  fill(0);
  rect(0, 0, 1600, 900);
  fill(255);
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

void generateNormalUI() {
  image(setting, 1500, 100, 100, 100);
  image(control, 1350, 100, 100, 100);
  if (showControlBar) {
    image(controlOption, 1300, 320, 200, 300);
  }

  if (showSettingBar) {
    image(levelOption1, 1500, 220, 180, 100);
    image(levelOption2, 1500, 320, 180, 100);
    image(levelOption3, 1500, 420, 180, 100);
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
  //text("Game Name",550,200);
  image(title, 800, 200, 1000, 500);
  textSize(20);
  noStroke();
  fill(0, 0, 0, 80);
  rect(300, 770, 1000, 40);
  fill(255);
  text("press any key to start", 600, 800);
}

void playerDraw() {
  // The Method updatelocation is changed to take mapController as an input
  playerController.updateLocation(map);
  playerController.interactDynamicItems(map);
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
}



void keyReleased() {
  if (keyCode == UP||key=='w') {
    return;
  }
  playerController.movementReset();
}


void mousePressed() {
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

  if (ifGameOver) {
    restartLevel();
  }
  
  if(ifLevelPass){
    level++;
    println(level);
    ifLevelPass=false;
  }
}

public void restartLevel() {
  time=0;
  playerController.ifShadowGenerated=false;
  playerController.shadow.location.set(0, 0);
  player.location.set(120, 500);
  player.velocity.set(0, 0);
  ifGameOver=false;
}

//void generateBackground(PImage bg) {
//  for (int i=0; i<15; i++) {
//    for (int j=0; j<10; j++) {
//      image(bg, i*128, j*128, 128, 128);
//    }
//  }
//}

public void placeClock() {
  image(clock, 100, 100, 300, 300);
  stroke(255,204,204);
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
