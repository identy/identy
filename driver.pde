
/*
 *
 * driver class
 *
 * arduino
 *
 * copyright 2014 identy [ www.identy.org ] 
 *
 */

// firmata
import org.firmata.*;

// processing
import processing.serial.*;

// arduino
import cc.arduino.*;

class driver {

  // arduino control
  Arduino _arduino;

  private PApplet context;

//  private byte pinInit = 1;  
//  private byte pinDone = 1;
//  
//  private byte pinServo = 12;
  
  int[] _arduinoRelay = { 
    Arduino.LOW, Arduino.LOW, Arduino.LOW, Arduino.LOW, Arduino.LOW, Arduino.LOW, Arduino.LOW, Arduino.LOW
  };

  public driver(PApplet context) {
    try {
      this.context = context;
      
      this._arduino = new Arduino(context, Arduino.list()[0]);
    }
    catch (Exception e) {
      //e.printStackTrace();
    }
  }

  void setup() {
    
    if (this._arduino == null) return;
    
    try {
      //this._arduino.pinMode(pinInit, Arduino.OUTPUT);

      for (int index = 0; index <= 7; index++) {
        this._arduinoRelay[index] = Arduino.LOW;
      }
      
      for (int relay = 0; relay <= 7; relay++) {
        this._arduino.pinMode(relay + 2, Arduino.OUTPUT);
        this._arduino.digitalWrite(relay + 2, Arduino.LOW);
      }
      
      //this._arduino.pinMode(pinServo, Arduino.OUTPUT);
      //this._arduino.pinMode(pinServo, Arduino.SERVO);
      
      //this._arduino.pinMode(pinDone, Arduino.OUTPUT);
    }
    catch (Exception e) {
      e.printStackTrace();
    }
  }

  void setup(String port) {
   try {
      if (this._arduino != null) this._arduino.dispose();
      this._arduino = null;
      
      this._arduino = new Arduino(context, port);
      this.setup();
    }
    catch (Exception e) {
      //e.printStackTrace();
    }
  }
   
  void init(boolean state) {
    //this._arduinoRelay[pinInit] = state ? Arduino.HIGH : Arduino.LOW;    
    //this._arduino.digitalWrite(pinInit, state ? Arduino.HIGH : Arduino.LOW);
  }
  void done(boolean state) {
    //this._arduinoRelay[pinDone] = state ? Arduino.HIGH : Arduino.LOW;    
    //this._arduino.digitalWrite(pinDone, state ? Arduino.HIGH : Arduino.LOW);
  }

  public String[] list() {
    return Arduino.list();
  }
      
  void reset() {
    //this._arduino.digitalWrite(pinInit, Arduino.LOW);
    for (int index = 0; index <= 7; index++) {
      this._arduinoRelay[index] = Arduino.LOW;
    }
    for (int relay = 0; relay <= 7; relay++) {
      this._arduino.digitalWrite(relay + 2, Arduino.LOW);
    }
    //this._arduino.digitalWrite(pinDone, Arduino.LOW);
  }

  void toggle(int relay) {

    this.reset();
    
    this._arduinoRelay[relay] = Arduino.HIGH;
    this._arduino.digitalWrite(relay + 2, Arduino.HIGH);
      
  }
  
  void write(int relay, boolean state) {

    this._arduinoRelay[relay] = state ? Arduino.HIGH : Arduino.LOW;    
    this._arduino.digitalWrite(relay + 2, state ? Arduino.HIGH : Arduino.LOW);
    
  }

//  void servo(int value) {
//    this._arduino.servoWrite(pinServo, value);
//  }
  
  void read() {}
  
  void digitalEvent(int pin, int value) {
    println("Digital pin "+pin+" has new value "+value);}
  
  void analogEvent(int pin, int value) {
    println("Analog pin "+pin+" has new value "+value);
  }

}
