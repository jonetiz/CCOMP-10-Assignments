/*
-
- "Dice Program" Assignment
- Jonathan Etiz
- CCOMP-10 (Intro to Programming)
-
*/

//Default # of faces is 6;
int faces = 6;
String shape = "Cube";

void setup() {
  size(512,512);
  background(255);
  noLoop();
}

void draw() {
  background(255); 
  textAlign(LEFT);
  fill(0);
  textSize(16);
  text("Press space to re-roll!", 352, 16);
  text("Modify number of faces using left and right arrows.", 8, 16);
  textSize(32);
  text("Number of Faces: " + str(faces), 8, 48);
  textSize(16);
  text("(" + shape + ")", 8, 70);
  
  int output = int(random(1, faces + 1));
  drawDie(output);
}

//Draw the die based on number of faces and output.
void drawDie(int output) {
  noFill();
  switch (faces) {
    case 4:
    case 8:
    case 20:
      //Draw a triangle.
      triangle(128,384,256,128,384,384);
    break;
    case 6:
      //Draw a square.
      rect(128,128,256,256);
    break;
    case 10:
      //Draw a kite.
      quad(128,300,256,128,384,300,256,384);
    break;
    case 12:
      //Draw a pentagon. Adapted from processing variable size polygon example.
      float angle = TWO_PI / 5;
      beginShape();
      for (float a = 0; a < TWO_PI; a += angle) {
        float sx = 256 + cos(a) * 128;
        float sy = 256 + sin(a) * 128;
        vertex(sx, sy);
      }
      endShape(CLOSE);
    break;
  }
  
  fill(0);
  //Draw pips; Else case adapted from processing variable size polygon example.
  if (output == 1) {
    ellipse(252, 252, 8, 8);
  } else {
    float angle = TWO_PI / output;
    for (float a = 0; a < TWO_PI; a += angle) {
      float sx = 256 + cos(a) * 48;
      float sy = 256 + sin(a) * 48;
      ellipse(sx, sy, 8, 8);
    }
    
    //Draw text representation when more than one pip.
    textAlign(CENTER);
    textSize(32);
    text(str(output), 256, 264);
  }
}

//Draw pips on the die. Taken from processing examples for polygons.

void keyPressed() {
  //Check for left/right arrow and adjust faces variable accordingly.
  if (key == CODED) {
    if (keyCode == LEFT) {
      switch(faces) {
        case 6:
          faces = 4;
          shape = "Tetrahedron";
        break;
        case 8:
          faces = 6;
          shape = "Cube";
        break;
        case 10:
          faces = 8;
          shape = "Octrahedron";
        break;
        case 12:
          faces = 10;
          shape = "Pentagonal Trapezohedron";
        break;
        case 20:
          faces = 12;
          shape = "Dodecahedron";
        break;
      }
      redraw();
    } else if (keyCode == RIGHT) {
      switch(faces) {
        case 4:
          faces = 6;
          shape = "Cube";
        break;
        case 6:
          faces = 8;
          shape = "Octrahedron";
        break;
        case 8:
          faces = 10;
          shape = "Pentagonal Trapezohedron";
        break;
        case 10:
          faces = 12;
          shape = "Dodecahedron";
        break;
        case 12:
          faces = 20;
          shape = "Icosahedron";
        break;
      }
      redraw();
    }
  //Roll on spacebar pressed.
  } else if (key == ' '){
    redraw();
  }
}
