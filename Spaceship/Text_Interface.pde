class Text_Interface {
  
  textPanel activeTextPanel;
  
  void refugeeOptions(float x, float y) {
    activeTextPanel = new refugeeText(x,y); 
  }
 
  void update() {
    if (activeTextPanel != null) {
      activeTextPanel.update();
    }
  }
  
  void show() {
    if (activeTextPanel != null) {
      activeTextPanel.show();
    }
  }
  
  void checkMousePress() {
    if (activeTextPanel != null) {
      activeTextPanel.mouseCheck();
    }
  }
  
}

class textPanel {
  
  float xOffset = 0;
  float yOffset = mainUI.uiHeight;
  float xWidth = 600;
  float yHeight = 300;
  float textX = 20 + xOffset;
  float mainTextY = yOffset + 20;
  float option1Y = yOffset + 120;
  float option2Y = yOffset + 220;
  float textSize1 = 10;
  String mainText = "description of event";
  String option1Text = "option1";
  String option2Text = "option2";
  boolean option1Over = false;
  boolean option2Over = false;
  int textBoxAnswer = 0;
  
  void show() {
    fill(51);
    rect(xOffset,yOffset,xWidth,yHeight);
    fill (255);
    text(mainText,textX, mainTextY);
    if (option1Over) {
      fill(20,120,255);
    }
    text(option1Text,textX,option1Y);
    fill(255);
    if (option2Over) {
      fill(20,120,255);
    }
    text(option2Text,textX,option2Y);
    fill(255);
  }
  
  void update() {
    if (mouseX > xOffset && mouseX < xOffset + xWidth) {
      if (mouseY > option1Y - 10 && mouseY < option1Y + 10) {
        option1Over = true;
        option2Over = false;
      } else if (mouseY > option2Y - 10 && mouseY < option2Y + 10) {
        option1Over = false;
        option2Over = true;
      } else {
        option1Over = false;
        option2Over = false;
      }
    }
  }
  
  void mouseCheck() {
    
  }
  
  int getTextAnswer () {
    if (mousePressed && option1Over) {
      System.out.println("Option 1 Clicked");
      return 1;
    }
    if (mousePressed && option2Over) {
      System.out.println("Option 2 Clicked");
      return 2;
    }
    else {
      System.out.println("No Option Clicked");
      return 0;
    }
  }
  
}

class refugeeText extends textPanel {
  
  String message1 = "Message Received: 'Eurimedes to unknown ship, requesting permission to dock.\n10 souls aboard requesting refuge";
  String option1 = "Transmit: Docking granted, match our speed";
  String option2 = "Orders: Increase speed, leave the Eurimedes behind";
  
  public refugeeText(float x, float y) {
    super.xOffset = x;
    super.yOffset = y;
    super.textX = super.xOffset + 20;
    super.mainTextY = y + 20;
    super.option1Y = y + 120;
    super.option2Y = y + 220;
    super.mainText = message1;
    super.option1Text = option1;
    super.option2Text = option2;
  }
  
  void mouseCheck() {
    System.out.println("Text Box Checking mouseClick");
    int textAnswer = super.getTextAnswer();
    
    if (textAnswer == 1) {
     eventsModule.activeRefugeeEncounter.stageActive = 4;
     textInterface.activeTextPanel = null;
   } else if (textAnswer == 2) {
     eventsModule.activeRefugeeEncounter.stageActive = 6;
     textInterface.activeTextPanel = null;
   }
  }
  
  void update() {
   super.update();
  }
  
  void show() {
    super.show();
  }
  
}