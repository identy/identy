
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
  
  boolean[] _portRelay = { 
    false, false, false, false, false, false, false, false
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
      _port.setDTR(false);
      _port.setRTS(false);
      
      //_port.bufferUntil(new String("#").getBytes()[0]);
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
      
  void reset() {
    for (int relay = 0; relay <= 7; relay++) {
      this._portRelay[relay] = false;
    }
  }
  
  // [*][*][relay pattern][#]
  void toggle(int relay) {
    
    this.reset();
    
    this._portRelay[relay - 1] = !this._portRelay[relay - 1];

    _write = (byte)pow(2, relay - 1);
    println("write :: " + binary(_write, 8));
    
//    _mask |= _write; _mask &= _write;
    _mask ^= _write;
    println("mask :: " + binary(_mask, 8));
    _write &= _mask;
    
    this._port.write(new byte[] {new String("*").getBytes()[0], new String("*").getBytes()[0], _write, new String("#").getBytes()[0]});
    
  }
  // [*][*][relay pattern][#]
  void write(int relay, boolean state) {

    //this.reset();
    
    this._portRelay[relay - 1] = state;
    
    _write = (byte)pow(2, relay - 1);
    println("write :: " + binary(_write, 8));
    
//    _mask |= _write; _mask &= _write;
    _mask ^= _write;
    println("mask :: " + binary(_mask, 8));
    _write &= _mask;
    
    this._port.write(new byte[] {new String("*").getBytes()[0], new String("*").getBytes()[0], _write, new String("#").getBytes()[0]});
    
  }
    
  void read() {
    this._port.write(new byte[] {new String("*").getBytes()[0], new String("*").getBytes()[0], _write, new String("#").getBytes()[0]});
  }
  
}

void serialEvent(Serial __port) {
         
  println("read :: " + binary(__port.read(), 8));
    
}
