public static UI_Panel mainUI;
public static Population_Module popModule;
public static Resource_Module resModule;
public static Ship_Layout newLayout;
public static boolean debug = true;

boolean gamePaused = false;

void setup() {
  size(1300,768); 
  mainUI = new UI_Panel();
  popModule = new Population_Module();
  resModule = new Resource_Module();
  newLayout = new Ship_Layout();
  
  
}

void draw() {
  if (frameCount % 30 == 0) {
    fill(150);
    rect(0,mainUI.uiHeight,width,height);
    resModule.updateResources();
    popModule.updatePopulation();
    newLayout.show();
    newLayout.update();
  }
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
 }
  
}