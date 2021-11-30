/*
-
- Jonathan Etiz
- CCOMP-10 (Introdution to Programming)
- "Recursion" Assignment
-
*/

/*FractalThing thing;

class FractalThing {
    int stack = 1;
    float xpos;
    color clr;
    int radius = width/3;
    FractalThing left;
    FractalThing right;
    FractalThing(int x, int s, color c) {
        xpos = x;
        stack = s;
        radius = x * 2 / 3;
        clr = c;

        color childClr = color(int(random(0,256)), int(random(0,256)), int(random(0,256)));
        if (s <= 10) {
            left = new FractalThing(x - radius, s+1, childClr);
            right = new FractalThing(x + radius, s+1, childClr);
        }
    }
    void update() {
        ellipseMode(CENTER);
        fill(clr);
        circle(xpos, height/2, radius);
        if (stack <= 10) {
            left.update();
            right.update();
        }
    }
}

void setup() {
    size(800, 800);
    thing = new FractalThing(width/2, 1, color(int(random(0,256)), int(random(0,256)), int(random(0,256))));
}

void draw() {
    background(255);
    thing.update();
}*/