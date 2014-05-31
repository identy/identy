
/*
 *
 * identy 
 *
 * interactive
 * 
 * copyright 2014 by identy [ www.identy.org ] 
 *
 */

// driver :: arduino
driver _driver;
// driver :: serial
driver357 _driver357;

// gui
gui _gui;
// audio
audio _audio;
// step
step _step;

//effect
star _star;

void setup() {

  size(800, 600, P3D);  
  //size(800, 600, P2D) colorMode(HSB) frameRate(30);
  H.init(this).background(#202020).autoClear(true);
    
  _driver = new driver(this);
  _driver.setup();

  _driver357 = new driver357(this);
  _driver357.setup();
  
  _audio = new audio(this);
  _audio.setup("___theme.mp3");
    
  _step = new step(this);
  _step.setup();
  
  _gui = new gui(this);
  _gui.setup();
  
}

void draw() {
  
  _gui.set();
  
  //_driver.read();
  //_driver357.read();
  
  _gui.draw();
  
}

void stop() {
  _audio.close();
  super.stop();
}
