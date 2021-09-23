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

//Using an object to allow passing through functions.
class ConfigParameter {
    Object value;
    ConfigParameter(Object v) {
        value = v;
    }
}

class Config {
    JSONObject json;
    ConfigParameter musicVolume = new ConfigParameter(1.0);
    ConfigParameter ambientVolume = new ConfigParameter(1.0);
    ConfigParameter sfxVolume = new ConfigParameter(1.0);

    ConfigParameter keybind_jump = new ConfigParameter('w');
    ConfigParameter keybind_left = new ConfigParameter('a');
    ConfigParameter keybind_crouch = new ConfigParameter('s');
    ConfigParameter keybind_right = new ConfigParameter('d');
    ConfigParameter keybind_reload = new ConfigParameter('r');
    ConfigParameter keybind_melee = new ConfigParameter('q');

    Config() {
        json = loadJSONObject("config.json");
        
        if (json != null) {
            musicVolume.value = (json.hasKey("musicVolume")) ? json.getFloat("musicVolume") : musicVolume.value;
            ambientVolume.value = (json.hasKey("ambientVolume")) ? json.getFloat("ambientVolume") : ambientVolume.value;
            sfxVolume.value = (json.hasKey("sfxVolume")) ? json.getFloat("sfxVolume") : sfxVolume.value;
        } else {
            json = new JSONObject();
        }

        //Re-save in case we caught missing values
        json.setFloat("musicVolume", (float)musicVolume.value);
        json.setFloat("ambientVolume", (float)ambientVolume.value);
        json.setFloat("sfxVolume", (float)sfxVolume.value);
        saveJSONObject(json, "config.json");
    }

    void update() {
        json.setFloat("musicVolume", (float)musicVolume.value);
        json.setFloat("ambientVolume", (float)ambientVolume.value);
        json.setFloat("sfxVolume", (float)sfxVolume.value);
        saveJSONObject(json, "config.json");
    }
}