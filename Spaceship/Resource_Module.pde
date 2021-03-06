class Resource_Module {

  double Metals = 80;
  double Energy = 100;
  double Stores = 250;
  
  Resource_Module() {

  }
  
  double[] getResources() {
     double[] resources = {Metals,Energy,Stores};
     return resources;
  }
  
  double getMetals() {
    return Metals;
  }
  
  void addMetals(double change) {
    Metals = Metals + change;
  }
  
  double getEnergy() {
    return Energy;
  }
  
  void addEnergy(double change) {
    Energy = Energy + change;
  }
  
  double getStores() {
    return Stores;
  }
  
  void addStores(double change) {
    Stores = Stores + change;
  }
  
  void setResources(double[] newRes) {
    Metals = newRes[0];
    Energy = newRes[1];
    Stores = newRes[2];
  }
  
  //Get resource consumption from various sources and update totals accordingly.
  void updateResources() {
    Stores = Stores_Module.updateStores(Stores);
    Energy = Energy_Module.updateEnergy(Energy);
    Metals = Metal_Module.updateMetals(Metals);
  }
  
}

static class Energy_Module {
  
  static double energyConsumption = 0;
  static float energyProduction = 0;
  static float maxConsumptionRate = 2;
  static float energyToLifeSupport = 0.5;
  static float energyToEngines = 0.5;
  
  static double updateEnergy(double currentEnergy) {
      
      energyProduction = newLayout.getEnergyGenTotal();    
      double newEnergy = currentEnergy - energyConsumption + energyProduction;
      if (newEnergy >= 0) {
        return newEnergy;
      } else {
        return 0;
      }
  }
  
  static void setEnergyConsumption(double newConsumption) {
    energyConsumption = newConsumption;
  }
  
  static float getO2Usage () {
    return energyToLifeSupport;
  }
  
  static float getEngineUsage() {
    return energyToEngines;
  }
  
  static double getConsumption() {
    return energyConsumption;
  }
  
  static void setEnergyConsumptionPercentage(double ratio) {
    energyToLifeSupport = (float)(energyProduction * ratio);
    energyToEngines = (float)(energyProduction * (1-ratio));
    energyConsumption = energyProduction;
  }
  
}

static class Stores_Module {
  
  static float storesProduction = 0;
  static float maxStores = 100 * newLayout.volume;
  
  static double updateStores(double currentStores) {
     storesProduction = newLayout.getStoresProduction();
     if (currentStores >= 0) {
     double newStores = currentStores - (popModule.getConsumption()) + storesProduction;
     if (newStores > maxStores) {
       newStores = maxStores;
     }
     return newStores;
     } else {
       return 0;
     }
  }
  
  static void setStoresProduction(float production) {
      storesProduction = production;
  }
  
}

static class Metal_Module {
  
  static double updateMetals(double current) {
    return (current + newLayout.getBussardScoopTotal());
  }
  
}

static class Oxygen_Module {
  
  // static float O2Reserves = 100;
  static float diffusionRate = 0.4;
  static float acceptableO2difference = 0;
  static float O2consumptionRate = 0.1; //Percent Oxygen consumed by person, per tick
  static float O2ProductionRate = 0;
  static float O2ProductionModifier = 1;
  
  static void updateO2(Ship_Layout thisShip, Ship_Room currentRoom) {
    O2ProductionRate = 0;
    
    Ship_Room[] adjacentRooms = thisShip.getAdjacentRooms(currentRoom.coords[0],currentRoom.coords[1]);
    for (Ship_Room room : adjacentRooms) {
      float O2Transfer = 0;
      if (room != null) {
        O2Transfer = (room.O2Percent - currentRoom.O2Percent) / 2 * diffusionRate;
        room.O2Percent -= (O2Transfer) - acceptableO2difference;
        currentRoom.O2Percent += (O2Transfer) - acceptableO2difference;
      }
    }
    
    double occupationModifier = popModule.getPop() / ((float)thisShip.volume + 1);
    if (currentRoom.lifeSupportActive) {
      O2ProductionRate = (float)Energy_Module.getO2Usage() / ((float)thisShip.volume + 1) * O2ProductionModifier;
    }
    currentRoom.O2Percent += O2ProductionRate - (occupationModifier * O2consumptionRate);
    if (currentRoom.O2Percent < 0) {
      currentRoom.O2Percent = 0;
    } else if (currentRoom.O2Percent > 100) {
      currentRoom.O2Percent = 100;
    }
  }
  
}