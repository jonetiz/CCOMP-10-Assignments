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
- Main File
-
*/

//0 - main menu; 1 - survival mode; 2 - campaign; 3 - multiplayer
int gameState = 0;

Config userConfig;
MainMenu mainMenu;

//Menu sounds
Sound menuBeep;
Sound menuError;
Sound menuHover;
Sound menuSelect1;
Sound menuSelect2;
Sound menuSelect3;

void setup() {
    size(displayWidth, displayHeight, P2D);
    fullScreen();
    userConfig = new Config();
    mainMenu = new MainMenu();
    menuFont1 = createFont("fonts\\HandelGothicRegular.ttf", 48);

    menuBeep = new Sound("sound\\menu\\beep.wav");
    menuError = new Sound("sound\\menu\\error.wav");
    menuHover = new Sound("sound\\menu\\hover.wav");
    menuSelect1 = new Sound("sound\\menu\\select1.wav");
    menuSelect2 = new Sound("sound\\menu\\select2.wav");
    menuSelect3 = new Sound("sound\\menu\\select3.wav");
}

void draw() {
    switch (gameState) {
        case 0:
            mainMenu.update();
        break;
        default:
            gameState = 0;
        break;
    }
}