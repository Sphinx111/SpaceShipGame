class Events_Module {
  
  public Refugee_Encounter activeRefugeeEncounter;
  
  void activateRefugees() {
    activeRefugeeEncounter = new Refugee_Encounter();
  }
  
  void update() {
    if (activeRefugeeEncounter != null) {
      activeRefugeeEncounter.update();
    }
  }
  
  void show() {
    if (activeRefugeeEncounter != null) {
      activeRefugeeEncounter.show();
    }
  }
  
}

class Refugee_Encounter {
  
  int[][] refugeeShipLayout = {{0,0},{1,0},{1,1},{1,2},{2,1},{0,2},{3,1},{4,1},{5,1}};
  int metalValue = 180;
  Ship_Layout refugeeShip = new Ship_Layout(refugeeShipLayout);
  
  public Refugee_Encounter() {
    float[] shipOffsets = {-250,newLayout.yOffset + 200};
    refugeeShip.setOffset(shipOffsets);
  }
  
  void update() {
    refugeeShip.update();
    if(refugeeShip.xOffset > width + (width/4)) {
      eventsModule.activeRefugeeEncounter = null;
    }
  }
  
  void show() {
    float[] shipOffsets = {refugeeShip.xOffset + 1, refugeeShip.yOffset};
    refugeeShip.setOffset(shipOffsets);
    refugeeShip.show();
  }
  
}