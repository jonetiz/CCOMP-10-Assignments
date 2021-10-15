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
- Campaign GameState
-
*/

class Campaign implements GameState {
    boolean paused = false;

    MenuWrapper pauseMenuWrapper = new MenuWrapper();

    PauseMenu pauseMenu = new PauseMenu(pauseMenuWrapper);
    SettingsMenu settingsMenu = new SettingsMenu(pauseMenuWrapper, pauseMenu);

    PImage pauseBufferBackground = createImage(width, height, ARGB);
    Level level;

    Campaign () {
        pauseMenuWrapper.setMenu(pauseMenu);
        level = new TestLevel();
    }
    void pause() {
        loadPixels();
        pauseBufferBackground.loadPixels();
        arrayCopy(pixels, pauseBufferBackground.pixels);
        pauseBufferBackground.updatePixels();

        paused = !paused;
    }
    void update() {
        if (!paused) {
            level.update();
        } else {
            background(pauseBufferBackground);
            pauseMenuWrapper.update();
        }
    }
}