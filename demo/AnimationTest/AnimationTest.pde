import java.util.concurrent.TimeUnit;

PImage image[] = new PImage[7];
PImage image2[]=new PImage[2];
int i=3;
int index=0;
int speed=3;
int frame=0;
void setup(){
  size(200,200);
  
  image[0]=loadImage("./set/Desappearing-(96x96)_01.gif");
  image[1]=loadImage("./set/Desappearing-(96x96)_02.gif");
  image[2]=loadImage("./set/Desappearing-(96x96)_03.gif");
  image[3]=loadImage("./set/Desappearing-(96x96)_04.gif");
  image[4]=loadImage("./set/Desappearing-(96x96)_05.gif");
  image[5]=loadImage("./set/Desappearing-(96x96)_06.gif");
  image[6]=loadImage("./set/Desappearing-(96x96)_07.gif");
  
  //image2[0]=loadImage("./set/Run_0.gif");
  //image2[1]=loadImage("./set/Desappearing_01.png");
}

void draw(){
  background(255);
  stroke(166,205,231);
  rect(width/2-11,height/2-13,22,26);
  display(image);
}

public void display(PImage image[]){
  imageMode(CENTER);
  image(image[index],width/2,height/2);
  //image(image2[0],width/2,height/2);
  if(frame%5==0){
    index=(index+1)%image.length;
  }
  frame++;
  
  
    
}
