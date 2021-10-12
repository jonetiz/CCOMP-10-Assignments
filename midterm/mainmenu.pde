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

    ShipHalcyon shipUnsc1 = new ShipHalcyon(1500, 200, 1.0, 1.0, 180, 1);
    ShipHalcyon shipUnsc2 = new ShipHalcyon(1800, 300, 0.8, 0.8, 180, 2);
    CovenantSupercarrier covieShip = new CovenantSupercarrier(0, 400, 1.0, 1.0, 0, 1);

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