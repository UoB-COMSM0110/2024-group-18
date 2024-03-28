import ch.bildspur.vision.DeepVision;
import ch.bildspur.vision.SingleHumanPoseNetwork;
import ch.bildspur.vision.result.HumanPoseResult;
import ch.bildspur.vision.result.KeyPointResult;
import processing.video.Capture;
import processing.sound.*;

class AlternativeController {
  PlayerController playerController;

  // sound libraries
  Amplitude amp;
  AudioIn in;
  // webcam and AI libraries.
  DeepVision vision;
  SingleHumanPoseNetwork pose;
  HumanPoseResult result;
  Capture cam;
  float threshold;
  float camX;
  float camY;
  float camWidth;
  float camHeight;

  public AlternativeController(PApplet parent, PlayerController playerController) {
    this.playerController=playerController;
    vision = new DeepVision(parent);
    threshold = 0.5;

    // video stuff
    pose = vision.createSingleHumanPoseEstimation();
    pose.setup();
    cam = new Capture(parent, "pipeline:autovideosrc");
    cam.start();

    // audio stuff
    amp = new Amplitude(parent);
    in = new AudioIn(parent, 0);
    in.start();
    amp.input(in);
    camWidth = 160;
    camHeight = 90;
    camX=width-camWidth;
    camY=height-camHeight;
  }

  void control() {
    imageMode(CORNER);
    // audio stuff
    soundController();

     //video stuff
    if (cam.available()) {
      cam.read();
    }
    image(cam, camX,camY, camWidth,camHeight);
    if (cam.width == 0) {
      return;
    }
    result = pose.run(cam);
    stroke(180, 80, 100);
    noFill();
    drawHuman(result);
    noFill();
    strokeWeight(2f);
    imageMode(CENTER); // return to default.
  }

  private void soundController() {
    if (amp.analyze()>0.01) {
      playerController.inputUp=true;
      println("UP"+millis());
    } else {
      playerController.inputUp=false;
    }
  }

  private float cameraX(KeyPointResult point) {
    return map(point.getX(), 0, cam.width, camX, camX + camWidth);
  }

  private float cameraY(KeyPointResult point) {
    return map(point.getY(), 0, cam.height, camY, camY + camHeight);
  }

  private void drawHuman(HumanPoseResult human) {
    // todo: maybe we can set these dynamically - eg tell the user to lean left / right and set them up like that?
    if (cameraX(human.getLeftEye())<camX+(camWidth/2)-10) {
      playerController.inputLeft=true;
    } else if (cameraX(human.getLeftEye())>camX+(camWidth/2)+10) {
      playerController.inputRight=true;
    } else {
      playerController.inputRight=false;
      playerController.inputLeft=false;
    }

    int i = 0;
    fill(0);
    for (KeyPointResult point : human.getKeyPoints()) {
      if (point.getProbability() < threshold)
        continue;

      // Map the keypoint's coordinates to the screen space where the camera feed is displayed
      ellipse(cameraX(point), cameraY(point), 2, 2);
      i++;
    }
  }
}
