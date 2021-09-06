/*
-
- Jonathan Etiz
- CCOMP-10 (Intro to Programming)
- "Magic 8-Ball" Assignment
-
*/

//8-ball responses
String[] responses = {
  "Don't bet \non it",
  "The stars \nsay no",
  "No doubt \nabout \nit",
  "Focus and \nask \nagain",
  "Looks like \nyes",
  "Chances \naren't \ngood",
  "Can't say \nnow",
  "Indications \nsay yes"
};

//Variable used to determine when to regenerate response. Default @ 60 Hz = 150t = 2.5 seconds
int regenTickCount = 150;

//Variable used to count ticks that it has been dragged.
int tickcount = 0;

//Current frame of regenerating
int regenFrame = 0;

//Current frame of disappearing (counts down)
int degenFrame = 60;

//Grace period in which 8-ball may not regenerate.
int graceperiod = 0;

//Current response array index
int currentResponse;

//Bool for if a new response has been set so it doesnt loop
boolean newResponse = false;

//Bool for whether or not the response is currently showing.
boolean showing = false;

//Bool for case when we want response to disappear.
boolean disappearing = false;

//Define starting positions, used for dragging
int x = 256;
int y = 256;

void setup() {
  size(512,512); 
  stroke(0);
  textAlign(CENTER);
}

void draw() {
  background(#000080);
  //Dragging functionality
  //If cursor is 384/2 px away from origin of circle, allow dragging.
  if(dist(x,y, mouseX, mouseY) < 384 / 2){
    cursor(HAND);
    if(mousePressed) {
      //Increase tickcount only when mouse is moved.
      if (x != mouseX || y != mouseY) tickcount++;
      
      //Set x & y to current mouse pos when clicked
      x = mouseX;
      y = mouseY;
    }
  } else {
    cursor(ARROW);
  }
  
  fill(32);
  circle(x,y,384);
  fill(0);
  circle(x,y,180);
  
  //Decrement grace period.
  graceperiod--;
  
  //If grace period hase elapsed, allow regeneration. 
  if (graceperiod <= 0) {
    //If our tickcount is greater than regenTickCount defined in header. See header for more variable information.
    if (tickcount >= regenTickCount) {
      //If disappearing, do the animation stuff to make it first fade out, then fade in.
      if (disappearing) {
        showing = false;
        
        //Set alpha so the response appears to fade out.
        degenFrame--;
        float alpha = (degenFrame / 60.0) * 255;
        
        fill(#0000ff, alpha);
        triangle(x-48,y-48,x,y+48,x+48,y-48);
        fill(#ffffff, alpha);
        text(responses[currentResponse].toUpperCase(),x,y-32);
        
        //When the degeneration timer (1 second) has elapsed, reset and move onto response generation.
        if (degenFrame <= 0) {
          degenFrame = 60;
          disappearing = false;
        }
      } else {
        if (!newResponse) {
          currentResponse = int(random(0, responses.length));
          newResponse = true;
        }
        
        //Set alpha so the response appears to fade in.
        regenFrame++;
        float alpha = (regenFrame / 60.0) * 255;
        
        fill(#0000ff, alpha);
        triangle(x-48,y-48,x,y+48,x+48,y-48);
        fill(#ffffff, alpha);
        text(responses[currentResponse].toUpperCase(),x,y-32);
        
        //When response is fully generated, (re)set variables.
        if (regenFrame >= 60) {
          regenFrame = 0;
          tickcount = 0;
          
          //Set 300 tick (5 second) graceperiod during which the 8-ball may not regenerate.
          graceperiod = 300;
          
          showing = true;
          disappearing = true;
          newResponse = false;
        }
      }
    }
  }
  
  //If showing variable is set, keep showing it.
  if (showing) {
    fill(#0000ff);
    triangle(x-48,y-48,x,y+48,x+48,y-48);
    fill(#ffffff);
    text(responses[currentResponse].toUpperCase(),x,y-32);
  }
}
