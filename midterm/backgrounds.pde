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
- Background Definitions
-
*/

class BackgroundDetail {
    //Stars or Clouds
    String type;
    //Size of detail
    int size;

    //Position
    float x;
    float y;

    //Image used for certain details
    PImage img;

    //Array of cloud image paths
    String[] cloudsArray = {
        "data\\img\\world\\bg\\cloud-1.png",
        "data\\img\\world\\bg\\cloud-2.png",
        "data\\img\\world\\bg\\cloud-3.png",
        "data\\img\\world\\bg\\cloud-4.png",
        "data\\img\\world\\bg\\cloud-5.png",
        "data\\img\\world\\bg\\cloud-6.png"
    };
    
    BackgroundDetail(String t, int min, int max, int xpos, int ypos) {
        type = t;
        size = int(random(min, max));
        x = xpos;
        y = ypos;
        if (type == "cloud") {
            //Get random cloud image
            img = loadImage(cloudsArray[int(random(0,5))]);
            img.resize(size, size);
        }
    }
    void update() {
        switch(type){
            case "star":
                noStroke();
                fill(255);
                beginShape();
                for (float a = 0; a < TWO_PI; a += TWO_PI / 4) {
                    float sx = x + cos(a) * size;
                    float sy = y + sin(a) * size;
                    vertex(sx, sy);
                    sx = x + cos(a+(TWO_PI/4)/2) * size/2;
                    sy = y + sin(a+(TWO_PI/4)/2) * size/2;
                    vertex(sx, sy);
                }
                endShape(CLOSE);
                if (x < 0 - size) {
                    x = width + size;
                    y = int(random(height));
                }
            break;
            case "cloud":
                imageMode(CENTER);
                tint(255, 128);
                image(img, x, y);
                tint(255, 255);
                if (x < 0 - size) {
                    x = width + size;
                    y = int(random(height));
                }
            break;
        }
    }
}

class Background {
    PImage background;

    ArrayList<BackgroundDetail> detailsArray = new ArrayList<BackgroundDetail>();

    //X coordinate of the background for referent movement
    int bgX = 0;

    //How fast the background will "naturally" move
    float speed;

    Background(color c, String t, float s, int d, int min, int max) {
        //c = bgcolor, t = backgrounddetail type, s = how fast the detail passively moves across screen, d = density (count actually, how many are generated per "screen" w*h); min/max passed to backgrounddetail
        background = createImage(width * 4, height, RGB);
        for(int i = 0; i < background.pixels.length; i++) {
            background.pixels[i] = color(c);
        }
        
        speed = s;

        for (int i = 0; i < d; i++) {
            BackgroundDetail detail = new BackgroundDetail(t, min, max, int(random(width)), int(random(height)));
            detailsArray.add(detail);
        }
    }
    void update() {
        imageMode(CORNER);
        image(background, bgX, 0);
        detailsArray.forEach((d) -> {
            d.x = d.x - speed;
            d.update();
        });
    }
}