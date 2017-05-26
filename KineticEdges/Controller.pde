AniSequence seqAnim;




/*******************************/
//Model Operations  Here or in Model?
void updateExtraPointsMoving() {
  for (RsObject obj : objects) {

    obj.update();

    //for (int i = 0; i <  obj.cornerPoints.size() - 1; i++) {
    //     PVector v = obj.cornerPoints.get(i); 
    //    PVector v1 =  obj.cornerPoints.get(i + 1);
    //    line(v.x, v.y, v1.x, v1.y);
    //}
  }//for objects
}

void drawObjects() {
  for (RsObject obj : objects) {
    obj.draw();
  }
}

void runTheCommand(SlltdCmd cmd) {
  for (RsObject obj : objects) {

    if (obj.selected) {

      switch (cmd) {
      case VIDEO: 
        obj.surfaceInputState = ShowSurfaceInputState.SHADER;
        break;
      case NOVIDEO: 
        obj.surfaceInputState = ShowSurfaceInputState.NOTHING;
        break;
      }
    }
  }
}
/*******************************/
//User Screen Interaction

void mousePressed() {
  //  println(mouseX +"  " + mouseY);

  state = State.UPDATING_MODEL;

  if (mouseButton == LEFT) {
    if (actObj != null) {

      if (actObj.cornerPoints.size() > 2) {
        PVector firstPoint = actObj.cornerPoints.get(0);
        float d = dist(firstPoint.x, firstPoint.y, mouseX, mouseY);
        //println(d);
        if (d < distToClose) {

          actObj.addCornerPoint(firstPoint);
          actObj.closedShape = true;
        } else
          actObj.addCornerPoint(new PVector( mouseX, mouseY));
      } else
        actObj.addCornerPoint(new PVector( mouseX, mouseY));

      extraPointsDist();
    }
  } else if (mouseButton == RIGHT) {
    cNewObject();
  } 

  if (randAnim) {
    for (RsObject obj : objects) {
      obj.stopRandAnim();

      obj.initRandAnim();
    }
  }

  state = State.EDITPOINTS;
}


void mouseReleased() {
}

int value = 0;

PVector rightMouseStartP = new PVector(0, 0);
PVector rightMouseEndP = new PVector(0, 0);

void mouseDragged() 
{
}




/*******************************/
//IO

void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  //print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern() + "  ");
  //println(" typetag: "+theOscMessage.typetag());

  if (theOscMessage.addrPattern().equals("/trigger")) {
    trigger();
    return;
  }
}

void keyPressed() {
  if (key == ' ') {
    spread = 30;
    Ani.to(this, 1.3, "spread", 1);
  } else if (key == 's') { //save
    saveDrawing();
  } else if (key == 'l') {
    loadDrawing();
  } else if (key == 'n') {
    cNewObject();
  } else if (key == '0') {
    mode = 0;
  } else if (key == '1') {
    mode = 1;
  } else if (key == 'f') {
    rescan = true;
  } else if (key == 'r') {
    record = !record;
  }
}

void newDrawing() {
  initModel();
}

void trigger() {
  spread = 30;
  Ani.to(this, 1.3, "spread", 1);
}

void saveDrawing() {
  JSONArray objectsJsonArray = new JSONArray();

  for (int i = 0; i < objects.size(); i++) {
    RsObject obj = objects.get(i);
    JSONObject objJsonObj = new JSONObject();
    JSONArray objPointsJsonArray = new JSONArray();

    for (int j = 0; j < obj.cornerPoints.size(); j++) {
      JSONObject p = new JSONObject();
      p.setInt("x", (int) obj.cornerPoints.get(j).x);
      p.setInt("y", (int) obj.cornerPoints.get(j).y);

      objPointsJsonArray.setJSONObject(j, p);
    }

    objJsonObj.setJSONArray("cornerPoints", objPointsJsonArray);
    objectsJsonArray.setJSONObject(i, objJsonObj);
  }

  saveJSONArray(objectsJsonArray, dataPath + "drawing.json");
}




void loadDrawing() {
  println("loadDrawing");


  File f = new File(dataPath+ "drawing.json");
  if (!f.exists()) {
    println("Draw file does not exist");
    return;
  } 


  JSONArray objectsJsonArray;

  try {
    objectsJsonArray = loadJSONArray(dataPath + "drawing.json");
  } 
  catch (Exception e) {
    println(e.toString());
    return;
  }

  state = State.UPDATING_MODEL;

  //loading = true;
  newDrawing();



  for (int i = 0; i < objectsJsonArray.size (); i++) {

    JSONObject object = objectsJsonArray.getJSONObject(i); 
    JSONArray objPointsJsonArray = object.getJSONArray("cornerPoints"); 

    RsObject obj = new RsObject(i);
    for (int j = 0; j < objPointsJsonArray.size(); j++) {
      JSONObject p = objPointsJsonArray.getJSONObject(j);

      obj.addCornerPoint(new PVector(p.getInt("x"), p.getInt("y")));
    }

    objects.add(obj);
  }

  updateModel();


  //loading = false;
  setState(State.EDITPOINTS);
}



/******************************/
//GUI changed

void controlEvent(ControlEvent theEvent) {
  state = State.UPDATING_MODEL;

  updateModel();
  state = State.EDITPOINTS;

  /*String guiElementName = theEvent.getController().getName();
   switch(guiElementName) {
   case extraPointsDist: 
   extraPointsDist();
   setState(State.EDITPOINTS);
   break;
   }
   */
  //println("got something from a controller " +theEvent.getController().getName());
}


void resetOverallAlpha() {
  Ani.to(this, fadeDuration, "overallAlpha", 0, Ani.EXPO_IN);
  //  alpha = 0;
}



void cStartFadeAnim() {
  state = State.UPDATING_MODEL;
  overallAlpha = 0;
  fadeAnim = !fadeAnim;
  println("fadeAnim " + fadeAnim);
  fadeAni = Ani.to(this, fadeDuration, "overallAlpha", 255, Ani.EXPO_IN, "onEnd:resetOverallAlpha");
  fadeAni.repeat();
  state = State.EDITPOINTS;
}


void cStartRandAnim() {
  state = State.UPDATING_MODEL;
  randAnim = !randAnim;
  println("randAnim " + randAnim);



  for (RsObject obj : objects) {
    obj.stopRandAnim();

    obj.initRandAnim();
  }
  state = State.EDITPOINTS;
}

void cStopSeqAnim() {
  state = State.UPDATING_MODEL;

  if (seqAnim != null)
    seqAnim.endSequence();

  for (int i = 0; i < objects.size(); i++) {
    RsObject obj = objects.get(i);
    obj.alpha = 255;
  }
  state = State.EDITPOINTS;
}

void cStartSeqAnim() {
  //Ani.init(this);
  state = State.UPDATING_MODEL;

  if (seqAnim != null)
    seqAnim.endSequence();
  //  Ani.killAll();
  //  Ani.overwrite();

  // initModel();

  objAnimState = ObjAnimState.SEQUENCE;
  seqAnim = new AniSequence(this);
  seqAnim.beginSequence();

  for (int i = 0; i < objects.size(); i++) {
    RsObject obj = objects.get(i);
    obj.initSeqAnim(i);
  }

  seqAnim.endSequence();
  seqAnim.start();
  setState(State.EDITPOINTS);
}



void cNewObject() {
  println("objects.size() " + objects.size());

  if (actObj != null && actObj.cornerPoints.size() == 0)
    return;

  RsObject obj = new RsObject(objects.size());
  objects.add(obj);
  actObj = obj;
}


void cEditMode() {
  state = State.UPDATING_MODEL;

  state = State.EDITPOINTS;
}