int x=0;
float yNoise=0;
int windowSize = 5;
float previousfilteredY;
float filteredY;

int bigWindow = 20;
float bigpreviousfilteredY;
float bigfilteredY;


float [] yPositions = {};
float[] bigyPositions={};

void setup() {
  noiseSeed(0);
  background(255);
  size(500, 600);
  fill(0);
  text("unfiltered", 20, 90);
  text("filtered, windowsize 5", 20, 190);
  text("filtered, windowsize 20", 20, 290);
}

void draw() {
  //add current y Position to array
  yPositions = append(yPositions, noise(frameCount));
  bigyPositions = append(bigyPositions, noise(frameCount));
  println(yPositions);
  //unfiltered
  line(x, 100+noise(frameCount)*10, x, 100+noise(frameCount-1)*10);
  //filtered  
  if (frameCount > windowSize) {
    previousfilteredY = median(subset(yPositions, 1));
    filteredY = median(yPositions);
    yPositions = subset(yPositions, 1);

    line(x, 200+filteredY*10, x, 200+previousfilteredY*10);
  }
  //filtered larger window
  if (frameCount > bigWindow) {
    bigpreviousfilteredY = median(subset(bigyPositions, 1));
    bigfilteredY = median(bigyPositions);
    bigyPositions = subset(bigyPositions, 1);

    line(x, 300+bigfilteredY*10, x, 300+bigpreviousfilteredY*10);
  }

  x++;
}


//returns median of an array of floats
float median(float[] signal) {
  //sort
  signal = sort(signal);
  float med=0;
  //if odd
  if (signal.length%2 != 0) { 
    int index = (signal.length-1)/2;
    med = signal[index];
    //if even
  } else if (signal.length%2 == 0) { 
    int a= signal.length/2-1;
    int b= signal.length/2;
    med = (signal[a]+signal[b])/2;
  } 
  return(med);
}