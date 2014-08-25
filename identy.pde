
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
//audio _audio;
// step
step _step;

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
  
//  _audio = new audio(this);
//  _audio.setup("theme.mp3");
    
  //_step = new step(this);
  //_step.setup();
  
  _gui = new gui(this);
  _gui.setup();
  
}

void draw() {
  
  _gui.set();

  _gui.draw();
  
}

void stop() {
//  _audio.close();
  super.stop();
}

void keyPressed() {
  
  switch(key) {
  case 'c':
    // enter/leave calibration mode, where surfaces can be warped 
    // and moved
    _gui.ks.toggleCalibration();
    break;

  case 'l':
    // loads the saved layout
    _gui.ks.load();
    break;

  case 's':
    // saves the layout
    _gui.ks.save();
    break;


  case ' ':
    break;
//  case 'm' | 'M':
//    _gui.menuSystemToggle(true);
//    break;
//  case 'd' | 'D':
//    _gui.debugSystemToggle(true);
//    break;
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
