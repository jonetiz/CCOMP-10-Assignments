/*
-
- Jonathan Etiz
- CCOMP-10 (Intro to Programming)
- "Forest" Assignment
-
*/

ArrayList<Tree> allTrees = new ArrayList<Tree>();

class Tree {
  int x, y;
  Tree (int xbase, int ybase) {
    x = xbase;
    y = ybase;
  }
  void update() {
    fill(128,128,0);
    rect(x-8,y-48,16,48);
    fill(0,100,0);
    triangle(x-24,y-16,x,y-32,x+24,y-16);
    triangle(x-20,y-28,x,y-44,x+20,y-28);
    triangle(x-16,y-40,x,y-56,x+16,y-40);
  }
}

void setup() {
  size(1024,512);
  
  //Generate a random number of trees, 100-250
  int num = int(random(100,250));
  for (int i = 0; i <= num; i++) {
    //Generate random x/y within bounds of "grass"
    int x = int(random(-23,1047));
    int y = int(random(128,512));
    //Instance a new Tree object
    Tree t = new Tree(x, y);
    //Add the new tree to the array
    allTrees.add(t);
  }
}

void draw() {
  background(0,128,256);
  //Grass
  fill(0,180,0);
  rect(0,128,1024,384);
  
  //foreach equivalent; iterates over each element of allTrees
  for (Tree t : allTrees) {
    //Make the tree go left (decrementing the x coordinate of the tree)
    t.x--;
    t.update();
    //If tree goes off screen, move it to other side of screen and change y coord to give impression of a new tree.
    if (t.x < -24) {
      t.x = 1048;
      t.y = int(random(128,512));
    }
  }
}
