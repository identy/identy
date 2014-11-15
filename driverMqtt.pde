
/*
 *
 * driver class
 *
 * mqtt
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

/*
 * author: Andreas Göransson, 2014
 */
import se.goransson.qatja.messages.*;
import se.goransson.qatja.*;

class driverMqtt {

  private PApplet context;

  private Qatja _client;

  int[] _arduinoRelay = { 
    Arduino.LOW, Arduino.LOW, Arduino.LOW, Arduino.LOW, Arduino.LOW, Arduino.LOW, Arduino.LOW, Arduino.LOW
  };
  
  public driverMqtt(PApplet context) {
    try {
      this.context = context;
            
      //this._client = new Qatja( this );
      this._client = new Qatja( context );
      this._client.DEBUG = true;
    }
    catch (Exception e) {
      //e.printStackTrace();
    }
  }

  void setup(String broker) {

    this._client.connect( "192.168.1.3", 1883, "unity-client" );
      
    if (this._client == null) return;
    
    try {
      
      for (int index = 0; index <= 7; index++) {
        this._arduinoRelay[index] = Arduino.LOW;
      }

      this._client.subscribe( "relay" );
    }
    catch (Exception e) {
      e.printStackTrace();
    }
  }

  public String[] list() {
    return new String[] {"192.168.1.3"};
  }
  
  void reset() {
    for (int index = 0; index <= 7; index++) {
      this._arduinoRelay[index] = Arduino.LOW;
    }
  }

  void write(int relay, boolean state) {
    String _bit = state ? "1" : "0";
    String _relay = str(relay);
    
    if (this._arduinoRelay[relay] == Arduino.HIGH ? true : false || state) this._client.publish( "relay", _relay + ", " + _bit);
    this._arduinoRelay[relay] = state ? Arduino.HIGH : Arduino.LOW;
    
    this._client.publish( "relay", _relay + "," + _bit);
  }

  void toggle(int relay) {
        
    this._arduinoRelay[relay] = this._arduinoRelay[relay] == Arduino.HIGH ? Arduino.LOW : Arduino.HIGH;
    
    String _bit = this._arduinoRelay[relay] == Arduino.HIGH ? "1" : "0";
    String _relay = str(relay);

    this._client.publish( "relay", _relay + "," + _bit);
    
  }

  void read() {}
  
  void close() {
   this._client.disconnect();
  }
  
  void mqttCallback(MQTTPublish message){
    
    String payload = new String(message.getPayload());
    String[] coords = split(payload, ",");
    
    //x = parseInt(coords[0]); y = parseInt(coords[1]);
    println("mqtt Callback relay " + coords[0] + ", bit " + coords[1]);
    
  }
  
}

