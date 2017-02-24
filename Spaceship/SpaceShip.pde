public static UI_Panel mainUI;
public static Population_Module popModule;
public static Resource_Module resModule;
public static Ship_Layout newLayout;
public static Travel_Module travelModule;
public static Events_Module eventsModule;
public static Background mainBackground;
public static boolean debug = true;

boolean gamePaused = false;

void setup() {
  size(1300,720); 
  mainUI = new UI_Panel();
  popModule = new Population_Module();
  resModule = new Resource_Module();
  newLayout = new Ship_Layout();
  travelModule = new Travel_Module();
  mainBackground = new Background();
  eventsModule = new Events_Module();
  
}

void draw() {
  //The game "ticks" over once every 30 frames
  if (frameCount % 30 == 0 && !gamePaused) {
    resModule.updateResources();
    popModule.updatePopulation();
    newLayout.update();
    eventsModule.update();
    travelModule.update();
  }
  if (!gamePaused) {
    mainBackground.update();
  }
  mainBackground.show();
  newLayout.show();
  eventsModule.show();
  mainUI.show();
}

void mousePressed() {
   if (mouseY > mainUI.uiHeight) {
     if (mainUI.activeDropdown == null) {
       if (mouseButton == LEFT) {
         newLayout.improveRoom(mouseX,mouseY);
       } else {
         newLayout.removeRoom(mouseX,mouseY);
       }
     }
   }
  
}

void keyPressed() {
 if (keyCode == UP) {
  double[] newRes = {100,100,250};
  resModule.setResources(newRes);  
  eventsModule.activateRefugees();
 }
 
 if (keyCode == RIGHT) {
   float[] newOffsets = {newLayout.xOffset + 5, newLayout.yOffset};
   newLayout.setOffset(newOffsets);
 } else if (keyCode == LEFT) {
   float[] newOffsets = {newLayout.xOffset - 5, newLayout.yOffset};
   newLayout.setOffset(newOffsets);
 }
 
 if (keyCode == DOWN) {
   if (gamePaused) {
     gamePaused = false;
   } else {
     gamePaused = true;
   }
 }
  
}