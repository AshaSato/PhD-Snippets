class SkeletonAnimation {

  String fileName;
  Table skelData;
  int skelRow;

  float jointRad = 15; 
  float boneRad = 10;

  color jointFill =#C11414;
  color boneFill = #FFCD00;

  PVector skellyOrigin;
  PVector spineShoulder = new PVector(0, 0, 0);

  float yRot;  //rotation on Y axis
  int sF;      //scaling factor

  //JOINT NAMES
  String [] jointNames = { "Head", "SpineShoulder", "SpineMid", 
    "ShoulderLeft", "ShoulderRight", 
    "ElbowLeft", "ElbowRight", 
    "WristLeft", "WristRight", 
    "HipLeft", "HipRight"};

  //JOINTS
  Ellipsoid origin, spineMid, head;
  Ellipsoid shoulderLeft, shoulderRight;
  Ellipsoid elbowLeft, elbowRight;
  Ellipsoid wristLeft, wristRight;
  Ellipsoid hipLeft, hipRight;

  //BONES
  Tube neck;
  Tube leftCollar, rightCollar;
  Tube leftArm, rightArm;
  Tube leftForearm, rightForearm;
  Tube spineUpper, sideLeft, sideRight, hipBase;  



  ///////////////////////////
  // CONSTRUCTOR
  //////////////////////////


  SkeletonAnimation(PApplet applet, PVector SkellyOrigin, String fileName, int SF, float YRot) {

    //load data from file 
    skelData = loadTable(fileName, "header,csv");
    skelRow = 0; 

    //scaling factor
    sF = SF;

    //JOINTS---------------------------------------------------------------------------------------------------------
    //---------------------------------------------------------------------------------------------------------------
    skellyOrigin = SkellyOrigin;
    origin = new Ellipsoid(applet, 16, 16);
    spineMid = new Ellipsoid(applet, 16, 16);
    head = new Ellipsoid(applet, 16, 16);
    shoulderLeft = new Ellipsoid(applet, 16, 16);
    shoulderRight = new Ellipsoid(applet, 16, 16);
    elbowLeft = new Ellipsoid(applet, 16, 16);
    elbowRight = new Ellipsoid(applet, 16, 16);
    wristLeft = new Ellipsoid(applet, 16, 16);
    wristRight = new Ellipsoid(applet, 16, 16);  
    hipLeft = new Ellipsoid(applet, 16, 16);
    hipRight = new Ellipsoid(applet, 16, 16);

    //set joint sizes;
    origin.setRadius(jointRad);
    spineMid.setRadius(jointRad);
    head.setRadius(50, 70, 50);

    shoulderLeft.setRadius(jointRad);
    shoulderRight.setRadius(jointRad);

    elbowLeft.setRadius(jointRad);
    elbowRight.setRadius(jointRad);

    wristLeft.setRadius(jointRad);
    wristRight.setRadius(jointRad);

    hipLeft.setRadius(jointRad);
    hipRight.setRadius(jointRad);

    //add joints to the skeleton
    origin.addShape(head);
    origin.addShape(spineMid);
    origin.addShape(shoulderLeft);
    origin.addShape(shoulderRight);
    origin.addShape(elbowLeft);
    origin.addShape(elbowRight);
    origin.addShape(wristRight);
    origin.addShape(wristLeft);
    origin.addShape(hipLeft);
    origin.addShape(hipRight);


    //BONES-----------------------------------------------------------------------------------------------
    //---------------------------------------------------------------------------------------------------------------
    neck = new Tube(applet, 16, 16);
    leftCollar = new Tube(applet, 16, 16);
    rightCollar = new Tube(applet, 16, 16);
    leftArm = new Tube(applet, 16, 16);
    rightArm = new Tube(applet, 16, 16);
    leftForearm = new Tube(applet, 16, 16);
    rightForearm = new Tube(applet, 16, 16);
    spineUpper = new Tube(applet, 16, 16);
    sideLeft = new Tube(applet, 16, 16);
    sideRight = new Tube(applet, 16, 16);
    hipBase = new Tube(applet, 16, 16);

    neck.setSize(boneRad, boneRad, boneRad, boneRad);
    leftCollar.setSize(boneRad, boneRad, boneRad, boneRad);
    rightCollar.setSize(boneRad, boneRad, boneRad, boneRad);
    leftArm.setSize(boneRad, boneRad, boneRad, boneRad);
    rightArm.setSize(boneRad, boneRad, boneRad, boneRad);
    leftForearm.setSize(boneRad, boneRad, boneRad, boneRad);
    rightForearm.setSize(boneRad, boneRad, boneRad, boneRad);
    spineUpper.setSize(boneRad, boneRad, boneRad, boneRad);
    sideLeft.setSize(boneRad, boneRad, boneRad, boneRad);
    sideRight.setSize(boneRad, boneRad, boneRad, boneRad);
    hipBase.setSize(boneRad, boneRad, boneRad, boneRad);

    origin.addShape(neck);
    origin.addShape(leftCollar);
    origin.addShape(rightCollar);
    origin.addShape(leftArm);
    origin.addShape(rightArm);
    origin.addShape(leftForearm);
    origin.addShape(rightForearm);
    origin.addShape(spineUpper);
    origin.addShape(sideLeft);
    origin.addShape(sideRight);
    origin.addShape(hipBase);


    //rotate whole skeleton:
    origin.moveTo(skellyOrigin);
    origin.rotateBy(0, YRot, 0);

    //set fill for joints and bones
    origin.fill(jointFill);
    head.fill(jointFill);
    spineMid.fill(jointFill);
    shoulderLeft.fill(jointFill);
    shoulderRight.fill(jointFill);
    elbowLeft.fill(jointFill);
    elbowRight.fill(jointFill);
    wristLeft.fill(jointFill);
    wristRight.fill(jointFill);
    hipLeft.fill(jointFill);
    hipRight.fill(jointFill);

    neck.fill(boneFill);
    leftCollar.fill(boneFill);
    rightCollar.fill(boneFill);
    leftArm.fill(boneFill);
    rightArm.fill(boneFill);
    leftForearm.fill(boneFill);
    rightForearm.fill(boneFill);
    spineUpper.fill(boneFill);
    sideLeft.fill(boneFill);
    sideRight.fill(boneFill);
    hipBase.fill(boneFill);
  }  //end skeleton constructor


  ///////////////////////////
  // DRAW VIEWPORT
  //////////////////////////

  //draws a viewport with a Y rotation
  void drawViewport(PGraphics viewport) {
    viewport.beginDraw();
    viewport.clear();
    skellyAnimationDraw();
    viewport.endDraw();
  }


  ///////////////////////////
  // DRAW SKELETON
  //////////////////////////

  //animated skeleton doesn't need filtering because the saved values are already filtered. 


  void skellyAnimationDraw() { 
    animateFrame();
    origin.draw(); //draws origin joint and all child joints including tubes?
   // drawBones();

    if (skelRow == skelData.getRowCount()-1) { //loop at end of file
      skelRow = 0;
    } else {
      skelRow +=1;
    }
  }

  
  void animateFrame() {
    //read in joint positions from DataFile
  this.head.moveTo(skelData.getFloat(skelRow,"HeadX"),skelData.getFloat(skelRow,"HeadY"),skelData.getFloat(skelRow,"HeadZ"));
  this.spineMid.moveTo(skelData.getFloat(skelRow,"SpineMidX"),skelData.getFloat(skelRow,"SpineMidY"),skelData.getFloat(skelRow,"HeadZ"));
  this.shoulderLeft.moveTo(skelData.getFloat(skelRow,"ShoulderLeftX"),skelData.getFloat(skelRow,"ShoulderLeftY"), skelData.getFloat(skelRow,"ShoulderLeftZ"));
  this.shoulderRight.moveTo(skelData.getFloat(skelRow,"ShoulderRightX"),skelData.getFloat(skelRow,"ShoulderRightY"), skelData.getFloat(skelRow,"ShoulderRightZ"));
  this.elbowLeft.moveTo(skelData.getFloat(skelRow,"ElbowLeftX"),skelData.getFloat(skelRow,"ElbowLeftY"), skelData.getFloat(skelRow,"ElbowLeftZ"));
  this.elbowRight.moveTo(skelData.getFloat(skelRow,"ElbowRightX"),skelData.getFloat(skelRow,"ElbowRightY"), skelData.getFloat(skelRow,"ElbowRightZ"));
  this.wristLeft.moveTo(skelData.getFloat(skelRow,"WristLeftX"),skelData.getFloat(skelRow,"WristLeftY"), skelData.getFloat(skelRow,"WristLeftZ"));
  this.wristRight.moveTo(skelData.getFloat(skelRow,"WristRightX"),skelData.getFloat(skelRow,"WristRightY"), skelData.getFloat(skelRow,"WristRightZ"));
  this.hipLeft.moveTo(skelData.getFloat(skelRow,"HipLeftX"),skelData.getFloat(skelRow,"HipLeftY"), skelData.getFloat(skelRow,"HipLeftZ"));
  this.hipRight.moveTo(skelData.getFloat(skelRow,"HipRightX"),skelData.getFloat(skelRow,"HipRightY"), skelData.getFloat(skelRow,"HipRightZ"));
  
  //move bones
  try{
    this.neck.setWorldPos(spineShoulder, head.getPosVec());
  } catch(Exception e) {
    println(e);
  }
    this.leftCollar.setWorldPos(spineShoulder, shoulderLeft.getPosVec());
    this.rightCollar.setWorldPos(spineShoulder, shoulderRight.getPosVec());
    this.leftArm.setWorldPos(shoulderLeft.getPosVec(), elbowLeft.getPosVec());
    this.rightArm.setWorldPos(shoulderRight.getPosVec(), elbowRight.getPosVec());
    this.leftForearm.setWorldPos(elbowLeft.getPosVec(), wristLeft.getPosVec());
    this.rightForearm.setWorldPos(elbowRight.getPosVec(), wristRight.getPosVec());
    this.spineUpper.setWorldPos(spineShoulder, spineMid.getPosVec());
    this.sideLeft.setWorldPos(spineMid.getPosVec(), hipLeft.getPosVec());
    this.sideRight.setWorldPos(spineMid.getPosVec(), hipRight.getPosVec());
    this.hipBase.setWorldPos(hipLeft.getPosVec(), hipRight.getPosVec());
  }
  
  void loadAnimationData(String fileName) {
    skelData = loadTable(fileName, "header,csv");
    skelRow = 0;
  
  }
  
} //end of skeleton Animation class!