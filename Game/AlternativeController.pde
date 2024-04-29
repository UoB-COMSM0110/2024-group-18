// Import vision libraries for processing images and detecting objects.
import ch.bildspur.vision.*;
import ch.bildspur.vision.result.*;
// Import libraries for video capturing.
import processing.video.Capture;
// Import libraries for processing sound.
import processing.sound.*;

// Define a class called AlternativeController to manage alternative inputs like camera and sound.
class AlternativeController {
  PlayerController playerController;

  // Declare variables for sound processing.
  Amplitude amp;
  AudioIn in;

  // Declare variables for vision and camera processing.
  DeepVision vision;
  ULFGFaceDetectionNetwork network;
  ResultList<ObjectDetectionResult> detections;
  Capture cam;
  float camX, camY, camWidth, camHeight;

  // Constructor initializes all components required for vision and sound processing.
  public AlternativeController(PApplet parent, PlayerController playerController) {
    this.playerController = playerController;
    vision = new DeepVision(parent);

    // Setup the face detection network and initialize the camera.
    network = vision.createULFGFaceDetectorRFB320();
    network.setup();
    String[] cameras = Capture.list();
    if (cameras.length == 0) {
      exit(); // Exit if no cameras are found.
    }
    cam = new Capture(parent, cameras[0]);
    cam.start();

    // Setup audio input and amplitude measurement.
    amp = new Amplitude(parent);
    in = new AudioIn(parent, 0);
    in.start();
    amp.input(in);

    // Initialize camera display settings.
    camWidth = 160;
    camHeight = 90;
    camX = parent.width - camWidth;
    camY = parent.height - camHeight;
  }

  // Control method uses sound and camera inputs to control player movement.
  void control() {
    soundController(); // Process sound input.
    imageMode(CORNER); // Set image mode for drawing.
    if (cam.available()) {
      cam.read(); // Read from the camera.
    }
    image(cam, camX, camY, camWidth, camHeight); // Display camera image.

    // Run object detection and handle detected objects.
    detections = network.run(cam);
    noFill();
    strokeWeight(2f);
    stroke(200, 80, 100);
    for (ObjectDetectionResult detection : detections) {
      rect(cameraX(detection), cameraY(detection), detection.getWidth()/2.5, detection.getHeight()/5);

      // Determine player movement based on object position.
      if (cameraX(detection) < camX + (camWidth / 2) - 30) {
        playerController.inputRight = true;
      } else if (cameraX(detection) > camX + (camWidth / 2) + 30) {
        playerController.inputLeft = true;
      } else {
        playerController.inputRight = false;
        playerController.inputLeft = false;
        playerController.movementReset();
      }
    }
    imageMode(CENTER); // Reset image mode.
  }

  // Helper method to process amplitude and trigger upward movement.
  private void soundController() {
    if (amp.analyze() > 0.02) {
      playerController.inputUp = true;
    } else {
      playerController.inputUp = false;
    }
  }

  // Map camera's detection coordinates to the display coordinates.
  private float cameraX(ObjectDetectionResult detection) {
    return map(detection.getX(), 0, cam.width, camX, camX + camWidth);
  }

  private float cameraY(ObjectDetectionResult detection) {
    return map(detection.getY(), 0, cam.height, camY, camY + camHeight);
  }
}
