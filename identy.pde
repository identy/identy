
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

void setup() {

  size(800, 600, P3D);  
  //size(800, 600, P2D) colorMode(HSB) frameRate(30);
      
    smooth();
    lights();
    
      noStroke();
      
  //cursor(CROSS);
  
  //H.init(this).background(#202020).autoClear(true);
  
  _driver = new driver(this);
  _driver.setup();

  _driver357 = new driver357(this);
  //_driver357.setup();
  
  _gui = new gui(this);
  _gui.setup();
  
}

void draw() {
  
  _gui.set();

  _gui.draw();
  
}

void stop() {
  
  //_driver.close();
  //_driver357.close();
  
  _gui.close();
  
  super.stop();
}

void keyPressed() {
  
  switch(key) {
  case 'c':
    _gui.ks.toggleCalibration();
    break;
  case 'l':
    _gui.ks.load();
    break;
  case 's':
    _gui.ks.save();
    break;


  case ' ':
    break;
    
  }
  
}


void mouseMoved()
{
  // usually when setting the amplitude and frequency of an Oscil
  // you will want to patch something to the amplitude and frequency inputs
  // but this is a quick and easy way to turn the screen into
  // an x-y control for them.
 // _gui.move();
}
