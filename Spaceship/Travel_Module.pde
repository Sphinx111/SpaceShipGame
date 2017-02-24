class Travel_Module {
 
  float distanceTravelled = 10000; //initialDistanceFromStart
  public float velocity = 10; //velocity in metres per second
  float massModifier = 10;
  public float c = 299792458;
  double relativityMassModifier = 1 / Math.sqrt((1 - ((velocity * velocity) / (c * c))));
  float shipMass = (float)((newLayout.volume * massModifier) + resModule.getMetals());
  
  public Travel_Module() {
    
  }
  
  public void update() {
    velocity += newLayout.getEngineForce() / shipMass * (Energy_Module.energyConsumption * Energy_Module.energyToEngines);  
    shipMass = newLayout.volume * massModifier;
    distanceTravelled += velocity;
    if (velocity > (c * 0.01)) {
      shipMass = (float)(((newLayout.volume * massModifier) + resModule.getMetals() )* relativityMassModifier);
    }
  }
  
  public float getDistance() {
    return distanceTravelled;
  }
  
  public float getVelocity() {
    return velocity;
  }
  
}