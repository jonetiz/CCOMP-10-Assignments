/*
-
- Jonathan Etiz
- CCOMP-10 (Intro to Programming)
- "Gravity" Assignment
-
*/

//Acceleration due to gravity (m/s/s)
float gravityCoefficient = 9.81;

//Framerate, very important for acceleration.
int framerate = 60;

//Instance a new thing and we'll call it thingy
thing thingy = new thing(256, 0, 0.9);

class thing {
  float x, y;
  
  //Elasticity/how bouncy it is.
  float e;
  //Velocity
  PVector v = new PVector(0,0);
  //Boolean for if the ball is grounded and shouldn't have any vertical velocity.
  boolean grounded = false;
  
  thing (int xbase, int ybase, float elasticity) {
    x = xbase;
    y = ybase;
    e = elasticity;
  }
  
  void update() {
    fill(#ffffff);
    circle(x,y,32);
    
    //Add gravity
    v.set(v.x, v.y + gravityCoefficient/framerate);
    
    //If it hits the bottom, make it bounce or stop based on elasticity.
    if (y >= 496) {
      v.y = (v.y * -e) + gravityCoefficient/framerate;
    }
        
    //Set position based on velocity
    x = x + v.x;
    y = y + v.y;
    
    if (x >= 528) {
      x = -16;
    } else if (x <= -16) {
      x = 528;
    }
  }
}

void setup() {
  size(512,512);
  frameRate(framerate);
}

void draw() {
  background(0);
  //run code for thingy
  thingy.update();
}

void keyPressed() {
  if(key == CODED) {
    if (keyCode == RIGHT) {
      thingy.v.x++;
    } else if (keyCode == LEFT) {
      thingy.v.x--;
    }
  }
}
