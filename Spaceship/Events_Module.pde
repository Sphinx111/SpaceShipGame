class Events_Module {
  
  public Refugee_Encounter activeRefugeeEncounter;
  
  void activateRefugees() {
    activeRefugeeEncounter = new Refugee_Encounter();
  }
  
  void updateMovement() {
    if (activeRefugeeEncounter != null && activeRefugeeEncounter.refugeeShip != null) {
      activeRefugeeEncounter.updateMovement();
    }
  }
  
  void show() {
    if (activeRefugeeEncounter != null && activeRefugeeEncounter.refugeeShip != null) {
      activeRefugeeEncounter.show();
    }
  }
  
}

class Refugee_Encounter {
  
  int[][] refugeeShipLayout = {{0,0},{1,0},{1,1},{1,2},{2,1},{0,2},{3,1},{4,1},{5,1}};
  int metalValue = 40;
  int popValue = 10;
  Ship_Layout refugeeShip;
  float initialRelVelocity = 2;
  float currentVelocity = initialRelVelocity;
  float stage2pause = 25;
  float stage2counter = 0;
  boolean stage3TextActive = false;
  
  int stageActive = 1; //Stage 1 - Arrival & Deceleration, Stage 2 - Docking, Stage 3 - Integration, Stage 4 - Decision
  
  public Refugee_Encounter() {
    refugeeShip = new Ship_Layout(refugeeShipLayout);
    refugeeShip.setOffset(-250, newLayout.yOffset+200);
    gridKey key1;
    key1 = new gridKey(0,0);
    refugeeShip.layoutMap.get(key1).engineForce = 10;
    key1 = new gridKey(1,1);
    refugeeShip.layoutMap.get(key1).energyGeneration = 20;
    key1 = new gridKey(0,2);
    refugeeShip.layoutMap.get(key1).engineForce = 10;
    key1 = new gridKey(3,1);
    refugeeShip.layoutMap.get(key1).storesProduction = 20;
    int[] dockPoint = {1,0};
    refugeeShip.setStarboardDock(dockPoint);
  }
  
  void updateMovement() {
    if (Math.abs(refugeeShip.xOffset - newLayout.xOffset) > 1000) {
      stageActive = 5;
    }
    switch (stageActive) {
      case 1: stage1Update();
      break;
      case 2: stage2Update();
      break;
      case 3: stage3Update();
      break;
      case 4: stage4Update();
      break;
      case 5: endEvent();
      break;
      case 6: stage6Active();
      break;
    }
    if (refugeeShip != null) {
      refugeeShip.show();
    }
  }
  
  void stage1Update() {

    System.out.println("Stage 1 Active");
    float distance = (newLayout.xOffset + (newLayout.starboardDock[0] * gridScale)) - (refugeeShip.xOffset + (refugeeShip.starboardDock[0] * gridScale));
    System.out.println("Distance is: " + distance);
    if (distance > 1) {
      currentVelocity -= 0.35 / (1 + distance);
      refugeeShip.moveShip(currentVelocity,0);
    } else {
      refugeeShip.setOffset(newLayout.xOffset + ((newLayout.starboardDock[0] - refugeeShip.starboardDock[0]) * gridScale), refugeeShip.yOffset);
      stageActive = 2;
      System.out.println("moving to Stage 2");
    }
    System.out.println("Distance is now: " + distance);
  }
  void stage2Update() {
    //System.out.println("Stage 2 Active");
    if (stage2counter < stage2pause) {
      stage2counter++;
      return;
    }
    if ((GridManager.gridToPixel(refugeeShip.starboardDock,refugeeShip)[1]) - (GridManager.gridToPixel(newLayout.starboardDock,newLayout)[1]) >= gridScale) {
      refugeeShip.moveShip(0,-1);
    } else {
      float dockMovement = (GridManager.gridToPixel(refugeeShip.starboardDock,refugeeShip)[1]) - (GridManager.gridToPixel(newLayout.starboardDock,newLayout)[1]);
      refugeeShip.moveShip(0,-dockMovement + gridScale);
      stageActive = 3;
    }
  }
  void stage3Update() {
    if (!stage3TextActive) {
      textInterface.refugeeOptions(400,400);
      stage3TextActive = true;
    }
  }
  void stage4Update() {
    //Copy Refugee Ship Layout to main layout and add figures up.
    //convert refugeeShip grid to pixels, then back to grid reference as used by main ship.
    for (Ship_Room room : refugeeShip.layoutMap.values()) {
      float[] roomPixels = GridManager.gridToPixel(room.coords, refugeeShip);
      int[] newRoom = GridManager.pixelToGrid(roomPixels, newLayout);
      float[] roomValues = room.getValues();
      gridKey newKey = new gridKey(newRoom[0],newRoom[1]);
      newLayout.layoutMap.put(newKey, new Ship_Room(newRoom,roomValues));
    }
    refugeeShip.layoutMap.clear();
    popModule.addPop(popValue);
    resModule.addMetals(metalValue);
    stageActive = 6;
  }
  void stage6Active() {
    refugeeShip.moveShip(-1,1);
    if (refugeeShip == null || refugeeShip.xOffset < -600) {
      endEvent();
    }
  }
  void endEvent() {
    refugeeShip = null;
    eventsModule.activeRefugeeEncounter = null;
  }
  
  void show() {
    if (refugeeShip != null) {
      refugeeShip.show();
    }
  }
  
}