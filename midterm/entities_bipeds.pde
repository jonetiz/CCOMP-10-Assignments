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
- Bipedal Entities
-
*/

import java.util.Map;

//These objects are used to get the position of a certain sprite.
class BipedSpriteLocation {
    PVector location = new PVector();
    PVector dimensions = new PVector();
    BipedSpriteLocation (float x, float y, float w, float h) {
        location.set(x,y);
        dimensions.set(w,h);
    }
    int[] coords() {
        return new int[]{
            int(location.x),
            int(location.y),
            int(dimensions.x),
            int(dimensions.y)
        };
    }
}

//These objects will be used to save the sprites of a particular biped.
class BipedSprites {
    HashMap<String,PImage> sprites = new HashMap<String,PImage>();
    BipedSprites (int side, BipedSpriteLocation head, BipedSpriteLocation idle, BipedSpriteLocation arm1, BipedSpriteLocation arm2, BipedSpriteLocation run1, BipedSpriteLocation run2, BipedSpriteLocation run3) {
        PImage ss;
        //Side 1 for unsc, 2 for covenant just like characters.
        if (side == 1) { 
            ss = spritesheetUNSC;
        } else if (side == 2) {
            ss = spritesheetCovenant;
        } else {
            ss = spritesheetCovenant;
        }

        sprites.put("Head", ss.get(head.coords()[0], head.coords()[1], head.coords()[2], head.coords()[3]));
        sprites.put("Idle", ss.get(idle.coords()[0], idle.coords()[1], idle.coords()[2], idle.coords()[3]));
        sprites.put("Arm1", ss.get(arm1.coords()[0], arm1.coords()[1], arm1.coords()[2], arm1.coords()[3]));
        sprites.put("Arm2", ss.get(arm2.coords()[0], arm2.coords()[1], arm2.coords()[2], arm2.coords()[3]));
        sprites.put("Run1", ss.get(run1.coords()[0], run1.coords()[1], run1.coords()[2], run1.coords()[3]));
        sprites.put("Run2", ss.get(run2.coords()[0], run2.coords()[1], run2.coords()[2], run2.coords()[3]));
        sprites.put("Run3", ss.get(run3.coords()[0], run3.coords()[1], run3.coords()[2], run3.coords()[3]));
    }
}

class Biped extends Character {
    BipedSprites sprites;
}

class Player extends Biped {
    Player(float xpos, float ypos) {
        levelPos.set(xpos, ypos);
        w = 100;
        h = 180;
        scaleX = 1;
        scaleY = 1;
        rotation = 0;
        layer = 0;
        maxHP = 100;
        curHP = maxHP;
        maxShield = 100;
        curShield = maxShield;
        movementSpeed = 100;
        side = 1;
        //weaponPrimary = new AssaultRifle(0);
        //weaponSecondary = new MagnumPistol(0);
        weaponOffset.set(w/2,0);
        sprites = new BipedSprites(
            1,
            new BipedSpriteLocation(494, 141, 13, 12),
            new BipedSpriteLocation(149, 169, 24, 39),
            new BipedSpriteLocation(93, 523, 17, 14),
            new BipedSpriteLocation(121, 524, 18, 14),
            new BipedSpriteLocation(442, 391, 25, 36),
            new BipedSpriteLocation(442, 391, 25, 36),
            new BipedSpriteLocation(442, 391, 25, 36)
        );
        sprites.sprites.get("Idle").resize(sprites.sprites.get("Idle").width * 4, sprites.sprites.get("Idle").height * 4);
        sprites.sprites.get("Head").resize(sprites.sprites.get("Head").width * 4, sprites.sprites.get("Head").height * 4);
        sprites.sprites.get("Arm1").resize(sprites.sprites.get("Arm1").width * 4, sprites.sprites.get("Arm1").height * 4);
        sprites.sprites.get("Arm2").resize(sprites.sprites.get("Arm2").width * 4, sprites.sprites.get("Arm2").height * 4);
    }
    void update() {
        //weaponPrimary.parent = this;
        //weaponSecondary.parent = this;
        if (alive) {
            noFill();
            stroke(#ff0000);
            rect(levelPos.x - campaign.level.referenceX, levelPos.y - campaign.level.referenceY, w, h);
            pushMatrix();
            translate(levelPos.x - campaign.level.referenceX, levelPos.y - campaign.level.referenceY);
            if(sin(rotation + radians(90)) <= 0) {
                scale(-1.0, 1.0);
            }
            image(sprites.sprites.get("Idle"), 0, h - sprites.sprites.get("Idle").height);
            image(sprites.sprites.get("Head"), 35, 0);
            image(sprites.sprites.get("Arm1"), 10, 40);
            popMatrix();
        }
    }
}