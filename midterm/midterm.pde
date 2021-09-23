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

//0 - main menu; 1 - campaign; 2 - endure; 3 - multiplayer
int gameState;

Config userConfig;
MainMenu mainMenu;

//Menu sounds
SoundEffect menuBeep;
SoundEffect menuError;
SoundEffect menuHover;
SoundEffect menuSelect1;
SoundEffect menuSelect2;
SoundEffect menuSelect3;

void setup() {
    fullScreen(P2D);
    surface.setTitle("Halo: Siege of Arcadia");
    
    gameState = 0;
    
    userConfig = new Config();
    mainMenu = new MainMenu();
    menuFont1 = createFont("data\\fonts\\HandelGothicRegular.ttf", 48);
    menuFont2 = createFont("data\\fonts\\HighwayGothicWide.ttf", 36);
    standardFont = createFont("data\\fonts\\HighwayGothic.ttf", 24);

    menuBeep = new SoundEffect("data\\sound\\menu\\beep.wav");
    menuError = new SoundEffect("data\\sound\\menu\\error.wav");
    menuHover = new SoundEffect("data\\sound\\menu\\hover.wav");
    menuSelect1 = new SoundEffect("data\\sound\\menu\\select1.wav");
    menuSelect2 = new SoundEffect("data\\sound\\menu\\select2.wav");
    menuSelect3 = new SoundEffect("data\\sound\\menu\\select3.wav");
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

void keyPressed() {
    if (key == ESC) {
        key = 0;
    }
}