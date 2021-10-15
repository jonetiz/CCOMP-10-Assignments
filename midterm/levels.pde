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

    ArrayList<WorldObject> levelObjects = new ArrayList<WorldObject>();

    String levelName = "NO LEVEL NAME";

    Background bg;

    void update() {
        levelObjects.forEach((obj) -> {
            if ((obj.pos.x > -100 - referenceX || obj.pos.x < width + 100 - referenceX) && (obj.pos.y > -100 - referenceY || obj.pos.y < height + 100 - referenceY)) {
                obj.update();
            }
        });

        loadedCharacters.forEach((c) -> {
            if ((c.pos.x > -500 - referenceX || c.pos.x < width + 500 - referenceX) && (c.pos.y > -500 - referenceY || c.pos.y < height + 500 - referenceY)) {
                c.update();

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

        drawLevel();
        if (bg != null) {
            bg.update();
        }
    }
    //Additional drawing for individual levels
    void drawLevel() {};
}

class WorldObject extends Entity{

}

class TestLevel extends Level {
    TestLevel() {
        levelName = "Test Level";
        levelObjects.add(new TestBox());
        bg = new Background(color(255,214,165), "cloud", 0.1, 30, 32, 96);
    }
    void drawLevel () {
        rectMode(CORNER);
        fill(0);
        rect(0,720,width,height-720);
    }
}

class TestBox extends WorldObject {

}