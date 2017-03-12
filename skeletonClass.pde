import controlP5.*;

import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;

import shapes3d.*;
import shapes3d.animation.*;
import shapes3d.utils.*;

import oscP5.*;
import netP5.*;


PFont textFont;
int currentStim = 0;
String [] stimList = {"To Drive", "To Eat", "To Mix", "To Clean", "To put on a seatbelt", "To carry",
                      "To play an accordion", "To use a rolling pin", "To Throw", "To pull", "To put on a hat",
                      "To lift weights", "To row", "To push", "to put on a jacket", "To drum", "To cycle", 
                      "To shake", "To hit", "To brush hair", "To brush teeth", "To zip up a jacket",
                      "To screw in a lightbulb", "To paint", "To climb", "To saw", "To swim", "To give", 
                      "To open the curtains", "To open a door", "To tear something", "To play the piano", 
                      "To bounce a ball"};
                      
ControlP5 cp5;
ControlFont cf;


OscP5 oscKinect;

PGraphics leftViewport;
PGraphics rightViewPort;

SkeletonAnimation skeleton1;
SkeletonMonitor skeleton2;

int currentView = 0;

//float r= .5;

void setup() {
  size(2000,1000,P3D);
  textFont = loadFont("Calibri.vlw");
  textSize(30);
  
  cp5 = new ControlP5(this);
  cf = new ControlFont(textFont,30);

  cp5.addScrollableList("dropdown")
    .setPosition(50,50)
    .setColorBackground(color(200,200,200))
    .setColorValueLabel(color(0,0,0))
    .setSize(350,800)
    .setBarHeight(40)
    .setItemHeight(40)
    .addItems(stimList)
    .setType(ControlP5.LIST)
    .setFont(cf);
  
  
  oscKinect = new OscP5(this, 12345);                      //listening for incoming OSC messages at port 12345
  
 
  
  leftViewport = createGraphics(500,500,P3D);
  rightViewPort = createGraphics(500,500,P3D);

  //skeleton constructor arguments: 
  //PApplet, skeletonType, skeletonOrigin, scalingFactor, yRotation
  skeleton1 = new SkeletonAnimation(this,new PVector(width*.5,height*.25,0),"Gestures1.txt",700,0); 
  skeleton2 = new SkeletonMonitor(this,new PVector(width*.5,height*.25,0),700,0);
  
  skeleton2.createSkeletonFile("Gestures4.txt"); //creates data file
  
}

void draw() {
  background(255);
  lights();
  directionalLight(255,255,255,0,-1,0);
  
  switch(currentView) {
    case 0:
  //draw skeleton 1 (Animation)
   skeleton1.drawViewport(leftViewport);
   image(leftViewport,0,0);
   break;

   case 1:
  //draw skeleton 2 (Monitor)
   skeleton2.drawViewport(rightViewPort);
   image(rightViewPort,0,0);
  //record skeleton2 
   skeleton2.recordSkeleton(skeleton2.p);
   break;
  }
  
}



void oscEvent(OscMessage msg) {
  //sends incoming kinect data to filter function. 
  for (int i = 0; i < skeleton1.jointNames.length; i++) {
    
    if (msg.checkAddrPattern("/skeleton/"+skeleton1.jointNames[i])) { //if message address matches a jointName

         float x = (msg.get(0).floatValue())*skeleton1.sF; 
         float y = (msg.get(1).floatValue())*skeleton1.sF;
         float z = (msg.get(2).floatValue())*skeleton1.sF;
         
         String trackingState = msg.get(3).stringValue();
         
         //- y and -z values because kinect coordinate system is right-handed
         //but processing's coordinate system is left-handed
         
         skeleton2.filterJoint(skeleton2.jointNames[i],x,-y,-z,trackingState);
    }
  }
}


//listens for changes to control p5 object dropdown list of stims
void ControlEvent(ControlEvent theEvent) {
  //skeleton1.loadAnimationData(stimList[int(theEvent.getController().getValue())]);
  
  skeleton2.createSkeletonFile((theEvent.getController().getValue()+".txt").toString());
}


//void mousePressed() {
//  if(currentView == 0) {
//    currentView = 1;
//  } else if (currentView == 1) {
//    currentView = 0;
//    currentStim+=1;
//  }
//}