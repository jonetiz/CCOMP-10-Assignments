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
- Sound Classes
-
*/

import processing.sound.*;

class Music {
    SoundFile file;
    String path;

    Music (String p) {
        path = sketchPath(p);
        file = new SoundFile(midterm.this, path);
        file.amp(userConfig.musicVolume);
    }

    void play() {
        file.play();
    }

    void stop() {
        file.stop();
    }

    void loop() {
        file.loop();
    }
}

class Sound {
    SoundFile file;
    String path;

    Sound (String p) {
        path = sketchPath(p);
        file = new SoundFile(midterm.this, path);
        file.amp(userConfig.sfxVolume);
    }

    void play() {
        file.play();
    }
}