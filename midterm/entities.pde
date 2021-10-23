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
    //Static movement (any direction)
    void movementStatic(float dir, float mag);
    //Death function
    void death();
    //Controls spotting and targeting enemies
    void spotting();
}

interface IWeapon {
    //Used within matrices to draw relative to bipeds.
    void draw();
    //Firing function
    void fire();
    //Secondary firing function
    void secondFire();
    //Reload function
    void reload();
}

interface IProjectile {
    //When the projectile hits something
    void hit();
    //When projectile reaches maxRange
    void expire();
}

class Entity implements IEntity {
    //Sprite to display
    PImage sprite;
    //Flipped sprite for certain use cases.
    PImage spriteFlipped;

    //Basic positioning
    PVector pos = new PVector();
    //Relative level positioning
    PVector levelPos = new PVector();
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
        float rectCenterX = other.levelPos.x;
        float rectCenterY = other.levelPos.y;
        float rectW = other.w;
        float rectH = other.h;
        float cx = this.levelPos.x;
        float cy = this.levelPos.y;
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
    //If true, cease AI functions.
    boolean braindead = false;

    int maxShield;
    int curShield;

    //How long since damage was taken.
    int shieldTimer;
    //How many ticks the shield has been regenerating for..
    int shieldRegenTimer;
    //What percentage of shield to regain per second of regen
    float shieldRegenRate = 25.0;
    //Regen shields 8 seconds after taking no damage.
    int shieldRegen = 8;

    boolean reloading = false;
    int reloadTime = 0;

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

    //Movement without animations (meant for space stuff mainly)
    void movementStatic(float dir, float mag){
        float x = levelPos.x;
        float y = levelPos.y;
        //Make speed scale so things meant to be 'further away' seem further away.
        mag = mag * (scaleX + scaleY / 2);
        levelPos.set(x + mag*cos(dir), y + mag*sin(dir));
    }
    
    void move(float mag) {}

    void death() {}

    //Adapted from "Tricks of the Windows Game Programming Gurus" Line Intersections
    private Object[] isAimingAtBiped(Character other) {
        //Returns an object of (boolean, intersectionX, intersectionY)
        Object[] rtrn = new Object[3];

        //p0 and p1 represent the LoS.
        PVector p0 = new PVector(weaponPrimary.projectileOrigin.x - campaign.level.referenceX, weaponPrimary.projectileOrigin.y + campaign.level.referenceY);
        PVector p1 = new PVector(fovDistance*cos(rotation) + (levelPos.x + w/2) - campaign.level.referenceX, fovDistance*sin(rotation) + (levelPos.y + h/2) + campaign.level.referenceY);
        //a = top
        PVector a0 = new PVector(other.levelPos.x - campaign.level.referenceX, other.levelPos.y + campaign.level.referenceY);
        PVector a1 = new PVector(other.levelPos.x + other.w - campaign.level.referenceX, other.levelPos.y + campaign.level.referenceY);
        //b = left
        PVector b0 = new PVector(other.levelPos.x - campaign.level.referenceX, other.levelPos.y + campaign.level.referenceY);
        PVector b1 = new PVector(other.levelPos.x - campaign.level.referenceX, other.levelPos.y + other.h + campaign.level.referenceY);
        //c = bottom
        PVector c0 = new PVector(other.levelPos.x - campaign.level.referenceX, other.levelPos.y + other.h + campaign.level.referenceY);
        PVector c1 = new PVector(other.levelPos.x + other.w - campaign.level.referenceX, other.levelPos.y + other.h + campaign.level.referenceY);
        //d = right
        PVector d0 = new PVector(other.levelPos.x + other.w - campaign.level.referenceX, other.levelPos.y + campaign.level.referenceY);
        PVector d1 = new PVector(other.levelPos.x + other.w - campaign.level.referenceX, other.levelPos.y + other.h + campaign.level.referenceY);

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
            rtrn[1] = p0.x + (at * p2.x);
            rtrn[2] = p0.y + (at * p2.y);
            return rtrn;
        } else if (bs >= 0 && bs <= 1 && bt >= 0 && bt <= 1) {
            rtrn[0] = true;
            rtrn[1] = p0.x + (bt * p2.x);
            rtrn[2] = p0.y + (bt * p2.y);
            return rtrn;
        } else if (cs >= 0 && cs <= 1 && ct >= 0 && ct <= 1) {
            rtrn[0] = true;
            rtrn[1] = p0.x + (ct * p2.x);
            rtrn[2] = p0.y + (ct * p2.y);
            return rtrn;
        } else if (ds >= 0 && ds <= 1 && dt >= 0 && dt <= 1) {
            rtrn[0] = true;
            rtrn[1] = p0.x + (dt * p2.x);
            rtrn[2] = p0.y + (dt * p2.y);
            return rtrn;
        } else {
            //Return false with empty intersection
            rtrn[0] = false;
            rtrn[1] = 0.0;
            rtrn[2] = 0.0;
            return rtrn;
        }
    }
    private Object[] isAimingAt(Character other) {
        //Returns an object of (boolean, PVector(intersectionX, intersectionY))
        Object[] rtrn = new Object[3];

        //p0 and p1 represent the LoS.
        PVector p0 = weaponPrimary.levelPos;
        PVector p1 = new PVector(fovDistance*cos(rotation) + levelPos.x, fovDistance*sin(rotation) + levelPos.y);
        //a = top
        PVector a0 = new PVector(other.levelPos.x - other.w/2, other.levelPos.y - other.h/2);
        PVector a1 = new PVector(other.levelPos.x + other.w/2, other.levelPos.y - other.h/2);
        //b = left
        PVector b0 = new PVector(other.levelPos.x - other.w/2, other.levelPos.y - other.h/2);
        PVector b1 = new PVector(other.levelPos.x - other.w/2, other.levelPos.y + other.h/2);
        //c = bottom
        PVector c0 = new PVector(other.levelPos.x - other.w/2, other.levelPos.y + other.h/2);
        PVector c1 = new PVector(other.levelPos.x + other.w/2, other.levelPos.y + other.h/2);
        //d = right
        PVector d0 = new PVector(other.levelPos.x + other.w/2, other.levelPos.y - other.h/2);
        PVector d1 = new PVector(other.levelPos.x + other.w/2, other.levelPos.y + other.h/2);

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
            rtrn[1] = p0.x + (at * p2.x);
            rtrn[2] = p0.y + (at * p2.y);
            return rtrn;
        } else if (bs >= 0 && bs <= 1 && bt >= 0 && bt <= 1) {
            rtrn[0] = true;
            rtrn[1] = p0.x + (bt * p2.x);
            rtrn[2] = p0.y + (bt * p2.y);
            return rtrn;
        } else if (cs >= 0 && cs <= 1 && ct >= 0 && ct <= 1) {
            rtrn[0] = true;
            rtrn[1] = p0.x + (ct * p2.x);
            rtrn[2] = p0.y + (ct * p2.y);
            return rtrn;
        } else if (ds >= 0 && ds <= 1 && dt >= 0 && dt <= 1) {
            rtrn[0] = true;
            rtrn[1] = p0.x + (dt * p2.x);
            rtrn[2] = p0.y + (dt * p2.y);
            return rtrn;
        } else {
            //Return false with empty intersection
            rtrn[0] = false;
            rtrn[1] = 0.0;
            rtrn[2] = 0.0;
            return rtrn;
        }
    }
    private Object[] isAimingAtObject(WorldObject other) {
        //Returns an object of (boolean, intersectionX, intersectionY)
        Object[] rtrn = new Object[3];

        //p0 and p1 represent the LoS.
        PVector p0 = new PVector(weaponPrimary.projectileOrigin.x - campaign.level.referenceX, weaponPrimary.projectileOrigin.y + campaign.level.referenceY);
        PVector p1 = new PVector(fovDistance*cos(rotation) + (levelPos.x + w/2) - campaign.level.referenceX, fovDistance*sin(rotation) + (levelPos.y + h/2) + campaign.level.referenceY);
        //a = top
        PVector a0 = new PVector(other.levelPos.x - campaign.level.referenceX, other.levelPos.y - other.h + campaign.level.referenceY);
        PVector a1 = new PVector(other.levelPos.x + other.w - campaign.level.referenceX, other.levelPos.y - other.h + campaign.level.referenceY);
        //b = left
        PVector b0 = new PVector(other.levelPos.x - campaign.level.referenceX, other.levelPos.y - other.h + campaign.level.referenceY);
        PVector b1 = new PVector(other.levelPos.x - campaign.level.referenceX, other.levelPos.y + campaign.level.referenceY);
        //c = bottom
        PVector c0 = new PVector(other.levelPos.x - campaign.level.referenceX, other.levelPos.y + campaign.level.referenceY);
        PVector c1 = new PVector(other.levelPos.x + other.w - campaign.level.referenceX, other.levelPos.y + campaign.level.referenceY);
        //d = right
        PVector d0 = new PVector(other.levelPos.x + other.w - campaign.level.referenceX, other.levelPos.y - other.h + campaign.level.referenceY);
        PVector d1 = new PVector(other.levelPos.x + other.w - campaign.level.referenceX, other.levelPos.y + campaign.level.referenceY);

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
            rtrn[1] = p0.x + (at * p2.x);
            rtrn[2] = p0.y + (at * p2.y);
            return rtrn;
        } else if (bs >= 0 && bs <= 1 && bt >= 0 && bt <= 1) {
            rtrn[0] = true;
            rtrn[1] = p0.x + (bt * p2.x);
            rtrn[2] = p0.y + (bt * p2.y);
            return rtrn;
        } else if (cs >= 0 && cs <= 1 && ct >= 0 && ct <= 1) {
            rtrn[0] = true;
            rtrn[1] = p0.x + (ct * p2.x);
            rtrn[2] = p0.y + (ct * p2.y);
            return rtrn;
        } else if (ds >= 0 && ds <= 1 && dt >= 0 && dt <= 1) {
            rtrn[0] = true;
            rtrn[1] = p0.x + (dt * p2.x);
            rtrn[2] = p0.y + (dt * p2.y);
            return rtrn;
        } else {
            //Return false with empty intersection
            rtrn[0] = false;
            rtrn[1] = 0.0;
            rtrn[2] = 0.0;
            return rtrn;
        }
    }

    //Rotate to aim at target
    private void rotateToTarget() {
        if (atan2(currentTarget.levelPos.y - this.weaponPrimary.projectileOrigin.y, currentTarget.levelPos.x - this.weaponPrimary.projectileOrigin.x) - atan2(currentTarget.levelPos.y - this.levelPos.y, currentTarget.levelPos.x - this.levelPos.x) >= 0) {
            rotation += radians(rotationSpeed)/frameRate;
        } else {
            rotation -= radians(rotationSpeed)/frameRate;
        }
    }
    
    //Global spotting function NEED TO ADD CASE FOR IF TARGET IS IN BLINDSPOT
    void spotting() {
        //Since spotting is the root of the AI workflow, we'll just check if the character is braindead here.
        if (!braindead) {
            loadedCharacters.forEach((c) -> {
                //If character isn't on the same layer, ignore it. If character is on the same side, ignore it.
                if (c.layer != this.layer || c.side == this.side || c.alive != true || c.braindead != false) return;
                if (c != this) {
                    //Check if the character is visible after passing all preliminary checks to this point.
                    if (checkInCircle(c, this.fovDistance)) {
                        currentTarget = c;
                    }
                }
            });
            ai();
        } else {
            currentTarget = null;
        }
    }

    //Global ai function; doubles as a global "update" function
    void ai() {
        if (currentTarget != null && currentTarget.alive == true) {
            //If target is in line of sight.
            //OLD CODE: abs(atan2(currentTarget.pos.y - this.pos.y, currentTarget.pos.x - this.pos.x) - rotation) % TWO_PI < 0.1
            if (currentTarget instanceof Biped) {
                if ((boolean)isAimingAtBiped(currentTarget)[0] == false) {
                    rotation = atan2((currentTarget.levelPos.y + currentTarget.h/2) - this.weaponPrimary.projectileOrigin.y, (currentTarget.levelPos.x + currentTarget.w/2) - this.weaponPrimary.projectileOrigin.x);
                } else {
                    //Prove this false and we won't fire.
                    boolean fire = true;
                    //Don't shoot if a box or something is in the way
                    for (WorldObject obj : campaign.level.levelObjects) {
                        //Since isAimingAtObject will check anything anywhere, we add the additional check to make sure the obj isn't in front of target.
                        if ((boolean)isAimingAtObject(obj)[0]) {
                            if (currentTarget.levelPos.x > this.levelPos.x) {
                                //If target is to the RIGHT of this
                                if (currentTarget.levelPos.x > obj.levelPos.x && obj.h >= currentTarget.h) {
                                    //If target is behind an object and the object is taller than player.
                                    fire = false;
                                    //Try to move to player
                                    move(movementSpeed);
                                }
                            } else {
                                //If target is to the LEFT of this
                                if (currentTarget.levelPos.x < obj.levelPos.x && obj.h >= currentTarget.h) {
                                    //If target is behind an object and the object is taller than player.
                                    fire = false;
                                    //Try to move to player
                                    move(-movementSpeed);
                                }
                            }
                        }
                    }
                    if (fire) {
                        this.weaponPrimary.fire();
                    }
                }
            } else {
                if ((boolean)isAimingAt(currentTarget)[0] == false) {
                    //If we're not looking at the man, rotate in his direction
                    rotateToTarget();
                } else {
                    //If we're looking at the dude cap his ass, but keep trying to rotate towards center to increase accuracy
                    rotateToTarget();
                    this.weaponPrimary.fire();
                    if (this.weaponSecondary != null && !(this instanceof Biped)) this.weaponSecondary.fire();
                }
            }
            
        } else {
            if (currentTarget instanceof Biped) {
                //Make it move or something when we don't have a target
                move(int(random(-1,1)) * movementSpeed);
            }
        }
        //Shield stuff
        
        shieldTimer++;
        if (shieldTimer >= shieldRegen * frameRate && curShield < maxShield) {
            shieldRegenTimer++;
            curShield += (shieldRegenRate/100) * (maxShield/frameRate);
            if (curShield > maxShield) curShield = maxShield;
        }

        if (curShield < 0) curShield = 0;
        if (curHP <= 0) {
            alive = false;
            death();
        }
    }
}

class Weapon extends Entity implements IWeapon {
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

    //How many ticks it takes to fully reload the weapon.
    int timeToReload;

    //Firing sound effect (multiple so its not boring)
    ArrayList<SoundEffect> sfx_fire = new ArrayList<SoundEffect>();
    SoundEffect sfx_dry;
    SoundEffect sfx_reload;
    SoundEffect sfx_ready;

    //Where the projectile will come from.
    PVector projectileOrigin = new PVector(pos.x, pos.y);
    ArrayList<Projectile> ownedProjectiles = new ArrayList<Projectile>();

    PImage crosshair;

    void draw(){}
    void update(){}
    void fire(){}
    void secondFire(){}

    void reload() {
        int ammoToReload;

        ammoToReload = ammoCurrentMaximum - ammoCurrent;

        if (ammoToReload > ammoTotal) ammoToReload = ammoTotal;

        ammoTotal -= ammoToReload;
        ammoCurrent += ammoToReload;
        //If/when ammo exceeds maximum.
        if (ammoCurrent > ammoCurrentMaximum) {
            int leftOver = ammoCurrent - ammoCurrentMaximum;
            ammoTotal = leftOver;
            ammoCurrent = ammoCurrentMaximum;
        }
        //Make sure we don't underflow
        if (ammoTotal < 0) {
            ammoTotal = 0;
        }
        //Make sure we don't overflow
        if (ammoTotal > ammoTotalMaximum) {
            ammoTotal = ammoTotalMaximum;
        }
    }
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

    //Character that fired projectile
    Character parent;

    void update() {
        if (exists) {
            //If the projectile still exists, run this stuff.
            w = sprite.width;
            h = sprite.height;

            float v = velocity/frameRate;
            levelPos.set(v*cos(rotation) + levelPos.x, v*sin(rotation) + levelPos.y);
            pushMatrix();
            translate(levelPos.x - campaign.level.referenceX, levelPos.y + campaign.level.referenceY);
            rotate(rotation);
            scale(scaleX, scaleY);
            imageMode(CENTER);
            image(sprite,0,0);
            popMatrix();

            //Hit registration
            loadedCharacters.forEach((c) -> {
                //If character isn't on the same layer as the projectile, ignore it. If it's not alive, or it's the originating character, we also ignore it.
                if (c.layer != this.layer || c.alive != true || c == parent) return;

                float xthing = (this.levelPos.x - c.levelPos.x) * cos(c.rotation) - (this.levelPos.y - c.levelPos.y) * sin(c.rotation);
                float ything = (this.levelPos.x - c.levelPos.x) * sin(c.rotation) + (this.levelPos.y - c.levelPos.y) * cos(c.rotation);

                boolean cond = false;

                //Don't account for rotation for bipeds, just use the basic hitbox.
                if (c instanceof Biped) {
                    cond = (this.levelPos.x >= c.levelPos.x && this.levelPos.x <= c.levelPos.x + c.w && this.levelPos.y >= c.levelPos.y && this.levelPos.y <= c.levelPos.y + c.h);
                } else {
                    cond = (abs(xthing) <= c.w/2 && abs(ything) <= c.h/2);
                }
                if (cond && exists) {
                    exists = false;
                    int damage = int(random(damageLower, damageUpper));
                    if (c.curShield > 0) {
                        c.curShield -= damage;
                        if(c.curShield < 0) c.curHP += c.curShield;
                    } else {
                        c.curHP -= damage;
                    }
                    c.shieldTimer = 0;
                    c.shieldRegenTimer = 0;
                    hit();
                    expire();
                }
            });

            if (gameState == campaign) {
                //Projectile hits floor
                if (this.levelPos.y >= campaign.level.floor.baseFloor - this.sprite.width) {
                    hit();
                    expire();
                }
                
                //Check collision with WorldObjects
                for (WorldObject obj : campaign.level.levelObjects) {
                    if (this.levelPos.x >= obj.levelPos.x && this.levelPos.x <= obj.levelPos.x + obj.w && this.levelPos.y <= obj.levelPos.y && this.levelPos.y >= obj.levelPos.y - obj.h) {
                        hit();
                        expire();
                    }
                }
            }
        }
    }

    void hit(){}

    void expire() {
        exists = false;
    }
}

class ParticleEffect extends Entity {
    //curLifetime is how long the effect has been "alive" in ticks. maxLifetime is when the effect will "expire". Default max lifetime is 60 (about a second)
    int curLifetime = 0;
    int maxLifetime = 60;

    //Current animation phase
    int curPhase = 0;

    String[] spritesArray;

    int opacity = 255;

    float scale = 1;

    ParticleEffect(float xpos, float ypos, int maxL, float s, String[] sA){
        levelPos.set(xpos, ypos);
        maxLifetime = maxL;
        spritesArray = sA;
        sprite = loadImage(sA[0]);
        spriteFlipped = sprite.copy();
        sprite.resize(ceil(sprite.width * s), ceil(sprite.height * s));
        scale = s;
    }
    void update() {
        curLifetime++;
        if (curLifetime < maxLifetime) {
            //Total count of animation phases
            int phaseCount = spritesArray.length;
            //How long each animation phase is
            int phaseLength = int(maxLifetime/phaseCount);
            //int thing = curLifetime % phaseLength;
            if(curLifetime % phaseLength == 0) {
                curPhase++;
                sprite = loadImage(spritesArray[curPhase]);
            }
            spriteFlipped = sprite.copy();
            spriteFlipped.resize(ceil(sprite.width + sprite.width * scale * curLifetime/maxLifetime), ceil(sprite.height + sprite.height * scale * curLifetime/maxLifetime));
            if(curPhase == spritesArray.length - 1) {
                opacity = 255 - ((curLifetime/phaseCount)/(maxLifetime/phaseCount)) * 255;
                tint(255, opacity);
            }
            image(spriteFlipped, levelPos.x - w/2 - campaign.level.referenceX, levelPos.y - h/2 + campaign.level.referenceY);
            noTint();
        }
    }
}