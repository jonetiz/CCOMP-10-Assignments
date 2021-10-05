/*
-
 - Jonathan Etiz
 - CCOMP-10 (Intro to Programming)
 - "Paint Clone" Assignment - Brush Class
 -
 */

class Brush {
  //Pencil, Paint, Marker, Fill, Erase
  String type = "pencil";
  //Brush size
  int size = 16;

  void update() {
    //Prevent over/underflow (min size = 1, max size = 256)
    if (brush.size < 1) size = 1;
    if (size > 256) size = 256;
    switch (type) {
    case "pencil":
      if (mouseY > 100) {
        fill(rgba, 128);
        circle(mouseX, mouseY, size);
      } else {
        cursor(ARROW);
      }
      break;
    case "paint":
      if (mouseY > 100) {
        for (int i = 0; i < size/2; i++) {
          stroke(rgba, 128-(128 * i/size));
          noFill();
          circle(mouseX, mouseY, i);
        }
        stroke(0);
        noFill();
        circle(mouseX, mouseY, size);
      } else {
        cursor(ARROW);
      }
      break;
    case "marker":
      if (mouseY > 100) {
        fill(rgba, 128);
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
    case "erase":
      if (mouseY > 100) {
        stroke(0);
        noFill();
        circle(mouseX, mouseY, size);
      } else {
        cursor(ARROW);
      }
      break;
    case "eyedropper":
      if (mouseY > 100) {
        noCursor();
        cursor(eyedropper, mouseX-4, mouseY-28);
      } else {
        cursor(ARROW);
      }
      break;
    }
  }

  void paint() {
    switch (type) {
    case "pencil":
      buffer.beginDraw();
      buffer.noStroke();
      buffer.fill(rgba);
      buffer.circle(mouseX, mouseY-100, size);
      buffer.endDraw();
      break;
    case "paint":
      buffer.beginDraw();
      for (int i = 0; i < size/2; i++) {
        buffer.stroke(rgba, 128-(128 * i/size));
        buffer.noFill();
        buffer.circle(mouseX, mouseY - 100, i);
      }
      buffer.endDraw();
      break;
    case "marker":
      buffer.beginDraw();
      buffer.noStroke();
      buffer.fill(rgba);
      buffer.rect(mouseX - (size/2), mouseY - (size/2) - 100, size, size);
      buffer.endDraw();
      break;
    case "fill":
      buffer.beginDraw();
      color c = buffer.get(mouseX, mouseY);
      println(c);
      for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++) {
          if (buffer.get(x,y) == c) {
            buffer.set(x,y,rgba);
          }
        }
      }
      buffer.endDraw();
      break;
    case "erase":
      buffer.beginDraw();
      //Check inside bounding rectangle of an arbitrary distance (size) from the mouse position and replace pixels of the color clicked on.
      for (int x = mouseX - (size/2); x < mouseX + (size/2); x++) {
        for (int y = mouseY - (size/2); y < mouseY + (size/2); y++) {
          //Yoinked the calc from https://stackoverflow.com/questions/14487322/get-all-pixel-array-inside-circle
          double dx = x - mouseX;
          double dy = y - mouseY;
          double distanceSquared = dx * dx + dy * dy;

          if (distanceSquared <= (size/2)*(size/2))
          {
            buffer.set(x, y - 100, transparent);
          }
        }
      }
      buffer.endDraw();
      break;
    case "eyedropper":
      rgba = buffer.get(mouseX-4, mouseY-28);
      break;
    }
  }
}
