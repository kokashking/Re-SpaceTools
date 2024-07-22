import oscP5.*;
import netP5.*;
import ddf.minim.*;
import controlP5.*;
import de.looksgood.ani.*;

ControlP5 cp5;

Textfield oscClipNr;
Textfield oscLayerNr;

Minim minim;
AudioInput in;

int levelCoeff = 150;
int levelThreashold = 30;
int timeBeatThreashold = 30;
int lastTimeBeat = 0;
boolean debug = false;
boolean sendToResolume = true;

int layerNr = 3;
int clipNr = 1;

int beatEllipseSize = 30;

OscP5 oscP5;
NetAddress myRemoteLocation;
NetAddress ResolumeLocation;

void setup() {
  size(500, 400);
  frameRate(25);
  /* start oscP5, listening for incoming messages at port 12000 */

  Ani.init(this);

  //GUI
  cp5 = new ControlP5(this);
  cp5.addSlider("levelThreashold")
    .setPosition(20, height/2 + 100)
      .setRange(0, 100)
        ;


  cp5.addSlider("timeBeatThreashold")
    .setPosition(20, height/2 + 130)
      .setRange(0, 1500)
        ;

  cp5.addSlider("levelCoeff")
    .setPosition(20, height/2 + 150)
      .setRange(0, 1500)
        ;

  cp5.addToggle("sendToResolume")
    .setPosition(300, height/2 + 100)
      .setSize(20, 20)
        ;


  oscLayerNr = cp5.addTextfield("oscLayerNr")
    .setPosition(300, height/2 + 150)
      .setSize(60, 20)
        .setAutoClear(false)
          .setLabel("Layer Nr")
            .setText(Integer.toString(layerNr))
              .setMoveable(true);

  oscClipNr = cp5.addTextfield("oscClipNr")
    .setPosition(370, height/2 + 150)
      .setSize(60, 20)
        .setAutoClear(false)
          .setLabel("Clip Nr")
            .setText(Integer.toString(clipNr))
              .setMoveable(true);


  //SOUND
  minim = new Minim(this);
  in = minim.getLineIn();


  //OSC
  oscP5 = new OscP5(this, 12000);

  /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
   * an ip address and a port number. myRemoteLocation is used as parameter in
   * oscP5.send() when sending osc packets to another computer, device, 
   * application. usage see below. for testing purposes the listening port
   * and the port of the remote location address are the same, hence you will
   * send messages back to this sketch.
   */
  myRemoteLocation = new NetAddress("127.0.0.1", 12001);
  ResolumeLocation = new NetAddress("127.0.0.1", 7000);
}


void draw() {
  background(0);

  stroke(255);

  for (int i = 0; i < in.bufferSize () - 1; i++)
  {
    line( i, 50 + in.left.get(i)*50, i+1, 50 + in.left.get(i+1)*50 );
    line( i, 150 + in.right.get(i)*50, i+1, 150 + in.right.get(i+1)*50 );
  }

  if (debug) {
    println(" ");
  }


  int level = (int)(in.left.level() * levelCoeff);
  if (level > levelThreashold && millis() > lastTimeBeat + timeBeatThreashold) {


    if (debug) {
      println(millis());
      println(level);
      println("trigger");
    }
    beatEllipseSize = 30;
    animateBeatCircle();
    sendTrigger();
    if (sendToResolume) {
      sendOSCToResolume();
    }
    lastTimeBeat = millis();
  }

  fill(255);
  ellipse(width/2, height/2, beatEllipseSize, beatEllipseSize);
}

public void controlEvent(ControlEvent theEvent) {

  if (theEvent.getController().getName().equals("oscClipNr")) {
    clipNr = Integer.parseInt(oscClipNr.getText());
  } else if (theEvent.getController().getName().equals("oscLayerNr")) {
    layerNr = Integer.parseInt(oscLayerNr.getText());
  }
}

void animateBeatCircle() {
  Ani.to(this, 0.2, "beatEllipseSize", 60, Ani.EXPO_OUT);
}

void mousePressed() {
  /* in the following different ways of creating osc messages are shown by example */
  OscMessage myMessage = new OscMessage("/test");

  myMessage.add(123); /* add an int to the osc message */

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation);
}

void sendTrigger() {
  OscMessage myMessage = new OscMessage("/trigger");
  oscP5.send(myMessage, myRemoteLocation);
}

void sendOSCToResolume() {

  OscMessage myMessage = new OscMessage("/layer"+ layerNr + "/clip" + clipNr + "/connect");
  myMessage.add(1);
  oscP5.send(myMessage, ResolumeLocation);
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
}

