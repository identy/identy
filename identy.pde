
/*
 *
 * sentence 
 *
 * arduino manager
 * 
 * copyright 2014 by identy [ www.identy.org ] 
 *
 */

// driver :: arduino, serial
driver _driver;

// gui
gui _gui;
// audio
audio _audio;
// step
step _step;

void setup() {

  size(800, 600, P3D);  
  //size(800, 600, P2D) colorMode(HSB) frameRate(30);
  background(#000000);
  
  _driver = new driver(this);
  _driver.setup();
  
  _audio = new audio(this);
  _audio.setup("___theme.mp3");
    
  _step = new step(this);
  _step.setup();
  
  _gui = new gui(this);
  _gui.setup();

  H.init(this).background(#202020).autoClear(true);
  
}

void draw() {
  
  _gui.set();
  _gui.draw();
  
}

void stop() {
  _audio.close();
  super.stop();
}
