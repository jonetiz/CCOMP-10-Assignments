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
    
    boolean alive = true;

    //Which "layer" is the entity on (used to differentiate any background/foreground elements); 0 - foreground, 1 or higher - background
    int layer;

    //Ty joe :D
    boolean checkInCircle(Entity other, float radius) {
        float rectCenterX = other.pos.x;
        float rectCenterY = other.pos.y;
        float rectW = other.w;
        float rectH = other.h;
        float cx = this.pos.x;
        float cy = this.pos.y;
        float r = radius;

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

    void update() {}
}

class Character extends Entity implements ICharacter {
    int maxShield;
    int curShield;

    Character currentTarget;
    //Rotation speed of the character (degrees per second)
    int rotationSpeed;
    //Movement speed of character (pixels per second)
    int movementSpeed;

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

    //Adapted from "Tricks of the Windows Game Programming Gurus" Line Intersections
    private Object[] isAimingAt(Character other) {
        //Returns an object of (boolean, PVector(intersectionX, intersectionY))
        Object[] rtrn = new Object[2];

        //p0 and p1 represent the LoS.
        PVector p0 = weaponPrimary.pos;
        PVector p1 = new PVector(fovDistance*cos(rotation) + pos.x, fovDistance*sin(rotation) + pos.y);
        //a = top
        PVector a0 = new PVector(other.pos.x - other.w/2, other.pos.y - other.h/2);
        PVector a1 = new PVector(other.pos.x + other.w/2, other.pos.y - other.h/2);
        //b = left
        PVector b0 = new PVector(other.pos.x - other.w/2, other.pos.y - other.h/2);
        PVector b1 = new PVector(other.pos.x - other.w/2, other.pos.y + other.h/2);
        //c = bottom
        PVector c0 = new PVector(other.pos.x - other.w/2, other.pos.y + other.h/2);
        PVector c1 = new PVector(other.pos.x + other.w/2, other.pos.y + other.h/2);
        //d = right
        PVector d0 = new PVector(other.pos.x + other.w/2, other.pos.y - other.h/2);
        PVector d1 = new PVector(other.pos.x + other.w/2, other.pos.y + other.h/2);

        PVector p2 = new PVector(p1.x - p0.x, p1.y - p0.y);
        PVector a2 = new PVector(a1.x - a0.x, a1.y - a0.y);
        PVector b2 = new PVector(b1.x - b0.x, b1.y - b0.y);
        PVector c2 = new PVector(c1.x - c0.x, c1.y - c0.y);
        PVector d2 = new PVector(d1.x - d0.x, d1.y - d0.y);
        //s1 = p2, s2 = a/b/c/d2
        //p2 = a/b/c/d0
        //p3 = a/b/c/d1
        float as, bs, cs, ds, at, bt, ct, dt;
        //s = (-s1_y * (p0_x - p2_x) + s1_x * (p0_y - p2_y)) / (-s2_x * s1_y + s1_x * s2_y);
        //t = ( s2_x * (p0_y - p2_y) - s2_y * (p0_x - p2_x)) / (-s2_x * s1_y + s1_x * s2_y);
        as = (-p2.y * (p0.x - a0.x) + p2.x * (p0.y - a0.y)) / (-a2.x * p2.y + p2.x * a2.y);
        at = ( a2.x * (p0.y - a0.y) - a2.y * (p0.x - a0.x)) / (-a2.x * p2.y + p2.x * a2.y);
        bs = (-p2.y * (p0.x - b0.x) + p2.x * (p0.y - b0.y)) / (-b2.x * p2.y + p2.x * b2.y);
        bt = ( b2.x * (p0.y - b0.y) - b2.y * (p0.x - b0.x)) / (-b2.x * p2.y + p2.x * b2.y);
        cs = (-p2.y * (p0.x - c0.x) + p2.x * (p0.y - c0.y)) / (-c2.x * p2.y + p2.x * c2.y);
        ct = ( c2.x * (p0.y - c0.y) - c2.y * (p0.x - c0.x)) / (-c2.x * p2.y + p2.x * c2.y);
        ds = (-p2.y * (p0.x - d0.x) + p2.x * (p0.y - d0.y)) / (-d2.x * p2.y + p2.x * d2.y);
        dt = ( d2.x * (p0.y - d0.y) - d2.y * (p0.x - d0.x)) / (-d2.x * p2.y + p2.x * d2.y);
        
        //If the "line" from weaponPrimary.pos intersects with top, bottom, left, or right
        if (as >= 0 && as <= 1 && at >= 0 && at <= 1) {
            rtrn[0] = true;
            rtrn[1] = new PVector(p0.x + (at * p2.x), p0.y + (at * p2.y));
            return rtrn;
        } else if (bs >= 0 && bs <= 1 && bt >= 0 && bt <= 1) {
            rtrn[0] = true;
            rtrn[1] = new PVector(p0.x + (bt * p2.x), p0.y + (bt * p2.y));
            return rtrn;
        } else if (cs >= 0 && cs <= 1 && ct >= 0 && ct <= 1) {
            rtrn[0] = true;
            rtrn[1] = new PVector(p0.x + (ct * p2.x), p0.y + (ct * p2.y));
            return rtrn;
        } else if (ds >= 0 && ds <= 1 && dt >= 0 && dt <= 1) {
            rtrn[0] = true;
            rtrn[1] = new PVector(p0.x + (dt * p2.x), p0.y + (dt * p2.y));
            return rtrn;
        } else {
            //Return false with empty PVector
            rtrn[0] = false;
            rtrn[1] = new PVector();
            return rtrn;
        }
    }

    //Rotate to aim at target
    private void rotateToTarget() {
        if (atan2(currentTarget.pos.y - this.weaponPrimary.pos.y, currentTarget.pos.x - this.weaponPrimary.pos.x) - atan2(currentTarget.pos.y - this.pos.y, currentTarget.pos.x - this.pos.x) >= 0) {
            rotation += radians(rotationSpeed)/frameRate;
        } else {
            rotation -= radians(rotationSpeed)/frameRate;
        }
    }
    
    //Global spotting function NEED TO ADD CASE FOR IF TARGET IS IN BLINDSPOT
    void spotting() {
        loadedCharacters.forEach((c) -> {
            //If character isn't on the same layer, ignore it. If character is on the same side, ignore it.
            if (c.layer != this.layer || c.side == this.side) return;
            if (c != this) {
                //Check if the character is visible after passing all preliminary checks to this point.
                if (checkInCircle(c, this.fovDistance)) {
                    currentTarget = c;
                }
            }
        });
        ai();
    }

    //Global ai function
    void ai() {
        if (currentTarget != null) {
            //If target is in line of sight.
            //OLD CODE: abs(atan2(currentTarget.pos.y - this.pos.y, currentTarget.pos.x - this.pos.x) - rotation) % TWO_PI < 0.1
            if ((boolean)isAimingAt(currentTarget)[0] == false) {
                //If we're not looking at the man, rotate in his direction
                rotateToTarget();
            } else {
                //If we're looking at the dude cap his ass, but keep trying to rotate towards center to increase accuracy
                rotateToTarget();
                this.weaponPrimary.fire();
            }
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
    
    //Ammo values; ammo per shot is controlled in each individual weapon entity, and as such ammo values that aren't set are implicitly infinite.
    //Current ammo in weapon and maximum allowed in weapon.
    int ammoCurrent;
    int ammoCurrentMaximum;

    //Total ammo and maximum able to be carried.
    int ammoTotal;
    int ammoTotalMaximum;

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

    //Blast radius (damages anything in this radius)
    int blastRadius;

    //Origin of projectile
    PVector origin = new PVector();

    //Parent weapon
    Weapon parent;

    void update() {
        if (exists) {
            //If the projectile still exists, run this stuff.
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
                //Apply damage in blast radius
                if (blastRadius > 0) {
                }
                //expire();
            }

            //Hit registration
            loadedCharacters.forEach((c) -> {
                //If character isn't on the same layer as the projectile, ignore it.
                if (c.layer != this.layer) return;

                float xthing = (this.pos.x - c.pos.x) * cos(c.rotation) - (this.pos.y - c.pos.y) * sin(c.rotation);
                float ything = (this.pos.x - c.pos.x) * sin(c.rotation) - (this.pos.y - c.pos.y) * cos(c.rotation);
                if (
                    abs(xthing) <= c.w/2
                    &&
                    abs(ything) <= c.h/2 
                    && 
                    exists
                ) {
                    exists = false;
                    int damage = int(random(damageLower, damageUpper));
                    if (c.curShield > 0) {
                        int damageLeftOver = damage - c.curShield;
                        c.curShield -= damage - damageLeftOver;
                        c.curHP -= damageLeftOver;
                    } else {
                        c.curHP -= damage;
                    }
                    hit();
                }
            });
        }
    }

    void hit(){}

    void expire(){}
}

class WorldObject extends Entity implements IWorldObject {
    void touch(){}
}

class ParticleEffect extends Entity {
    //curLifetime is how long the effect has been "alive" in ticks. maxLifetime is when the effect will "expire". Default max lifetime is 60 (about a second)
    int curLifetime = 0;
    int maxLifetime = 60;

    //Current animation phase
    int curPhase = 0;
    ParticleEffect(float xpos, float ypos, int maxL, float scale, String[] spritesArray){
        pos.set(xpos, ypos);
        maxLifetime = maxL;
        sprite = loadImage(spritesArray[0]);
        spriteFlipped = sprite.copy();
        sprite.resize(ceil(sprite.width * scale), ceil(sprite.height * scale));
    }
    void update() {
        curLifetime++;
        if (curLifetime < maxLifetime) {
            //Total count of animation phases
            int phaseCount = spritesArray.length();
            //How long each animation phase is
            int phaseLength = int(maxLifetime/phaseCount);
            //int thing = curLifetime % phaseLength;
            for(curPhase; curLifetime % phaseLength = 0; curPhase++) {
                sprite = loadImage(spritesArray[curPhase]);
            }
            spriteFlipped = sprite.copy();
            spriteFlipped.resize(ceil(sprite.width + sprite.width * curLifetime/maxLifetime), ceil(sprite.height + sprite.height * curLifetime/maxLifetime));
            tint(255, opacity);
            image(spriteFlipped, pos.x - w/2, pos.y - h/2);
        }
    }
}