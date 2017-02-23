class Background {
  
  int starCount = 40;
  int dustCount = 20;
  Star[] stars = new Star[starCount];
  Star[] dust = new Star[dustCount];
  float velocity;
  float blurThreshold = 10000; 
  float secondBlurThreshold = 10000000;
   
  public Background() {
    velocity = travelModule.getVelocity();
    for (int i = 0; i < starCount; i++) {
      stars[i] = new Star();
    }
    for (int i = 0; i < dustCount; i++) {
      dust[i] = new Star(0.7);
    }
    
  }
  
  void show() {
    fill(0);
    noStroke();
    rect(0,mainUI.uiHeight,width,height-mainUI.uiHeight);
    velocity = travelModule.getVelocity();
    float blurLength = 0;
    if (velocity > blurThreshold) {
      blurLength = (velocity - blurThreshold) * 0.0001;
    } else {
      stroke(150);
      for (Star d: dust) {
        d.show(0);
      }
    }
    stroke(255);
    for (Star s : stars) {
      s.show(blurLength);
    }
  }
  
  void update() {
    for (Star s : stars) {
      s.update(velocity);      
    }
    if (velocity < blurThreshold) {
      for (Star d : dust) {
        d.update(velocity);
      }
    }
    
  }
  
}

class Star {
  float[] pos = new float[2];
  float size = 1;
  boolean isDust = false;
  
  public Star() {
    float y = (float)((Math.random() * (height - mainUI.uiHeight)) + mainUI.uiHeight);
    float x = (float)(Math.random() * width);
    pos[0] = x;
    pos[1] = y;
    size = (float)(Math.random() + 0.5);
  }
  
  public Star(float size) {
    float y = (float)((Math.random() * (height - mainUI.uiHeight)) + mainUI.uiHeight);
    float x = (float)(Math.random() * width);
    pos[0] = x;
    pos[1] = y;
    this.size = size;
    isDust = true;
  }
  
  void show(float blur) {
    if (travelModule.velocity < mainBackground.secondBlurThreshold) {
      strokeWeight(constrain(size - (blur / 2),0.01,1.5));
    } else {
      strokeWeight(constrain((size - (blur / 2))*5,0.01,15));
    }
    if (blur <= 0) {
      point(pos[0],pos[1]);
    } else {
      line(pos[0],pos[1],pos[0]-blur,pos[1]);
    }
  }
  
  void update(float velocity) {
    if (pos[0] < 0) {
      pos[0] = width + (float)((velocity * 0.01) * Math.random());
      pos[1] = (float)((Math.random() * (height - mainUI.uiHeight)) + mainUI.uiHeight);
    }
    if (!isDust) {
      if (velocity < mainBackground.secondBlurThreshold) {
        pos[0] -= (velocity * 0.0001) + (size * 0.001);
      } else {
        pos[0] -= (velocity / travelModule.c * width) + (size * 0.0001);
      }
    } else {
      pos[0] -= 5 + (velocity * 0.001);
    }
  }
  
}