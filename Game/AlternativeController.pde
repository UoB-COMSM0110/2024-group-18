import ch.bildspur.vision.*;
import ch.bildspur.vision.result.*;
import processing.video.Capture;

import processing.sound.*;

class AlternativeController {
  PlayerController playerController;

  // sound libraries
  Amplitude amp;
  AudioIn in;
  // webcam and AI libraries.
  DeepVision vision;
  ULFGFaceDetectionNetwork network;
  ResultList<ObjectDetectionResult> detections;
  Capture cam;
  float camX;
  float camY;
  float camWidth;
  float camHeight;

  public AlternativeController(PApplet parent, PlayerController playerController) {
    this.playerController=playerController;
    vision = new DeepVision(parent);

    // video stuff
    network = vision.createULFGFaceDetectorRFB320();
    network.setup();
      cam = new Capture(parent, "pipeline:avfvideosrc");
    
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
    // audio stuff
    soundController();

    //video stuff
    imageMode(CORNER);
    if (cam.available()) {
      cam.read();
    }
    // todo: figure out how to flip the webcam feed so it is drawn correctly
    image(cam, camX, camY, camWidth, camHeight);
    detections = network.run(cam);
    noFill();
    strokeWeight(2f);
    stroke(200, 80, 100);
    for (ObjectDetectionResult detection : detections) {
      rect(cameraX(detection), cameraY(detection), detection.getWidth()/2.5, detection.getHeight()/5);
      if (cameraX(detection)<camX+(camWidth/2)-10) {
        playerController.inputRight=true;
      } else if (cameraX(detection)>camX+(camWidth/2)+10) {
        playerController.inputLeft=true;
      } else {
        playerController.inputRight=false;
        playerController.inputLeft=false;
        playerController.movementReset();
      }
    }
    imageMode(CENTER); // return to default.
  }

  private void soundController() {
    if (amp.analyze()>0.01) {
      playerController.inputUp=true;
    } else {
      playerController.inputUp=false;
    }
  }

  private float cameraX(ObjectDetectionResult detection) {
    return map(detection.getX(), 0, cam.width, camX, camX + camWidth);
  }

  private float cameraY(ObjectDetectionResult detection) {
    return map(detection.getY(), 0, cam.height, camY, camY + camHeight);
  }

}
