Player player;
PlayerController playerController;
// Each one generate a map for one level, will need 2 more
Map map;
String story1="In 2100s, You are a astronaut but dropped into an unknown space.\n You found you can't contact outside anymore.";
String stroy2="There's only a button, a door and a mystery machine in front of your sight.\n You started thinking if this could help u get way out...";

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

float xPos,ypos;
float xSpeed=0.8,ySpeed=0.8;
int xDirection=1,yDirection=1;

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
  background01=loadImage("./assets/Background/Blue.png");
  clock = loadImage("./assets//Clock.png");
  levelOption1 = loadImage("./assets/Background/level1.png");
  levelOption2 = loadImage("./assets/Background/level2.png");
  levelOption3 = loadImage("./assets/Background/level3.png");

  level=-1;

  player = new Player();
  playerController = new PlayerController(player);
  map = new Map("./maps/map1.txt");
  // Store map items in list from mapController
  map.generateMap();
}

void draw() {
  imageMode(CENTER);
  if(level==-1){
    showTitle();
  }
  // Generate background based on level
  else if (level==0) {
    generateStartUI();
  } else {
    if (level==1) {
      generateBackground(background01);
    }
    placeClock();
    
    // Generate map based on level
    map.displayMap(level);
    // Show player animation and location
    playerDraw();
  }
  if(level!=-1){
    generateNormalUI();

  }
}

void showTitle(){
  image(startScreen,800,450,1630,930);
  fill(0,0,0,255-lag*8);
  rect(0,0,1600,900);
  image(title,800,450-lag*10,1000,500);
  if(lag==25){
    level=0;
  }
  lag++;
}

void generateNormalUI(){
  image(setting,1500,100,100,100);
  image(control,1350,100,100,100);
  if(showControlBar){
    image(controlOption,1300,320,200,300);
  }
  
  if(showSettingBar){
    image(levelOption1,1500,220,180,100);
    image(levelOption2,1500,320,180,100);
    image(levelOption3,1500,420,180,100);
  }
}

void generateStartUI(){
  xPos=xPos+(xSpeed*xDirection);
  ypos=ypos+(ySpeed*yDirection);
  if(xPos>width/2+30||xPos<width/2-30){
    xDirection*=-1;
  }
  if(ypos>height/2+30||ypos<height/2-30){
    yDirection*=-1;
  }
  image(startScreen,xPos,ypos,1630,930);
  
  textSize(40);
  fill(0);
  //text("Game Name",550,200);
  image(title,800,200,1000,500);
  textSize(20);
  noStroke();
  fill(0,0,0,80);
  rect(300,770,1000,40);
  fill(255);
  text("press any key to start",600,800);
}

void playerDraw() {
  // The Method updatelocation is changed to take mapController as an input
  playerController.updateLocation(map);
  playerController.interactDynamicItems(map);
  playerController.updateAnimation();
  player.updateAnimation();
  playerController.displayShadow();
  
  player.velocity.add(player.acceleration);
  player.location.add(player.velocity);
}

void keyPressed() {
  if(level==0){
    showStory();
    level=1;
  }
  playerController.movementControl();
}

void showStory(){
  for(int i=0;i<1000;i++){
    background(0);
    text(story1,300,300);
  }
}

void keyReleased() {
  playerController.movementReset();
}

void mousePressed(){
  if(mouseX>1300&&mouseX<1400
  &&mouseY>50&&mouseY<150){
    if(showControlBar){
      control=loadImage("./assets/Background/control.png");
      showControlBar=false;
    }else{
      control=loadImage("./assets/Background/control2.png");
      showControlBar=true;
    }
  }
  if(mouseX>1450&&mouseX<1550
  &&mouseY>50&&mouseY<150){
    if(showSettingBar){
      setting=loadImage("./assets/Background/setting.png");
      showSettingBar=false;
    }else{
      setting=loadImage("./assets/Background/setting2.png");
      showSettingBar=true;
    }
  }
}

void generateBackground(PImage bg) {
  for (int i=0; i<15; i++) {
    for (int j=0; j<10; j++) {
      image(bg, i*128, j*128, 128, 128);
    }
  }
}

public void placeClock() {
  image(clock, 100, 100, 200, 200);
  stroke(0);
  strokeWeight(5);
  time_x=20*sin(time);
  time_y=20*cos(time);
  line(100, 100, 100+time_x, 100-time_y);
  time+=0.005;
}
