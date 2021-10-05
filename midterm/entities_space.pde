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
- Entities - Space Classes
- Primarily used in Main Menu, maybe used in scenery.
-
*/

class ShipHalcyon extends Character {
    ShipHalcyon (int xpos, int ypos, float scaX, float scaY, int r, int l) {
        super();
        pos.set(xpos, ypos);
        w = 179;
        h = 61;
        scaleX = scaX;
        scaleY = scaY;
        rotation = radians(r);
        layer = l;
        maxHP = 100000;
        curHP = maxHP;
        maxShield = 0;
        curShield = maxShield;
        fov = 330;
        fovDistance = 3000;
        side = 1;
        weaponPrimary = new SpaceMacGun();
        weaponOffset.set(w/2,0);
        sprite = loadImage("data\\img\\char\\space\\unsc-halcyon.png");
        spriteFlipped = loadImage("data\\img\\char\\space\\unsc-halcyon-f.png");
    }
    void update() { 
        rect(pos.x, pos.y, 16,16);
        pushMatrix();
        translate(pos.x, pos.y);
        rotate(rotation);
        imageMode(CENTER);
        rectMode(CENTER);
        scale(scaleX, scaleY);
        if(sin(rotation + radians(90)) <= 0) {
            image(spriteFlipped, 0, 0);
        } else {
            image(sprite, 0, 0);
        }
        if ((boolean)userConfig.debug.value) {
            noFill();
            strokeWeight(1);
            stroke(#00ff00);
            rect(0, 0, w, h);
            stroke(#ff0000);
            arc(0, 0, fovDistance*2, fovDistance*2, -radians(fov/2), radians(fov/2), PIE);
            textFont(standardFont);
            textSize(int(w/10));
            textAlign(RIGHT);
            text(getClass().getSimpleName(), w/2, h/2);
            line(weaponOffset.x, weaponOffset.y, 1500, 0);
        }
        popMatrix();

        weaponPrimary.pos = new PVector(weaponOffset.x*cos(rotation) * scaleX + pos.x, weaponOffset.x*sin(rotation)* scaleY + pos.y );
        weaponPrimary.rotation = rotation;
        weaponPrimary.scaleX = scaleX;
        weaponPrimary.scaleY = scaleY;

        weaponPrimary.update();
        spotting();
    }
}

class SpaceMacGun extends Weapon {
    SpaceMacGun() {
        rof = 15;
        lastShot = int(15*frameRate*60);
        inaccuracy = 0.01;
    }
    void update() {
        projectileOrigin = pos;
        pushMatrix();
        translate(pos.x, pos.y);
        rotate(rotation);
        rect(0, 0,16,16);
        popMatrix();
        ownedProjectiles.forEach((p) -> {
            if (p.exists) p.update();
        });
        lastShot++;
    }
    void fire() {
        if (lastShot >= (60 * frameRate)/rof) {
            Projectile proj = new MacRound(projectileOrigin, rotation + random(-inaccuracy, inaccuracy), scaleX, scaleY);
            ownedProjectiles.add(proj);
            lastShot = 0;
        }
    }
}

class MacRound extends Projectile {
    MacRound(PVector position, float rot, float sX, float sY) {
        pos = position;
        origin.set(position.x, position.y);
        rotation = rot;
        scaleX = sX;
        scaleY = sY;

        damageUpper = 10000;
        damageLower = 1000;
        maxRange = int(1500*(scaleX+scaleY)/2);
        velocity = 500;
        sprite = loadImage("data\\img\\proj\\space\\unsc-projectile-large.png");
    }

    void hit(Entity otherObject) {
        otherObject.curHP =- (int)random(damageLower, damageUpper);
        expire();
    }

    void expire() {
        exists = false;
    }
}

class CovenantSupercarrier extends Character {
    CovenantSupercarrier (int xpos, int ypos, float scaX, float scaY, int r, int l) {
        super();
        pos.set(xpos, ypos);
        w = 359;
        h = 58;
        scaleX = scaX;
        scaleY = scaY;
        rotation = radians(r);
        layer = l;
        maxHP = 100000;
        curHP = maxHP;
        maxShield = 50000;
        curShield = maxShield;
        fov = 350;
        fovDistance = 3000;
        side = 2;
        weaponPrimary = new CovenantCannonLarge();
        weaponOffset.set(w/2,0);
        sprite = loadImage("data\\img\\char\\space\\cov-super.png");
        spriteFlipped = loadImage("data\\img\\char\\space\\cov-super-f.png");
    }
    void update() { 
        rect(pos.x, pos.y, 16,16);
        pushMatrix();
        translate(pos.x, pos.y);
        rotate(rotation);
        imageMode(CENTER);
        rectMode(CENTER);
        scale(scaleX, scaleY);
        if(sin(rotation + radians(90)) <= 0) {
            image(spriteFlipped, 0, 0);
        } else {
            image(sprite, 0, 0);
        }
        if ((boolean)userConfig.debug.value) {
            noFill();
            strokeWeight(1);
            stroke(#00ff00);
            rect(0, 0, w, h);
            stroke(#ff0000);
            arc(0, 0, fovDistance*2, fovDistance*2, -radians(fov/2), radians(fov/2), PIE);
            textFont(standardFont);
            textSize(int(w/10));
            textAlign(RIGHT);
            text(getClass().getSimpleName(), w/2, h/2);
            line(weaponOffset.x, weaponOffset.y, 1500, 0);
        }
        popMatrix();

        weaponPrimary.pos = new PVector(weaponOffset.x*cos(rotation) * scaleX + pos.x, weaponOffset.x*sin(rotation)* scaleY + pos.y );
        weaponPrimary.rotation = rotation;
        weaponPrimary.scaleX = scaleX;
        weaponPrimary.scaleY = scaleY;

        weaponPrimary.update();
        //spotting();
    }
}

class CovenantCannonLarge extends Weapon {
    CovenantCannonLarge() {
        rof = 15;
        lastShot = int(15*frameRate*60);
        inaccuracy = 0.01;
    }
    void update() {
        projectileOrigin = pos;
        pushMatrix();
        translate(pos.x, pos.y);
        rotate(rotation);
        rect(0, 0,16,16);
        popMatrix();
        ownedProjectiles.forEach((p) -> {
            if (p.exists) p.update();
        });
        lastShot++;
    }
    void fire() {
        if (lastShot >= (60 * frameRate)/rof) {
            Projectile proj = new CovenantLargePlasmaBall(projectileOrigin, rotation + random(-inaccuracy, inaccuracy), scaleX, scaleY);
            ownedProjectiles.add(proj);
            lastShot = 0;
        }
    }
}

class CovenantLargePlasmaBall extends Projectile {
    CovenantLargePlasmaBall(PVector position, float rot, float sX, float sY) {
        pos = position;
        origin.set(position.x, position.y);
        rotation = rot;
        scaleX = sX;
        scaleY = sY;

        damageUpper = 10000;
        damageLower = 1000;
        maxRange = int(1500*(scaleX+scaleY)/2);
        velocity = 500;
        sprite = loadImage("data\\img\\proj\\space\\cov-projectile.png");
    }

    void hit(Entity otherObject) {
        otherObject.curHP =- (int)random(damageLower, damageUpper);
        expire();
    }

    void expire() {
        exists = false;
    }
}