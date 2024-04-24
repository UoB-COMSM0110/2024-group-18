import ch.bildspur.vision.*;
import ch.bildspur.vision.result.*;
import processing.video.Capture;

import processing.sound.*;

class AlternativeController {
  PlayerController playerController;

  // The sound libraries
  Amplitude amp;
  AudioIn in;
  // The webcam and AI libraries.
  DeepVision vision;
  ULFGFaceDetectionNetwork network;
  ResultList<ObjectDetectionResult> detections;
  Capture cam;
  float camX;
  float camY;
  float camWidth;
  float camHeight;

  /* Creates a new instance of the alternative controller object including importing the machine vision libraries
  note that this takes several seconds so an appropriate loading screen should be shown to the user.  */
  public AlternativeController(PApplet parent, PlayerController playerController) {
    this.playerController=playerController;
    vision = new DeepVision(parent);

    // video stuff
    network = vision.createULFGFaceDetectorRFB320();
    network.setup();
    String[] cameras = Capture.list();
    if (cameras.length == 0) {
      exit();
    } 
    cam = new Capture(parent, cameras[0]);
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

  /* allows the controlling of the character with the webcam and sound input.
  Displays the webcam on the screen to provide feedback to the user. */
  void control() {
    // audio stuff
    soundController();
    //video stuff
    imageMode(CORNER);
    if (cam.available()) {
      cam.read();
    }
    image(cam, camX, camY, camWidth, camHeight);
    detections = network.run(cam);
    noFill();
    strokeWeight(2f);
    stroke(200, 80, 100);
    for (ObjectDetectionResult detection : detections) {
      rect(cameraX(detection), cameraY(detection), detection.getWidth()/2.5, detection.getHeight()/5);
      if (cameraX(detection)<camX+(camWidth/2)-20) {
        playerController.inputRight=true;
      } else if (cameraX(detection)>camX+(camWidth/2)+20) {
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
