import controlP5.*;

//GUI Strings

static final String extraPointsDist = "Noise Dist";

ControlFrame cf;
DropdownList objectsAnimationListDL;

boolean showGui = false;


void initGui() {

  cf = new ControlFrame(this, 400, 500, "Controls");
}


void updateGUI() {
  //objectsAnimationListDL
  // objectsAnimationListDL.addItem("obj "+i, i);
}




class ControlFrame extends PApplet {

  int w, h;
  PApplet parent;
  ControlP5 cp5;
  RadioButton blinModeRBtn;

  public ControlFrame(PApplet _parent, int _w, int _h, String _name) {
    super();   
    parent = _parent;
    w=_w;
    h=_h;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void settings() {
    size(w, h);
  }

  public void setup() {

    cp5 = new ControlP5(this);

    cp5.addSlider("Max Dist Direction")
      .plugTo(parent, "slowMovePointMaxDistSwitchDir")
      .setPosition(80, 10)
      .setRange(0, 30)
      .setSize(180, 9)
      .setValue(13)
      ;

    cp5.addSlider("Max Dist Reset")
      .plugTo(parent, "slowMovePointMaxDistReset")
      .setPosition(80, 20)
      .setRange(0, 50)
      .setSize(180, 9)
      .setValue(30)
      ;

    cp5.addSlider("Max Length")
      .plugTo(parent, "slowMoveMaxEdgeLength")
      .setPosition(80, 30)
      .setRange(0, 700)
      .setSize(180, 9)
      .setValue(100)
      ;

    cp5.addSlider("Min Length")
      .plugTo(parent, "slowMoveMinEdgeLength")
      .setPosition(80, 40)
      .setRange(0, 300)
      .setSize(180, 9)
      .setValue(20)
      ;

    cp5.addSlider("Object Blink Duration")
      .plugTo(parent, "objectBlinkDuration")
      .setPosition(80, 60)
      .setRange(0, 4)
      .setSize(180, 9)
      .setValue(0.2)
      ;

    cp5.addSlider("Blink Frame Pause")
      .plugTo(parent, "blinkFramePauseBetweenEdgeFade")
      .setPosition(80, 70)
      .setRange(0, 4)
      .setSize(180, 9) 
      .setValue(0.1)
      ;


    cp5.addSlider("Edge Random")
      .plugTo(parent, "edgeRandCoef")
      .setPosition(80, 80)
      .setRange(1, 5)
      .setSize(180, 9)
      .setValue(2)
      ;


    cp5.addSlider("Edge Blink Duration")
      .plugTo(parent, "edgeBlinkDuration")
      .setPosition(80, 90)
      .setRange(0, 4)
      .setSize(180, 9)
      .setValue(0.05)
      ;

    cp5.addSlider("Overall transparency")
      .plugTo(parent, "overallTransp")
      .setPosition(80, 100)
      .setRange(0, 255)
      .setSize(180, 9)
      .setValue(255)
      ;

    cp5.addSlider("Edge color R")
      .plugTo(parent, "edgeColR")
      .setPosition(80, 120)
      .setRange(0, 255)
      .setSize(180, 9)
      .setValue(255)
      ;

    cp5.addSlider("Edge color G")
      .plugTo(parent, "edgeColG")
      .setPosition(80, 130)
      .setRange(0, 255)
      .setSize(180, 9)
      .setValue(255)
      ;

    cp5.addSlider("Edge color B")
      .plugTo(parent, "edgeColB")
      .setPosition(80, 140)
      .setRange(0, 255)
      .setSize(180, 9)
      .setValue(255)
      ;

    cp5.addSlider("Edge Weight")
      .plugTo(parent, "edgeW")
      .setPosition(80, 150)
      .setRange(0, 30)
      .setSize(180, 9)
      .setValue(1)
      ;

    cp5.addSlider("Fade duration")
      .plugTo(parent, "fadeDuration")
      .setPosition(80, 190)
      .setRange(0, 4)
      .setSize(180, 9)
      .setValue(1)
      ;

    cp5.addButton("load")
      .setPosition(10, 0)
      .setSize(20, 10)
      ;

    cp5.addButton("reset")
      .setPosition(45, 0)
      .setSize(20, 10)
      ;

    cp5.addButton("save")
      .setPosition(10, 20)
      .setSize(20, 10)
      ;

    cp5.addButton("slow")
      .setPosition(45, 50)
      .setSize(20, 10)
      ;

    cp5.addButton("seqAnim")
      .setPosition(10, 50)
      .setSize(20, 10)
      ;

    cp5.addButton("rand")
      .setPosition(10, 70)
      .setSize(20, 10)
      ;

    cp5.addButton("fade")
      .setPosition(45, 70)
      .setSize(20, 10)
      ;

    cp5.addButton("newObject")
      .setPosition(10, 120)
      .setSize(60, 10)
      ;

    cp5.addSlider(extraPointsDist)
      .plugTo(parent, "extraPointsDistPx")
      .setPosition(80, 180)
      .setRange(1, 300)
      .setSize(180, 9)
      .setValue(40)
      ;


    //objectsAnimationListDL = cp5.addDropdownList("Objects")
    //  .setPosition(20, 220)
    //  .setSize(200, 300)
    //  ;

    //  customize(objectsAnimationListDL);

    /*
    cp5.addRadioButton("blinkMode1")
     .setPosition(10, 50)
     .setSize(20, 9)
     .addItem("seqAnimuence", 0)
     .addItem("random", 1)
    /*   .addItem("center", 2)
     .addItem("blue", 3)
     .addItem("grey", 4) */
  }

  void draw() {
    background(190);
  }

  void blinkMode1(int value) {
    println("blinkMode " + value);
    // blinkMode = value;
  }

  void load() {
    println("load");
    loadDrawing();
  }

  void reset() {
    println("reset");
    initModel();
  }

  void save() {
    println("save");
    saveDrawing();
  }

  void slow() {
    cStopSeqAnim();
  }

  void seqAnim() {
    cStartSeqAnim();
  }

  void rand() {
    cStartRandAnim();
  }

  void fade() {
    cStartFadeAnim();
  }

  void newObject() {
    cNewObject();
  }

  void customize(DropdownList ddl) {
    // a convenience function to customize a DropdownList
    ddl.setBackgroundColor(color(190));
    ddl.setItemHeight(20);
    ddl.setBarHeight(15);
    ddl.getCaptionLabel().set("Objects");
    //  //    ddl.addItem("obj "+i, i);
    // }
    //ddl.scroll(0);
    ddl.setColorBackground(color(60));
    ddl.setColorActive(color(255, 128));
  }
}