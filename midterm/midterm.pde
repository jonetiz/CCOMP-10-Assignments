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
Config userConfig;

//GameStates; whatever is currently set as the variable gameState will be displayed, any other objects GameState will be kept in memory until deconstructed.
GameState gameState;
MainMenu mainMenu;
Campaign campaign;

//Currently loaded characters, used for targeting/aggro iteration.
ArrayList<Character> loadedCharacters = new ArrayList<Character>();
ArrayList<ParticleEffect> loadedPFX = new ArrayList<ParticleEffect>();

//Menu sounds
SoundEffect menuBeep;
SoundEffect menuError;
SoundEffect menuHover;
SoundEffect menuSelect1;
SoundEffect menuSelect2;
SoundEffect menuSelect3;

interface GameState {
    void pause();
    void update();
}

void setup() {
    //Fullscreen things
    fullScreen(P2D);
    //size(1280,720);
    //Set window title
    surface.setTitle("Halo: Siege of Arcadia");
    
    //Initialize configs and gamestates
    userConfig = new Config();
    mainMenu = new MainMenu();
    campaign = new Campaign();
    gameState = campaign;
    
    //Initialize global resources
    menuFont1 = createFont("data\\fonts\\HandelGothicRegular.ttf", 48);
    menuFont2 = createFont("data\\fonts\\HighwayGothicWide.ttf", 36);
    standardFont = createFont("data\\fonts\\HighwayGothic.ttf", 24);
    
    //SFX
    menuBeep = new SoundEffect("data\\sound\\menu\\beep.wav");
    menuError = new SoundEffect("data\\sound\\menu\\error.wav");
    menuHover = new SoundEffect("data\\sound\\menu\\hover.wav");
    menuSelect1 = new SoundEffect("data\\sound\\menu\\select1.wav");
    menuSelect2 = new SoundEffect("data\\sound\\menu\\select2.wav");
    menuSelect3 = new SoundEffect("data\\sound\\menu\\select3.wav");

    menuCursor = loadImage("data\\img\\menu-cursor.png");
    menuCursorPressed = loadImage("data\\img\\menu-cursor-pressed.png");
    menuCursor.resize(24,24);
    menuCursorPressed.resize(24,24);
    
    //Consciously setting currentCursor to a *reference* of menuCursor, as it will allow us to "hotswap" the currentCursor in runtime
    currentCursor = menuCursor;
}

void draw() {
    //Draw will be handled inside each individual gamestate
    gameState.update();
    noCursor();
    imageMode(CENTER);
    image(currentCursor, mouseX+4, mouseY+8);
}

void keyPressed() {
    //Override escape key to disable exiting game when pressed. Will be used for back in menus/exiting menus.
    if (key == ESC) {
        key = 0;
        gameState.pause();
    }
}