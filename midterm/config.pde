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
- User Configuration Controller
-
*/

class Config {
    JSONObject json;
    float musicVolume = 1.0;
    float ambientVolume = 1.0;
    float sfxVolume = 1.0;

    Config() {
        json = loadJSONObject("config.json");
        
        if (json != null) {
            musicVolume = (json.hasKey("musicVolume")) ? json.getFloat("musicVolume") : musicVolume;
            ambientVolume = (json.hasKey("ambientVolume")) ? json.getFloat("ambientVolume") : ambientVolume;
            sfxVolume = (json.hasKey("sfxVolume")) ? json.getFloat("sfxVolume") : sfxVolume;
        } else {
            json = new JSONObject();
        }

        //Re-save in case we caught missing values
        json.setFloat("musicVolume", musicVolume);
        json.setFloat("ambientVolume", ambientVolume);
        json.setFloat("sfxVolume", sfxVolume);
        saveJSONObject(json, "config.json");
    }

    void update() {

    }
}