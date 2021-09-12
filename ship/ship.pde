/*
-
- Jonathan Etiz
- CCOMP-10 (Intro to Programming)
- "Ship" Assignment
-
*/

Ship ship = new Ship(512,256);

class Ship {
  //Position
  float x, y;
  //Rotation
  float rot;
  //Velocity
  PVector v = new PVector(0.0, 0.0);
  //Inertial dampeners for fun
  boolean inertialDampeners = true;
  //Terminal velocity in any direction
  float terminalVelocity = 5.0;
  
  Ship(int xpos, int ypos) {
    x = xpos;
    y = ypos;
  }
  
  void update() {
    //Handle terminal velocity
    if (v.x > terminalVelocity) v.x = terminalVelocity;
    if (v.x < -terminalVelocity) v.x = -terminalVelocity;
    if (v.y > terminalVelocity) v.y = terminalVelocity;
    if (v.y < -terminalVelocity) v.y = -terminalVelocity;
    
    x = x + v.x;
    y = y + v.y;
    v.set(v.x, v.y);
    
    //Draw the ship itself
    pushMatrix();
    translate(x,y);
    rotate(radians(rot));
    fill(255);
    triangle(-12,16,0,-16,12,16);
    popMatrix();
    
    if (x > width + 16) x = -16;
    if (x < -16) x = width + 16;
    if (y > height + 16) y = -16;
    if (y < -16) y = height + 16;
  }
  
  void calculateVelocity(int fv) {
    v.x += cos(radians(rot - 90)) * fv;
    v.y += sin(radians(rot - 90)) * fv;
  }
  
  void dampenVelocity() {
    //Dampen x velocity
    if (v.x < 0.25 && v.x > -0.25) {
      v.x = 0;
    } else if (v.x > 0) {
      v.x -= 0.25;
    } else if (v.x < 0) {
      v.x += 0.25;
    }
    //Dampen y velocity
    if (v.y < 0.25 && v.y > -0.25) {
      v.y = 0;
    } else if (v.y > 0) {
      v.y -= 0.25;
    } else if (v.y < 0) {
      v.y += 0.25;
    }
  }
}

void setup() {
  size(1024,512);
}

void draw() {
  background(0);
  ship.update();
  println(ship.v);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      ship.rot = ship.rot - 5;
    }
    if (keyCode == RIGHT) {
      ship.rot = ship.rot + 5;
    }
    if (keyCode == UP) ship.calculateVelocity(1);
    if (keyCode == DOWN) ship.calculateVelocity(-1);
  } else if (key == ' ') {
    //Inertial dampeners or something
    ship.dampenVelocity();
  }
}
