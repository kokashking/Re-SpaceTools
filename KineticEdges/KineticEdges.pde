static final int DISPLAY_NR = 0; 
boolean fullscreen = false;

import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
import oscP5.*;
import netP5.*;
import geomerative.*;


OscP5 oscP5;
NetAddress myRemoteLocation;


void settings() {
  //fullScreen(P3D, DISPLAY_NR);
  if (fullscreen)
    fullScreen(P3D, DISPLAY_NR);
  else
    size(1080, 1080, P3D);
}

void setup() {

  initModel();

  appPath = sketchPath();
  String sketchname = "movingLines"; //getClass().getSimpleName();


  initGui();

  println(appPath);

  dataPath = appPath + "/data/";

  oscP5 = new OscP5(this, 12001);

  Ani.init(this);

  pgLines = createGraphics(width, height);
  pgShaders = createGraphics(width, height);
}


ArrayList<PVector> testPoints;

void draw() {

  noStroke();
  fill(0, 30);
  rect(0, 0, width, width);


  switch (state) {
  case IMAGELOADED: 
    break;
  case EDITPOINTS:

    switch (objAnimState) {

    case ALL:
      updateExtraPointsMoving();   
      drawObjects();
      break;

    case SEQUENCE:
      updateExtraPointsMoving();
      drawObjects();
      break;
    }


  case UPDATING_MODEL: 
    break;
  }

  if (record) {
    saveFrame("kinetecDrawing-########.png");
  }
  //fill(255);
  //text(frameRate, 10, 10);
}