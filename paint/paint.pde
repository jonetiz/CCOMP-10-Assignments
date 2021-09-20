/*
-
 - Jonathan Etiz
 - CCOMP-10 (Intro to Programming)
 - "Paint Clone" Assignment
 -
 */

//Import stuff
import javax.swing.JColorChooser;
import javax.swing.JFileChooser;
import javax.swing.filechooser.FileFilter;
import java.awt.*;

//Initialize the bucket and buffer images.
PImage bucket;
//Buffer used for saving and stuff.
PGraphics buffer;
//Background image
PImage background;

//Color variable
color rgba = color(0, 0, 0, 255);
color transparent = color(0, 0);
Color javaColor;
Component colorPicker;

//File save stuff
Component fcParent;
JFileChooser fileChooser = new JFileChooser();

//Initialize our brush object
Brush brush = new Brush();

//Ctrl key boolean for Ctrl+S
boolean ctrlKey = false;

void setup() {
  size(1024, 800);
  surface.setTitle("Macrosoft Paint");
  bucket = loadImage("bucket.png");
  bucket.resize(32, 32);
  
  buffer = createGraphics(width, height-100);
  
  background = loadImage("transparency.png");
}

void draw() {
  for (int x = 0; x < width; x = x + 128) {
    for (int y = 0; y < height; y = y + 128) {
      image(background,x,y);
    }
  }
  
  image(buffer, 0, 100);
  brush.update();
  
  noStroke();
  fill(200, 200, 255);
  rect(0, 0, width, 100);
  stroke(0);
  line(0, 100, width, 100);
  
  //Current Color Info
  fill(rgba);
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
  text("Pencil", 312, 40);
  
  //Paint button
  fill(active("paint"));
  rect(344, 0, 64, 64);
  fill(0);
  text("Paint", 376, 40);
  
  //Marker button
  fill(active("marker"));
  rect(408, 0, 64, 64);
  fill(0);
  text("Marker", 440, 40);
  
  //Fill button
  fill(active("fill"));
  rect(472, 0, 64, 64);
  image(bucket, 488, 16);
  
  //Erase button
  fill(active("erase"));
  rect(536, 0, 64, 64);
  fill(0);
  text("Erase", 568, 40);
 
  fill(0);
  text("Current Brush", 408, 86);
  
  //Broken unfortunately
  //surface.setResizable(true);
}

void mousePressed() {
  //If user clicks on the color picker
  if (mouseX <= 256 && mouseY <= 64) {
    javaColor = JColorChooser.showDialog(colorPicker, "Color Chooser", Color.white);
    if (javaColor != null) rgba = color(javaColor.getRed(), javaColor.getGreen(), javaColor.getBlue(), javaColor.getAlpha());
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

  //If user clicks on erase selector
  if (mouseX >= 536 && mouseX < 600 && mouseY <= 64) {
    brush.type = "erase";
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
    if (javaColor != null) rgba = color(javaColor.getRed(), javaColor.getGreen(), javaColor.getBlue(), javaColor.getAlpha());
  }

  if (key == 's') {
    int returnVal = fileChooser.showSaveDialog(fcParent);
    if (returnVal == JFileChooser.APPROVE_OPTION) {
      buffer.save(fileChooser.getSelectedFile().getAbsolutePath());
    }
  }
}

void mouseWheel(MouseEvent event) {
  int e = int(event.getCount());
  brush.size = brush.size - e;
}

color active(String type) {
  if (type == brush.type) {
    return color(200);
  } else {
    return color(255);
  }
}
