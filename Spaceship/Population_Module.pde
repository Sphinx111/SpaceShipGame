class Population_Module {
 
  int totalPop = 10;
  int maxPop = 1000;
  
  double consumptionRate = 1;
  double maxConsumption = 2;
  
  void setPop(int newPop) {
    totalPop = newPop;  
  }
  
  void addPop(int add) {
    totalPop += add;
  }
  
  void setAbsMaxPop(float max) {
    maxPop = (int)max;
  }
  
  void setMaxPop(float ratio) {
    maxPop = 10+(int)Math.floor(990*ratio);
  }
  
  void setPopPercentage(double ratio) {
    totalPop = (int)(maxPop * ratio);
  }
  
  void setConsumptionRate(double ratio) {
    consumptionRate = 0.5 + ((maxConsumption-0.5) * ratio);
  }
  
  int getPop() {
    return totalPop;    
  }
  
  double getConsumption() {
    return totalPop * consumptionRate;  
  }
  
  void updatePopulation() {
      maxPop = (int)newLayout.getPopMaxTotal();
      if(Math.random() < (0.001*totalPop) && totalPop < maxPop) {
        double foodSurplus = resModule.getStores() - (10 * (totalPop * consumptionRate)); //amount of food left after 10 ticks at current consumption
        double percentageOversupply = foodSurplus / (100 * (totalPop * consumptionRate));
        if (percentageOversupply > 0) {
          totalPop += constrain((int)Math.floor(totalPop * percentageOversupply),0,(totalPop*0.2));
        }
      }
    if (resModule.getStores() <= (consumptionRate * totalPop)) {
      if (0.05 * totalPop >= 1) {
        totalPop -= (int)Math.floor(0.05 * totalPop);
      } else {
        if (Math.random() < 0.2) {
          totalPop -= 1;
        }
      }
    }
    if (totalPop > maxPop) {
      if (Math.random() < 0.2) {
        totalPop -= Math.floor((totalPop - maxPop) / 5) + 1;
      }
    }
    if (totalPop < 0) {
      totalPop = 0;
    }
  }
  
}