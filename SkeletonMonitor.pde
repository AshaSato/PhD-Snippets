class SkeletonMonitor {

  float jointRad = 15; 
  float boneRad = 10;
  float handRad = 20;

  color jointFill =#D30CEA;
  color boneFill = #61DEAF;

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

  //FILTER VARIABLES

  int windowSize = 3;

  //ArrayLists to contain joint position history for filtered joints
  ArrayList <PVector> shoulderLeftWindow;
  ArrayList <PVector> shoulderRightWindow;
  ArrayList <PVector> elbowLeftWindow;
  ArrayList <PVector> elbowRightWindow;
  ArrayList <PVector> wristLeftWindow;
  ArrayList <PVector> wristRightWindow;

  //PVectors to hold current (filtered) position
  PVector fShoulderLeft;
  PVector fShoulderRight;
  PVector fElbowLeft;
  PVector fElbowRight;
  PVector fWristLeft;
  PVector fWristRight;

  //PVectors to hold filtered position at previous frame
  PVector pShoulderLeft;
  PVector pShoulderRight;
  PVector pElbowLeft;
  PVector pElbowRight;
  PVector pWristLeft;
  PVector pWristRight;
  
 PrintWriter p;

  ///////////////////////////
  // CONSTRUCTOR
  //////////////////////////


  SkeletonMonitor(PApplet applet, PVector SkellyOrigin, int SF, float YRot) {
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

    wristLeft.setRadius(handRad);
    wristRight.setRadius(handRad);

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


    ///FILTER
    //initialize filter history arraylists

    shoulderLeftWindow = new ArrayList<PVector>();
    shoulderRightWindow = new ArrayList<PVector>();
    elbowLeftWindow = new ArrayList<PVector>();
    elbowRightWindow = new ArrayList<PVector>();
    wristLeftWindow = new ArrayList<PVector>();
    wristRightWindow = new ArrayList<PVector>();
  }  //end skeleton constructor



  ///////////////////////////
  // FILTER FUNCTIONS
  //////////////////////////

  float median(float[] signal) {
    //sort
    signal = sort(signal);
    float med=0;
    //if odd, median is value indexed at length-1/2
    if (signal.length%2 != 0) { 
      int index = (signal.length-1)/2;
      med = signal[index];
      //if even, median s average of values indexed at length/2-1 and length/2
    } else if (signal.length%2 == 0) { 
      int a= signal.length/2-1;
      int b= signal.length/2;
      med = (signal[a]+signal[b])/2;
    } 
    return(med);
  }


  PVector medianPVector(ArrayList<PVector> pVArray) {
    //float arrays to hold x, y and z windows
    float [] x = {};
    float [] y = {};
    float [] z = {};

    //put x y and z values from PVectors into x,y,z arrays
    for (PVector pV : pVArray) {
      x = append(x, pV.x);
      y = append(y, pV.y);
      z = append(z, pV.z);
    }
    //median values from those lists
    float xmed = median(x);
    float ymed = median(y);
    float zmed = median(z);

    PVector medP = new PVector(xmed, ymed, zmed);
    return(medP);
  }




  void filterJoint (String jointName, float x, float y, float z, String trackingState) {
    //For non-filtered joints, pass values directly to updateJoints()
        if (jointName == "Head") {
      head.moveTo(x, y, z);
    } else if (jointName == "SpineMid") {
      spineMid.moveTo(x, y, z);
    } else if (jointName == "HipLeft") {
      hipLeft.moveTo(x, y, z);
    } else if (jointName == "HipRight") {
      hipRight.moveTo(x, y, z);
    }

    //for filtered joints, update the relevant Filter Array
    if (jointName == "ShoulderLeft") {
      shoulderLeftWindow.add(new PVector(x, y, z));
            //if the filterWindow has reached the windowSize
      if (shoulderLeftWindow.size()>windowSize) { 
        //get median filtered position
        fShoulderLeft = medianPVector(shoulderLeftWindow);
        //pass the filtered values to the updateJoints function 
        updateJoint(jointName, fShoulderLeft.x, fShoulderLeft.y, fShoulderLeft.z, trackingState);
        //and remove the first item from the Window (it's a moving window)
        shoulderLeftWindow.remove(0);
      }
    } else if (jointName == "ShoulderRight") { //and so on 
      shoulderRightWindow.add(new PVector(x, y, z));
      if (shoulderRightWindow.size()>windowSize) { 
        fShoulderRight = medianPVector(shoulderRightWindow);
        updateJoint(jointName, fShoulderRight.x, fShoulderRight.y, fShoulderRight.z,trackingState);
        shoulderRightWindow.remove(0);
      }
    } else if (jointName == "ElbowLeft") {
      elbowLeftWindow.add(new PVector(x, y, z));
      if (elbowLeftWindow.size()>windowSize) { 
        fElbowLeft = medianPVector(elbowLeftWindow);
        updateJoint(jointName, fElbowLeft.x, fElbowLeft.y, fElbowLeft.z,trackingState);
        elbowLeftWindow.remove(0);
      }
    } else if (jointName == "ElbowRight") {
      elbowRightWindow.add(new PVector(x, y, z));
        if (elbowRightWindow.size()>windowSize) { 
        fElbowRight = medianPVector(elbowRightWindow);
        updateJoint(jointName, fElbowRight.x, fElbowRight.y, fElbowRight.z,trackingState);
        elbowRightWindow.remove(0);
      }
    } else if (jointName == "WristLeft") {
      wristLeftWindow.add(new PVector(x, y, z));
            if (wristLeftWindow.size()>windowSize) { 
        fWristLeft = medianPVector(wristLeftWindow);
        updateJoint(jointName, fWristLeft.x, fWristLeft.y, fWristLeft.z,trackingState);
        wristLeftWindow.remove(0);
      }
    } else if (jointName == "WristRight") {
      wristRightWindow.add(new PVector(x, y, z));
         if (wristRightWindow.size()>windowSize) { 
        fWristRight = medianPVector(wristRightWindow);
        updateJoint(jointName, fWristRight.x, fWristRight.y, fWristRight.z,trackingState);
        wristRightWindow.remove(0);
      }
    }
  }


  ///////////////////////////
  // DRAW VIEWPORT
  //////////////////////////

  //draws a viewport with a Y rotation
  void drawViewport(PGraphics viewport) {
    viewport.beginDraw();
    viewport.clear();
    skellyMonitorDraw();
    viewport.endDraw();
  }


  ///////////////////////////
  // DRAW SKELETON
  //////////////////////////

  void skellyMonitorDraw() { 
    origin.moveTo(skellyOrigin);
    origin.rotateBy(0, yRot, 0);
    drawBones();
    origin.draw(); //draws origin joint and all child joints including tubes?
  }

  void drawBones() {
   try{
    neck.setWorldPos(spineShoulder, head.getPosVec());
   } catch(Exception e) {
     println(e);
   }
    leftCollar.setWorldPos(spineShoulder, shoulderLeft.getPosVec());
    rightCollar.setWorldPos(spineShoulder, shoulderRight.getPosVec());
    leftArm.setWorldPos(shoulderLeft.getPosVec(), elbowLeft.getPosVec());
    rightArm.setWorldPos(shoulderRight.getPosVec(), elbowRight.getPosVec());
    leftForearm.setWorldPos(elbowLeft.getPosVec(), wristLeft.getPosVec());
    rightForearm.setWorldPos(elbowRight.getPosVec(), wristRight.getPosVec());
    spineUpper.setWorldPos(spineShoulder, spineMid.getPosVec());
    sideLeft.setWorldPos(spineMid.getPosVec(), hipLeft.getPosVec());
    sideRight.setWorldPos(spineMid.getPosVec(), hipRight.getPosVec());
    hipBase.setWorldPos(hipLeft.getPosVec(), hipRight.getPosVec());
  }


  ///////////////////////////
  // UPDATE JOINT
  //////////////////////////

  //updates a single joint
  void updateJoint(String jointName, float x, float y, float z,String trackingState) {
    if (jointName == "Head") {
      head.moveTo(x, y, z);
    } else if (jointName == "SpineMid") {
      spineMid.moveTo(x, y, z);
    } else if (jointName == "ShoulderLeft") {
      shoulderLeft.moveTo(x, y, z);
    } else if (jointName == "ShoulderRight") {
      shoulderRight.moveTo(x, y, z);
    } else if (jointName == "ElbowLeft") {
      elbowLeft.moveTo(x, y, z);
    } else if (jointName == "ElbowRight") {
      elbowRight.moveTo(x, y, z);
    } else if (jointName == "WristLeft") {
      wristLeft.moveTo(x, y, z);
    } else if (jointName == "WristRight") {
      wristRight.moveTo(x, y, z);
    } else if (jointName == "HipLeft") {
      hipLeft.moveTo(x, y, z);
    } else if (jointName == "HipRight") {
      hipRight.moveTo(x, y, z);
  
    }
  }//end of update joint function





  ///////////////////////////
  //  RECORD SKELETON
  //////////////////////////

  void createSkeletonFile(String fileName) {
      //header  
    p = createWriter(fileName);  
    p.println("SpineShoulderX,SpineShoulderY,SpineShoulderZ,"
              +"HeadX,HeadY,HeadZ,"
              +"SpineMidX,SpineMidY,SpineMidZ,"
              +"ShoulderLeftX,ShoulderLeftY,ShoulderLeftZ,"
              +"ShoulderRightX,ShoulderRightY,ShoulderRightZ,"
              +"ElbowLeftX,ElbowLeftY,ElbowLeftZ,"
              +"ElbowRightX,ElbowRightY,ElbowRightZ,"
              +"WristLeftX,WristLeftY,WristLeftZ,"
              +"WristRightX,WristRightY,WristRightZ,"
              +"HipLeftX,HipLeftY,HipLeftZ,"
              +"HipRightX,HipRightY,HipRightZ,");
  }

  void recordSkeleton(PrintWriter p) {
    p.println(spineShoulder.x+","+spineShoulder.y+","+spineShoulder.z+","
              +head.getPosVec().x+","+head.getPosVec().y+","+head.getPosVec().z+","
              +spineMid.getPosVec().x+","+spineMid.getPosVec().y+","+spineMid.getPosVec().z+","
              +shoulderLeft.getPosVec().x+","+shoulderLeft.getPosVec().y+","+shoulderLeft.getPosVec().z+","
              +shoulderRight.getPosVec().x+","+shoulderRight.getPosVec().y+","+shoulderRight.getPosVec().z+","
              +elbowLeft.getPosVec().x+","+elbowLeft.getPosVec().y+","+elbowLeft.getPosVec().z+","
              +elbowRight.getPosVec().x+","+elbowRight.getPosVec().y+","+elbowRight.getPosVec().z+","
              +wristLeft.getPosVec().x+","+wristLeft.getPosVec().y+","+wristLeft.getPosVec().z+","
              +wristRight.getPosVec().x+","+wristRight.getPosVec().y+","+wristRight.getPosVec().z+","
              +hipLeft.getPosVec().x+","+hipLeft.getPosVec().y+","+hipLeft.getPosVec().z+","
              +hipRight.getPosVec().x+","+hipRight.getPosVec().y+","+hipRight.getPosVec().z);
  }
  
} //end of skeleton Monitor class!