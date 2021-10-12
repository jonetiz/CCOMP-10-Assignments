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
    PImage planetArcadia;

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
    MusicPlaylist menuMusic = new MusicPlaylist(
        new Music("data\\sound\\music\\halowars.wav"),
        new Music("data\\sound\\music\\combatevolved.wav")
    );
    
    MenuMain mainMenuMenu = new MenuMain();
    MenuButton campaignButton = new MenuButton(mainMenuMenu, width/2, height/2, 300, 50, "Campaign", false,
        new ButtonCallback() {
            void call() { mainMenuWrapper = new MenuWrapper(campaignMenu); }
        }
    );
    MenuButton endureButton = new MenuButton(mainMenuMenu, width/2, height/2 + 75, 300, 50, "Endure", false,
        new ButtonCallback() {
            void call() { println("asdf"); }
        }
    );
    MenuButton multiplayerButton = new MenuButton(mainMenuMenu, width/2, height/2 + 150, 300, 50, "Multiplayer", false,
        new ButtonCallback() {
            void call() { println("asdf"); }
        }
    );
    MenuButton settingsButton = new MenuButton(mainMenuMenu, width/2, height/2 + 225, 300, 50, "Settings", false,
        new ButtonCallback() {
            void call() { mainMenuWrapper = new MenuWrapper(settingsMenu); }
        }
    );
    MenuButton exitButton = new MenuButton(mainMenuMenu, width/2, height/2 + 300, 300, 50, "Exit", false,
        new ButtonCallback() {
            void call() { exit(); }
        }
    );

    MenuCampaign campaignMenu = new MenuCampaign();
    MenuButton continueButton = new MenuButton(campaignMenu, width/2, height/2, 300, 50, "Continue", false,
        new ButtonCallback() {
            void call() { println("asdf"); }
        }
    );
    MenuButton newGameButton = new MenuButton(campaignMenu, width/2, height/2 + 75, 300, 50, "New Game", false,
        new ButtonCallback() {
            void call() { println("asdf"); }
        }
    );
    MenuButton loadGameButton = new MenuButton(campaignMenu, width/2, height/2 + 150, 300, 50, "Load Game", false,
        new ButtonCallback() {
            void call() { println("asdf"); }
        }
    );
    MenuButton campaignBackButton = new MenuButton(campaignMenu, width/2, height/2 + 225, 300, 50, "Back", false,
        new ButtonCallback() {
            void call() { mainMenuWrapper = new MenuWrapper(mainMenuMenu); }
        }
    );

    SettingsMenu settingsMenu = new SettingsMenu();
    MenuSlider musicSlider = new MenuSlider(settingsMenu, 100, 300, 400, userConfig.musicVolume);
    MenuSlider ambientSlider = new MenuSlider(settingsMenu, 100, 450, 400, userConfig.ambientVolume);
    MenuSlider sfxSlider = new MenuSlider(settingsMenu, 100, 600, 400, userConfig.sfxVolume);
    MenuButton settingsBackButton = new MenuButton(settingsMenu, width-200, height-150, 100, 50, "Back", true,
        new ButtonCallback() {
            void call() { mainMenuWrapper = new MenuWrapper(mainMenuMenu); }
        }
    );
    
    MenuWrapper mainMenuWrapper = new MenuWrapper(mainMenuMenu);

    MainMenu() {
        bg = new Background(color(0), "star", 0.1, 180, 2, 8);
        menuMusic.play();
    }
    void update() {
        menuMusic.changeVolume((float)userConfig.musicVolume.value);
        menuMusic.update();
        bg.update();

        loadedCharacters.forEach((c) -> {
            c.update();
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

        mainMenuWrapper.update();

        fill(#2399ff);
        textAlign(RIGHT);
        textFont(standardFont);
        text("A game by Jonathan Etiz", width-16,height-24);
    }
}