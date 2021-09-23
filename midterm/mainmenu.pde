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

class MainMenu {
    Background bg;
    MusicPlaylist menuMusic = new MusicPlaylist(
        new Music("data\\sound\\music\\halowars.wav"),
        new Music("data\\sound\\music\\combatevolved.wav")
    );
    
    MenuMain mainMenuMenu = new MenuMain();
    MenuButton campaignButton = new MenuButton(mainMenuMenu, width/2, height/2, 300, 50, "Campaign", true);
    MenuButton endureButton = new MenuButton(mainMenuMenu, width/2, height/2 + 75, 300, 50, "Endure", true);
    MenuButton multiplayerButton = new MenuButton(mainMenuMenu, width/2, height/2 + 150, 300, 50, "Multiplayer", true);
    SettingsButton settingsButton = new SettingsButton(mainMenuMenu, width/2, height/2 + 225, 300, 50, "Settings", true);
    ExitButton exitButton = new ExitButton(mainMenuMenu, width/2, height/2 + 300, 300, 50, "Exit", true);

    SettingsMenu settingsMenu = new SettingsMenu();
    MenuSlider musicSlider = new MenuSlider(settingsMenu, 100, 300, 400, userConfig.musicVolume);
    MenuSlider ambientSlider = new MenuSlider(settingsMenu, 100, 450, 400, userConfig.ambientVolume);
    MenuSlider sfxSlider = new MenuSlider(settingsMenu, 100, 600, 400, userConfig.sfxVolume);
    
    MenuWrapper mainMenuWrapper = new MenuWrapper(mainMenuMenu);

    MainMenu() {
        bg = new Background(color(0), "star", 1, 180, 2, 8);
        menuMusic.play();
    }
    void update() {
        menuMusic.changeVolume((float)userConfig.musicVolume.value);
        menuMusic.update();
        bg.update();
        mainMenuWrapper.update();

        fill(#2399ff);
        textAlign(RIGHT);
        textFont(standardFont);
        text("A Game by Jonathan Etiz; Version 0.0.1", width-16,height-24);
    }
}