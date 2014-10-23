
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
//driver357 _driver357;

// gui
gui _gui;

void setup() {

  size(800, 600, P3D);  
  //size(800, 600, P2D) colorMode(HSB) frameRate(30);
      
//    smooth();
//    lights();
//    
//      noStroke();
      
  //cursor(CROSS);
  
  H.init(this).background(#202020).autoClear(true);
  
  _driver = new driver(this);
  _driver.setup();

  //_driver357 = new driver357(this);
  //_driver357.setup();
  
  _gui = new gui(this);
  _gui.setup();
  
}

void draw() {
  
  if (_gui.set()) _gui.draw();
  else _gui.draw();
  
}

void stop() {
  
  _gui.close();
  
  super.stop();
}

//void keyPressed() {
//  
//  switch(key) {
//    case ' ':
//      break;
//    case 'm' | 'M':
//      _gui.systemToggle(_gui.systemisActive());
//      break;
//    case 'd' | 'D':
//      _gui.debugToggle(_gui.debugisActive());
//      break;
//    case 'c':
//      _gui.ks.toggleCalibration();
//      break;
//    case 'l':
//      _gui.ks.load();
//      break;
//    case 's':
//      _gui.ks.save();
//      break;
//  }
//  
//}

void mouseMoved() { }
