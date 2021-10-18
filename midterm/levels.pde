/*
-
- Jonathan Etiz
- CCOMP-10 (Intro to Programming)
- Midterm Assignment
---
- Halo: Siege of Arcadia
- This project is not affiliated, associated, authorized, endorsed by, or in any way officially connected with Microsoft, 343 Industries, Bungie Studios, or any of their
- subsidiaries. The official Halo website can be found at https://www.halowaypoint.com.
-
- The name Halo and any other relevant names, marks, emblems, or images are registered trademarks of 343 Industries.
-
---
-
- Levels Classes & Entities
-
*/

class Level {
    //The point of reference for objects placed in a level. As this shifts, objects will follow suit. Shifts with the player, in most (all forseeable) cases.
    //This is ALWAYS representative of the level's position relative to the top left of the "camera"/screen. IE: referenceX = -100, any object at 2000 px (assuming 1920 width)
    //will show 80 pixels.
    int referenceX = 0;
    int referenceY = 0;
    
    //Array of all WorldObjects (crates and the like) in the level
    ArrayList<WorldObject> levelObjects = new ArrayList<WorldObject>();

    //Level name string for use in menus or something
    String levelName = "NO LEVEL NAME";

    //Gravity in the level, default is 9.81 m/s/s.
    float gravityCoefficient = 9.81;

    Background bg;

    //Level floor generated in init method based on levelObjects array and a base value.
    LevelFloor floor;

    //How "long" the level is in pixels.
    int length = 100000;
    
    void init () {
        //Create whatever objects necessary and add them to levelObjects.
        levelObjects.add(new CovenantCrate(1000, 720, 0, 1.0));
        //Generate the levelFloor.
        floor = new LevelFloor(length, 720, levelObjects);
    }
    void update() {
        //Load background
        if (bg != null) {
            bg.update();
        }

        levelObjects.forEach((obj) -> {
            //Check if the object is within 100 pixels of the sides of the screen and begins drawing/updating
            if (
                (obj.levelPos.x + obj.w > -100 - referenceX && obj.levelPos.x < width + 100 - referenceX)
                &&
                (obj.levelPos.y + obj.h > -100 - referenceY && obj.levelPos.y < height + 100 - referenceY)
            ) {
                obj.pos.set(obj.levelPos.x + referenceX, obj.levelPos.y + referenceY);
                obj.update();
            }
        });

        loadedCharacters.forEach((c) -> {
            //Check if the character is within 500 pixels of the sides of the screen and begins drawing/updating
            if ((c.pos.x > -500 - referenceX || c.pos.x < width + 500 - referenceX) && (c.pos.y > -500 - referenceY || c.pos.y < height + 500 - referenceY)) {
                c.update();
                
                //If the character's y position is less than the floor position.
                if (int(c.pos.y) < this.floor.get(c.pos.x)) {

                }

                //limit projectiles in memory to 100 for optimization
                if (c.weaponPrimary.ownedProjectiles.size() > 100) {
                    c.weaponPrimary.ownedProjectiles.remove(0);
                }
                if (c.weaponSecondary != null) {
                    if (c.weaponSecondary.ownedProjectiles.size() > 100) {
                        c.weaponSecondary.ownedProjectiles.remove(0);
                    }
                }
            }
        });

        loadedPFX.forEach((fx) -> {
            fx.update();
        });

        //limit particle effects in memory to 250 for optimization
        if (loadedPFX.size() > 250) {
            loadedPFX.remove(0);
        }

        floor.update();
        drawLevel();
    }
    //Additional drawing for individual levels
    void drawLevel() {};
}

//A floor object containing 
class LevelFloor {
    int baseFloor;

    //This array contains the floor values at each x-relative. For example, floorArray[z] will return the y-value of the floor at x-relative coordinate z.
    int[] floorArray;

    LevelFloor (int length, int base, ArrayList<WorldObject> arr) {
        baseFloor = base;
        floorArray = new int[length];
        //Set the floor array.
        Arrays.fill(floorArray, base);
        arr.forEach((obj) -> {
            //First we'll see if the object is even on the layer 0 (player layer), should be very quick and easy to filter.
            if (obj.layer == 0) {
                for (int i = 0; i <= width; i++) {
                    floorArray[int(obj.pos.x) + i] = int(obj.pos.y + obj.h);
                }
            }
        });
        //Might insert some loading done clause if this is really intensive, we'll see...
    }
    void update() {
        rectMode(CORNER);
        noStroke();
        //Fill in space below the floor
        fill(60);
        rect(0, baseFloor, width, height - baseFloor);
        //Draw a black floor
        fill(0);
        rect(0, baseFloor, width, 4);
    }
    //Method to get the y position of the floor at a certain x coordinate.
    int get(float x) {
        return floorArray[int(x)];
    }
}

class WorldObject extends Entity {
    PVector levelPos = new PVector();
}

class CovenantCrate extends WorldObject {
    CovenantCrate (float relX, float relY, int layer, float scale) {
        levelPos.set(relX, relY);
        sprite = loadImage("data\\img\\world\\obj\\covenantcrate.png");
        sprite.resize(int(180 * scale), int(200 * scale));
        w = sprite.width;
        h = sprite.height;
    }
    void update() {
        println("UPDATE");
        imageMode(CORNER);
        image(sprite, pos.x, pos.y - h);
    }
}

class TestLevel extends Level {
    TestLevel() {
        levelName = "Test Level";
        levelObjects.add(new TestBox());
        bg = new Background(color(255,214,165), "cloud", 0.1, 30, 32, 96);
    }
    void drawLevel () {
    }
}

class TestBox extends WorldObject {

}