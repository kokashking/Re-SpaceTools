static final int DISPLAY_NR = 2; 

import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
import oscP5.*;
import netP5.*;
import geomerative.*;
import deadpixel.keystone.*;
import gab.opencv.*;


OscP5 oscP5;
NetAddress myRemoteLocation;


void settings() {
  fullScreen(P3D, DISPLAY_NR);
  //size(1500, 1000, P3D);
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

  
  //fill(255);
  //text(frameRate, 10, 10);
}