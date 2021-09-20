/*
-
 - Jonathan Etiz
 - CCOMP-10 (Intro to Programming)
 - "Paint Clone" Assignment
 -
 */

import javax.swing.JColorChooser;
import java.awt.*;

PImage bucket;
PImage buffer;

//Color variable
color rgb = color(0, 0, 0);
Color javaColor;
Component colorPicker;

Brush brush = new Brush();

class Brush {
  //Pencil, Paint, Marker, Fill
  String type = "paint";
  //Brush size
  int size = 16;

  void update() {
    /*
    loadPixels();

    //Create buffer array that is length of pixels array minus the top bar (100 pixels tall).
    color[] buffer = new color[pixels.length - (width * 100)];
    
    for (int i = (width * 100); i < pixels.length; i++) {
      
    }*/
    
    //Prevent over/underflow (min size = 1, max size = 256)
    if (brush.size < 1) size = 1;
    if (size > 256) size = 256;
    switch (type) {
    case "pencil":
      if (mouseY > 100) {
          noStroke();  
          fill(rgb);
          circle(mouseX, mouseY, size);
      } else {
        cursor(ARROW);
      }
      break;
    case "paint":
      if (mouseY > 100) {
        for (int i = 0; i < size; i++) {
          stroke(rgb, 128-(128 * i/size));
          noFill();
          circle(mouseX, mouseY, i);
        }
      } else {
        cursor(ARROW);
      }
      break;
    case "marker":
      if (mouseY > 100) {
          noStroke();  
          fill(rgb);
          rect(mouseX - (size/2), mouseY - (size/2), size, size);
      } else {
        cursor(ARROW);
      }
      break;
    case "fill":
      if (mouseY > 100) {
        noCursor();
        image(bucket, mouseX, mouseY);
      } else {
        cursor(ARROW);
      }
      break;
    }
  }

  void paint() {
    switch (type) {
      case "fill":
        fill(rgb);
        noStroke();
        rect(0,101,width,height-101);
      break;
    }
  buffer = get(0,100,width,height-100);
  }
}

void setup() {
  size(1024, 800);
  background(255);
  bucket = loadImage("bucket.png");
  bucket.resize(32, 32);
  buffer = get(0,100,width,height-100);
}

void draw() {
  background(255);
  image(buffer,0,100);
  brush.update();
  //"Toolbar" area; Drawn after so you can't draw on top.
  noStroke();
  fill(200, 200, 255);
  rect(0, 0, width, 100);
  stroke(0);
  line(0, 100, width, 100);

  //Current Color Info
  fill(rgb);
  rect(0, 0, 256, 64);
  fill(0);
  textSize(16);
  textAlign(CENTER);
  text("Current Color", 128, 86);

  //Brush type selector
  //Pencil button
  fill(active("pencil"));
  rect(280, 0, 64, 64);
  fill(0);
  text("Pencil",312,40);

  //Paint button
  fill(active("paint"));
  rect(344, 0, 64, 64);
  fill(0);
  text("Paint",376,40);

  //Marker button
  fill(active("marker"));
  rect(408, 0, 64, 64);
  fill(0);
  text("Marker",440,40);

  //Fill button
  fill(active("fill"));
  rect(472, 0, 64, 64);
  image(bucket,488,16);
  
  fill(0);
  text("Current Brush", 408, 86);
}

void mousePressed() {
  //If user clicks on the color picker
  if (mouseX <= 256 && mouseY <= 64) {
    javaColor = JColorChooser.showDialog(colorPicker, "Color Chooser", Color.white);
    if (javaColor != null) rgb = color(javaColor.getRed(), javaColor.getGreen(), javaColor.getBlue());
  }
  
  //If user clicks on pencil selector
  if (mouseX >= 280 && mouseX < 344 && mouseY <= 64) {
    brush.type = "pencil";
  }
  //If user clicks on paint selector
  if (mouseX >= 344 && mouseX < 408 && mouseY <= 64) {
    brush.type = "paint";
  }
  //If user clicks on marker selector
  if (mouseX >= 408 && mouseX < 472 && mouseY <= 64) {
    brush.type = "marker";
  }
  //If user clicks on fill selector
  if (mouseX >= 472 && mouseX < 536 && mouseY <= 64) {
    brush.type = "fill";
  }
  
  //If user clicks on canvas
  if (mouseY > 100) brush.paint();
}

void mouseDragged() {
  //If user clicks on canvas
  if (mouseY > 100) brush.paint();
}

void keyPressed() {
  if (key == 't') {
    javaColor = JColorChooser.showDialog(colorPicker, "Color Chooser", Color.white);
    if (javaColor != null) rgb = color(javaColor.getRed(), javaColor.getGreen(), javaColor.getBlue());
  }
}

void mouseWheel(MouseEvent event) {
  int e = int(event.getCount());
  brush.size = brush.size + e;
}

color active(String type) {
  if (type == brush.type) {
    return color(200);
  } else {
    return color(255);
  }
}
