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
    ShipHalcyon (float xpos, float ypos, float scaX, float scaY, int r, int l) {
        super();
        pos.set(xpos, ypos);
        levelPos.set(xpos, ypos);
        w = 179;
        h = 61;
        scaleX = scaX;
        scaleY = scaY;
        rotation = radians(r);
        layer = l;
        maxHP = 50000;
        curHP = maxHP;
        maxShield = 0;
        curShield = maxShield;
        rotationSpeed = 12;
        movementSpeed = 1;
        fov = 330;
        fovDistance = 3000;
        side = 1;
        weaponPrimary = new SpaceMacGun(l);
        weaponSecondary = new SpaceMachineGun(l);
        weaponOffset.set(w/2,0);
        sprite = loadImage("data\\img\\char\\space\\unsc-halcyon.png");
        spriteFlipped = loadImage("data\\img\\char\\space\\unsc-halcyon-f.png");
    }
    void update() {
        weaponPrimary.parent = this;
        weaponSecondary.parent = this;
        if (alive) {
            pushMatrix();
            translate(levelPos.x, levelPos.y);
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

            weaponPrimary.levelPos = new PVector(weaponOffset.x*cos(rotation) * scaleX + levelPos.x, weaponOffset.x*sin(rotation)* scaleY + levelPos.y);
            weaponPrimary.rotation = rotation;
            weaponPrimary.scaleX = scaleX;
            weaponPrimary.scaleY = scaleY;
            weaponSecondary.levelPos = new PVector(levelPos.x, levelPos.y);
            weaponSecondary.rotation = rotation;
            weaponSecondary.scaleX = scaleX;
            weaponSecondary.scaleY = scaleY;

            weaponPrimary.update();
            weaponSecondary.update();
            spotting();
        }
    }
    void death() {
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 4, new String[]{"data\\img\\proj\\space\\unsc-explosion-1.png", "data\\img\\proj\\space\\unsc-explosion-2.png", "data\\img\\proj\\space\\unsc-explosion-3.png", "data\\img\\proj\\space\\unsc-explosion-4.png","data\\img\\proj\\space\\unsc-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 4, new String[]{"data\\img\\proj\\space\\unsc-explosion-1.png", "data\\img\\proj\\space\\unsc-explosion-2.png", "data\\img\\proj\\space\\unsc-explosion-3.png", "data\\img\\proj\\space\\unsc-explosion-4.png","data\\img\\proj\\space\\unsc-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 4, new String[]{"data\\img\\proj\\space\\unsc-explosion-1.png", "data\\img\\proj\\space\\unsc-explosion-2.png", "data\\img\\proj\\space\\unsc-explosion-3.png", "data\\img\\proj\\space\\unsc-explosion-4.png","data\\img\\proj\\space\\unsc-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 4, new String[]{"data\\img\\proj\\space\\unsc-explosion-1.png", "data\\img\\proj\\space\\unsc-explosion-2.png", "data\\img\\proj\\space\\unsc-explosion-3.png", "data\\img\\proj\\space\\unsc-explosion-4.png","data\\img\\proj\\space\\unsc-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 4, new String[]{"data\\img\\proj\\space\\unsc-explosion-1.png", "data\\img\\proj\\space\\unsc-explosion-2.png", "data\\img\\proj\\space\\unsc-explosion-3.png", "data\\img\\proj\\space\\unsc-explosion-4.png","data\\img\\proj\\space\\unsc-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 4, new String[]{"data\\img\\proj\\space\\unsc-explosion-1.png", "data\\img\\proj\\space\\unsc-explosion-2.png", "data\\img\\proj\\space\\unsc-explosion-3.png", "data\\img\\proj\\space\\unsc-explosion-4.png","data\\img\\proj\\space\\unsc-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 4, new String[]{"data\\img\\proj\\space\\unsc-explosion-1.png", "data\\img\\proj\\space\\unsc-explosion-2.png", "data\\img\\proj\\space\\unsc-explosion-3.png", "data\\img\\proj\\space\\unsc-explosion-4.png","data\\img\\proj\\space\\unsc-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 4, new String[]{"data\\img\\proj\\space\\unsc-explosion-1.png", "data\\img\\proj\\space\\unsc-explosion-2.png", "data\\img\\proj\\space\\unsc-explosion-3.png", "data\\img\\proj\\space\\unsc-explosion-4.png","data\\img\\proj\\space\\unsc-explosion-5.png"}));
    }
}

class SpaceMacGun extends Weapon {
    SpaceMacGun(int l) {
        rof = 15;
        lastShot = int(rof*frameRate*60);
        inaccuracy = 0.01;
        layer = l;
    }
    void update() {
        projectileOrigin = levelPos;
        ownedProjectiles.forEach((p) -> {
            if (p.exists) p.update();
        });
        lastShot++;
    }
    void fire() {
        if (lastShot >= (60 * frameRate)/rof) {
            Projectile proj = new MacRound(projectileOrigin, rotation + random(-inaccuracy, inaccuracy), scaleX, scaleY, layer, parent);
            ownedProjectiles.add(proj);
            lastShot = 0;
        }
    }
}

class MacRound extends Projectile {
    MacRound(PVector position, float rot, float sX, float sY, int l, Character p) {
        levelPos = position;
        origin.set(position.x, position.y);
        rotation = rot;
        scaleX = sX;
        scaleY = sY;
        layer = l;

        damageUpper = 10000;
        damageLower = 1000;
        maxRange = int(1500*(scaleX+scaleY)/2);
        velocity = 1000;
        sprite = loadImage("data\\img\\proj\\space\\unsc-projectile-large.png");
        parent = p;
    }

    void hit() {
        String[] particleArray = {
            "data\\img\\proj\\space\\unsc-explosion-1.png",
            "data\\img\\proj\\space\\unsc-explosion-2.png",
            "data\\img\\proj\\space\\unsc-explosion-3.png"
        };

        loadedPFX.add(new ParticleEffect(levelPos.x, levelPos.y, 90, random(2), new String[]{particleArray[int(random(particleArray.length))], "data\\img\\proj\\space\\unsc-explosion-4.png", "data\\img\\proj\\space\\unsc-explosion-5.png"}));
    }

    void expire() {
        exists = false;
    }
}

class SpaceMachineGun extends Weapon {
    SpaceMachineGun(int l) {
        rof = 600;
        lastShot = int(rof*frameRate*60);
        inaccuracy = 0.03;
        layer = l;
    }
    void update() {
        projectileOrigin = levelPos;
        ownedProjectiles.forEach((p) -> {
            if (p.exists) p.update();
        });
        lastShot++;
    }
    void fire() {
        if (lastShot >= (60 * frameRate)/rof) {
            Projectile proj = new MachineGunRound(projectileOrigin, rotation + random(-inaccuracy, inaccuracy), scaleX, scaleY, layer, parent);
            ownedProjectiles.add(proj);
            lastShot = 0;
        }
    }
}

class MachineGunRound extends Projectile {
    MachineGunRound(PVector position, float rot, float sX, float sY, int l, Character p) {
        levelPos = position;
        origin.set(position.x, position.y);
        rotation = rot;
        scaleX = sX;
        scaleY = sY;
        layer = l;

        damageUpper = 250;
        damageLower = 50;
        maxRange = int(1500*(scaleX+scaleY)/2);
        velocity = 500;
        sprite = loadImage("data\\img\\proj\\space\\unsc-projectile-small.png");
        parent = p;
    }

    void hit() {
        String[] particleArray = {
            "data\\img\\proj\\space\\unsc-explosion-1.png",
            "data\\img\\proj\\space\\unsc-explosion-2.png",
            "data\\img\\proj\\space\\unsc-explosion-3.png"
        };

        loadedPFX.add(new ParticleEffect(levelPos.x, levelPos.y, 30, 0.5, new String[]{particleArray[int(random(particleArray.length))], "data\\img\\proj\\space\\unsc-explosion-4.png", "data\\img\\proj\\space\\unsc-explosion-5.png"}));
    }

    void expire() {
        exists = false;
    }
}

class CovenantSupercarrier extends Character {
    CovenantSupercarrier (float xpos, float ypos, float scaX, float scaY, int r, int l) {
        super();
        pos.set(xpos, ypos);
        levelPos.set(xpos, ypos);
        w = 359;
        h = 58;
        scaleX = scaX;
        scaleY = scaY;
        rotation = radians(r);
        layer = l;
        maxHP = 50000;
        curHP = maxHP;
        maxShield = 25000;
        curShield = maxShield;
        rotationSpeed = 6;
        movementSpeed = 1;
        fov = 350;
        fovDistance = 3000;
        side = 2;
        weaponPrimary = new CovenantCannonLarge(l);
        weaponSecondary = new CovenantShipRepeater(l);
        weaponOffset.set(w/2,0);
        sprite = loadImage("data\\img\\char\\space\\cov-super.png");
        spriteFlipped = loadImage("data\\img\\char\\space\\cov-super-f.png");
    }
    void update() {
        weaponPrimary.parent = this;
        weaponSecondary.parent = this;
        if (alive) {
            pushMatrix();
            translate(levelPos.x, levelPos.y);
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

            weaponPrimary.levelPos = new PVector(weaponOffset.x*cos(rotation) * scaleX + levelPos.x, weaponOffset.x*sin(rotation)* scaleY + levelPos.y);
            weaponPrimary.rotation = rotation;
            weaponPrimary.scaleX = scaleX;
            weaponPrimary.scaleY = scaleY;
            weaponSecondary.levelPos = new PVector(levelPos.x, levelPos.y);
            weaponSecondary.rotation = rotation;
            weaponSecondary.scaleX = scaleX;
            weaponSecondary.scaleY = scaleY;

            weaponPrimary.update();
            weaponSecondary.update();
            spotting();
        }
    }
    void death() {
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 4, new String[]{"data\\img\\proj\\space\\cov-explosion-1.png", "data\\img\\proj\\space\\cov-explosion-2.png", "data\\img\\proj\\space\\cov-explosion-3.png", "data\\img\\proj\\space\\cov-explosion-4.png","data\\img\\proj\\space\\cov-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 4, new String[]{"data\\img\\proj\\space\\cov-explosion-1.png", "data\\img\\proj\\space\\cov-explosion-2.png", "data\\img\\proj\\space\\cov-explosion-3.png", "data\\img\\proj\\space\\cov-explosion-4.png","data\\img\\proj\\space\\cov-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 4, new String[]{"data\\img\\proj\\space\\cov-explosion-1.png", "data\\img\\proj\\space\\cov-explosion-2.png", "data\\img\\proj\\space\\cov-explosion-3.png", "data\\img\\proj\\space\\cov-explosion-4.png","data\\img\\proj\\space\\cov-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 4, new String[]{"data\\img\\proj\\space\\cov-explosion-1.png", "data\\img\\proj\\space\\cov-explosion-2.png", "data\\img\\proj\\space\\cov-explosion-3.png", "data\\img\\proj\\space\\cov-explosion-4.png","data\\img\\proj\\space\\cov-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 4, new String[]{"data\\img\\proj\\space\\cov-explosion-1.png", "data\\img\\proj\\space\\cov-explosion-2.png", "data\\img\\proj\\space\\cov-explosion-3.png", "data\\img\\proj\\space\\cov-explosion-4.png","data\\img\\proj\\space\\cov-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 4, new String[]{"data\\img\\proj\\space\\cov-explosion-1.png", "data\\img\\proj\\space\\cov-explosion-2.png", "data\\img\\proj\\space\\cov-explosion-3.png", "data\\img\\proj\\space\\cov-explosion-4.png","data\\img\\proj\\space\\cov-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 4, new String[]{"data\\img\\proj\\space\\cov-explosion-1.png", "data\\img\\proj\\space\\cov-explosion-2.png", "data\\img\\proj\\space\\cov-explosion-3.png", "data\\img\\proj\\space\\cov-explosion-4.png","data\\img\\proj\\space\\cov-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 4, new String[]{"data\\img\\proj\\space\\cov-explosion-1.png", "data\\img\\proj\\space\\cov-explosion-2.png", "data\\img\\proj\\space\\cov-explosion-3.png", "data\\img\\proj\\space\\cov-explosion-4.png","data\\img\\proj\\space\\cov-explosion-5.png"}));
    }
}

class CovenantCannonLarge extends Weapon {
    CovenantCannonLarge(int l) {
        rof = 15;
        lastShot = int(rof*frameRate*60);
        inaccuracy = 0.01;
        layer = l;
    }
    void update() {
        projectileOrigin = levelPos;
        ownedProjectiles.forEach((p) -> {
            if (p.exists) p.update();
        });
        lastShot++;
    }
    void fire() {
        if (lastShot >= (60 * frameRate)/rof) {
            Projectile proj = new CovenantLargePlasmaBall(projectileOrigin, rotation + random(-inaccuracy, inaccuracy), scaleX * 2, scaleY * 2, layer, parent);
            ownedProjectiles.add(proj);
            lastShot = 0;
        }
    }
}

class CovenantLargePlasmaBall extends Projectile {
    CovenantLargePlasmaBall(PVector position, float rot, float sX, float sY, int l, Character p) {
        levelPos = position;
        origin.set(position.x, position.y);
        rotation = rot;
        scaleX = sX;
        scaleY = sY;
        layer = l;

        damageUpper = 10000;
        damageLower = 1000;
        maxRange = int(1500*(scaleX+scaleY)/2);
        velocity = 500;
        sprite = loadImage("data\\img\\proj\\space\\cov-projectile.png");
        parent = p;
    }

    void hit() {
        String[] particleArray = {
            "data\\img\\proj\\space\\cov-explosion-1.png",
            "data\\img\\proj\\space\\cov-explosion-2.png",
            "data\\img\\proj\\space\\cov-explosion-3.png"
        };

        loadedPFX.add(new ParticleEffect(levelPos.x, levelPos.y, 90, random(2), new String[]{particleArray[int(random(particleArray.length))], "data\\img\\proj\\space\\cov-explosion-4.png", "data\\img\\proj\\space\\cov-explosion-5.png"}));
    }

    void expire() {
        exists = false;
    }
}

class CovenantCCS extends Character {
    CovenantCCS (float xpos, float ypos, float scaX, float scaY, int r, int l) {
        super();
        pos.set(xpos, ypos);
        levelPos.set(xpos, ypos);
        w = 260;
        h = 38;
        scaleX = scaX;
        scaleY = scaY;
        rotation = radians(r);
        layer = l;
        maxHP = 25000;
        curHP = maxHP;
        maxShield = 10000;
        curShield = maxShield;
        rotationSpeed = 24;
        movementSpeed = 2;
        fov = 350;
        fovDistance = 3000;
        side = 2;
        weaponPrimary = new CovenantShipRepeater(l);
        weaponSecondary = new CovenantShipRepeater(l);
        weaponOffset.set(w/2, 0);
        sprite = loadImage("data\\img\\char\\space\\cov-ccs.png");
        spriteFlipped = loadImage("data\\img\\char\\space\\cov-ccs-f.png");
    }
    void update() {
        weaponPrimary.parent = this;
        weaponSecondary.parent = this;
        if (alive) {
            pushMatrix();
            translate(levelPos.x, levelPos.y);
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

            weaponPrimary.levelPos = new PVector(weaponOffset.x*cos(rotation) * scaleX + levelPos.x, weaponOffset.x*sin(rotation)* scaleY + levelPos.y);
            weaponPrimary.rotation = rotation;
            weaponPrimary.scaleX = scaleX;
            weaponPrimary.scaleY = scaleY;
            weaponSecondary.levelPos = new PVector(levelPos.x,levelPos.y);
            weaponSecondary.rotation = rotation;
            weaponSecondary.scaleX = scaleX;
            weaponSecondary.scaleY = scaleY;

            weaponPrimary.update();
            weaponSecondary.update();
            spotting();
        }
    }
    void death() {
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 3, new String[]{"data\\img\\proj\\space\\cov-explosion-1.png", "data\\img\\proj\\space\\cov-explosion-2.png", "data\\img\\proj\\space\\cov-explosion-3.png", "data\\img\\proj\\space\\cov-explosion-4.png","data\\img\\proj\\space\\cov-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 3, new String[]{"data\\img\\proj\\space\\cov-explosion-1.png", "data\\img\\proj\\space\\cov-explosion-2.png", "data\\img\\proj\\space\\cov-explosion-3.png", "data\\img\\proj\\space\\cov-explosion-4.png","data\\img\\proj\\space\\cov-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 3, new String[]{"data\\img\\proj\\space\\cov-explosion-1.png", "data\\img\\proj\\space\\cov-explosion-2.png", "data\\img\\proj\\space\\cov-explosion-3.png", "data\\img\\proj\\space\\cov-explosion-4.png","data\\img\\proj\\space\\cov-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 3, new String[]{"data\\img\\proj\\space\\cov-explosion-1.png", "data\\img\\proj\\space\\cov-explosion-2.png", "data\\img\\proj\\space\\cov-explosion-3.png", "data\\img\\proj\\space\\cov-explosion-4.png","data\\img\\proj\\space\\cov-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 3, new String[]{"data\\img\\proj\\space\\cov-explosion-1.png", "data\\img\\proj\\space\\cov-explosion-2.png", "data\\img\\proj\\space\\cov-explosion-3.png", "data\\img\\proj\\space\\cov-explosion-4.png","data\\img\\proj\\space\\cov-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 3, new String[]{"data\\img\\proj\\space\\cov-explosion-1.png", "data\\img\\proj\\space\\cov-explosion-2.png", "data\\img\\proj\\space\\cov-explosion-3.png", "data\\img\\proj\\space\\cov-explosion-4.png","data\\img\\proj\\space\\cov-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 3, new String[]{"data\\img\\proj\\space\\cov-explosion-1.png", "data\\img\\proj\\space\\cov-explosion-2.png", "data\\img\\proj\\space\\cov-explosion-3.png", "data\\img\\proj\\space\\cov-explosion-4.png","data\\img\\proj\\space\\cov-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 3, new String[]{"data\\img\\proj\\space\\cov-explosion-1.png", "data\\img\\proj\\space\\cov-explosion-2.png", "data\\img\\proj\\space\\cov-explosion-3.png", "data\\img\\proj\\space\\cov-explosion-4.png","data\\img\\proj\\space\\cov-explosion-5.png"}));
    }
}

class CovenantShipRepeater extends Weapon {
    CovenantShipRepeater(int l) {
        rof = 300;
        lastShot = int(rof*frameRate*60);
        inaccuracy = 0.05;
        layer = l;
    }
    void update() {
        projectileOrigin = levelPos;
        ownedProjectiles.forEach((p) -> {
            if (p.exists) p.update();
        });
        lastShot++;
    }
    void fire() {
        if (lastShot >= (60 * frameRate)/rof) {
            Projectile proj = new CovenantRepeaterShell(projectileOrigin, rotation + random(-inaccuracy, inaccuracy), scaleX * 0.5, scaleY * 0.5, layer, parent);
            ownedProjectiles.add(proj);
            lastShot = 0;
        }
    }
}

class CovenantRepeaterShell extends Projectile {
    CovenantRepeaterShell(PVector position, float rot, float sX, float sY, int l, Character p) {
        levelPos = position;
        origin.set(position.x, position.y);
        rotation = rot;
        scaleX = sX;
        scaleY = sY;
        layer = l;

        damageUpper = 500;
        damageLower = 100;
        maxRange = int(1500*(scaleX+scaleY)/2);
        velocity = 1000;
        sprite = loadImage("data\\img\\proj\\space\\cov-projectile.png");
        parent = p;
    }

    void hit() {
        String[] particleArray = {
            "data\\img\\proj\\space\\cov-explosion-1.png",
            "data\\img\\proj\\space\\cov-explosion-2.png",
            "data\\img\\proj\\space\\cov-explosion-3.png"
        };

        loadedPFX.add(new ParticleEffect(levelPos.x, levelPos.y, 30, 0.5, new String[]{particleArray[int(random(particleArray.length))], "data\\img\\proj\\space\\cov-explosion-4.png", "data\\img\\proj\\space\\cov-explosion-5.png"}));
    }

    void expire() {
        exists = false;
    }
}

class ShipCruiserUNSC extends Character {
    ShipCruiserUNSC (float xpos, float ypos, float scaX, float scaY, int r, int l) {
        super();
        pos.set(xpos, ypos);
        levelPos.set(xpos, ypos);
        w = 125;
        h = 34;
        scaleX = scaX;
        scaleY = scaY;
        rotation = radians(r);
        layer = l;
        maxHP = 35000;
        curHP = maxHP;
        maxShield = 0;
        curShield = maxShield;
        rotationSpeed = 18;
        movementSpeed = 1;
        fov = 330;
        fovDistance = 3000;
        side = 1;
        weaponPrimary = new SpaceMacGun(l);
        weaponSecondary = new SpaceMachineGun(l);
        weaponOffset.set(w/2,0);
        sprite = loadImage("data\\img\\char\\space\\unsc-cruiser.png");
        spriteFlipped = loadImage("data\\img\\char\\space\\unsc-cruiser-f.png");
    }
    void update() {
        weaponPrimary.parent = this;
        if (alive) {
            pushMatrix();
            translate(levelPos.x, levelPos.y);
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

            weaponPrimary.levelPos = new PVector(weaponOffset.x*cos(rotation) * scaleX + levelPos.x, weaponOffset.x*sin(rotation)* scaleY + levelPos.y);
            weaponPrimary.rotation = rotation;
            weaponPrimary.scaleX = scaleX;
            weaponPrimary.scaleY = scaleY;
            weaponSecondary.levelPos = new PVector(levelPos.x, levelPos.y);
            weaponSecondary.rotation = rotation;
            weaponSecondary.scaleX = scaleX;
            weaponSecondary.scaleY = scaleY;

            weaponPrimary.update();
            weaponSecondary.update();
            spotting();
        }
    }
    void death() {
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 2, new String[]{"data\\img\\proj\\space\\unsc-explosion-1.png", "data\\img\\proj\\space\\unsc-explosion-2.png", "data\\img\\proj\\space\\unsc-explosion-3.png", "data\\img\\proj\\space\\unsc-explosion-4.png","data\\img\\proj\\space\\unsc-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 2, new String[]{"data\\img\\proj\\space\\unsc-explosion-1.png", "data\\img\\proj\\space\\unsc-explosion-2.png", "data\\img\\proj\\space\\unsc-explosion-3.png", "data\\img\\proj\\space\\unsc-explosion-4.png","data\\img\\proj\\space\\unsc-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 2, new String[]{"data\\img\\proj\\space\\unsc-explosion-1.png", "data\\img\\proj\\space\\unsc-explosion-2.png", "data\\img\\proj\\space\\unsc-explosion-3.png", "data\\img\\proj\\space\\unsc-explosion-4.png","data\\img\\proj\\space\\unsc-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 2, new String[]{"data\\img\\proj\\space\\unsc-explosion-1.png", "data\\img\\proj\\space\\unsc-explosion-2.png", "data\\img\\proj\\space\\unsc-explosion-3.png", "data\\img\\proj\\space\\unsc-explosion-4.png","data\\img\\proj\\space\\unsc-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 2, new String[]{"data\\img\\proj\\space\\unsc-explosion-1.png", "data\\img\\proj\\space\\unsc-explosion-2.png", "data\\img\\proj\\space\\unsc-explosion-3.png", "data\\img\\proj\\space\\unsc-explosion-4.png","data\\img\\proj\\space\\unsc-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 2, new String[]{"data\\img\\proj\\space\\unsc-explosion-1.png", "data\\img\\proj\\space\\unsc-explosion-2.png", "data\\img\\proj\\space\\unsc-explosion-3.png", "data\\img\\proj\\space\\unsc-explosion-4.png","data\\img\\proj\\space\\unsc-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 2, new String[]{"data\\img\\proj\\space\\unsc-explosion-1.png", "data\\img\\proj\\space\\unsc-explosion-2.png", "data\\img\\proj\\space\\unsc-explosion-3.png", "data\\img\\proj\\space\\unsc-explosion-4.png","data\\img\\proj\\space\\unsc-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 2, new String[]{"data\\img\\proj\\space\\unsc-explosion-1.png", "data\\img\\proj\\space\\unsc-explosion-2.png", "data\\img\\proj\\space\\unsc-explosion-3.png", "data\\img\\proj\\space\\unsc-explosion-4.png","data\\img\\proj\\space\\unsc-explosion-5.png"}));
    }
}

class ShipFrigateUNSC extends Character {
    ShipFrigateUNSC (float xpos, float ypos, float scaX, float scaY, int r, int l) {
        super();
        pos.set(xpos, ypos);
        levelPos.set(xpos, ypos);
        w = 66;
        h = 18;
        scaleX = scaX;
        scaleY = scaY;
        rotation = radians(r);
        layer = l;
        maxHP = 15000;
        curHP = maxHP;
        maxShield = 0;
        curShield = maxShield;
        rotationSpeed = 24;
        movementSpeed = 3;
        fov = 330;
        fovDistance = 3000;
        side = 1;
        weaponPrimary = new SpaceMacGun(l);
        weaponSecondary = new SpaceMachineGun(l);
        weaponOffset.set(w/2,0);
        sprite = loadImage("data\\img\\char\\space\\unsc-frigate.png");
        spriteFlipped = loadImage("data\\img\\char\\space\\unsc-frigate-f.png");
    }
    void update() {
        weaponPrimary.parent = this;
        weaponSecondary.parent = this;
        if (alive) {
            pushMatrix();
            translate(levelPos.x, levelPos.y);
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

            weaponPrimary.levelPos = new PVector(weaponOffset.x*cos(rotation) * scaleX + levelPos.x, weaponOffset.x*sin(rotation)* scaleY + levelPos.y);
            weaponPrimary.rotation = rotation;
            weaponPrimary.scaleX = scaleX;
            weaponPrimary.scaleY = scaleY;
            weaponSecondary.levelPos = new PVector(levelPos.x, levelPos.y);
            weaponSecondary.rotation = rotation;
            weaponSecondary.scaleX = scaleX;
            weaponSecondary.scaleY = scaleY;

            weaponPrimary.update();
            weaponSecondary.update();
            spotting();
        }
    }
    void death() {
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 1, new String[]{"data\\img\\proj\\space\\unsc-explosion-1.png", "data\\img\\proj\\space\\unsc-explosion-2.png", "data\\img\\proj\\space\\unsc-explosion-3.png", "data\\img\\proj\\space\\unsc-explosion-4.png","data\\img\\proj\\space\\unsc-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 1, new String[]{"data\\img\\proj\\space\\unsc-explosion-1.png", "data\\img\\proj\\space\\unsc-explosion-2.png", "data\\img\\proj\\space\\unsc-explosion-3.png", "data\\img\\proj\\space\\unsc-explosion-4.png","data\\img\\proj\\space\\unsc-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 1, new String[]{"data\\img\\proj\\space\\unsc-explosion-1.png", "data\\img\\proj\\space\\unsc-explosion-2.png", "data\\img\\proj\\space\\unsc-explosion-3.png", "data\\img\\proj\\space\\unsc-explosion-4.png","data\\img\\proj\\space\\unsc-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 1, new String[]{"data\\img\\proj\\space\\unsc-explosion-1.png", "data\\img\\proj\\space\\unsc-explosion-2.png", "data\\img\\proj\\space\\unsc-explosion-3.png", "data\\img\\proj\\space\\unsc-explosion-4.png","data\\img\\proj\\space\\unsc-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 1, new String[]{"data\\img\\proj\\space\\unsc-explosion-1.png", "data\\img\\proj\\space\\unsc-explosion-2.png", "data\\img\\proj\\space\\unsc-explosion-3.png", "data\\img\\proj\\space\\unsc-explosion-4.png","data\\img\\proj\\space\\unsc-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 1, new String[]{"data\\img\\proj\\space\\unsc-explosion-1.png", "data\\img\\proj\\space\\unsc-explosion-2.png", "data\\img\\proj\\space\\unsc-explosion-3.png", "data\\img\\proj\\space\\unsc-explosion-4.png","data\\img\\proj\\space\\unsc-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 1, new String[]{"data\\img\\proj\\space\\unsc-explosion-1.png", "data\\img\\proj\\space\\unsc-explosion-2.png", "data\\img\\proj\\space\\unsc-explosion-3.png", "data\\img\\proj\\space\\unsc-explosion-4.png","data\\img\\proj\\space\\unsc-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 1, new String[]{"data\\img\\proj\\space\\unsc-explosion-1.png", "data\\img\\proj\\space\\unsc-explosion-2.png", "data\\img\\proj\\space\\unsc-explosion-3.png", "data\\img\\proj\\space\\unsc-explosion-4.png","data\\img\\proj\\space\\unsc-explosion-5.png"}));
    }
}

class ShipDestroyerUNSC extends Character {
    ShipDestroyerUNSC (float xpos, float ypos, float scaX, float scaY, int r, int l) {
        super();
        pos.set(xpos, ypos);
        levelPos.set(xpos, ypos);
        w = 67;
        h = 19;
        scaleX = scaX;
        scaleY = scaY;
        rotation = radians(r);
        layer = l;
        maxHP = 15000;
        curHP = maxHP;
        maxShield = 0;
        curShield = maxShield;
        rotationSpeed = 24;
        movementSpeed = 3;
        fov = 330;
        fovDistance = 3000;
        side = 1;
        weaponPrimary = new SpaceMacGun(l);
        weaponSecondary = new SpaceMachineGun(l);
        weaponOffset.set(w/2,0);
        sprite = loadImage("data\\img\\char\\space\\unsc-destroyer.png");
        spriteFlipped = loadImage("data\\img\\char\\space\\unsc-destroyer-f.png");
    }
    void update() {
        weaponPrimary.parent = this;
        weaponSecondary.parent = this;
        if (alive) {
            pushMatrix();
            translate(levelPos.x, levelPos.y);
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

            weaponPrimary.levelPos = new PVector(weaponOffset.x*cos(rotation) * scaleX + levelPos.x, weaponOffset.x*sin(rotation)* scaleY + levelPos.y);
            weaponPrimary.rotation = rotation;
            weaponPrimary.scaleX = scaleX;
            weaponPrimary.scaleY = scaleY;
            weaponSecondary.levelPos = new PVector(levelPos.x, levelPos.y);
            weaponSecondary.rotation = rotation;
            weaponSecondary.scaleX = scaleX;
            weaponSecondary.scaleY = scaleY;

            weaponPrimary.update();
            weaponSecondary.update();
            spotting();
        }
    }
    void death() {
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 1, new String[]{"data\\img\\proj\\space\\unsc-explosion-1.png", "data\\img\\proj\\space\\unsc-explosion-2.png", "data\\img\\proj\\space\\unsc-explosion-3.png", "data\\img\\proj\\space\\unsc-explosion-4.png","data\\img\\proj\\space\\unsc-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 1, new String[]{"data\\img\\proj\\space\\unsc-explosion-1.png", "data\\img\\proj\\space\\unsc-explosion-2.png", "data\\img\\proj\\space\\unsc-explosion-3.png", "data\\img\\proj\\space\\unsc-explosion-4.png","data\\img\\proj\\space\\unsc-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 1, new String[]{"data\\img\\proj\\space\\unsc-explosion-1.png", "data\\img\\proj\\space\\unsc-explosion-2.png", "data\\img\\proj\\space\\unsc-explosion-3.png", "data\\img\\proj\\space\\unsc-explosion-4.png","data\\img\\proj\\space\\unsc-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 1, new String[]{"data\\img\\proj\\space\\unsc-explosion-1.png", "data\\img\\proj\\space\\unsc-explosion-2.png", "data\\img\\proj\\space\\unsc-explosion-3.png", "data\\img\\proj\\space\\unsc-explosion-4.png","data\\img\\proj\\space\\unsc-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 1, new String[]{"data\\img\\proj\\space\\unsc-explosion-1.png", "data\\img\\proj\\space\\unsc-explosion-2.png", "data\\img\\proj\\space\\unsc-explosion-3.png", "data\\img\\proj\\space\\unsc-explosion-4.png","data\\img\\proj\\space\\unsc-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 1, new String[]{"data\\img\\proj\\space\\unsc-explosion-1.png", "data\\img\\proj\\space\\unsc-explosion-2.png", "data\\img\\proj\\space\\unsc-explosion-3.png", "data\\img\\proj\\space\\unsc-explosion-4.png","data\\img\\proj\\space\\unsc-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 1, new String[]{"data\\img\\proj\\space\\unsc-explosion-1.png", "data\\img\\proj\\space\\unsc-explosion-2.png", "data\\img\\proj\\space\\unsc-explosion-3.png", "data\\img\\proj\\space\\unsc-explosion-4.png","data\\img\\proj\\space\\unsc-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 1, new String[]{"data\\img\\proj\\space\\unsc-explosion-1.png", "data\\img\\proj\\space\\unsc-explosion-2.png", "data\\img\\proj\\space\\unsc-explosion-3.png", "data\\img\\proj\\space\\unsc-explosion-4.png","data\\img\\proj\\space\\unsc-explosion-5.png"}));
    }
}

class CorvetteCovenant extends Character {
    CorvetteCovenant (float xpos, float ypos, float scaX, float scaY, int r, int l) {
        super();
        pos.set(xpos, ypos);
        levelPos.set(xpos, ypos);
        w = 133;
        h = 24;
        scaleX = scaX;
        scaleY = scaY;
        rotation = radians(r);
        layer = l;
        maxHP = 25000;
        curHP = maxHP;
        maxShield = 0;
        curShield = maxShield;
        rotationSpeed = 30;
        movementSpeed = 3;
        fov = 350;
        fovDistance = 3000;
        side = 2;
        weaponPrimary = new CovenantShipRepeater(l);
        weaponOffset.set(w/2, 0);
        sprite = loadImage("data\\img\\char\\space\\cov-corvette.png");
        spriteFlipped = loadImage("data\\img\\char\\space\\cov-corvette-f.png");
    }
    void update() {
        weaponPrimary.parent = this;
        if (alive) {
            pushMatrix();
            translate(levelPos.x, levelPos.y);
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

            weaponPrimary.levelPos = new PVector(weaponOffset.x*cos(rotation) * scaleX + levelPos.x, weaponOffset.x*sin(rotation)* scaleY + levelPos.y);
            weaponPrimary.rotation = rotation;
            weaponPrimary.scaleX = scaleX;
            weaponPrimary.scaleY = scaleY;

            weaponPrimary.update();
            spotting();
        }
    }
    void death() {
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 1, new String[]{"data\\img\\proj\\space\\cov-explosion-1.png", "data\\img\\proj\\space\\cov-explosion-2.png", "data\\img\\proj\\space\\cov-explosion-3.png", "data\\img\\proj\\space\\cov-explosion-4.png","data\\img\\proj\\space\\cov-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 1, new String[]{"data\\img\\proj\\space\\cov-explosion-1.png", "data\\img\\proj\\space\\cov-explosion-2.png", "data\\img\\proj\\space\\cov-explosion-3.png", "data\\img\\proj\\space\\cov-explosion-4.png","data\\img\\proj\\space\\cov-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 1, new String[]{"data\\img\\proj\\space\\cov-explosion-1.png", "data\\img\\proj\\space\\cov-explosion-2.png", "data\\img\\proj\\space\\cov-explosion-3.png", "data\\img\\proj\\space\\cov-explosion-4.png","data\\img\\proj\\space\\cov-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 1, new String[]{"data\\img\\proj\\space\\cov-explosion-1.png", "data\\img\\proj\\space\\cov-explosion-2.png", "data\\img\\proj\\space\\cov-explosion-3.png", "data\\img\\proj\\space\\cov-explosion-4.png","data\\img\\proj\\space\\cov-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 1, new String[]{"data\\img\\proj\\space\\cov-explosion-1.png", "data\\img\\proj\\space\\cov-explosion-2.png", "data\\img\\proj\\space\\cov-explosion-3.png", "data\\img\\proj\\space\\cov-explosion-4.png","data\\img\\proj\\space\\cov-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 1, new String[]{"data\\img\\proj\\space\\cov-explosion-1.png", "data\\img\\proj\\space\\cov-explosion-2.png", "data\\img\\proj\\space\\cov-explosion-3.png", "data\\img\\proj\\space\\cov-explosion-4.png","data\\img\\proj\\space\\cov-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 1, new String[]{"data\\img\\proj\\space\\cov-explosion-1.png", "data\\img\\proj\\space\\cov-explosion-2.png", "data\\img\\proj\\space\\cov-explosion-3.png", "data\\img\\proj\\space\\cov-explosion-4.png","data\\img\\proj\\space\\cov-explosion-5.png"}));
        loadedPFX.add(new ParticleEffect(levelPos.x + random(-w/2, w/2), levelPos.y + random(-h/2, h/2), 90, 1, new String[]{"data\\img\\proj\\space\\cov-explosion-1.png", "data\\img\\proj\\space\\cov-explosion-2.png", "data\\img\\proj\\space\\cov-explosion-3.png", "data\\img\\proj\\space\\cov-explosion-4.png","data\\img\\proj\\space\\cov-explosion-5.png"}));
    }
}