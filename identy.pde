
/*
 *
 * identy 
 *
 * interactive
 * 
 * copyright 2014 by identy [ www.identy.org ] 
 *
 */

// processing.*;
//import processing.opengl.*;
//import processing.data;

//import org.json.*; 
//import org.json.JSONArray;
//import org.json.JSONObject;


//import java.awt.Frame;

// import ketai.ui.*;

// driver :: Mqtt
driverMqtt _driverMqtt;
// driver :: arduino
//driver _driver;
// driver :: serial
//driver357 _driver357;

// gui
gui _gui;

void setup() {
 
  //orientation(LANDSCAPE);

  //size(800, 600, P3D) colorMode(HSB) frameRate(30);
  //size(600, 400, P3D);
  
  size(800, 500, OPENGL);
  H.init(this).background(#202020).autoClear(true);
  
  smooth();
    
//    lights();
//    noStroke();
//    cursor(CROSS);
  
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
  this.stop();
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

void mouseMoved() {}

