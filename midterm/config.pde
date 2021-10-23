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
    //Initialize config parameters with default values.
    ConfigParameter musicVolume = new ConfigParameter(1.0);
    ConfigParameter ambientVolume = new ConfigParameter(1.0);
    ConfigParameter sfxVolume = new ConfigParameter(1.0);

    ConfigParameter keybind_jump = new ConfigParameter('w');
    ConfigParameter keybind_left = new ConfigParameter('a');
    ConfigParameter keybind_right = new ConfigParameter('d');
    ConfigParameter keybind_reload = new ConfigParameter('r');
    ConfigParameter keybind_swWeapon = new ConfigParameter('q');

    ConfigParameter debug = new ConfigParameter(false);

    Config() {
        json = loadJSONObject("config.json");
        
        if (json != null) {
            musicVolume.value = (json.hasKey("musicVolume")) ? json.getFloat("musicVolume") : musicVolume.value;
            ambientVolume.value = (json.hasKey("ambientVolume")) ? json.getFloat("ambientVolume") : ambientVolume.value;
            sfxVolume.value = (json.hasKey("sfxVolume")) ? json.getFloat("sfxVolume") : sfxVolume.value;
            keybind_jump.value = (json.hasKey("keybind_jump")) ? json.getString("keybind_jump") : keybind_jump.value;
            keybind_left.value = (json.hasKey("keybind_left")) ? json.getString("keybind_left") : keybind_left.value;
            keybind_right.value = (json.hasKey("keybind_right")) ? json.getString("keybind_right") : keybind_right.value;
            keybind_reload.value = (json.hasKey("keybind_reload")) ? json.getString("keybind_reload") : keybind_reload.value;
            keybind_swWeapon.value = (json.hasKey("keybind_swWeapon")) ? json.getString("keybind_swWeapon") : keybind_swWeapon.value;
            debug.value = (json.hasKey("debug")) ? json.getBoolean("debug") : debug.value;
        } else {
            json = new JSONObject();
        }

        //Re-save in case we caught missing values
        json.setFloat("musicVolume", (float)musicVolume.value);
        json.setFloat("ambientVolume", (float)ambientVolume.value);
        json.setFloat("sfxVolume", (float)sfxVolume.value);
        json.setString("keybind_jump", keybind_jump.value.toString());
        json.setString("keybind_left", keybind_left.value.toString());
        json.setString("keybind_right", keybind_right.value.toString());
        json.setString("keybind_reload", keybind_reload.value.toString());
        json.setString("keybind_swWeapon", keybind_swWeapon.value.toString());
        json.setBoolean("debug", (boolean)debug.value);
        saveJSONObject(json, "config.json");
    }

    void update() {
        json.setFloat("musicVolume", (float)musicVolume.value);
        json.setFloat("ambientVolume", (float)ambientVolume.value);
        json.setFloat("sfxVolume", (float)sfxVolume.value);
        json.setString("keybind_jump", keybind_jump.value.toString());
        json.setString("keybind_left", keybind_left.value.toString());
        json.setString("keybind_right", keybind_right.value.toString());
        json.setString("keybind_reload", keybind_reload.value.toString());
        json.setString("keybind_swWeapon", keybind_swWeapon.value.toString());
        json.setBoolean("debug", (boolean)debug.value);
        saveJSONObject(json, "config.json");
    }
}