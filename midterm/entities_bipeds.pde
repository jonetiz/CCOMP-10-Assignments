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
        //Arm for rifles (player only, otherwise it's just for their regular arm)
        sprites.put("Arm1", ss.get(arm1.coords()[0], arm1.coords()[1], arm1.coords()[2], arm1.coords()[3]));
        //Arm for pistols (player only)
        sprites.put("Arm2", ss.get(arm2.coords()[0], arm2.coords()[1], arm2.coords()[2], arm2.coords()[3]));
        sprites.put("Run1", ss.get(run1.coords()[0], run1.coords()[1], run1.coords()[2], run1.coords()[3]));
        sprites.put("Run2", ss.get(run2.coords()[0], run2.coords()[1], run2.coords()[2], run2.coords()[3]));
        sprites.put("Run3", ss.get(run3.coords()[0], run3.coords()[1], run3.coords()[2], run3.coords()[3]));
    }
}

class Biped extends Character {
    BipedSprites sprites;
    //Whether or not character is running.
    boolean running = false;
    //Used as a kind of 'framecounter' for the running animation.
    int runPhase = 0;
    
    boolean jumping = false;

    //Vector used for acceleration (m/s/s)
    PVector acceleration = new PVector(0, 0);

    //Update gravity stuff or osmething
    void updateAccel() {
        //Friction
        if (abs(this.acceleration.x) >= 5 && !running) {
            if (this.acceleration.x >= 5) {
                this.acceleration.x -= campaign.level.floor.frictionCoefficient;
            } else if (this.acceleration.x <= -5) {
                this.acceleration.x += campaign.level.floor.frictionCoefficient;
            } else {
                this.acceleration.x = 0;
            }
        }

        if (this.levelPos.x <= 100 && this.acceleration.x < 0) {
            this.acceleration.x = 0;
        }

        this.levelPos.y = this.levelPos.y - (acceleration.y * 10) / frameRate;
        this.levelPos.x = this.levelPos.x + (acceleration.x * 10) / frameRate;
        
        //Check collision (don't run inside of boxes)
        for (WorldObject obj : campaign.level.levelObjects) {
            //Make sure the object is being drawn
            if (obj.levelPos.x + obj.w > campaign.level.referenceX - 100 && obj.levelPos.x < width + campaign.level.referenceX + 100) {
                if(this.levelPos.x + this.w >= obj.levelPos.x && this.levelPos.x <= obj.levelPos.x + obj.w && this.levelPos.y + this.h >= obj.levelPos.y && this.levelPos.y <= obj.levelPos.y + obj.h) {
                    if (this.levelPos.x + this.w < obj.levelPos.x + obj.w/2) {
                        this.levelPos.x = obj.levelPos.x - this.w;
                    } else if (this.levelPos.x >= obj.levelPos.x + obj.w/2) {
                        this.levelPos.x = obj.levelPos.x + obj.w;
                    }
                } 
            }
        }

        //If biped is in the air
        if (this.levelPos.y + this.h < campaign.level.floor.floorArray[int(this.levelPos.x)]) {
            acceleration.y -= campaign.level.gravityCoefficient;
            jumping = true;
        } else {
            jumping = false;
            acceleration.y = 0;
            levelPos.y = campaign.level.floor.floorArray[int(this.levelPos.x)] - this.h;
        }
    }

    //Linear movement left or right.
    void move(float mag) {
        //Invisible wall 100 px from left level boundary (things get weird if player goes past here)
        if (levelPos.x < 100 && mag < 0) {
            return;
        }
        running = true;
        //Only add movement speed if we're within bounds of max speed.
        if (abs(this.acceleration.x) < movementSpeed) {
            acceleration.x += mag;
            if (acceleration.x > movementSpeed) acceleration.x = movementSpeed;
            if (acceleration.x < -movementSpeed) acceleration.x = -movementSpeed;
        }
        if (runPhase > 28) {
            runPhase = 0;
        } else if (runPhase < 0) {
            runPhase = 28;
        }
        if (mag > 0) runPhase++;
        if (mag < 0) runPhase--;
    }
}

class Player extends Biped {
    //Similar to reloading, will be used for switching weapons instead.
    boolean switchingWeapons = false;
    int switchWeaponTimer = 0;

    Player(float xpos, float ypos) {
        pos.set(xpos, ypos);
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
        weaponPrimary = new AssaultRifle(0, this);
        weaponSecondary = new MagnumPistol(0, this);
        
        sprites = new BipedSprites(
            1,
            new BipedSpriteLocation(1976, 564, 52, 48),
            new BipedSpriteLocation(596, 676, 95, 156),
            new BipedSpriteLocation(716, 1600, 80, 56),
            new BipedSpriteLocation(172, 1812, 32, 88),
            new BipedSpriteLocation(672, 872, 100, 156),
            new BipedSpriteLocation(544, 872, 84, 156),
            new BipedSpriteLocation(912, 872, 68, 156)
        );
    }
    void update() {
        updateAccel();
        weaponPrimary.parent = this;
        weaponSecondary.parent = this;
        if (alive) {
            currentCursor = weaponPrimary.crosshair;
            pushMatrix();
            imageMode(CORNER);
            if(sin(rotation + radians(90)) <= 0) {
                translate(levelPos.x - campaign.level.referenceX + w, levelPos.y - campaign.level.referenceY);
                scale(-1.0, 1.0);
            } else {
                translate(levelPos.x - campaign.level.referenceX, levelPos.y - campaign.level.referenceY);
                scale (1.0, 1.0);
            }

            //Set screen position
            pos.set(screenX(0,0) - w/2, screenY(0,0) + h/2);

            //Select idle/running animation
            if (running == false) {
                runPhase = 0;
            }
            if (runPhase < 7) {
                image(sprites.sprites.get("Idle"), 0, h - sprites.sprites.get("Idle").height);
            } else if (runPhase >= 7 && runPhase < 14) {
                image(sprites.sprites.get("Run1"), -5, h - sprites.sprites.get("Run1").height);
            } else if (runPhase >= 14 && runPhase < 21) {
                image(sprites.sprites.get("Run2"), -10, h - sprites.sprites.get("Run2").height);
            } else if (runPhase >= 21) {
                image(sprites.sprites.get("Run3"), 15, h - sprites.sprites.get("Run3").height);
            }
            //Head transformations
            pushMatrix();
            translate(23 + sprites.sprites.get("Head").width/2, -2 + sprites.sprites.get("Head").height/2);
            if(sin(rotation + radians(90)) <= 0) {
                rotate(-rotation - PI);
            } else {
                rotate(rotation);
            }
            image(sprites.sprites.get("Head"), -sprites.sprites.get("Head").width/2, -sprites.sprites.get("Head").height/2);
            popMatrix();

            //Arm Transformations
            pushMatrix();
            if (weaponPrimary instanceof MagnumPistol) {
                //If weapon isn't a pistol
                translate(15 + sprites.sprites.get("Arm2").width/2, 35 + sprites.sprites.get("Arm2").height/4);
                if(reloading) {
                    //Put gun 45 degrees down when reloading because yes
                    rotate(radians(-45));
                } else if(switchingWeapons) {
                    //Switch weapon anim
                    rotate(0);
                } else {
                    if(sin(rotation + radians(90)) <= 0) {
                        rotate(-rotation - PI + radians(-90));
                    } else {
                        rotate(rotation + radians(-90));
                    }
                }

                //Draw weapon before arm since arm is "over" the weapon
                weaponPrimary.pos = new PVector(screenX(15,35), screenY(15,35));
                weaponPrimary.draw();

                image(sprites.sprites.get("Arm2"), -sprites.sprites.get("Arm2").width/2, -sprites.sprites.get("Arm2").height/4);
            } else {
                //If weapon isn't a pistol
                translate(3 + sprites.sprites.get("Arm1").width/3, 37 + sprites.sprites.get("Arm1").height/3);
                if(reloading) {
                    //Put gun 45 degrees down when reloading because yes
                    rotate(radians(45));
                } else if(switchingWeapons) {
                    //Switch weapon anim
                    if(sin(rotation + radians(90)) <= 0) {
                        rotate(-radians(90) - PI);
                    } else {
                        rotate(radians(90));
                    }
                } else {
                    if(sin(rotation + radians(90)) <= 0) {
                        rotate(-rotation - PI);
                    } else {
                        rotate(rotation);
                    }
                }

                //Draw weapon before arm since arm is "over" the weapon
                weaponPrimary.pos = new PVector(screenX(0,10), screenY(0,10));
                weaponPrimary.draw();

                image(sprites.sprites.get("Arm1"), -sprites.sprites.get("Arm1").width/3, -sprites.sprites.get("Arm1").height/3);
            }
            popMatrix();
            popMatrix();

            weaponPrimary.rotation = rotation;
            weaponPrimary.scaleX = scaleX;
            weaponPrimary.scaleY = scaleY;

            weaponPrimary.update();

            if (mousePressed && mouseButton == LEFT && !reloading && !switchingWeapons) {
                weaponPrimary.fire();
            }

            if (moveRight && !jumping) {
                move(movementSpeed);
            }
            if (moveLeft && !jumping) {
                move(-movementSpeed);
            }

            //If player is pressing left and right, just don't move, also if they're not pressing either make sure running gets set to false.
            if (moveLeft && moveRight) {
                running = false;
            }
            if (!moveLeft && !moveRight) {
                running = false;
            }

            if (jump && !jumping) {
                acceleration.y = 175;
            }

            if (reload == true && !reloading && !switchingWeapons && weaponPrimary.ammoTotal > 0 && weaponPrimary.ammoCurrent < weaponPrimary.ammoCurrentMaximum) {
                weaponPrimary.sfx_reload.play();
                reloading = true;
            }
            if (switchWeapon == true && !reloading && !switchingWeapons) {
                switchingWeapons = true;
            }

            //1 seconds switch weapon "timer"/animation stuff
            if (switchingWeapons) {
                switchWeaponTimer++;
                //half-way thru animation, switch the weapons out
                if(switchWeaponTimer == 30) {
                    Weapon temp = weaponPrimary;
                    weaponPrimary = weaponSecondary;
                    weaponSecondary = temp;
                }
                //When we're done  switching
                if (switchWeaponTimer == 60) {
                    switchingWeapons = false;
                    switchWeaponTimer = 0;
                    weaponPrimary.sfx_ready.play();
                }
            }

            if (reloading) {
                reloadTime++;
                if (reloadTime >= weaponPrimary.timeToReload) {
                    weaponPrimary.reload();
                    weaponPrimary.sfx_ready.play();
                    reloading = false;
                    reloadTime = 0;
                }
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

class EvilPlayer extends Player {

    EvilPlayer(float xpos, float ypos) {
        super(xpos, ypos);
        side = 2;
        fov = 360;
        fovDistance = 3000;
        rotationSpeed = 180;
    }
    void update() {
        updateAccel();
        weaponPrimary.parent = this;
        weaponSecondary.parent = this;
        if (alive) {
            pushMatrix();
            imageMode(CORNER);
            if(sin(rotation + radians(90)) <= 0) {
                translate(levelPos.x - campaign.level.referenceX + w, levelPos.y - campaign.level.referenceY);
                scale(-1.0, 1.0);
            } else {
                translate(levelPos.x - campaign.level.referenceX, levelPos.y - campaign.level.referenceY);
                scale (1.0, 1.0);
            }

            //Set screen position
            pos.set(screenX(0,0) - w/2, screenY(0,0) + h/2);

            //Select idle/running animation
            if (running == false) {
                runPhase = 0;
            }
            if (runPhase < 7) {
                image(sprites.sprites.get("Idle"), 0, h - sprites.sprites.get("Idle").height);
            } else if (runPhase >= 7 && runPhase < 14) {
                image(sprites.sprites.get("Run1"), -5, h - sprites.sprites.get("Run1").height);
            } else if (runPhase >= 14 && runPhase < 21) {
                image(sprites.sprites.get("Run2"), -10, h - sprites.sprites.get("Run2").height);
            } else if (runPhase >= 21) {
                image(sprites.sprites.get("Run3"), 15, h - sprites.sprites.get("Run3").height);
            }
            //Head transformations
            pushMatrix();
            translate(23 + sprites.sprites.get("Head").width/2, -2 + sprites.sprites.get("Head").height/2);
            if(sin(rotation + radians(90)) <= 0) {
                rotate(-rotation - PI);
            } else {
                rotate(rotation);
            }
            image(sprites.sprites.get("Head"), -sprites.sprites.get("Head").width/2, -sprites.sprites.get("Head").height/2);
            popMatrix();

            //Arm Transformations
            pushMatrix();
            if (weaponPrimary instanceof MagnumPistol) {
                //If weapon isn't a pistol
                translate(15 + sprites.sprites.get("Arm2").width/2, 35 + sprites.sprites.get("Arm2").height/4);
                if(reloading) {
                    //Put gun 45 degrees down when reloading because yes
                    rotate(radians(-45));
                } else if(switchingWeapons) {
                    //Switch weapon anim
                    rotate(0);
                } else {
                    if(sin(rotation + radians(90)) <= 0) {
                        rotate(-rotation - PI + radians(-90));
                    } else {
                        rotate(rotation + radians(-90));
                    }
                }

                //Draw weapon before arm since arm is "over" the weapon
                weaponPrimary.pos = new PVector(screenX(15,35), screenY(15,35));
                weaponPrimary.draw();

                image(sprites.sprites.get("Arm2"), -sprites.sprites.get("Arm2").width/2, -sprites.sprites.get("Arm2").height/4);
            } else {
                //If weapon isn't a pistol
                translate(3 + sprites.sprites.get("Arm1").width/3, 37 + sprites.sprites.get("Arm1").height/3);
                if(reloading) {
                    //Put gun 45 degrees down when reloading because yes
                    rotate(radians(45));
                } else if(switchingWeapons) {
                    //Switch weapon anim
                    if(sin(rotation + radians(90)) <= 0) {
                        rotate(-radians(90) - PI);
                    } else {
                        rotate(radians(90));
                    }
                } else {
                    if(sin(rotation + radians(90)) <= 0) {
                        rotate(-rotation - PI);
                    } else {
                        rotate(rotation);
                    }
                }

                //Draw weapon before arm since arm is "over" the weapon
                weaponPrimary.pos = new PVector(screenX(0,10), screenY(0,10));
                weaponPrimary.draw();

                image(sprites.sprites.get("Arm1"), -sprites.sprites.get("Arm1").width/3, -sprites.sprites.get("Arm1").height/3);
            }
            popMatrix();
            popMatrix();

            weaponPrimary.rotation = rotation;
            weaponPrimary.scaleX = scaleX;
            weaponPrimary.scaleY = scaleY;

            weaponPrimary.update();

            if (!reloading && !switchingWeapons && weaponPrimary.ammoTotal > 0 && weaponPrimary.ammoCurrent <= 0) {
                reloading = true;
            }
            if (!reloading && !switchingWeapons && weaponPrimary.ammoTotal <= 0 && weaponPrimary.ammoCurrent <= 0) {
                switchingWeapons = true;
            }

            //1 seconds switch weapon "timer"/animation stuff
            if (switchingWeapons) {
                switchWeaponTimer++;
                //half-way thru animation, switch the weapons out
                if(switchWeaponTimer == 30) {
                    Weapon temp = weaponPrimary;
                    weaponPrimary = weaponSecondary;
                    weaponSecondary = temp;
                }
                //When we're done  switching
                if (switchWeaponTimer == 60) {
                    switchingWeapons = false;
                    switchWeaponTimer = 0;
                }
            }

            if (reloading) {
                reloadTime++;
                if (reloadTime >= weaponPrimary.timeToReload) {
                    weaponPrimary.reload();
                    reloading = false;
                    reloadTime = 0;
                }
            }
        }
        spotting();
    }
}