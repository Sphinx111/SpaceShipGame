class Travel_Module {
 
  float distanceTravelled = 10000; //initialDistanceFromStart
  public float velocity = 10; //velocity in metres per second
  float massModifier = 10;
  public float c = 299792458;
  double relativityMassModifier = 1 / Math.sqrt((1 - ((velocity * velocity) / (c * c))));
  float shipMass = (float)(((newLayout.volume * massModifier) + resModule.getMetals() )* relativityMassModifier);
  
  public Travel_Module() {
    
  }
  
  public void update() {
    shipMass = newLayout.volume * massModifier;
    distanceTravelled += velocity;
  }
  
  public void addImpulse(float force) {
    velocity += force / shipMass * (Energy_Module.energyConsumption * Energy_Module.energyToEngines);
  }
  
  public float getDistance() {
    return distanceTravelled;
  }
  
  public float getVelocity() {
    return velocity;
  }
  
}