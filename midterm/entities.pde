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
- Entities Base Classes
-
*/

interface IEntity {
    //Draw and do whatever we need every frame
    void update();
}

interface ICharacter {
    //Move; 0 = up, 1 = left, 2 = down, 3 = right
    void movement(int dir, float mag);
    //Death function
    void death();
    //Controls spotting and targeting enemies
    void spotting();
}

interface IWeapon {
    //Firing function
    void fire();
    //Secondary firing function
    void secondFire();
    //Reload function
    void reload();
    //Melee function
    void melee();
}

interface IProjectile {
    //When the projectile hits something
    void hit();
    //When projectile reaches maxRange
    void expire();
}

interface IWorldObject {
    //When something touches the WorldObject
    void touch();
}

class Entity implements IEntity {
    PImage sprite;
    //Flipped sprite for certain use cases.
    PImage spriteFlipped;

    //Basic positioning
    PVector pos = new PVector();
    int w;
    int h;
    float rotation;
    float scaleX = 1.0;
    float scaleY = 1.0;

    int maxHP;
    int curHP;

    //Which "layer" is the entity on (used to differentiate any background/foreground elements); 0 - foreground, 1 or higher - background
    int layer;

    void update() {}
}

class Character extends Entity implements ICharacter {
    int maxShield;
    int curShield;

    Character currentTarget;
    //Rotation speed of the enemy.
    int rotationSpeed;

    //FOV things for AI spotting
    int fov;
    int fovDistance;

    //Resistance and damage modifiers (for different difficulties; 0.25 - Easy, 1.0 - Normal, 3.0 - Heroic, 4.0 - Legendary)
    float resModifier = 1.0;
    float dmgModifier = 1.0;

    //Weapons in character "posession"
    Weapon weaponPrimary;
    Weapon weaponSecondary;

    PVector weaponOffset = new PVector();

    //0 = neutral, 1 = unsc, 2 = covenant
    int side;

    Character() {
        loadedCharacters.add(this);
    }

    //Basic movement, need to add animations for most characters.
    void movement(int dir, float mag){
        float x = pos.x;
        float y = pos.y;
        switch (dir) {
            case 0:
                y = y - mag;
            break;
            case 1:
                x = x - mag;
            break;
            case 2:
                y = y + mag;
            break;
            case 3:
                x = x + mag;
            break;
        }
    }
    
    void death(){}

    //Ty joe :D
    private boolean checkVisibility(Character other) {
        float rectCenterX = other.pos.x;
        float rectCenterY = other.pos.y;
        float rectW = other.w;
        float rectH = other.h;
        float cx = this.pos.x;
        float cy = this.pos.y;
        float r = this.fovDistance;

        float rx = rectCenterX - rectW/2;
        float ry = rectCenterY - rectH/2;

        //top & bottom
        if(abs(cx-rectCenterX)<=rectW/2 && abs(cy-rectCenterY)<=rectH/2 + r){
            return true;
        }
        //left & right
        if(abs(cy-rectCenterY)<=rectH/2 && abs(cx-rectCenterX)<=rectW/2 +r){
            return true;
        }
        //corners
        if(dist(rx,ry,cx,cy)<=r || dist(rx+rectW,ry,cx,cy)<=r || dist(rx,ry+rectH,cx,cy)<=r || dist(rx+rectW,ry+rectH,cx,cy)<=r){
            return true; 
        }
        //TODO: Handle backward FOV fov cone
        return false;
    }

    void spotting() {
        loadedCharacters.forEach((c) -> {
            //If character isn't on the same layer, ignore it. If character is on the same side, ignore it.
            if (c.layer != this.layer || c.side == this.side) return;
            if (c != this) {
                //Check if the character is visible after passing all preliminary checks to this point.
                if (checkVisibility(c)) {
                    currentTarget = c;
                }
            }
        });
        ai();
    }

    void ai() {
        if (currentTarget != null) {
            //If thing 1 is in line of sight of thing 2
            if (!(abs(atan2(currentTarget.pos.y - this.pos.y, currentTarget.pos.x - this.pos.x) - rotation) % TWO_PI < 0.1 )) {
                rotation -= 1/frameRate;

            }
            println(abs(atan2(currentTarget.pos.y - this.pos.y, currentTarget.pos.x - this.pos.x) - rotation));
        }
    }
}

class Weapon extends Entity implements IWeapon {
    //X AND Y ARE RELATIVE TO PARENT CHARACTER

    //The weapon's parent/holder
    Character parent;
    //Rate of fire (RPM)
    float rof;
    int lastShot;
    float inaccuracy;

    //Where the projectile will come from.
    PVector projectileOrigin = new PVector(pos.x, pos.y);
    ArrayList<Projectile> ownedProjectiles = new ArrayList<Projectile>();

    void update(){}
    void fire(){}
    void secondFire(){}
    void reload(){}
    void melee(){}
}

class Projectile extends Entity implements IProjectile {
    boolean exists = true;

    //Upper and lower bounds of damage
    float damageUpper;
    float damageLower;
    //Maximum range before it deletes (or some other behavior)
    int maxRange = 128;
    int lifetime;
    //Velocity in pixels/second
    int velocity;

    PVector origin = new PVector();

    Weapon parent;

    void update() {
        if (exists) {
            w = sprite.width;
            h = sprite.height;

            float v = velocity/frameRate;
            pos.set(v*cos(rotation) + pos.x, v*sin(rotation) + pos.y);
            pushMatrix();
            translate(pos.x,pos.y);
            rotate(rotation);
            scale(scaleX, scaleY);
            image(sprite,0,0);
            popMatrix();
            //Using a "lifetime" variable since the range is wacky at spawn.
            if (origin.dist(pos) >= maxRange) {
                expire();
            }
        }
    }

    void hit(){}

    void expire(){}
}

class WorldObject extends Entity implements IWorldObject {
    void touch(){}
}