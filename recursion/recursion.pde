/*
-
- Jonathan Etiz
- CCOMP-10 (Introdution to Programming)
- "Recursion" Assignment
-
*/

void setup() {
    size(800, 800);
}

void draw() {
    background(255);
    fill(color(int(random(255)), int(random(255)), int(random(255))));
    airplane(0, width, 0);
}

void airplane(int a, int b, int stack) {
    if (a != b && stack < 10) {
        ellipseMode(CENTER);
        circle((a + b)/2, height/2, (b-a)/3);
        fill(color(int(random(255)), int(random(255)), int(random(255))));
        airplane(0, a + (b-a)/3, stack + 1);
        airplane(b-(b-a)/3, width, stack + 1);
    }
}