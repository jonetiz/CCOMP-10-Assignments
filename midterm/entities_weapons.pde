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
- Weapon Entities
-
*/

class AssaultRifle extends Weapon {
    AssaultRifle(int l, Character c) {
        rof = 650;
        lastShot = int(rof*frameRate*60);
        inaccuracy = 0.01;
        layer = l;
        sprite = loadImage("data\\img\\weap\\AssaultRifle\\assaultrifle.png");
        ammoCurrent = 60;
        ammoCurrentMaximum = 60;
        ammoTotal = 600;
        ammoTotalMaximum = 600;
        parent = c;

        crosshair = loadImage("data\\img\\weap\\AssaultRifle\\crosshair.png");

        //2.5 seconds to reload
        timeToReload = 150;

        sfx_fire.add(new SoundEffect("data\\sound\\weap\\assault_rifle\\fire_1.wav"));
        sfx_fire.add(new SoundEffect("data\\sound\\weap\\assault_rifle\\fire_2.wav"));
        sfx_fire.add(new SoundEffect("data\\sound\\weap\\assault_rifle\\fire_3.wav"));
        sfx_fire.add(new SoundEffect("data\\sound\\weap\\assault_rifle\\fire_4.wav"));
        sfx_dry = new SoundEffect("data\\sound\\weap\\assault_rifle\\dryfire.wav");
        sfx_ready = new SoundEffect("data\\sound\\weap\\assault_rifle\\ready.wav");
        sfx_reload = new SoundEffect("data\\sound\\weap\\assault_rifle\\reload.wav");
    }

    AssaultRifle(int l, Character c, int aC, int aT) {
        this(l, c);
        ammoCurrent = aC;
        ammoTotal = aT;
    }

    //Draw weapon | SEPARATE from update, intended to be used inside matrix.
    void draw() {
        projectileOrigin = new PVector((100 * cos(rotation) + pos.x) + campaign.level.referenceX, (100 * sin(rotation) + pos.y) - campaign.level.referenceY);
        levelPos = new PVector(pos.x + campaign.level.referenceX, pos.y - campaign.level.referenceY);
        image(sprite, -5, -5);
        if (parent == campaign.level.playerCharacter) {
            if (dist(projectileOrigin.x, projectileOrigin.y, mouseX + campaign.level.referenceX, mouseY - campaign.level.referenceY) > 200) { 
                parent.rotation = atan2((mouseY - campaign.level.referenceY) - projectileOrigin.y, (mouseX + campaign.level.referenceX) - projectileOrigin.x);
            } else {
                parent.rotation = atan2(mouseY - pos.y, mouseX - pos.x);
            }
        }
    }
    void update() {
        ownedProjectiles.forEach((p) -> {
            if (p.exists) p.update();
        });
        lastShot++;
    }
    void fire() {
        if (ammoCurrent > 0) {
            if (lastShot >= (60 * frameRate)/rof) {
                sfx_fire.get(int(random(0, sfx_fire.size()))).play();
                Projectile proj = new AssaultRifleRound(projectileOrigin, rotation + random(-inaccuracy, inaccuracy), scaleX, scaleY, layer, parent);
                ownedProjectiles.add(proj);
                lastShot = 0;
                ammoCurrent--;
            }
        } else {
            //Play appropriate sounds *only* if character is player.
            if (parent == campaign.level.playerCharacter) {
                //Only play if it's not currently playing so we don't spam the sound.
                if(!sfx_dry.file.isPlaying() && !parent.reloading) sfx_dry.play();
            }
        }
    }
}

class AssaultRifleRound extends Projectile {
    AssaultRifleRound(PVector position, float rot, float sX, float sY, int l, Character p) {
        levelPos = position;
        origin = position;
        rotation = rot;
        scaleX = sX;
        scaleY = sY;
        layer = l;

        damageUpper = 5;
        damageLower = 10;
        maxRange = int(2000*(scaleX+scaleY));
        velocity = 3000;
        sprite = loadImage("data\\img\\proj\\regular\\assaultrifle.png");
        parent = p;
    }

    void hit() {
        String[] particleArray = {
            "data\\img\\proj\\space\\unsc-explosion-1.png",
            "data\\img\\proj\\space\\unsc-explosion-2.png",
            "data\\img\\proj\\space\\unsc-explosion-3.png"
        };

        loadedPFX.add(new ParticleEffect(levelPos.x, levelPos.y, 15, 0.25, new String[]{particleArray[int(random(particleArray.length))]}));
    }
}

class MagnumPistol extends Weapon {
    MagnumPistol(int l, Character c) {
        rof = 120;
        lastShot = int(rof*frameRate*60);
        inaccuracy = 0.005;
        layer = l;
        sprite = loadImage("data\\img\\weap\\MagnumPistol\\magnum.png");
        ammoCurrent = 12;
        ammoCurrentMaximum = 12;
        ammoTotal = 120;
        ammoTotalMaximum = 120;
        parent = c;

        crosshair = loadImage("data\\img\\weap\\MagnumPistol\\crosshair.png");
        crosshair.resize(32,32);

        //1.25 seconds to reload
        timeToReload = 75;

        sfx_fire.add(new SoundEffect("data\\sound\\weap\\magnum\\fire.wav"));
        sfx_dry = new SoundEffect("data\\sound\\weap\\magnum\\dryfire.wav");
        sfx_ready = new SoundEffect("data\\sound\\weap\\magnum\\ready.wav");
        sfx_reload = new SoundEffect("data\\sound\\weap\\magnum\\reload.wav");
    }

    MagnumPistol(int l, Character c, int aC, int aT) {
        this(l, c);
        ammoCurrent = aC;
        ammoTotal = aT;
    }

    //Draw weapon | SEPARATE from update, intended to be used inside matrix.
    void draw() {
        projectileOrigin = new PVector((25 * cos(rotation) + pos.x) + campaign.level.referenceX, (25 * sin(rotation) + pos.y) - campaign.level.referenceY);
        levelPos = new PVector(pos.x + campaign.level.referenceX, pos.y - campaign.level.referenceY);
        pushMatrix();
        rotate(radians(90));
        image(sprite, 40, -25);
        popMatrix();
        if (parent == campaign.level.playerCharacter) {
            if (dist(projectileOrigin.x, projectileOrigin.y, mouseX + campaign.level.referenceX, mouseY - campaign.level.referenceY) > 300) { 
                parent.rotation = atan2((mouseY - campaign.level.referenceY) - projectileOrigin.y, (mouseX + campaign.level.referenceX) - projectileOrigin.x);
            } else {
                parent.rotation = atan2(mouseY - pos.y, mouseX - pos.x);
            }
        }
    }
    void update() {
        ownedProjectiles.forEach((p) -> {
            if (p.exists) p.update();
        });
        lastShot++;
    }
    void fire() {
        if (ammoCurrent > 0) {
            if (lastShot >= (60 * frameRate)/rof) {
                sfx_fire.get(int(random(0, sfx_fire.size()))).play();
                Projectile proj = new MagnumPistolRound(projectileOrigin, rotation + random(-inaccuracy, inaccuracy), scaleX, scaleY, layer, parent);
                ownedProjectiles.add(proj);
                lastShot = 0;
                ammoCurrent--;
            }
        } else {
            //Play appropriate sounds *only* if character is player.
            if (parent == campaign.level.playerCharacter) {
                //Only play if it's not currently playing so we don't spam the sound.
                if(!sfx_dry.file.isPlaying() && !parent.reloading) sfx_dry.play();
            }
        }
    }
}

class MagnumPistolRound extends Projectile {
    MagnumPistolRound(PVector position, float rot, float sX, float sY, int l, Character p) {
        levelPos = position;
        origin = position;
        rotation = rot;
        scaleX = sX;
        scaleY = sY;
        layer = l;

        damageUpper = 10;
        damageLower = 25;
        maxRange = int(2000*(scaleX+scaleY));
        velocity = 3000;
        sprite = loadImage("data\\img\\proj\\regular\\assaultrifle.png");
        parent = p;
    }

    void hit() {
        String[] particleArray = {
            "data\\img\\proj\\space\\unsc-explosion-1.png",
            "data\\img\\proj\\space\\unsc-explosion-2.png",
            "data\\img\\proj\\space\\unsc-explosion-3.png"
        };

        loadedPFX.add(new ParticleEffect(levelPos.x, levelPos.y, 15, 0.25, new String[]{particleArray[int(random(particleArray.length))]}));
    }
}