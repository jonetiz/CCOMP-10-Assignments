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
- Main Menu
-
*/

class MainMenu implements GameState {
    //Spawn ships in random positions (Covies on left, UNSC on right side of screen.)
    ShipHalcyon shipUnsc1 = new ShipHalcyon(width-random(width/3), random(height), 1.0, 1.0, 180, 1);
    ShipCruiserUNSC shipUnsc2 = new ShipCruiserUNSC(width-random(width/3), random(height), 1.0, 1.0, 180, 1);
    ShipFrigateUNSC shipUnsc3 = new ShipFrigateUNSC(width-random(width/3), random(height), 1, 1, 180, 1);
    ShipFrigateUNSC shipUnsc4 = new ShipFrigateUNSC(width-random(width/3), random(height), 1, 1, 180, 1);
    ShipFrigateUNSC shipUnsc5 = new ShipFrigateUNSC(width-random(width/3), random(height), 1, 1, 180, 1);
    ShipDestroyerUNSC shipUnsc6 = new ShipDestroyerUNSC(width-random(width/3), random(height), 1, 1, 180, 1);
    ShipDestroyerUNSC shipUnsc7 = new ShipDestroyerUNSC(width-random(width/3), random(height), 1, 1, 180, 1);
    CovenantSupercarrier covieShip1 = new CovenantSupercarrier(random(width/3), random(height), 1.0, 1.0, 0, 1);
    CovenantCCS covieShip2 = new CovenantCCS(random(width/3), random(height), 1.0, 1.0, 0, 1);
    CovenantCCS covieShip3 = new CovenantCCS(random(width/3), random(height), 1.0, 1.0, 0, 1);
    CorvetteCovenant covieShip4 = new CorvetteCovenant(random(width/3), random(height), 1.0, 1.0, 0, 1);
    CorvetteCovenant covieShip5 = new CorvetteCovenant(random(width/3), random(height), 1.0, 1.0, 0, 1);
    CorvetteCovenant covieShip6 = new CorvetteCovenant(random(width/3), random(height), 1.0, 1.0, 0, 1);
    CorvetteCovenant covieShip7 = new CorvetteCovenant(random(width/3), random(height), 1.0, 1.0, 0, 1);
    CorvetteCovenant covieShip8 = new CorvetteCovenant(random(width/3), random(height), 1.0, 1.0, 0, 1);
    CorvetteCovenant covieShip9 = new CorvetteCovenant(random(width/3), random(height), 1.0, 1.0, 0, 1);

    Background bg;

    //Music playlist definition for Main Menu
    MusicPlaylist menuMusic = new MusicPlaylist(
        new Music("data\\sound\\music\\halowars.wav"),
        new Music("data\\sound\\music\\combatevolved.wav")
    );
    
    //Menu definitions
    MenuWrapper mainMenuWrapper = new MenuWrapper();
    
    MenuMain mainMenuMenu = new MenuMain(mainMenuWrapper);
    MenuCampaign campaignMenu = new MenuCampaign(mainMenuWrapper, mainMenuMenu);
    SettingsMenu settingsMenu = new SettingsMenu(mainMenuWrapper, mainMenuMenu);
    
    MainMenu() {
        bg = new Background(color(0), "star", 0.1, 180, 2, 8);
        mainMenuWrapper.setMenu(mainMenuMenu);
        mainMenuMenu.menuWrapper = mainMenuWrapper;
        campaignMenu.menuWrapper = mainMenuWrapper;
        settingsMenu.menuWrapper = mainMenuWrapper;
    }
    void pause() {}
    void init() {
        loadedCharacters.add(shipUnsc1);
        loadedCharacters.add(shipUnsc2);
        loadedCharacters.add(shipUnsc3);
        loadedCharacters.add(shipUnsc4);
        loadedCharacters.add(shipUnsc5);
        loadedCharacters.add(shipUnsc6);
        loadedCharacters.add(covieShip1);
        loadedCharacters.add(covieShip2);
        loadedCharacters.add(covieShip3);
        loadedCharacters.add(covieShip4);
        loadedCharacters.add(covieShip5);
        loadedCharacters.add(covieShip6);
        loadedCharacters.add(covieShip7);
        loadedCharacters.add(covieShip8);
    }
    void update() {
        menuMusic.changeVolume((float)userConfig.musicVolume.value);
        menuMusic.update();
        bg.update();

        loadedCharacters.forEach((c) -> {
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

            //Recycle characters so the scene goes on perpetually.
            if (c.alive != true) {
                c.braindead = true;
                switch (c.side) {
                    //UNSC Ships
                    case 1:
                        c.rotation = radians(180);
                        c.pos.set(width + 1000, random(height));
                    break;
                    //Covenant ships
                    case 2:
                        c.rotation = 0;
                        c.pos.set(-1000, random(height));
                    break;
                }
                c.curHP = c.maxHP;
                c.curShield = c.maxShield;
                c.alive = true;
            }
            if (c.braindead) {
                c.movementStatic(c.rotation, c.movementSpeed);
                if (c.pos.x > random(250,1250) && c.pos.x < width-random(250,1250)) {
                    c.braindead = false;
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

        mainMenuWrapper.update();

        fill(#2399ff);
        textAlign(RIGHT);
        textFont(standardFont);
        text("A game by Jonathan Etiz", width-16,height-24);
    }
}