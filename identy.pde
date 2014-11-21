
/*
 *
 * identy 
 *
 * interactive
 * 
 * copyright 2014 by identy [ www.identy.org ] 
 *
 */

import ketai.ui.*;

// driver :: Mqtt
driverMqtt _driverMqtt;
// driver :: arduino
//driver _driver;
// driver :: serial
//driver357 _driver357;

// gui
gui _gui;

void setup() {
 
  orientation(LANDSCAPE);
  //size(800, 600, P3D) colorMode(HSB) frameRate(30);
  size(800, 500, P3D);
  
//    smooth();
//    lights();
//    
//      noStroke();
      
  //cursor(CROSS);
  
  //H.init(this).background(#202020).autoClear(true);
  
  _driverMqtt = new driverMqtt(this);
  //_driverMqtt.setup();

  //_driver = new driver(this);
  //_driver.setup();

  //_driver357 = new driver357(this);
  //_driver357.setup();
  
  _gui = new gui(this);
  _gui.setup(this);
  
  //KetaiAlertDialog.popup(this, "identy!", "system setup");
  
}

void draw() {
  
  if (_gui.set()) _gui.draw(this);
  //else _gui.draw();
  
}

void stop() {
  
  _gui.close();
  _driverMqtt.close();
  //_driver.close();
  super.stop();
}

void exit(){
  super.exit();
}  

void keyPressed() {
  
  switch(key) {
    case ' ':
      break;
    case 'a' | 'A':
    case 'p' | 'P':
      _gui.Sequence();
      break;
    case 'm' | 'M':
      _gui.selectSystem(!_gui.isSystem());
      break;
    case 'd' | 'D':
      //_gui.selectDraw(!_gui.isDraw());
      break;
    case 'g' | 'G':
      _gui.selectDebug(!_gui.isDebug());
      break;
    case 'c':
      //_gui.ks.toggleCalibration();
      break;
    case 'l':
      //_gui.ks.load();
      break;
    case 's':
      //_gui.ks.save();
      break;
  }

}

void mouseMoved() { }
