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
    Music menuMusic = new Music("sound\\mainmenu.wav");
    
    MenuMain mainMenuMenu = new MenuMain();
    MenuButton campaignButton = new MenuButton(mainMenuMenu, width/2, height/2, 300, 50, "Campaign", true);
    MenuButton endureButton = new MenuButton(mainMenuMenu, width/2, height/2 + 75, 300, 50, "Endure", true);
    MenuButton multiplayerButton = new MenuButton(mainMenuMenu, width/2, height/2 + 150, 300, 50, "Multiplayer", true);
    SettingsButton settingsButton = new SettingsButton(mainMenuMenu, width/2, height/2 + 225, 300, 50, "Settings", true);
    ExitButton exitButton = new ExitButton(mainMenuMenu, width/2, height/2 + 300, 300, 50, "Exit", true);

    SettingsMenu settingsMenu = new SettingsMenu();
    
    MenuWrapper mainMenuWrapper = new MenuWrapper(mainMenuMenu);

    MainMenu() {
        bg = new Background(color(0), "star", 1, 180, 2, 8);
        menuMusic.loop();
    }
    void update() {
        bg.update();
        mainMenuWrapper.update();
    }
}