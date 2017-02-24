public static int gridScale = 40;

class Ship_Layout {
  
  int volume = 8;
  HashMap<gridKey, Ship_Room> layoutMap = new HashMap<gridKey, Ship_Room>();
  float xOffset = 350;
  float yOffset = mainUI.uiHeight + 200;
  boolean isPlayerShip = false;
  
  Ship_Layout() {
    isPlayerShip = true;
       for (int y = 0; y < 2; y++) {
         for (int x = 0; x < 4; x++) {
           gridKey newKey = new gridKey(x,y);
           int[] newPos = {x,y};
           layoutMap.put(newKey, new Ship_Room(newPos));
           layoutMap.get(newKey).O2Percent = 100;
           if (x == 0) {
             layoutMap.get(newKey).energyGeneration = 10;
           } else if (x == 1 && y == 0) {
             layoutMap.get(newKey).storesProduction = 20;
           } else if (x == 3) {
             layoutMap.get(newKey).lifeSupportActive = true;
           }
         }
       }
       {
         int[] room2 = {0,-1};
         gridKey tempKey2 = new gridKey(0,-1);
         layoutMap.put(tempKey2, new Ship_Room(room2));
         layoutMap.get(tempKey2).O2Percent = 100;
         int[] room1 = {-1,-1};
         gridKey tempKey1 = new gridKey(-1,-1);
         layoutMap.put(tempKey1, new Ship_Room(room1));
         layoutMap.get(tempKey1).O2Percent = 100;
         layoutMap.get(tempKey1).engineForce = 50;
         int[] room3 = {0,2};
         tempKey2 = new gridKey(0,2);
         layoutMap.put(tempKey2,new Ship_Room(room3));
         layoutMap.get(tempKey2).O2Percent = 100;
         int[] room4 = {-1,2};
         tempKey1 = new gridKey(-1,2);
         layoutMap.put(tempKey1, new Ship_Room(room4));
         layoutMap.get(tempKey1).O2Percent = 100;
         layoutMap.get(tempKey1).engineForce = 50;
       }
  }
  
  public Ship_Layout(int[][] layoutPlan) {
    for (int[] grids : layoutPlan) {
      gridKey newKey = new gridKey(grids[0],grids[1]);
      layoutMap.put(newKey, new Ship_Room(grids));
    }
  }
  
  void setOffset(float[] offset) {
    xOffset = offset[0];
    yOffset = offset[1];
  }
  
  //takes x,y float values of MousePos, converts to grid and checks if room exists.
  void improveRoom(float x, float y) {
    float[] xy = {x,y};
    int[] intKey = GridManager.pixelToGrid(xy,this);
    gridKey testKey = new gridKey(intKey[0],intKey[1]);
    if (layoutMap.containsKey(testKey)) {
      mainUI.createdropDownMenu(x,y,intKey[0],intKey[1]);
    } else {
      addRoom(intKey[0],intKey[1]); 
    }
  }
  
  void addRoom(int x, int y) {
    if (resModule.getMetals() >= 10 && isConnectedToAnyRoom(x,y)) {
      resModule.addMetals(-10);
      int[] newRoom = {x,y};
      gridKey newKey = new gridKey(x,y);
      layoutMap.put(newKey, new Ship_Room(newRoom));
    }
  }
  
  void upgradeRoom(int x, int y) {
    gridKey newKey = new gridKey(x,y);
    Ship_Room currentRoom = layoutMap.get(newKey);
    if (currentRoom.canBuildGenerator()) {
      currentRoom.energyGeneration += 10;
      resModule.addMetals(-10);
    }
  }
  
  void addStoresRoom(int x, int y) {
    if (resModule.getMetals() >= 5) {
      gridKey newKey = new gridKey(x,y);
      Ship_Room currentRoom = layoutMap.get(newKey);
      if (currentRoom.canBuildStores()) {
        currentRoom.storesProduction += 20;
        resModule.addMetals(-5);
      }
    }
  }
  
  void addEngine(int x, int y) {
    if (resModule.getMetals() >= 50) {
      gridKey newKey = new gridKey(x,y);
      Ship_Room currentRoom = layoutMap.get(newKey);
      if (currentRoom.canBuildEngine()) {
        currentRoom.engineForce += 50;
        resModule.addMetals(-50);
      }
    }
  }
  
  void removeRoom(float x, float y) {
    float[] tempCoord = {x,y};
    int[] removeRoom = GridManager.pixelToGrid(tempCoord, this);
    gridKey removeKey = new gridKey(removeRoom[0],removeRoom[1]);
    layoutMap.put(removeKey,null);
    layoutMap.remove(removeKey);
  }
  
  void toggleLifeSupport(int x, int y) {
    gridKey newKey = new gridKey(x,y);
    Ship_Room currentRoom = layoutMap.get(newKey);
      if (currentRoom.lifeSupportActive) {
        currentRoom.lifeSupportActive = false;
        resModule.addMetals(5);
      } else {
        if (currentRoom.canBuildLifeSupport()) {
          currentRoom.lifeSupportActive = true;
          resModule.addMetals(-10);
      }
    }
  }
  
  //TODO - move behaviour into each room's "show()" function
  void show() {
    stroke(0);
    strokeWeight(1);
    for (Ship_Room room : layoutMap.values()) {
      float[] roomPos = {room.coords[0],room.coords[1]};
      float[] pixPos = GridManager.gridToPixel(roomPos,this);
      float O2DisplayAmount = (255 * room.O2Percent / 100);
      stroke(0);
      fill(255,O2DisplayAmount,O2DisplayAmount);
      rect(pixPos[0],pixPos[1],gridScale,gridScale);
      if(room.energyGeneration > 0) {
        float e = room.energyGeneration;
        fill(e*15,e*15,e*2);
        ellipse(pixPos[0]+(gridScale/2),pixPos[1]+(gridScale/2),gridScale-2,gridScale-2);
        fill(255-(e*25),255-(e*25),255-(e*15));
        textSize(gridScale/4);
        text("+"+room.energyGeneration,pixPos[0]+(gridScale/8*1),pixPos[1]+(gridScale/8*5));
        textSize(12);
      } else if (room.storesProduction > 0) {
        float s = room.storesProduction;
        fill(s*2,s*15,s*15);
        rect(pixPos[0]+(gridScale/4),pixPos[1]+(gridScale/4),gridScale/2,gridScale/2);
        fill(255-(s*25),255-(s*25),255-(s*15));
        textSize(gridScale/5);
        text("+"+room.storesProduction,pixPos[0]+(gridScale/8*2),pixPos[1]+(gridScale/8*4));
        textSize(12);
      }
      if (room.lifeSupportActive) {
        fill(100);
        rect(pixPos[0],pixPos[1],gridScale/5,gridScale/5);
      }
      if (room.engineForce > 0) {
        fill(20,190,20);
        rect(pixPos[0],pixPos[1]+(gridScale/4),gridScale,gridScale/2);
        fill(0);
        textSize(gridScale/4);
        text("" + room.engineForce,pixPos[0]+2,pixPos[1]+(gridScale/2));
        textSize(12);
      }
    }
  }
  
  float generationTotal = 0;
  float popMaxTotal = 1023456;
  float storesProductionTotal = 0;
  float engineForceTotal = 0;
  
  float getEnergyGenTotal() {
    return generationTotal;
  }
  float getPopMaxTotal () {
    return popMaxTotal;
  }
  float getStoresProduction() {
    return storesProductionTotal;
  }
  float getEngineForce() {
    return engineForceTotal;
  }
  
  void update() {
    generationTotal = 0;
    popMaxTotal = 0;
    storesProductionTotal = 0;
    engineForceTotal = 0;
    int roomCount = 0;
    for (Ship_Room room : layoutMap.values()) {
      if (isPlayerShip) {
        Oxygen_Module.updateO2(this, room);
      }
      generationTotal += room.energyGeneration;
      if (room.O2Percent < 80) {
        popMaxTotal += room.populationCapacity * (room.O2Percent / 100);
      } else {
        popMaxTotal += room.populationCapacity;
      }
      storesProductionTotal += room.storesProduction;
      engineForceTotal += room.engineForce;
      roomCount++;
    }
    //Send updated energy Production stats to energy module
    // Energy_Module.setEnergyProduction(generationTotal);
    //popModule.setAbsMaxPop(popMaxTotal);
    //Stores_Module.setStoresProduction(storesProductionTotal);
    //travelModule.addImpulse(engineForceTotal);
    volume = roomCount;
  }
  
  boolean isConnectedToAnyRoom(int x,int y) {
    gridKey key1 = new gridKey(x,y-1);
    gridKey key2 = new gridKey(x,y+1);
    gridKey key3 = new gridKey(x-1,y);
    gridKey key4 = new gridKey(x+1,y);
    if (layoutMap.containsKey(key1) || layoutMap.containsKey(key2) || layoutMap.containsKey(key3) || layoutMap.containsKey(key4)) {
      return true;
    } else {
      return false;
    }
  }
  
  Ship_Room[] getAdjacentRooms(int x, int y) {
    gridKey keyUp = new gridKey(x,y-1);
    gridKey keyDown = new gridKey(x,y+1);
    gridKey keyLeft = new gridKey(x-1,y);
    gridKey keyRight = new gridKey(x+1,y);
    Ship_Room[] adjacentRooms = new Ship_Room[4];
    if (layoutMap.containsKey(keyUp)) {
      adjacentRooms[0] = layoutMap.get(keyUp);
    }
    if (layoutMap.containsKey(keyDown)) {
      adjacentRooms[1] = layoutMap.get(keyDown);
    }
    if (layoutMap.containsKey(keyLeft)) {
      adjacentRooms[2] = layoutMap.get(keyLeft);
    }
    if (layoutMap.containsKey(keyRight)) {
      adjacentRooms[3] = layoutMap.get(keyRight);
    }
    return adjacentRooms;
  }
  
}


class Ship_Room {
  int[] coords; 
  float O2Percent = 50;
  float energyGeneration = 0;
  float storesProduction = 0;
  float engineForce = 0;
  float populationCapacity = 20;
  boolean lifeSupportActive = false;
  boolean filled = false;
  
  Ship_Room(int[] pos) {
    coords = pos; 
    O2Percent = 50;
  }
  
  public boolean canBuildGenerator() {
    if (storesProduction == 0 && engineForce == 0 && !lifeSupportActive && energyGeneration < 100 && resModule.getMetals() >= 10) {
      return true;
    } else {
      return false;
    }
  }
  
  public boolean canBuildStores() {
    if (energyGeneration == 0 && engineForce == 0 && !lifeSupportActive) {
      return true;
    } else {
      return false;
    }
  }
  
  public boolean canBuildLifeSupport() {
    if (energyGeneration == 0 && engineForce == 0 && storesProduction == 0 && resModule.getMetals() >= 10) {
      return true;
    } else {
      return false;
    }
  }
  
  public boolean canBuildEngine() {
    if (energyGeneration == 0 && storesProduction == 0 && !lifeSupportActive) {
      return true;
    } else {
      return false;
    }
  }
  
}

static class GridManager {
  
  public static int[] pixelToGrid(float[] pixLoc, Ship_Layout thisShip) {
    int[] gridLoc = {(int)Math.floor((pixLoc[0] - thisShip.xOffset) / gridScale),(int)Math.floor((pixLoc[1] - thisShip.yOffset) / gridScale)};
    return gridLoc;
  }
  
  public static float[] gridToPixel(float[] gridLoc, Ship_Layout thisShip) {
    float[] pixLoc = {(gridLoc[0] * gridScale) + thisShip.xOffset, (gridLoc[1] * gridScale) + thisShip.yOffset};
    return pixLoc;
  }
  
}

class gridKey {
 
    int x;
    int y;

    public gridKey(int xVal, int yVal) {
        this.x = xVal;
        this.y = yVal;
    }

    @Override
    public boolean equals(Object object) {
        if (!(object instanceof gridKey)) {
            return false;
        }

        gridKey otherKey = (gridKey) object;
        return this.x == otherKey.x && this.y == otherKey.y;
    }

    @Override
    public int hashCode() {
        int result = 17; // any prime number
        result = 31 * result + this.x;
        result = 31 * result + this.y;
        return result;
    }
  
}