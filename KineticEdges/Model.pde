//////VARS

int distToClose = 10;

//rec
boolean record = false; 

//polar cmd vars
double cmdAngle = 0;
double cmdRadius = 0;

//CornerPinSurface surface;
PGraphics glblOffscreen;

PGraphics pgLines;
PGraphics pgShaders;

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





/*
RsObject is a simplest visual element: Point, Line, Any Contour  
 
 */

enum State {
  IMAGELOADED, 
    MAPIMAGE, 
    EDITPOINTS, 
    PRESENTATION, 
    UPDATING_MODEL
}

enum ShowSurfaceInputState {
  NOTHING, 
    VIDEO1, 
    VIDEO2, 
    SHADER
}

enum SlltdCmd {
  VIDEO, 
    NOVIDEO
}

enum ObjAnimState {
  ALL, 
    SEQUENCE, 
    RANDOM
}

State state;
ObjAnimState objAnimState;

float objectBlinkDuration;

int setState(State newState) {
  state = newState;
  return 1;
}

static ArrayList<RsObject> objects;
ArrayList<RsEdge> recognizedEdges;

int extraPointsDistPx = 40;
int edgeW = 1;
float blinkPauseBetweenObjects = 0.01;
int overallAlpha = 255;
float fadeDuration;

float edgeRandCoef = 2;
float edgeBlinkDuration = 0.05;

boolean randAnim = false;

Ani fadeAni;
boolean fadeAnim = false;

RsObject actObj = null;


void initModel() {  
  objects = new ArrayList<RsObject>();
  recognizedEdges = new ArrayList<RsEdge>();
  objAnimState = ObjAnimState.ALL;
}

void updateModel() {
  extraPointsDist();

  updateGUI();
}

void extraPointsDist() {

  for (RsObject obj : objects) {
    obj.extraPoints = new ArrayList<PVector>();
    obj.extraPointsMoving = new ArrayList<PVector>();
    if (obj.cornerPoints.size() > 0) {
      PVector p = obj.cornerPoints.get(0);
      obj.extraPoints.add(new PVector(p.x, p.y));
      obj.extraPointsMoving.add(new PVector(p.x, p.y));
    }

    for (int i = 0; i < obj.cornerPoints.size() - 1; i++) {
      PVector p1 = obj.cornerPoints.get(i);
      PVector p2 = obj.cornerPoints.get(i+1);
      obj.extraPoints.addAll(createRandomPathWithoutFirstPoint(p1, p2, extraPointsDistPx, 6));
      obj.extraPointsMoving = new ArrayList<PVector>(clonePoints(obj.extraPoints));
    }

    if (obj.closedShape) {
      int lastIndex = obj.extraPoints.size() - 1;
      obj.extraPoints.set(lastIndex, obj.extraPoints.get(0));
      obj.extraPointsMoving.set(lastIndex, obj.extraPointsMoving.get(0));
    }

    if (obj.cornerPoints.size() > 0) {
      PVector center = new PVector(obj.cornerPoints.get(0).x, obj.cornerPoints.get(0).y);
      if (obj.cornerPoints.size() > 1) {

        for (int i = 1; i < obj.cornerPoints.size(); i++) {
          center.add(obj.cornerPoints.get(i).x, obj.cornerPoints.get(i).y);
        }

        center.div(obj.cornerPoints.size());

        obj.menuPoint = center;
      }
    }

    println(obj.cornerPoints.size() );
    if (obj.cornerPoints.size() > 1) {


      RPoint contourpoints[] = new RPoint[obj.cornerPoints.size()];
      for (int i = 0; i < obj.cornerPoints.size(); i++) {
        contourpoints[i] = new RPoint(obj.cornerPoints.get(i).x, obj.cornerPoints.get(i).y);
        //println(i);
        //  contourpoints[i].x = 1;//obj.cornerPoints.get(i).x;
        // contourpoints[i].y = 2;//obj.cornerPoints.get(i).y;
      }

      RContour rCntr = new RContour(contourpoints); 
      obj.rContour = rCntr;

      obj.bounds = rCntr.getBoundsPoints();
      println( "bounds " + obj.bounds.length);

      int w = int(obj.bounds[1].x - obj.bounds[0].x);
      int h = int(obj.bounds[3].y - obj.bounds[0].y);
      obj.w = w;
      obj.h = h;
      obj.offscreen = createGraphics(w, h, P3D);
      // obj.surface = ks.createCornerPinSurface(w, h, 10);

      PImage newMask = createImage(w, h, ARGB);
      newMask.loadPixels();

      RContour ctr = new RContour(obj.rContour.getPoints());
      ArrayList<PVector> ctrPv = new ArrayList<PVector>(obj.cornerPoints);

      ctr.translate(-obj.bounds[0].x, -obj.bounds[0].y);

      for (int i = 0; i < ctr.getPoints().length; i++) {
        // ctrPv.add(i, new PVector(ctr.getPoints()[i].x, ctr.getPoints()[i].y));
        println(ctr.getPoints()[i].x);
      }


      ctrPv = translateList(obj.extraPoints, new PVector (-obj.bounds[0].x, -obj.bounds[0].y));
      //ctrPv.remove(obj.cornerPoints.size() -1 );

      PVector actP; 
      for (int iy = 0; iy < h; iy++) {
        for (int ix = 0; ix < w; ix++) {
          // newMask.pixels[iy*];

          actP = new PVector(ix, iy);
          //println("actP ", actP.x +  "  " +  actP.y);
          if (contains(actP, ctrPv))
            //if(iy < 50)
            newMask.pixels[iy*w + ix] = color(0, 0, 0, 0); 
          else
            newMask.pixels[iy*w + ix] = color(0, 0, 0, 255);
          // if (ctr.contains(new RPoint(iy*w + ix, iy))){}  
          //println("contains");
        }
      }

      newMask.updatePixels();
      obj.mask = newMask;
    }

    println("objects updated");
  }
}




class RsObject {

  int index;
  ArrayList<PVector> cornerPoints;
  ArrayList<PVector> extraPoints;
  ArrayList<PVector> extraPointsMoving;
  ArrayList<RsEdge> edges = new ArrayList<RsEdge>();
  int alpha = 255;
  boolean closedShape = false;
  String videoFolderPath = "/test";

  ShowSurfaceInputState surfaceInputState = ShowSurfaceInputState.NOTHING;

  boolean selected = false;
  PVector menuPoint;
  RContour rContour;
  RPoint bounds[];   // from left up clockwise 
  // CornerPinSurface surface;
  PGraphics offscreen;
  int w, h;
  PImage mask;


  public RsObject(int index) {
    this.index = index;
    this.cornerPoints = new ArrayList<PVector>();
    this.extraPoints = new ArrayList<PVector>();
    this.extraPointsMoving = new ArrayList<PVector>();
    //surface = ks.createCornerPinSurface(400, 300, 20);
  }

  public RsObject(ArrayList<PVector> points, int index) {
    this.index = index;
    this.cornerPoints = new ArrayList<PVector>(points);
    this.extraPoints = new ArrayList<PVector>();
    this.extraPointsMoving = new ArrayList<PVector>();
    //surface = ks.createCornerPinSurface(400, 300, 20);
  }

  public void createExtraPoints() {
    if (cornerPoints.size() > 1) {
      for (int i = 0; i < cornerPoints.size() - 1; i++) {
        PVector p1 = cornerPoints.get(i);
        PVector p2 = cornerPoints.get(i + 1);
        extraPoints.addAll(createRandomPath(p1, p2, extraPointsDistPx, 0));
      }
    } else {
      PVector p1 = cornerPoints.get(0);
      extraPoints.add(new PVector(p1.x, p1.y));
    }
    extraPointsMoving = new ArrayList<PVector>(extraPoints);
  }

  public void createExtraPointsLastEdge() {
    if (cornerPoints.size() > 1) {
      for (int i = cornerPoints.size() - 2; i < cornerPoints.size() - 1; i++) {
        PVector p1 = cornerPoints.get(i);
        PVector p2 = cornerPoints.get(i + 1);
        extraPoints.addAll(createRandomPathWithoutFirstPoint(p1, p2, extraPointsDistPx, 2));
      }
    } else if ( cornerPoints.size() == 1) {
      PVector p1 = cornerPoints.get(0);
      extraPoints.add(new PVector(p1.x, p1.y));
    }
    extraPointsMoving = new ArrayList<PVector>(extraPoints);
  }

  public void addCornerPoint(PVector p) {
    cornerPoints.add(new PVector(p.x, p.y));
    if (cornerPoints.size() > 1) {
      PVector p1 = cornerPoints.get(cornerPoints.size() - 2);
      PVector p2 = cornerPoints.get(cornerPoints.size() - 1);
      extraPoints.addAll(createRandomPathWithoutFirstPoint(p1, p2, extraPointsDistPx, 6));
      extraPointsMoving = new ArrayList<PVector>(clonePoints(extraPoints));
    } else if (cornerPoints.size() == 1) {
      extraPoints.add(new PVector(p.x, p.y));
      extraPointsMoving.add(new PVector(p.x, p.y));
    }

    //  println(extraPointsMoving.size());
  }

  void seqAnimEnd() {
    //println("sequenceEnd() restart all again");
    println("resetAlpha seqAnimEnd" + index);
    Ani.to(this, blinkPauseBetweenObjects, "alpha", 0, Ani.EXPO_IN);
    seqAnim.start();
  }

  void resetAlpha() {
    // println("resetAlpha " + index);
    Ani.to(this, blinkPauseBetweenObjects, "alpha", 0, Ani.EXPO_IN);
    //  alpha = 0;
  }

  public void initRandAnim() {
    for (int i = 0; i < extraPointsMoving.size(); i++) {
      RsEdge e = new RsEdge();

      edges.add(e);
      e.initRandAnim();
    }
  }

  public void stopRandAnim() {
    for (int i = 0; i < extraPointsMoving.size(); i++) {
      if (edges.size()-1 > i)
        edges.get(i).stopRandAnim();
      edges.clear();
    }
  }

  public void initSeqAnim(int index) {

    alpha = 0;
    if (index != objects.size() - 1)
      seqAnim.add(Ani.to(this, objectBlinkDuration, "alpha", 255, Ani.EXPO_IN, "onEnd:resetAlpha"));
    else if (index == objects.size() - 1)
      seqAnim.add(Ani.to(this, objectBlinkDuration, "alpha", 255, Ani.EXPO_IN, "onEnd:seqAnimEnd"));
    //if (index != objects.size() - 1)
    //  seqAnim.add(Ani.to(this, duration + delay, "alpha", 0, Ani.EXPO_OUT));
    //else
    //  seqAnim.add(Ani.to(this, duration + delay, "alpha", 0, Ani.EXPO_OUT, "onEnd:seqAnimEnd"));
  }

  public void addVideo() {
  }

  public void update() {
    for (int i = 0; i < extraPointsMoving.size(); i++) {



      PVector v = extraPointsMoving.get(i);

      PVector vOrig = extraPoints.get(i);

      if (v == vOrig)
        println("fuckl");
      //  println(i);
      float r1 = random(-spread, spread);
      float r2 = random(-spread, spread);
      v.x += random(-1, 1);
      if (dist(v.x + r1, v.y, vOrig.x, vOrig.y) > slowMovePointMaxDistSwitchDir) {
        v.x -= r1;
      }

      if (dist(v.x, v.y + r2, vOrig.x, vOrig.y) > slowMovePointMaxDistSwitchDir) {
        v.y -= r2;
      }

      if (dist(v.x, v.y, vOrig.x, vOrig.y) > slowMovePointMaxDistReset ) {
        v.x = vOrig.x;
        v.y = vOrig.y;
      }

      extraPointsMoving.set(i, v);

      if (closedShape && i == extraPointsMoving.size() - 1) {
        int lastIndex = extraPointsMoving.size() - 1;
        extraPointsMoving.set(lastIndex, extraPointsMoving.get(0));
      }
    }

    // mouse is on
    if (cornerPoints.size() > 2) {  //for line other method
      if (contains(new PVector(mouseX, mouseY), cornerPoints)) {
        // println(index);

        if (mousePressed) {
          // surface.render(offscreen);
          selected = !selected;
          // ks.toggleCalibration();
        }
      }
    }
  }

  public void draw() {
    stroke(edgeColR, edgeColG, edgeColB, alpha);
    strokeWeight(edgeW);
    for (int i = 0; i <  extraPointsMoving.size() - 1; i++) {
      PVector v = extraPointsMoving.get(i);
      PVector v1 =  extraPointsMoving.get(i + 1);

      if (randAnim) {
        stroke(edgeColR, edgeColG, edgeColB, edges.get(i).alpha);   //no rand edges
      }
      if (fadeAnim) {
        stroke(edgeColR, edgeColG, edgeColB, overallAlpha);
        //println(overallAlpha);
      }

      line(v.x, v.y, v1.x, v1.y);
    }

    if (this.index == objects.size() - 1 && cornerPoints.size() >= 1) {
      line(cornerPoints.get(cornerPoints.size() - 1).x, cornerPoints.get(cornerPoints.size() - 1).y, mouseX, mouseY);
    }

    if (selected) {
      //ellipse(menuPoint.x, menuPoint.y, 20, 20);
    }
  }
}

PImage temp1;


class RsEdge {
  PVector p1;
  PVector p2;
  int alpha = 0;
  Ani randAni;

  public RsEdge() {
  }

  public RsEdge(PVector p1, PVector p2) {
    this.p1 = p1;
    this.p2 = p2;
  }

  void resetAlpha() {
    Ani.to(this, objectBlinkDuration, "alpha", 0, Ani.EXPO_IN);
    //  alpha = 0;
  }

  public void stopRandAnim() {
    if (randAni != null)
      randAni.end();
  }

  public void initRandAnim() {
    randAni = Ani.to(this, objectBlinkDuration * random(1, edgeRandCoef), "alpha", 255, Ani.EXPO_IN, "onEnd:resetAlpha");
    randAni.repeat();
  }
}

ArrayList<Integer> cloneInts(ArrayList<Integer> ints) {
  ArrayList<Integer> newInts = new ArrayList<Integer>();

  for (int i = 0; i < ints.size(); i++) {
    Integer inta = ints.get(i);
    newInts.add(inta);
  }

  return newInts;
}

ArrayList<PVector> clonePoints(ArrayList<PVector> points) {
  ArrayList<PVector> newPoints = new ArrayList<PVector>();

  for (int i = 0; i < points.size(); i++) {
    PVector p = new PVector (points.get(i).x, points.get(i).y);
    newPoints.add(p);
  }

  return newPoints;
}

ArrayList<PVector> createRandomPathWithoutFirstPoint(PVector a, PVector b, int stepCoef, float spreadWidth) {
  ArrayList<PVector> path = new ArrayList<PVector>();
  int stepsN = (int) dist(a.x, a.y, b.x, b.y)/stepCoef;
  PVector v = new PVector();
  v.x = b.x - a.x;
  v.y = b.y - a.y;

  float mag = v.mag();

  v.x = v.x / mag;
  v.y = v.y / mag;

  float temp = v.x;
  v.x = -v.y;
  v.y = temp;

  RPath rPath = new RPath(a.x, a.y);
  rPath.addLineTo(b.x, b.y);

  float delta = 1.0/stepsN;
  for (float i = 0; i < stepsN; i++) {
    rPath.insertHandle(i*delta);
    //nextPoint.x =
  }

  PVector nextPoint = new PVector();


  for (int i = 1; i < rPath.getHandles().length - 1; i++) {
    float spread = random(-spreadWidth, spreadWidth);
    nextPoint.x = rPath.getHandles()[i].x + v.x * spread;
    nextPoint.y = rPath.getHandles()[i].y + v.y * spread;
    // ellipse(nextPoint.x, nextPoint.y, 10, 10);
    path.add(new PVector(nextPoint.x, nextPoint.y));
  }
  path.add(new PVector(b.x, b.y));

  return path;
}

ArrayList<PVector> createRandomPath(PVector a, PVector b, int stepCoef, float spreadWidth) {
  ArrayList<PVector> path = new ArrayList<PVector>();
  int stepsN = (int) dist(a.x, a.y, b.x, b.y)/stepCoef;
  PVector v = new PVector();
  v.x = b.x - a.x;
  v.y = b.y - a.y;

  float mag = v.mag();

  v.x = v.x / mag;
  v.y = v.y / mag;

  float temp = v.x;
  v.x = -v.y;
  v.y = temp;

  RPath rPath = new RPath(a.x, a.y);
  rPath.addLineTo(b.x, b.y);

  float delta = 1.0/stepsN;
  for (float i = 0; i < stepsN; i++) {
    rPath.insertHandle(i*delta);
    //nextPoint.x =
  }

  PVector nextPoint = new PVector();

  path.add(new PVector(a.x, a.y));
  for (int i = 1; i < rPath.getHandles().length - 1; i++) {
    float spread = random(-spreadWidth, spreadWidth);
    nextPoint.x = rPath.getHandles()[i].x + v.x * spread;
    nextPoint.y = rPath.getHandles()[i].y + v.y * spread;
    // ellipse(nextPoint.x, nextPoint.y, 10, 10);
    path.add(new PVector(nextPoint.x, nextPoint.y));
  }
  path.add(new PVector(b.x, b.y));

  return path;
}


/*
//keystone for image mapping
 Keystone ks;
 CornerPinSurface surface;
 PGraphics offscreen;
 
 void initKeystone(PImage photo) {
 ks = new Keystone(this);
 surface = ks.createCornerPinSurface(photo.width, photo.height, 20);
 offscreen = createGraphics(400, 300, P3D);
 
 offscreen.beginDraw();
 offscreen.background(0);
 offscreen.image(photo, 0, 0);
 offscreen.endDraw();
 }
 */