import processing.core.PVector;
import processing.core.PImage;

// Class representing a player in a game with various attributes and animations
class Player extends GameObject {
    PVector velocity;
    PVector acceleration;
    boolean isOnGround;
    float speed;
    boolean facingRight;
    boolean isJumping;
    float gravity;
    float jumpPower;
    float jumpDirectionalSpeed;
    float airControl;
    boolean platformTouched;
    boolean ifDead;

    int index;
    int frame;
    PImage[] idleLeft;
    PImage[] idleRight;
    PImage[] runLeft;
    PImage[] runRight;
    PImage[] jumpLeft;
    PImage[] jumpRight;
    PImage[] fallLeft;
    PImage[] fallRight;
    PImage[] disappear;
    PImage[] current_animation;
    PImage currentImage;

    // Use AnimationLoader to manage GIF loading
    private AnimationLoader animationLoader;

    public Player() {
        super(120, 500, 20, 60);
        animationLoader = new AnimationLoader("./assets/Player"); // Set base path
        initializeAttributes();
        loadAnimations(); // Load animations with AnimationLoader
        currentImage = animationLoader.loadImageWithCheck("./assets/Player/run/Run_01.gif"); // Default image
    }

    // Initialize player attributes
    private void initializeAttributes() {
        velocity = new PVector(0, 0);
        acceleration = new PVector(0, gravity);
        isOnGround = false;
        speed = 6.0f;
        facingRight = true;
        gravity = 2.0f;
        jumpPower = -30.0f;
        jumpDirectionalSpeed = 10.0f;
        airControl = 5.0f;
        platformTouched = false;
        ifDead = false;
        frame = 0;
        index = 0; // Initial animation index
    }

    // Load animations using AnimationLoader
    private void loadAnimations() {
        idleLeft = animationLoader.loadImages("idle/idleleft", 11);
        idleRight = animationLoader.loadImages("idle/idleright", 11);
        runLeft = animationLoader.loadImages("run/RunToLeft", 12);
        runRight = animationLoader.loadImages("run/Run", 12);
        jumpLeft[0] = animationLoader.loadImageWithCheck("./assets/Player/jump&fall/JumpLeft.png");
        jumpRight[0] = animationLoader.loadImageWithCheck("./assets/Player/jump&fall/JumpRight.png");
        fallLeft[0] = animationLoader.loadImageWithCheck("./assets/Player/jump&fall/FallLeft.png");
        fallRight[0] = animationLoader.loadImageWithCheck("./assets/Player/jump&fall/FallRight.png");
        disappear = animationLoader.loadImages("disappear/Desappearing-(96x96)_", 7);
    }

    public void updateAnimation() {
        selectStatus(); // Determine the appropriate animation
        if (ifDead) {
            displayDead();
        } else {
            displayImage();
        }
    }

    public void selectStatus() {
        if (ifDead) {
            current_animation = disappear;
            return;
        }

        if (velocity.x > 0) { // Moving right
            facingRight = true;
            current_animation = (velocity.y > 0) ? fallRight 
                              : (velocity.y < 0) ? jumpRight 
                              : runRight;
            index = 0; // Reset index
        } else if (velocity.x < 0) { // Moving left
            facingRight = false;
            current_animation = (velocity.y > 0) ? fallLeft 
                              : (velocity.y < 0) ? jumpLeft 
                              : runLeft;
            index = 0; // Reset index
        } else { // Idle
            current_animation = (velocity.y > 0) ? (facingRight ? fallRight : fallLeft)
                              : (velocity.y < 0) ? (facingRight ? jumpRight : jumpLeft)
                              : (facingRight ? idleRight : idleLeft);
        }
    }

    public void displayDead() {
        if (frame % 4 == 0) {
            currentImage = current_animation[index];
            index++;
            if (index >= current_animation.length) {
                this.location.set(width, height); // Move off-screen
                index = current_animation.length - 1; // Keep last frame
            }
        }
        frame++;
    }

    public void displayImage() {
        if (frame % 4 == 0) {
            currentImage = current_animation[index];
            index = (index + 1) % current_animation.length;
        }
        frame++;
    }
}
