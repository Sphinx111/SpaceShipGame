import java.text.DecimalFormat;

class UI_Panel {
  
  private DecimalFormat df2 = new DecimalFormat(".##");
  private DecimalFormat df1 = new DecimalFormat("#,###,###.##");
  dropDownMenu activeDropdown;
  
  //constructor runs once at sketch setup
  UI_Panel() {
    setupUIControls();
  }
  
  void show() {
    drawUIBoxes();
    drawResourceElements();
    drawPopulationElements();
    drawUIControls();
    updateUIControls();
  }
  
  //Draw static bounding boxes for UI elements
  public int uiHeight = 80;
  
  void drawUIBoxes() {
    fill(70);
    stroke(0);
    rect(0,0,width,uiHeight);
  }
  
  /*  UI Controls set up as sliders
      
      
  */  
  
  HScrollbar hs1;
  HScrollbar hs2;
  HScrollbar hs3;
  int scrollbarX = 600;
  int scrollbar1Y = 8;
  int scrollbar2Y = 28;
  int scrollbar3Y = 48;
  int scrollbarWidth = 400;
  double scroll1Ratio = 0;
  double scroll2Ratio = 0;
  double scroll3Ratio = 0;
  
  void setupUIControls() {
   hs1 = new HScrollbar(scrollbarX, scrollbar1Y, scrollbarWidth, 16, 16);
   hs2 = new HScrollbar(scrollbarX, scrollbar2Y, scrollbarWidth, 16, 16);
   hs2.newspos = scrollbarX + (scrollbarWidth / 2);
   hs3 = new HScrollbar(scrollbarX, scrollbar3Y, scrollbarWidth, 16, 16); 
   hs3.newspos = scrollbarX + (scrollbarWidth / 2);
  }
  
  //draw UI controls

  void drawUIControls() {
    fill(20);
    textSize(12);
    //text("Population: ", scrollbarX-60,scrollbar1Y+2);
    //text("" + df2.format(scroll1Ratio), scrollbarX + scrollbarWidth, scrollbar1Y+2);
    //hs1.display();
    fill(20);
    text(df2.format((100-(100*hs2.getPos())))+ "% Engines < ", scrollbarX-120,scrollbar2Y+2);
    text("> Life Support " + df2.format(hs2.getPos()*100) + "%", scrollbarX + scrollbarWidth + 1, scrollbar2Y+2);
    hs2.display();
    fill(20);
    text("Rationing: ", scrollbarX-60,scrollbar3Y+2);
    text("" + df2.format(popModule.consumptionRate * popModule.getPop()) + " stores per day", scrollbarX + scrollbarWidth, scrollbar3Y+2);
    hs3.display();
    if (activeDropdown != null) {
      activeDropdown.show();      
    }
  }
  
  //update UI controls
  
  void updateUIControls() {
   scroll1Ratio = hs1.getPos();
   //popModule.setMaxPop((float)dropDownMenu.scroll1Ratio);
   scroll2Ratio = hs2.getPos();
   Energy_Module.setEnergyConsumptionPercentage(scroll2Ratio);
   scroll3Ratio = hs3.getPos();
   popModule.setConsumptionRate(scroll3Ratio);
   hs1.update();
   hs2.update();
   hs3.update(); 
   if (activeDropdown != null) {
     activeDropdown.update();
   }
  }
  
  //Draw text to screen showing resource elements.
  //variables set position of text elements on screen.
  
  int distanceXPos = 20;
  int velocityXPos = distanceXPos;
  int velocityYPos = 60;
  int metalXPos = 200;
  int energyXPos = 300;
  int storesXPos = 400;
   
  void drawResourceElements() {
    float distance = travelModule.getDistance();
    float velocity = travelModule.getVelocity();
    double[] currentResources = resModule.getResources();
    fill(0);
    String distanceText = "Dist: " + df1.format(distance/1000) + " km";
    String velocityText;
    if (velocity <= 1000) {
      velocityText = "Vel: " + df1.format(velocity) + " m/s";
    } else if (velocity < (travelModule.c / 100) ) {
      velocityText = "Vel: " + df1.format(velocity/1000) + " km/s";
    } else {
      velocityText = "Vel: " + df2.format(travelModule.velocity / travelModule.c) + " c";
    }
    String metalText = "Metal: " + df2.format(currentResources[0]);
    String energyText = "Energy: " + df2.format(currentResources[1]);
    String storesText;
    if (currentResources[2] >= 1) {
      storesText = "Stores: " + df2.format(currentResources[2] / (popModule.getPop() * popModule.consumptionRate)) + " days left";
    } else {
      storesText = "Stores: 0";
    }
    text(distanceText,distanceXPos,40);
    text(velocityText,velocityXPos,velocityYPos);
    text(metalText, metalXPos,40);
    //text(energyText, energyXPos, 40);
    text(storesText, energyXPos, 40);
  }
  
  int popXPos = metalXPos;
  
  void drawPopulationElements() {
    int popCount = popModule.getPop();
    text("Population: " + popCount + " / " + (int)Math.floor(popModule.maxPop), popXPos,60);
  }
   
  void createdropDownMenu(float x, float y, int gridX, int gridY) {
      activeDropdown = new dropDownMenu(x,y,gridX, gridY);
  }
  
}
  
class dropDownMenu {
  
  float xOrigin;
  float yOrigin;
  float xWidth = 120;
  float optionHeight = 20;
  int numOfOptions = 6;
  float yHeight = optionHeight * numOfOptions;
  float option1Y = 10;
  float optionTextOffset = 5;
  boolean option1Active = false;
  boolean option2Active = false;
  boolean option3Active = false;
  boolean option4Active = false;
  boolean option5Active = false;
  boolean option6Active = false;
  int gridX;
  int gridY;
  Ship_Room clickedRoom;
  
  dropDownMenu(float x, float y, int gX, int gY) {
     xOrigin = x;
     yOrigin = y;
     gridX = gX;
     gridY = gY;
     gridKey clickedKey = new gridKey(gridX,gridY);
     clickedRoom = newLayout.layoutMap.get(clickedKey);
  }
  
  void update() {
      if (mouseX > xOrigin && mouseX < xOrigin + xWidth
          && mouseY > yOrigin && mouseY < yOrigin + yHeight) {
        if (mouseY < yOrigin + optionHeight) {
          option1Active = true;  
          option2Active = false;
          option3Active = false;
          option4Active = false;
          option5Active = false;
          option6Active = false;
        } else if (mouseY < yOrigin + (2*optionHeight)) {
          option2Active = true;
          option1Active = false;
          option3Active = false;
          option4Active = false;
          option5Active = false;
          option6Active = false;
        } else if (mouseY < yOrigin + (3*optionHeight)) {
          option1Active = false;
          option2Active = false;
          option3Active = true;
          option4Active = false;
          option5Active = false;
          option6Active = false;
        } else if (mouseY < yOrigin + (4*optionHeight)) {
          option4Active = true;
          option3Active = false;
          option2Active = false;
          option1Active = false;
          option5Active = false;
          option6Active = false;
        } else if (mouseY < yOrigin + (5*optionHeight)) {
          option4Active = false;
          option3Active = false;
          option2Active = false;
          option1Active = false;
          option5Active = true;
          option6Active = false;
        } else if (mouseY < yOrigin + (6*optionHeight)) {
          option4Active = false;
          option3Active = false;
          option2Active = false;
          option1Active = false;
          option5Active = false;
          option6Active = true;
        }
      }
      if (option1Active && mousePressed) {
        newLayout.upgradeRoom(gridX, gridY);
        mainUI.activeDropdown = null;
      } else if (option2Active && mousePressed) {
        newLayout.addStoresRoom(gridX, gridY);
        mainUI.activeDropdown = null;
      } else if (option3Active && mousePressed) {
        mainUI.activeDropdown = null;
      } else if (option4Active && mousePressed) {
        newLayout.toggleLifeSupport(gridX,gridY);
        mainUI.activeDropdown = null;
      } else if (option5Active && mousePressed) {
        newLayout.addEngine(gridX,gridY);
        mainUI.activeDropdown = null;
      } else if (option6Active && mousePressed) {
        if (clickedRoom.isFront) {
          newLayout.addBussardScoop(gridX, gridY);
        } else {
          newLayout.removeBussardScoop(gridX,gridY);
        }
        mainUI.activeDropdown = null;
      }
  }
  
  void show() {
    fill(255);
    stroke(0);
    rect(xOrigin,yOrigin,xWidth,yHeight); //bounding box
    textSize(10);
    
    if (clickedRoom.canBuildGenerator()) {
      //first optionBox
      if (!option1Active) {
      noFill();
      } else {
        fill(20);
      }
      rect(xOrigin,yOrigin,xWidth,optionHeight); //first option panel
      if (!option1Active) {
        fill(0);
      } else {
        fill(255);
      }
      text("+Energy (10m)", xOrigin + optionTextOffset,yOrigin+option1Y);
    }
    
    if (clickedRoom.canBuildStores()) {
      //second optionBox
      if (!option2Active) {
        noFill();
      } else {
        fill(20);
      }
      rect(xOrigin,yOrigin + optionHeight,xWidth,optionHeight); //second option panel
      if (!option2Active) {
        fill(0);
      } else {
        fill(255);
      }
      text("+Stores (5m)", xOrigin + optionTextOffset,yOrigin+option1Y+optionHeight);
    }
    
    //third optionBox
    if (!option3Active) {
      noFill();
    } else {
      fill(20);
    }
    rect(xOrigin,yOrigin + (2 * optionHeight),xWidth,optionHeight); //second option panel
    if (!option3Active) {
      fill(0);
    } else {
      fill(255);
    }
    text("Cancel", xOrigin + optionTextOffset,yOrigin+option1Y+(2*optionHeight));
    
    if (clickedRoom.canBuildLifeSupport() || clickedRoom.lifeSupportActive) {
      //fourth optionBox
      if (!option4Active) {
        noFill();
      } else {
        fill(20);
      }
      rect(xOrigin,yOrigin + (3 * optionHeight),xWidth,optionHeight); //second option panel
      if (!option4Active) {
        fill(0);
      } else {
        fill(255);
      }
      text("togg lifeSupp (10m)", xOrigin + optionTextOffset,yOrigin+option1Y+(3*optionHeight));
    }
    
    if (clickedRoom.canBuildEngine()) {
      //fifth optionBox
      if (!option5Active) {
        noFill();
      } else {
        fill(20);
      }
      rect(xOrigin,yOrigin + (4 * optionHeight),xWidth,optionHeight); //second option panel
      if (!option5Active) {
        fill(0);
      } else {
        fill(255);
      }
      text("+Engine (50m)", xOrigin + optionTextOffset,yOrigin+option1Y+(4*optionHeight));
    }
    
    //sixth optionBox
    if (!option6Active) {
      noFill();
    } else {
      fill(20);
    }
    rect(xOrigin,yOrigin + (5 * optionHeight),xWidth,optionHeight); //second option panel
    if (!option6Active) {
      fill(0);
    } else {
      fill(255);
    }
    String bussardText = "";
    if (clickedRoom.isFront) {
      bussardText = "+Bussard (2m)";
    } else if (clickedRoom.bussardScoop > 0) {
      bussardText = "remove Bussard";
    } else {
      bussardText = "=FrontOfShipOnly=";
    }
      text(bussardText, xOrigin + optionTextOffset,yOrigin+option1Y+(5*optionHeight));
    
    textSize(12);
  }
  
}

class HScrollbar {
  int swidth, sheight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;

  HScrollbar (float xp, float yp, int sw, int sh, int l) {
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)sw / (float)widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
    spos = xpos;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;
    loose = l;
  }

  void update() {
    if (overEvent()) {
      over = true;
    } else {
      over = false;
    }
    if (mousePressed && over) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
    }
    if (abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
    }
  }

  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+swidth &&
       mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    noStroke();
    fill(204);
    rect(xpos, ypos, swidth, sheight);
    if (over || locked) {
      fill(0, 0, 0);
    } else {
      fill(102, 102, 102);
    }
    rect(spos, ypos, sheight, sheight);
  }

  //TODO: Fix so that it returns a value between 0 and 1.
  float getPos() {
    if ((spos - xpos) / (swidth - sheight) < 0.001) {
      return 0;
    } else if ((spos - xpos) / (swidth - sheight) < 0.999) {
      return (spos - xpos) / (swidth - sheight);
    } else {
      return 1;
    }
  }
}