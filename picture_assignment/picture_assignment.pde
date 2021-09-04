/*
-
- "Draw a Picture" Assignment
- Jonathan Etiz
- CCOMP-10 (Intro to Programming)
-
*/

void setup() {
  size(512,384);
  background(255,88,43);
}

void draw() {
  // Sun
  fill(244,247,239);
  stroke(253,215,122);
  ellipse(256,128,128,128);
  // Grass
  fill(64,128,64);
  stroke(0);
  rect(0,256,512,128);
  // Mountain 1
  fill(128,128,128);
  triangle(32,260,108,90,184,260);
  // Mountain 4 (from left)
  fill(128,128,128);
  triangle(290,276,364,108,440,276);
  // Mountain 2
  fill(128,128,128);
  triangle(116,284,192,132,268,284);
  // Mountain 3
  fill(128,128,128);
  triangle(218,290,294,138,370,290);
  // House Base
  fill(128,64,64);
  rect(64,284,128,64);
  // Door
  fill(128,90,0);
  rect(90,300,24,48);
  // Doorknob
  fill(225,225,0);
  ellipse(108,326,4,4);
  // Window
  fill(64,180,255);
  rect(128,300,48,32);
  // Roof
  fill(64,32,0);
  triangle(48,284,124,232,208,284);
}
