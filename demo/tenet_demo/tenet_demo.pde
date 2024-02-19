import java.util.List;

private static int FRAME=80;
BufferedReader reader;
String line;
boolean input_flag=true;
int level=0;
PImage clock;
float time=0;
float time_x;
float time_y;
List<String> terrain;
int level_index;
int grid_index;
PImage boss[];
int bossFrame=0;
int bossIndex=0;

void setup(){
  size(500,500);
  reader = createReader("terrain.txt");
  clock = loadImage("Clock.png");
  terrain=new ArrayList<String>();
  boss = new PImage[2];
  boss[0] = loadImage("Megapack III Fallen Kings King Of Giants Goken.png");
  boss[1] = loadImage("Megapack III Fallen Kings King Of Giants Goken2.png");
}

void draw(){
  background(255);
  placeClock();
  if(input_flag){
    inputLine();
  }
  
  if(line!=null){
    terrain.add(line);
    level++;
  }
  
  if(line==null){
    input_flag=false;
  }
  makeTerrain(terrain);
  generateBoss();
  
}

public void inputLine(){
  try{
    line = reader.readLine();
   }catch(IOException e){
    e.printStackTrace();
    line=null;
   }
}

public void makeTerrain(List<String> terrain){
  strokeWeight(1);
  fill(222,184,135);
  for(int j=0;j<terrain.size();j++){
    for(int i=0;i<10;i++){
      if(terrain.get(j).charAt(i)=='1'){
        rect(i*50,420-50*j,50,50);
      }
    }
  }
}

public void placeClock(){
  imageMode(CENTER);
  image(clock,50,50);
  stroke(0);
  time_x=15*sin(time);
  time_y=15*cos(time);
  line(50,50,50+time_x,50-time_y);
  time+=0.005;
}

public void generateBoss(){
  if(bossFrame%FRAME==0){
    bossIndex++;
    bossIndex%=2;
  }
  bossFrame++;
  image(boss[bossIndex],230,80,width/6,height/6);
  fill(255,215,0,60);
  strokeWeight(5);
  stroke(255,215,0);
  ellipse(230,80,100,150);
}
