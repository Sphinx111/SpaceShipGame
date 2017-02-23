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
  
  static double energyConsumption = 0.5;
  static float energyProduction = 0;
  static float maxConsumptionRate = 2;
  static float energyToLifeSupport = 0.5;
  static float energyToEngines = 0.5;
  
  static double updateEnergy(double currentEnergy) {
    
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
  
  static double getConsumption() {
    return energyConsumption;
  }
  
  static void setEnergyProduction(float newProduction) {
    energyProduction = newProduction;
  }
  
  static void setEnergyConsumptionPercentage(double ratio) {
    energyConsumption = energyProduction * ratio * maxConsumptionRate;
  }
  
}

static class Stores_Module {
  
  static float storesProduction = 0;
  
  static double updateStores(double currentStores) {
     if (currentStores >= 0) {
     double newStores = currentStores - (popModule.getConsumption()) + storesProduction;
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
    return (current +  (popModule.totalPop * popModule.consumptionRate * 0.01));
  }
  
}

static class Oxygen_Module {
  
  // static float O2Reserves = 100;
  static float diffusionRate = 0.4;
  static float acceptableO2difference = 0;
  static float O2consumptionRate = 0.1; //Percent Oxygen consumed by person, per room, per tick
  static float O2ProductionRate = 0;
  static float lifeSupportModifier = 100;
  
  static void updateO2(Ship_Room currentRoom) {
    Ship_Room[] adjacentRooms = newLayout.getAdjacentRooms(currentRoom.coords[0],currentRoom.coords[1]);
    for (Ship_Room room : adjacentRooms) {
      float O2Transfer = 0;
      if (room != null) {
        O2Transfer = (room.O2Percent - currentRoom.O2Percent) / 2 * diffusionRate;
        room.O2Percent -= (O2Transfer) - acceptableO2difference;
        currentRoom.O2Percent += (O2Transfer) - acceptableO2difference;
      }
    }
    
    float occupationModifier = popModule.totalPop / (newLayout.volume + 1);
    if (currentRoom.lifeSupportActive) {
      O2ProductionRate = (float)Energy_Module.getConsumption() * Energy_Module.energyToLifeSupport / newLayout.volume;
    } else {
      O2ProductionRate = (float)Energy_Module.getConsumption() / newLayout.volume * (1/lifeSupportModifier);
    }
    currentRoom.O2Percent += O2ProductionRate - (occupationModifier * O2consumptionRate) ;
  }
  
}