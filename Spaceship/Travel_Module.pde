class Travel_Module {
 
  float distanceTravelled = 10000; //initialDistanceFromStart
  float velocity = 10; //velocity in metres per second
  float massModifier = 10;
  float shipMass = newLayout.volume * massModifier;
  
  public Travel_Module() {
    
  }
  
  public void update() {
    shipMass = newLayout.volume * massModifier;
    distanceTravelled += velocity;
  }
  
  public void addImpulse(float force) {
    velocity += force / shipMass;
  }
  
  public float getDistance() {
    return distanceTravelled;
  }
  
  public float getVelocity() {
    return velocity;
  }
  
}