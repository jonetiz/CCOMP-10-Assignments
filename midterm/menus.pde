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
- Menu Classes
- *Not to be confused with MainMenu class, which is used according to gameState. These classes are used for the actual interactable menus.
-
*/

PFont menuFont1;
PFont menuFont2;
PFont standardFont;
PImage menuLogo;

PImage menuCursor;
PImage menuCursorPressed;
PImage currentCursor;

interface ButtonCallback {
    void call();
}

class Menu {
    String title;
    ArrayList<MenuElement> elements;
    int ox, oy;

    void update() {}
}

class MenuWrapper {
    Menu currentMenu;
    MenuWrapper() { }
    MenuWrapper(Menu cm) {
        currentMenu = cm;
    }
    void update() {
        currentMenu.update();

        //Set cursor to default when in a menu
        if (mousePressed) {
            noTint();
            currentCursor = menuCursorPressed;
        } else {
            noTint();
            currentCursor = menuCursor;
        }
    }
    void setMenu(Menu set) {
        currentMenu = set;
    }
}

//Main menu menu
class MenuMain extends Menu {
    MenuWrapper menuWrapper;

    MenuButton campaignButton = new MenuButton(width/2, height/2, 300, 50, "Campaign", false,
        new ButtonCallback() {
            void call() { menuWrapper.setMenu(mainMenu.campaignMenu); }
        }
    );
    MenuButton endureButton = new MenuButton(width/2, height/2 + 75, 300, 50, "Endure", false,
        new ButtonCallback() {
            void call() { println("asdf"); }
        }
    );
    MenuButton multiplayerButton = new MenuButton(width/2, height/2 + 150, 300, 50, "Multiplayer", false,
        new ButtonCallback() {
            void call() { println("asdf"); }
        }
    );
    MenuButton settingsButton = new MenuButton(width/2, height/2 + 225, 300, 50, "Settings", false,
        new ButtonCallback() {
            void call() { menuWrapper.setMenu(mainMenu.settingsMenu); }
        }
    );
    MenuButton exitButton = new MenuButton(width/2, height/2 + 300, 300, 50, "Exit", false,
        new ButtonCallback() {
            void call() { exit(); }
        }
    );

    MenuMain(MenuWrapper mw) {
        title = "Main Menu";
        menuLogo = loadImage("data\\img\\menu-temp.png");
        menuLogo.resize(512,128);
        menuWrapper = mw;
    }
    void update() {
        imageMode(CENTER);
        image(menuLogo,width/2,height*0.3);
        strokeWeight(4);
        stroke(#2399ff);
        line(width/2-width/6, height*0.4, width/2+width/6, height*0.4);
        fill(#2399ff);
        textAlign(CENTER);
        textFont(menuFont1);
        text(title.toUpperCase(), width/2, height*0.4 + 50);
        
        campaignButton.update();
        endureButton.update();
        multiplayerButton.update();
        settingsButton.update();
        exitButton.update();
    }
}

//Pause menu (small)
class PauseMenu extends Menu {
    MenuWrapper menuWrapper;

    MenuButton continueButton = new MenuButton(width/2, height/2 - 100, 250, 50, "Continue", true,
        new ButtonCallback() {
            void call() { campaign.paused = false; }
        }
    );
    MenuButton restartButton = new MenuButton(width/2, height/2 - 25, 250, 50, "Restart", true,
        new ButtonCallback() {
            //TODO: Add restart case when restart mission becomes a thing
            void call() {  }
        }
    );
    MenuButton settingsButton = new MenuButton(width/2, height/2 + 50, 250, 50, "Settings", true,
        new ButtonCallback() {
            void call() { menuWrapper.setMenu(campaign.settingsMenu); }
        }
    );
    MenuButton exitMainMenuButton = new MenuButton(width/2, height/2 + 125, 250, 50, "Main Menu", true,
        new ButtonCallback() {
            void call() { gameState = mainMenu; }
        }
    );
    MenuButton exitWindowsButton = new MenuButton(width/2, height/2 + 200, 250, 50, "Windows", true,
        new ButtonCallback() {
            void call() { exit(); }
        }
    );

    PauseMenu(MenuWrapper mw) {
        menuWrapper = mw;
    }
    void update() {
        rectMode(CENTER);
        stroke(#2399ff);
        fill(#051f43, 80);
        strokeWeight(4);
        rect(width/2, height/2, 300, 500, 20);
        fill(#ffffff);
        textFont(menuFont1);
        textAlign(CENTER);
        textSize(28);
        text("GAME PAUSED", width/2, height/2 - 200);
        strokeWeight(4);
        stroke(#2399ff);
        line(width/2-width/14, height/2 - 180, width/2+width/14, height/2 - 180);
        
        continueButton.update();
        restartButton.update();
        settingsButton.update();
        exitMainMenuButton.update();
        exitWindowsButton.update();
    }
}

//Large menu
class MenuLarge extends Menu {
    MenuLarge(String t) {
        title = t;
        elements = new ArrayList<MenuElement>();
    }
    MenuLarge(String t, int ox, int oy) {
        title = t;
        elements = new ArrayList<MenuElement>();
        ox = ox;
        oy = oy;
    }
    void update() {
        fill(#2399ff);
        textFont(menuFont1);
        textAlign(LEFT);
        text(title.toUpperCase(), 100, 190);
        strokeWeight(4);
        stroke(#1e608f, 200);
        beginShape();
        fill(color(#051f43,255));
        vertex(-4, 200);
        vertex(width + 4, 200);
        fill(color(#051f43,80));
        vertex(width + 4, height - 200);
        vertex(-4, height - 200);
        endShape();
        specialCase();
        elements.forEach((e) -> {
            e.update();
        });
    }
    void specialCase() {
        println("Invalid MenuLarge detected.");
    }
}

class MenuCampaign extends Menu {
    MenuWrapper menuWrapper;
    Menu exitMenu;

    MenuButton continueButton = new MenuButton(width/2, height/2, 300, 50, "Continue", false,
        new ButtonCallback() {
            void call() { println("asdf"); }
        }
    );
    MenuButton newGameButton = new MenuButton(width/2, height/2 + 75, 300, 50, "New Game", false,
        new ButtonCallback() {
            void call() { println("asdf"); }
        }
    );
    MenuButton loadGameButton = new MenuButton(width/2, height/2 + 150, 300, 50, "Load Game", false,
        new ButtonCallback() {
            void call() { println("asdf"); }
        }
    );
    MenuButton campaignBackButton = new MenuButton(width/2, height/2 + 225, 300, 50, "Back", false,
        new ButtonCallback() {
            void call() { menuWrapper.setMenu(exitMenu); }
        }
    );

    MenuCampaign(MenuWrapper mw, Menu exit) {
        title = "Campaign";
        menuLogo = loadImage("data\\img\\menu-temp.png");
        menuLogo.resize(512,128);
        menuWrapper = mw;
        exitMenu = exit;
    }
    void update() {
        if (key == ESC) {
            key = 0;
            menuWrapper.setMenu(exitMenu);
        }

        imageMode(CENTER);
        image(menuLogo,width/2,height*0.3);
        strokeWeight(4);
        stroke(#2399ff);
        line(width/2-width/6, height*0.4, width/2+width/6, height*0.4);
        fill(#2399ff);
        textAlign(CENTER);
        textFont(menuFont1);
        text(title.toUpperCase(), width/2, height*0.4 + 50);

        continueButton.update();
        newGameButton.update();
        loadGameButton.update();
        campaignBackButton.update();
    }
}

class SettingsMenu extends MenuLarge {
    MenuWrapper menuWrapper;
    Menu exitMenu;

    MenuSlider musicSlider = new MenuSlider(100, 300, 400, userConfig.musicVolume);
    MenuSlider ambientSlider = new MenuSlider(100, 450, 400, userConfig.ambientVolume);
    MenuSlider sfxSlider = new MenuSlider(100, 600, 400, userConfig.sfxVolume);
    MenuButton settingsBackButton = new MenuButton(width-200, height-150, 100, 50, "Back", true, new ButtonCallback() {
        void call() { menuWrapper.setMenu(exitMenu); }
    });

    SettingsMenu(MenuWrapper mw, Menu exit) {
        super("Settings");
        menuWrapper = mw;
        exitMenu = exit;
    }
    void specialCase() {
        if (key == ESC) {
            key = 0;
            menuWrapper.setMenu(exitMenu);
        }

        //Display setting stuff
        fill(#2399ff);
        textFont(menuFont2);
        textAlign(LEFT);
        text("MUSIC VOLUME", 100, 250);
        text("AMBIENCE VOLUME", 100, 400);
        text("SFX VOLUME", 100, 550);

        musicSlider.update();
        ambientSlider.update();
        sfxSlider.update();
        settingsBackButton.update();
    }
}

class MenuElement {
    int x, y, w, h;
    //Order for a structured/autopos menu; probably never gonna use, but just in case or something idno
    int order;

    boolean mouseover;
    int mouseovercount;
    int mouseclickcount;

    void update() {
        
    }
}

class MenuButton extends MenuElement {
    //Background true/false
    boolean background;
    String text;

    ButtonCallback callback;


    MenuButton(int xbase, int ybase, int wid, int hei, String t, boolean bg, ButtonCallback cb) {
        x = xbase;
        y = ybase;
        w = wid;
        h = hei;
        text = t;
        background = bg;
        callback = cb;
    }

    void update() {
        mouseover = (x - w/2 <= mouseX && mouseX <= x + w/2 && y - h/2 <= mouseY && mouseY <= y + h/2);
        if (background) {
            strokeWeight(2);
            if(mouseover) {
                stroke(255);
            } else {
                stroke(#1e608f, 200);
            }
            fill(#051f43, 200);
            rectMode(CORNER);
            rect(x-w/2, y-h/2, w, h, 5);
        }
        textAlign(CENTER);
        textFont(menuFont1);
        if (mouseover) {
            if (mouseovercount == 0) menuHover.play();
            mouseovercount++;
            fill(255);
        } else {
            mouseovercount = 0;
            fill(#2399ff);
        }
        if (mouseover && mousePressed) {
            if (mouseclickcount == 0) {
                menuSelect3.play();
                callback.call();
                //Make sure it doesn't press any buttons that "appear" under
                mousePressed = false;
            }
            mouseclickcount++;
        } else {
            mouseclickcount = 0;
        }
        textSize(32);
        text(text.toUpperCase(), x, y + 10);
    }
}

//Slider for settings
class MenuSlider extends MenuElement {
    //Position of slider
    float sliderPos;
    ConfigParameter param;
    
    MenuSlider(int xbase, int ybase, int wid, ConfigParameter p) {
        x = xbase;
        y = ybase;
        w = wid;
        sliderPos = (float)p.value;
        param = p;
    }

    void update() {
        float sliderX;
        mouseover = (x + 24 <= mouseX && mouseX <= x + w - 24 && y - 16 <= mouseY && mouseY <= y + 16);

        fill(#2399ff);
        stroke(#2399ff);
        line(x+20,y,x+w-20,y);
        noStroke();
        triangle(x,y,x+16,y-16,x+16,y+16);
        triangle(x+w,y,x+w-16,y-16,x+w-16,y+16);

        //Calculate slidey part of the slider's x-coordinate
        sliderX = (x+20) + (w-48) * sliderPos;
        if (mouseover) {
            if (mousePressed) {
                if (mouseclickcount == 0) menuHover.play();
                mouseclickcount++;
                sliderX = mouseX - 4;
                updateConfig(sliderX);
            } else { 
                mouseclickcount = 0;
            }
            fill(255);
        } else {
            fill(#2399ff);
        }
        
        rectMode(CORNER);
        rect(sliderX,y-16*(sliderPos+0.25),8,32*(sliderPos+0.25));
    }

    void updateConfig(float sliderX) {
        var newValue = (sliderX-(x+20))/(w-48);
        sliderPos = newValue;
        param.value = newValue;
        userConfig.update();
    }
}