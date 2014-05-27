
/*
 *
 * driver 357 class
 *
 * microchip
 *
 * copyright 2014 identy [ www.identy.org ] 
 *
 */

// processing
import processing.serial.*;

class driver357 {

  // serial control
  Serial _Port;  

  private PApplet context;
  
  int[] _portRelay = { 
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  };

  public driver357(PApplet context) {
    try {
      this.context = context;
      
      this._port = new Serial(context, Serial.list()[0]);
 
    }
    catch (Exception e) {
      e.printStackTrace();
    }
  }

  void setup() {
    try {}
    catch (Exception e) {
      e.printStackTrace();
    }
  }

  void setup(String port) {
   try {
      this._port.dispose();
      this._port = null;
      
      this._port = new Serial(context, port);
      this.setup();
    }
    catch (Exception e) {
      e.printStackTrace();
    }
  }
   
  public String[] list() {
    return Serial.list();
  }
      
  void reset() {}

  void toggle(int relay) {

    this.reset();
      
  }
  
  void write(int relay, boolean state) {
    _port.write('H');
  }
    
}

void serialEvent(Serial __port) {}
