import processing.pdf.*;
PShape background;
color bodytext = color(0, 0, 0), 
darkOrange = color(255, 165, 1), 
lightOrange = color(255, 204, 102), 
lightBlue = color(201, 228, 242), 
midBlue = color(96, 175, 215), 
darkBlue = color(10, 132, 193), 
recessionBox = color(200, 226, 241, 180), 
gridLines = color(153), 
peakLine = color(200, 226, 241);
PFont location, data12, scaleNums, basicStatsParFont, basicStatsData, industry, pieStats;
int counter = 0;
int c = counter + 1;
Table counties;

void setup() {
  background = loadShape("blank.svg");
  size(792, 612/*, PDF, "derp.pdf"*/);
  counties = new Table("IEDCountyData.tsv");
  location = createFont("Helvetica Neue Light", 26);
  data12 = createFont("AurulentSansMono-Regular", 24);
  scaleNums = createFont("Helvetica Neue Light", 7);
  basicStatsParFont = createFont("Helvetica Neue Light", 10);
  basicStatsData = createFont("AurulentSansMono-Regular", 10);
  industry = createFont("AurulentSansMono-Regular", 8);
  pieStats = createFont("AurulentSansMono-Regular", 16);
  smooth();
}

void draw() {
  background(255);
  String filename = counties.getString(c, 2);
  beginRecord(PDF, "/Profiles/" + filename + ".pdf");
  shape(background, 0, 0);
  drawData();
  basicStats();
  drawLineGraphs();
  drawBarChart();
  drawPie();

  String countyname = counties.getString(c, 1).toUpperCase();
  String statename = counties.getString(c, 4).toUpperCase();
  textFont(location);
  fill(0, 0, 0);
  text(countyname + ", " + statename, 15, 100);
    endRecord();
    counter+=1;
    c = counter +1;
    println(counter);
    if (frameCount == 3112) {
      exit();
    }
}


void drawData() {
  fill(0, 0, 0);
  //section for 2013 growth rates
  textFont(data12);
  textAlign(LEFT);

  int xOrigin = 15;
  int yOrigin = 167;
  Float exNom12 = counties.getFloat1(c, 36);
  Float exShare12 = counties.getFloat1(c, 40)*100;
  Float exGrowthLT = counties.getFloat1(c, 37)*100;
  Float exGrowthBR = counties.getFloat1(c, 38)*100;
  Float exGrowthAR = counties.getFloat1(c, 39)*100;

  if (exNom12 > 1000) {
    text("$" + nf(exNom12/1000, 0, 1), xOrigin, yOrigin);
    String str12 = nf(exNom12/1000, 0, 1);
    textFont(basicStatsParFont);
    text("Billion", xOrigin + (str12.length()+1)*15, yOrigin);
    textFont(data12);
  }
  else {

    text("$" + nf(exNom12, 0, 1), xOrigin, yOrigin);
    String str12 = nf(exNom12, 0, 1);
    textFont(basicStatsParFont);
    text("Million", xOrigin + (str12.length()+1)*15, yOrigin);
    textFont(data12);
  }
  text(nf(exShare12, 0, 1) + "%", xOrigin +155, yOrigin);
  fill(darkBlue);
  text(nf(exGrowthLT, 0, 1) + "%", xOrigin +155*2, yOrigin);
  text(nf(exGrowthBR, 0, 1) + "%", xOrigin + 155*3, yOrigin);
  text(nf(exGrowthAR, 0, 1) + "%", xOrigin + 155*4, yOrigin);
}
//End drawData

void basicStats() {
  String countyname = counties.getString(c, 1);
  String statename = counties.getString(c, 4);
  String countyGov = " has a county government. ";
  if (counties.getInt1(c, 6)==0) {
    countyGov = " does not have a county government. ";
  }
  String LgMdSm = "small";
  if (counties.getInt1(c, 5)>50000) {
    LgMdSm = "medium-sized";
  }
  if (counties.getInt1(c, 5)>500000) {
    LgMdSm = "large";
  }
  String metroMicro = "not in a metropolitan/micropolitan area.";
  String centralOutlying = "";
  if (counties.getInt1(c, 8)!=0) {
    if (counties.getInt1(c, 9)==1) {
      centralOutlying = ", central";
    }
    else {
      centralOutlying = ", outlying";
    }
    if (counties.getInt1(c, 9)==1) {
      metroMicro = "in the " + counties.getString(c, 7) + " micropolitan area.";
    }
    else {
      metroMicro = "in the " + counties.getString(c, 7) + " metropolitan area.";
    }
  }


  String basicStatsPar = countyname +", "+statename + countyGov;
  String basicStatsPar2 = countyname + " is a " + LgMdSm + centralOutlying + " county " + metroMicro;
  fill(0, 0, 0);
  textFont(basicStatsParFont);
  textLeading(12);
  text(basicStatsPar+"\n\n"+basicStatsPar2, 184, 494, 250, 100);

  textFont(basicStatsData);
  //right aligned data
  textAlign(RIGHT);
  Float pop12 = counties.getFloat1(c, 5);
  Float GDP13 = counties.getFloat1(c, 35);
  Float unem13 = counties.getFloat1(c, 34);
  //POP data
  if (pop12 >=1000000) { 
    text(nf(pop12/1000000, 0, 1)+ " MILLION", 741, 497);
  }
  else {
    text(nfc(pop12, 0), 705, 497);
  }
  //GDP DAta
  if (GDP13 > 1000000000) {
    text("$"+ nf(GDP13/1000000000, 0, 1)+" BILLION", 741, 519);
  }
  else if (GDP13 > 1000000) {
    text("$" + nf(GDP13/1000000, 0, 1) + " MILLION", 741, 519);
  }
  else {
    text("$" + nfc(GDP13, 0), 705, 519);
  }
  //unem data
  text(nf(unem13, 0, 1)+"%", 698, 541);
  //left aligned row names
  textAlign(LEFT);
  text("POPULATION, 2012", 504, 497);
  text("NOMINAL GDP", 504, 519);
  text("UNEMPLOYMENT RATE", 504, 541);
}

void drawLineGraphs() {
  fill(0, 0, 0);
  int graphWidth = 123;
  int graphHeight = 65;
  int beginYear = 2002;
  Float xStep = graphWidth/11.0;
  // Will want to loop over this for each graph
  int g=10;
  Float countyScaled = counties.getFloat1(c, g);
  Float stateScaled = counties.getFloat1(c, g+14);

  int xOrigin = 29;
  int yOrigin = 225;

  //data notes at the top of each graph
  fill(75, 75, 75);
  textFont(scaleNums);
  text("Inflation-adjusted GDP (2002=100)", xOrigin, yOrigin-3);


  //get lowest and highest values for county and state data and compare them
  Float countyLowestValue = 1000000000000000.0;
  Float countyHighestValue = 0.0;
  Float stateLowestValue = 1000000000000000.0;
  Float stateHighestValue = 0.0;

  for (int b=g; b<(g+12); b++) {
    if (counties.getFloat1(c, b) < countyLowestValue) {
      countyLowestValue = counties.getFloat1(c, b);
    }
    if (counties.getFloat1(c, b) > countyHighestValue) {
      countyHighestValue = counties.getFloat1(c, b);
    }
  }
  for (int s=g+12; s<g+24; s++) {
    if (counties.getFloat1(c, s) < stateLowestValue) {
      stateLowestValue = counties.getFloat1(c, s);
    }
    if (counties.getFloat1(c, s) > stateHighestValue) {
      stateHighestValue = counties.getFloat1(c, s);
    }
  }
  Float LowestValueScaled = countyLowestValue*100/countyScaled;
  Float HighestValueScaled = countyHighestValue*100/countyScaled;
  if ((stateLowestValue*100/stateScaled) < LowestValueScaled) {
    LowestValueScaled = stateLowestValue*100/stateScaled;
  }
  if ((stateHighestValue*100/stateScaled) > HighestValueScaled) {
    HighestValueScaled = stateHighestValue*100/stateScaled;
  }
  //set highest and lowest values to 5s
  int HighestValue5Scaled = (int)ceil(HighestValueScaled);
  int LowestValue5Scaled = (int)floor(LowestValueScaled);
  Float range = 1.0*HighestValue5Scaled - LowestValue5Scaled;
  Float yInterval;
  Float yStep;
  Float rangeRatio;
  int stepCount = 5;
  Float translate;
  while (HighestValue5Scaled %5 != 0) {
    HighestValue5Scaled +=1;
  }
  while (LowestValue5Scaled %5 != 0) {
    LowestValue5Scaled -=1;
  }
  //establish the graphs range of values, its ratio of pixels per index increment, and translate it up by 5%
  range = 1.0*HighestValue5Scaled - LowestValue5Scaled;
  //establish oldRange, range, yInterval, and StepCount
  yInterval = 5.0;

  int stepUp = (HighestValue5Scaled-100)/5;
  int stepDown = (100 - LowestValue5Scaled)/5;
  stepCount = stepUp + stepDown;
  int a = 0;
  int[] stepArray = {
    5, 10, 20, 30, 40, 50, 60, 70, 80, 100, 150, 200, 250, 300
  };
  while (stepCount > 6) {
    a++;

    while (HighestValue5Scaled % stepArray[a] != 0) {
      HighestValue5Scaled +=1;
    }
    while (LowestValue5Scaled % stepArray[a] != 0) {
      LowestValue5Scaled -=1;
    }
    stepUp = (HighestValue5Scaled-100)/stepArray[a];
    stepDown = (100 - LowestValue5Scaled)/stepArray[a];
    stepCount = stepUp + stepDown;
    yInterval = 1.0 * stepArray[a];
    range = 1.0*HighestValue5Scaled - LowestValue5Scaled;

    if (stepCount>6) {
      println("ALERT!" + counties.getString(c, 1) + " has a range of " + range);
    }
  }

  yStep = 1.0*graphHeight/(stepCount);
  rangeRatio = (graphHeight / range);
  translate = rangeRatio*(LowestValue5Scaled);

  //test range is divisible by its interval and revalue depending

  /*//Some useful code for figuring out why a graph might be misbehaving
   textFont(location, 12);
   text(LowestValue5Scaled + " - " + HighestValue5Scaled + " : " + range, xOrigin, 150);
   text(yInterval + " : " + stepCount, xOrigin, 170);
   */

  //int countyPeakYear = counties.getInt1(c, g+12) - 2000;
  //int countyTroughYear = counties.getInt1(c, g+13) - 2000;

  //Axes and lines
  strokeWeight(1);
  stroke(gridLines);
  //x axis
  line(xOrigin, yOrigin +graphHeight, xOrigin +graphWidth, yOrigin + graphHeight);
  //y axis
  //line(xOrigin, yOrigin+graphHeight, xOrigin, yOrigin); 

  //Graph horizontal lines setup
  for (int z=1; z < stepCount+2; z++) {
    if (z==6 & g==63) {
      break;
    }
    Float currentyStep = yStep*(z-1) + yOrigin;
    if (z!=stepCount+1) {
      line(xOrigin, currentyStep, graphWidth + xOrigin, currentyStep);
    }
    //Code for creating automatic 5 step labels, evenly spaced
    Float stepText = HighestValue5Scaled - yInterval*(z-1);
    String stepTextRnd = nf(stepText, 0, 0 );
    if (g==65) {
      stepText = -1*(currentyStep-yOrigin-translate-graphHeight)/rangeRatio;
      stepTextRnd = nf(stepText, 0, 1) + "%";
    }
    textFont(scaleNums);
    fill(75, 75, 75);
    textAlign(RIGHT);
    text(stepTextRnd, xOrigin-3, currentyStep+2);
    textAlign(LEFT);
    //End evenly spaced labels
  } 

  //looping over values to graph  
  for (int r = g+1; r < g+12; r++) {  
    //get county values
    Float countyPrevNumber = counties.getFloat1(c, r-1);
    Float countyNumber = counties.getFloat1(c, r);
    //get state values
    Float statePrevNumber = counties.getFloat1(c, r+11);
    Float stateNumber = counties.getFloat1(c, r+12);

    //scale the county values
    Float countyPrevNumberScaled = -1*(rangeRatio*((countyPrevNumber *100) / countyScaled))+yOrigin + translate + graphHeight ;
    Float countyNumberScaled =  -1*(rangeRatio*((countyNumber *100)/ countyScaled))+yOrigin + translate + graphHeight;
    //scale the state values
    Float statePrevNumberScaled = -1*(rangeRatio*((statePrevNumber *100) / stateScaled))+yOrigin + translate + graphHeight ;
    Float stateNumberScaled =  -1*(rangeRatio*((stateNumber *100)/ stateScaled))+yOrigin + translate + graphHeight;

    //establish which x position we are one depending on the year; (r-38)==2002
    Float prevStep = xStep * (r-(g+1)) + xOrigin;
    Float currentStep = xStep * (r-g) + xOrigin;

    stroke(gridLines);
    strokeWeight(1);
    //x-axis hashmarks
    if (r==(g+1)) {
      line(prevStep, yOrigin + graphHeight+2, prevStep, yOrigin+graphHeight);
    }
    line(currentStep, yOrigin + graphHeight+2, currentStep, yOrigin+graphHeight);
    // x-axis labels
    textFont(scaleNums);
    fill(75, 75, 75);
    int year = 2 + (r-(g+1));
    String yearString = "'0"+year;
    if (year < 10) {
      yearString = "'0"+year;
    }
    else {
      yearString = "'"+year;
    }
    text(yearString, prevStep-5, yOrigin+graphHeight+10);
    if (year ==12) {
      int year13 = 13;
      String year13String = "'" + year13;
      text(year13String, currentStep-5, yOrigin+graphHeight+10);
    }
    //x-axis label
    fill(gridLines);
    text("year", xOrigin+115, yOrigin+graphHeight + 18);
    /*      if (countyPeakYear!=countyTroughYear) {
     //county peak value line
     
     if (year==countyPeakYear) {
     stroke(peakLine);
     strokeWeight(2);
     line(prevStep, yOrigin +graphHeight, prevStep, yOrigin);
     strokeWeight(1);
     }
     //county trough value rectange
     if (year==countyTroughYear) {
     fill(recessionBox);
     stroke(255, 255, 255, 0);
     strokeWeight(0);
     rect(xOrigin + xStep*(r-(g+1)), yOrigin, xStep*11 - xStep*(r-(g+1)), graphHeight);
     fill(0);
     strokeWeight(1);
     }
     
     }
     */
    //draw the state, then county (on top) trend-line  
    strokeWeight(2);
    stroke(midBlue);
    line(prevStep, statePrevNumberScaled, currentStep, stateNumberScaled);
    stroke(darkOrange);
    line(prevStep, countyPrevNumberScaled, currentStep, countyNumberScaled);
    strokeWeight(0);
  }
  //End for loop for individual graph
}
//End drawLineGraphs

void drawBarChart() {
  int xOrigin = 170;
  int yOrigin = 232;
  int barGraphWidth = 297;
  int barHeight = 20;
  stroke(255);
  strokeWeight(0);
  //bar 1
  String bar1Cat = counties.getString(c, 62).toUpperCase();
  Float bar1Amt = counties.getFloat1(c, 63);
  Float bar1Share = counties.getFloat1(c, 64)*100;
  int bar1Width = barGraphWidth;

  textFont(industry);
  fill(0, 0, 0);
  if (bar1Amt > 1000) {
    text(bar1Cat + " - $"+ nf(bar1Amt/1000, 0, 1) + " BILLION" + " - " + nf(bar1Share, 0, 1) + "%", xOrigin, yOrigin-2);
  }
  else {
    text(bar1Cat + " - $"+ nf(bar1Amt, 0, 1) + " MILLION" + " - " + nf(bar1Share, 0, 1) + "%", xOrigin, yOrigin-2);
  }
  fill(midBlue);

  rect(xOrigin, yOrigin+1, bar1Width, barHeight);
  fill(0, 0, 0);
  //set scale equal to the largest share divided by barMaxWidth
  Float scale = counties.getFloat1(c, 64)*100/barGraphWidth;
  //scale the rest of the bars as a proportion of the initial bar
  //distance between top of bar1 and top of bar2 
  int yStep = 41;

  //Loop over bars 2-5
  for (int i=65; i<77; i+=3) {
    //bar 2

    String bar2Cat = counties.getString(c, i).toUpperCase();
    Float bar2Amt = counties.getFloat1(c, i+1);
    Float bar2Share = counties.getFloat1(c, i+2)*100;
    Float bar2Width = bar2Share / scale;

    textFont(industry);
    fill(0, 0, 0);
    if (bar2Amt > 1000) {
      text(bar2Cat + " - $"+ nf(bar2Amt/1000, 0, 1) + " BILLION" + " - " + nf(bar2Share, 0, 1) + "%", xOrigin, yOrigin+yStep-2);
    }
    else {
      text(bar2Cat + " - $"+ nf(bar2Amt, 0, 1) + " MILLION" + " - " + nf(bar2Share, 0, 1) + "%", xOrigin, yOrigin+yStep-2);
    }
    fill(midBlue);

    rect(xOrigin, yOrigin+yStep+1, bar2Width, barHeight);
    yStep += 41;
    //bar 3
    //bar 4
    //bar 5
  }
}
//End drawBarChart
void drawPie() {
  float diameter = 124;
  int centerX = 558;
  int centerY = 310;
  noStroke();
  
  float goodsShare12 = counties.getFloat1(c, 42)*100;
  float servShare12 = counties.getFloat1(c, 41)*100;
  float stategoodsShare12 = counties.getFloat1(c, 44)*100;
  float stateservShare12 = counties.getFloat1(c, 45)*100;
  
  fill(0);
  textFont(pieStats);
  text(nf(goodsShare12,0,1) + "%", 575, 391);
  text(nf(servShare12,0,1) + "%", 575, 415);
  
  text(nf(stategoodsShare12,0,1) + "%", 720, 391);
  text(nf(stateservShare12,0,1) + "%", 720, 415);

  for (int s=46; s<55 ; s+=8) {
    float lastAng = radians(270);
    if(s==54){
      centerX = 702;
    }
    for (int i=s; i<s+4; i++) {
      float pieValues = counties.getFloat1(c, i);
      float pieMapped = map(pieValues, 0, 1, 0, 360);

      switch(i) {
      case 46:
      case 54: 
        fill(darkBlue);
        break;
      case 47:
      case 55:
        fill(lightBlue);
        break;
      case 48:
      case 56:
        fill(midBlue);
        break;
      case 49:
      case 57:
        fill(darkOrange);
        break;
      }

      arc(centerX, centerY, diameter, diameter, lastAng, lastAng + radians(pieMapped));
      lastAng += radians(pieMapped);
    }
  }
}

void keyPressed() {
  if (keyCode == LEFT) {
    counter -= 1;
  } 
  else if (keyCode == RIGHT) {
    counter += 1;
  } 
  else {
    counter = counter;
  }

  if (counter < 0) {
    counter = 3112;
  }

  if (counter > 3112) {
    counter = 0;
  }
  c = counter + 1;
  println(counter);
}

