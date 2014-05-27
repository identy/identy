
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
  Serial _port;
  
  private byte _write = 0;
  private byte _mask = 0;
  
  private PApplet context;
  
  byte[] _portRelay = { 
    0, 2, 4, 8, 16, 32, 64, 127
  };

  public driver357(PApplet context) {
    try {
      this.context = context;
      this._port = new Serial(context, Serial.list()[1], 9600);
    }
    catch (Exception e) {
      e.printStackTrace();
    }
  }

  void setup() {
    try {
      //_port.setDTR(false);
      //_port.setRTS(false);
      
      //_port.bufferUntil(Integer.decode("#"));
    }
    catch (Exception e) {
      e.printStackTrace();
    }
  }

  void setup(String port) {
   try {
      this._port.dispose();
      this._port = null;
      
      this._port = new Serial(context, port, 9600);
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
  
  // [*][*][relay pattern][#]
  void toggle(int relay) {
    this.reset();
  }
  // [*][*][relay pattern][#]
  void write(int relay, boolean state) {

    _write = (byte)pow(2, relay - 1);
    println("write :: " + binary(_write, 8));
    
//    _mask |= _write;
//    println("mask or :: " + binary(_mask, 8));
//    _mask &= _write;
//    println("mask and :: " + binary(_mask, 8));
    _mask ^= _write;
    println("mask xor :: " + binary(_mask, 8));
    _write &= _mask;
    
    this._port.write(new byte[] {new String("*").getBytes()[0], new String("*").getBytes()[0], _write, new String("#").getBytes()[0]});
    
  }
    
  void read() {
    this._port.write(new byte[] {new String("*").getBytes()[0], new String("*").getBytes()[0], _write, new String("#").getBytes()[0]});
  }
  
}

void serialEvent(Serial __port) {

  //__port.clear();          
  //println("read :: " + binary(__port.read(), 8));
    
}
