
/*
 *
 * driver class
 *
 * arduino
 *
 * copyright 2014 identy [ www.identy.org ] 
 *
 */

// processing
import processing.serial.*;

// arduino
import cc.arduino.*;

class driver {

  // arduino control
  Arduino _arduino;

  private PApplet context;
  
  int[] _arduinoRelay = { 
    Arduino.LOW, Arduino.LOW, Arduino.LOW, Arduino.LOW, Arduino.LOW, Arduino.LOW, Arduino.LOW, Arduino.LOW, Arduino.LOW, Arduino.LOW, Arduino.LOW, Arduino.LOW, Arduino.LOW, Arduino.LOW
  };

  public driver(PApplet context) {
    try {
      this.context = context;
      
      //_arduino = new Arduino(context, "COM2", 57600);
      //this._arduino = new Arduino(context, Arduino.list()[0], 57600);
      this._arduino = new Arduino(context, Arduino.list()[0]);
    }
    catch (Exception e) {
      e.printStackTrace();
    }
  }

  void setup() {
    try {
      for (int relay = 2; relay <= 8; relay++) {
        this._arduino.pinMode(relay, Arduino.OUTPUT);
        //this._arduino.digitalWrite(relay, Arduino.LOW);
        //this._arduinoRelay[relay - 2] = Arduino.LOW;
      }
      this._arduino.pinMode(12, Arduino.OUTPUT);
      this._arduino.pinMode(12, Arduino.SERVO);
    }
    catch (Exception e) {
      e.printStackTrace();
    }
  }

  void setup(String port) {
   try {
      this._arduino.dispose();
      this._arduino = null;
      
      this._arduino = new Arduino(context, port);
      this.setup();
    }
    catch (Exception e) {
      e.printStackTrace();
    }
  }
   
  public String[] list() {
    return Arduino.list();
  }
      
  void reset() {
    for (int relay = 2; relay <= 8; relay++) {
      this._arduino.digitalWrite(relay, Arduino.LOW);
      this._arduinoRelay[relay - 2] = Arduino.LOW;
    }
  }

  void toggle(int relay) {

    this.reset();

    this._arduino.digitalWrite(relay + 1, Arduino.HIGH);
    this._arduinoRelay[relay - 1] = Arduino.HIGH;
      
  }

  void servo(int value) {
    this._arduino.servoWrite(12, value);
  }
  
  void write(int relay, boolean state) {
    
    this._arduino.digitalWrite(relay + 1, state ? Arduino.HIGH : Arduino.LOW);
    this._arduinoRelay[relay - 1] = state ? Arduino.HIGH : Arduino.LOW;
    
  }
    
}

void digitalEvent(int pin, int value) {
  println("Digital pin "+pin+" has new value "+value);}

void analogEvent(int pin, int value) {
  println("Analog pin "+pin+" has new value "+value);
}
