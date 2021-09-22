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
PImage menuLogo;

class Menu {
    String title;
    ArrayList<MenuButton> buttons;
    int ox, oy;

    void update() {}
}

class MenuWrapper {
    Menu currentMenu;
    MenuWrapper(Menu cm) {
        currentMenu = cm;
    }
    void update() {
        currentMenu.update();
    }
}

//Main menu menu
class MenuMain extends Menu {
    MenuMain() {
        title = "Main Menu";
        buttons = new ArrayList<MenuButton>();
        menuLogo = loadImage("img\\menu-temp.png");
        menuLogo.resize(512,128);
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
        buttons.forEach((b) -> {
            b.update();
        });
    }
}

//Large menu
class MenuLarge extends Menu {
    MenuLarge(String t) {
        title = t;
        buttons = new ArrayList<MenuButton>();
    }
    MenuLarge(String t, int ox, int oy) {
        title = t;
        buttons = new ArrayList<MenuButton>();
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
        fill(color(#051f43,0));
        vertex(width + 4, height - 200);
        vertex(-4, height - 200);
        endShape();
        buttons.forEach((b) -> {
            b.update();
        });
        specialCase();
    }
    void specialCase() {
        println("Invalid MenuLarge detected.");
    }
}

class SettingsMenu extends MenuLarge {
    SettingsMenu() {
        super("Settings");
    }
    void specialCase() {
        if (key == CODED) {
            if (keyCode == ESC) {
               mainMenu.mainMenuWrapper = new MenuWrapper(mainMenu.mainMenuMenu);
            }
        }
    }
}

class MenuButton {
    int x, y, w, h;
    //Order for a structured/autopos menu
    int order;
    //Background true/false
    boolean background;
    String text;

    private boolean mouseover;
    private int mouseovercount;
    private int mouseclickcount;

    MenuButton(Menu parent, int xbase, int ybase, int wid, int hei, String t, boolean bg) {
        parent.buttons.add(this);
        x = xbase;
        y = ybase;
        w = wid;
        h = hei;
        text = t;
        background = bg;
    }
    MenuButton(Menu parent, int o, int wid, int hei, String t, boolean bg) {
        parent.buttons.add(this);
        order = o;
        w = wid;
        h = hei;
        text = t;
        background = bg;

        //Since we're going off ordering, we're going to automatically set position based on parent menu.
        x = parent.ox;
        y = parent.oy * o;
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
                pressed();
            }
            mouseclickcount++;
        } else {
            mouseclickcount = 0;
        }
        textSize(32);
        text(text.toUpperCase(), x, y + 10);
    }
    void pressed() {
        println("Button pressed without action assignment");
    };
}

class SettingsButton extends MenuButton {
    SettingsButton(Menu parent, int xbase, int ybase, int wid, int hei, String t, boolean bg) {
        super(parent, xbase, ybase, wid, hei, t, bg);
    }
    SettingsButton(Menu parent, int o, int wid, int hei, String t, boolean bg) {
        super(parent, o, wid, hei, t, bg);
    }
    void pressed() {
        mainMenu.mainMenuWrapper = new MenuWrapper(mainMenu.settingsMenu);
    }
}

class ExitButton extends MenuButton {
    ExitButton(Menu parent, int xbase, int ybase, int wid, int hei, String t, boolean bg) {
        super(parent, xbase, ybase, wid, hei, t, bg);
    }
    ExitButton(Menu parent, int o, int wid, int hei, String t, boolean bg) {
        super(parent, o, wid, hei, t, bg);
    }
    void pressed() {
        exit();
    }
}