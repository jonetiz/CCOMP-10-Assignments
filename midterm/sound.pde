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
import java.util.*;

/*
interface Sound {
    void play();
    void stop();
    void loop();
    void changeVolume();
} */

class Sound {
    SoundFile file;
    String path;
    ConfigParameter volumeParam;

    void play() {
        file.play();
        file.amp((float)volumeParam.value);
    }

    void stop() {
        file.stop();
    }

    void loop() {
        file.loop();
        file.amp((float)volumeParam.value);
    }

    void changeVolume(float newVolume) {
        file.amp(newVolume);
    }
}

class Music extends Sound {
    Music (String p) {
        path = sketchPath(p);
        file = new SoundFile(midterm.this, path);
        volumeParam = userConfig.musicVolume;
    }
}

class Ambience extends Music {
    Ambience (String p) {
        super(p);
        volumeParam = userConfig.ambientVolume;
    }
}

class SoundEffect extends Sound {
    SoundEffect (String p) {
        path = sketchPath(p);
        file = new SoundFile(midterm.this, path);
        volumeParam = userConfig.sfxVolume;
    }
}

//Playlists probably only used in main menu, but we'll see; Intended behavior is to indefinitely loop until stopped with stop() method.
class MusicPlaylist {
    ArrayList<Music> songs = new ArrayList<Music>();
    //Used for skipping/intended fading functionality.
    Music nextSong;
    Music currentSong;
    MusicPlaylist(Music... args) {
        for (Music song : args) {
            songs.add(song);
        }
        Random rand = new Random();
        currentSong = songs.get(rand.nextInt(songs.size()));
        nextSong = songs.get(rand.nextInt(songs.size()));
    }

    void update() {
        if (currentSong.file.isPlaying() == false) {
            currentSong = nextSong;
            Random rand = new Random();
            nextSong = songs.get(rand.nextInt(songs.size()));
            play();
        }
    }

    void changeVolume(float newVolume) {
        currentSong.changeVolume(newVolume);
    }

    void play() {
        currentSong.play();
    }

    void skip() {
        currentSong.stop();
        currentSong = nextSong;
        Random rand = new Random();
        nextSong = songs.get(rand.nextInt(songs.size()));
        play();
    }

    void forceSong(Music song) {
        currentSong.stop();
        currentSong = song;
        Random rand = new Random();
        nextSong = songs.get(rand.nextInt(songs.size()));
        play();
    }

    void forceNextSong(Music song) {
        nextSong = song;
    }
    
    void stop() {
        songs.clear();
        currentSong.stop();
    }
}