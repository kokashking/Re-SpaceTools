import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
import oscP5.*;
import netP5.*;
import geomerative.*;



String appPath;
String dataPath;


float spread = 1.0;

boolean loading = false;

int mode = -1;


//vars for mode 1
boolean rescan = false;
boolean drawing = false;


// Lists of edge points with defined distance 
ArrayList<PVector> aPointsList = new ArrayList<PVector>();
ArrayList<PVector> bPointsList = new ArrayList<PVector>();

//Lists of indexes of edge points sorted with specific characteristics
ArrayList<Integer> circleIndexes = new ArrayList<Integer>();  // sorted by closest distance to center


ArrayList<Integer> actualIndexes = new ArrayList<Integer>();


//
int showedEdgesN = 1;

int nextEdgeIndex = 0;

int seqAnimNextEdgeIndex = 0;

int animPauseCounterThreshold = 10;
int animPauseCounter = 0;


int animFrameCounter = 0;


//Controllable variables

int slowMovePointMaxDistSwitchDir = 13;
int slowMovePointMaxDistReset= 30;

int slowMoveMaxEdgeLength = 100;
int slowMoveMinEdgeLength = 10;

int noyseMoveMaxDistAllPoints = 100;


int blinkMaxEdgeSize = 100;
int blinkMinEdgeSize = 30;

boolean blinkRandomEdge = false;

int blinkMode = -1;  // int



boolean rgb = true;

int edgeColR = 255;
int edgeColG= 50;
int edgeColB = 255;


OscP5 oscP5;
NetAddress myRemoteLocation;

void settings() {
  fullScreen(3);
  //size(1280, 800);
}

void setup() {
  //size(1280, 800);
  //fullScreen();

  initModel();

  appPath = sketchPath();
  String sketchname = "movingLines"; //getClass().getSimpleName();



  initGui();

  println(appPath);

  //dataPath = appPath.replace(sketchname, "");   //Releas Tricks
  //dataPath = dataPath + "data/";

  dataPath = appPath + "/data/";



  oscP5 = new OscP5(this, 12001);
  //myRemoteLocation = new NetAddress("127.0.0.1", 12000);

  Ani.init(this);
}

ArrayList<PVector> testPoints;

void draw() {
  noStroke();
  fill(0, 30);
  rect(0, 0, width, width);


  //if (rgb) {
  //  stroke(edgeColR, edgeColG, edgeColB);
  //} else { 
  //  stroke(edgeTransp);
  //}





  switch (state) {
  case IMAGELOADED: 
    break;
  case EDITPOINTS:

    switch (objAnimState) {

    case ALL:
      updateExtraPointsMoving();   
      break;

    case SEQUENCE:
      updateExtraPointsMoving();
      break;
    }


  case UPDATING_MODEL: 
    break;
  }


  ellipse(mouseX, mouseY, 10, 10);
}