public static UI_Panel mainUI;
public static Population_Module popModule;
public static Resource_Module resModule;
public static Ship_Layout newLayout;
public static Travel_Module travelModule;
public static Events_Module eventsModule;
public static Background mainBackground;
public static Text_Interface textInterface;
public static boolean debug = true;
public static int updateRate = 30;

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
  textInterface = new Text_Interface();
  
}

void draw() {
  //The game "ticks" over once every 30 frames
  if (frameCount % updateRate == 0 && !gamePaused) {
    resModule.updateResources();
    popModule.updatePopulation();
    newLayout.update();
    travelModule.update();
  }
  if (!gamePaused) {
    mainBackground.update();
    eventsModule.updateMovement();
  }
  mainBackground.show();
  newLayout.show();
  eventsModule.show();
  mainUI.show();
  textInterface.update();
  textInterface.show();
}

void mousePressed() {
  textInterface.checkMousePress();
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
 }
 
 if (keyCode == RIGHT) {
   newLayout.moveShip(5,0);
     gridScale += 5;
 } else if (keyCode == LEFT) {
   newLayout.moveShip(-5,0);
   gridScale -= 5;
 }
 
 if (keyCode == DOWN) {
   if (gamePaused) {
     gamePaused = false;
   } else {
     gamePaused = true;
   }
 }
  
}