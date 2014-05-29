
/*
 *
 * gui class
 * 
 * copyright 2014 identy [ www.identy.org ]
 *
 */

import java.awt.Frame;
import java.awt.BorderLayout;

import controlP5.*;

class gui {

  final static int CONTROLLER = 0, TAB = 1, GROUP = 2;
  
  private color backgroundColor = color(0, 0, 0);
  private color strokeColor = color(255, 255, 255);
  private color fillColor = color(4, 79, 111);
  
  private controlP5.ControlP5 _gui;

  private controlP5.Button _buttonSystem;
  private controlP5.ControlGroup _groupSystem;

  private controlP5.ListBox _listArduinoPort;
  private controlP5.ListBox _listSerial357Port;
  
  private controlP5.Button sequencePlay;
  
  private controlP5.Textarea consoleDebug;
  private controlP5.CheckBox checkboxDebugger;
  
  //controlP5.Knob audioVolume;
  //controlP5.Knob servoAngle;
  
  Println console;
  
  private PApplet context;
    
  public gui(PApplet context) {

    this.context = context;

    _gui = new ControlP5(context);
    _gui.addControllersFor(context);   
    _gui.setAutoDraw(true);
    _gui.enableShortcuts();
    
    //_gui.setControlFont(createFont("Tahoma", 11));
    _gui.setControlFont(createFont("MS UI GOTHIC", 12));

    _gui.setColorBackground(0xff660000);  
    _gui.setColorForeground(0xffaa0000);
    _gui.setColorLabel(0xffdddddd);
    _gui.setColorValue(0xffff88ff);
    _gui.setColorActive(0xffff0000);
    
  }

  void setup() {
                
    _buttonSystem = _gui.addButton("menuSystem", 1, 1, 1, 100, 20);
    _buttonSystem.getCaptionLabel().set("system ");
    _buttonSystem.getCaptionLabel().align(LEFT,CENTER);
    _buttonSystem.getCaptionLabel().setLetterSpacing(2);
    _buttonSystem.getCaptionLabel().toUpperCase(false);
    
    _groupSystem = _gui.addGroup("groupSystem", 1, 22, width - 2);
    _groupSystem.setBackgroundHeight(height - 140);
    //_groupSystem.setBackgroundColor(color(17, 17, 17));
    _groupSystem.setBackgroundColor(color(0,51,102,200));
    _groupSystem.activateEvent(true);
    _groupSystem.hideBar();
    _groupSystem.hide();

    _gui.addTextlabel("PortArduino", "arduino port", 20, 20)
      .moveTo(_groupSystem);
    
    _listArduinoPort = _gui.addListBox("arduinoPort", 20, 60, 200, 60);
    _listArduinoPort.moveTo(_groupSystem);
    _listArduinoPort.setBarHeight(18);
    _listArduinoPort.toUpperCase(false);
    _listArduinoPort.getCaptionLabel().set("port");
    _listArduinoPort.actAsPulldownMenu(true);
    _listArduinoPort.setItemHeight(20);
    _listArduinoPort.enableCollapse();
    
    for (int i = 0; i < _driver.list().length; i++) {
      _listArduinoPort.addItem(_driver.list()[i], i);
    }
   
    _listArduinoPort.addListener(new portListener());
    //_listArduinoPort.setValue(0);

    _gui.addTextlabel("Port357", "serial357 port", 240, 20)
      .moveTo(_groupSystem);
    
    _listSerial357Port = _gui.addListBox("serial357Port", 240, 60, 200, 60);
    _listSerial357Port.moveTo(_groupSystem);
    _listSerial357Port.setBarHeight(18);
    _listSerial357Port.toUpperCase(false);
    _listSerial357Port.getCaptionLabel().set("port");
    _listSerial357Port.actAsPulldownMenu(true);
    _listSerial357Port.setItemHeight(20);
    _listSerial357Port.enableCollapse();
    
    for (int i = 0; i < _driver.list().length; i++) {
      _listSerial357Port.addItem(_driver357.list()[i], i);
    }
   
    _listSerial357Port.addListener(new port357Listener());
    //_listSerial357Port.setValue(0);
    
    for (int index = 1; index <= 7; index++) {
      
      Toggle relayToggle = _gui.addToggle("relayToggle" + index)
        .moveTo(_groupSystem)
        .setBroadcast(false)
        .setId(index)
        .setPosition(20, 60 + (40 * index))
        .setSize(50, 20)
        .setValue(false)
        .setBroadcast(true)
        .setMode(ControlP5.SWITCH);
        
      relayToggle.getCaptionLabel().set("relay " + index);
      relayToggle.getCaptionLabel().toUpperCase(false);
      
      _gui.getController("relayToggle" + index).addListener(new relayToggleListener());
      
      Range rangeRelay = _gui.addRange("rangeRelay" + index)
        .moveTo(_groupSystem)
        .setBroadcast(false)
        .setId(index)
        .setPosition(110, 60 + (40 * index))
        .setSize(400, 20)
        .setHandleSize(20)
        .setRange(0, 100)
        .setRangeValues(10, 40)
        .setSliderMode(Slider.FLEXIBLE)
        .setBroadcast(true)
        .setColorForeground(color(255, 40))
        .setColorBackground(color(255, 40));
        
      rangeRelay.getCaptionLabel().set("range " + index);
      rangeRelay.getCaptionLabel().toUpperCase(false);
      
      _gui.getController("rangeRelay" + index).addListener(new relayRangeListener());
      
    }
    
    for (int index = 1; index <= 8; index++) {
      
      Toggle relayControl = _gui.addToggle("relayControl" + index)
        .moveTo(_groupSystem)
        .setBroadcast(false)
        .setId(index)
        .setPosition(580, 60 + (40 * index))
        .setSize(50, 20)
        .setValue(false)
        .setBroadcast(true)
        .setMode(ControlP5.SWITCH);
        
      relayControl.getCaptionLabel().set("relay " + index);
      relayControl.getCaptionLabel().toUpperCase(false);
      
      _gui.getController("relayControl" + index).addListener(new relayControlListener());

    }

    sequencePlay = _gui.addButton("sequencePlay")
      .moveTo(_groupSystem)
      .setBroadcast(false)
      .setValue(128)
      .setPosition(720, 20)
      .setImages(loadImage("play_red.png"), loadImage("play_blue.png"), loadImage("play_green.png"))
      .setBroadcast(true)
      .updateSize();
    
//    servoAngle = _gui.addKnob("servoAngle")
//      .setBroadcast(false)
//      .setRange(0, 180)
//      .setValue(20)
//      .setPosition(30, 400)
//      .setRadius(30)
//      .setNumberOfTickMarks(9)
//      .setTickMarkLength(6)
//      .snapToTickMarks(true)
//      .setBroadcast(true)
//      .setColorForeground(color(255))
//      .setColorBackground(color(0, 160, 100))
//      .setColorActive(color(255, 255, 0))
//      .setDragDirection(Knob.HORIZONTAL);
//
//    servoAngle.captionLabel().set("angle ");
//    servoAngle.captionLabel().toUpperCase(false);

//    audioVolume = _gui.addKnob("audioVolume")
//      .setBroadcast(false)
//      .moveTo(_groupSystem)
//      .setRange(-20, 20)
//      .setValue(20)
//      .setPosition(500, 420)
//      .setRadius(30)
//      .setNumberOfTickMarks(8)
//      .setTickMarkLength(5)
//      .snapToTickMarks(true)
//      .setBroadcast(true)
//      .setColorForeground(color(255))
//      .setColorBackground(color(0, 160, 100))
//      .setColorActive(color(255, 255, 0))
//      .setDragDirection(Knob.HORIZONTAL);
//
//    audioVolume.captionLabel().set("volume ");
//    audioVolume.captionLabel().toUpperCase(false);

    checkboxDebugger = _gui.addCheckBox("checkboxDebugger")
      .moveTo(_groupSystem)
      .setPosition(20, 440)
      .setColorForeground(color(120))
      .setColorActive(color(255))
      .setColorLabel(color(255))
      .setSize(10, 10)
      .setItemsPerRow(4)
      .setSpacingColumn(86)
      .setSpacingRow(20)
      .addItem("debuger", 0)
      .addItem("draw", 1)
      .addItem("mute", 2)
      .addItem("repeat", 3);
    
    for(Toggle toggle:checkboxDebugger.getItems()) {
      toggle.getCaptionLabel().toUpperCase(false);
    }
        
    consoleDebug = _gui.addTextarea("consoleDebug")
      .setPosition(4, height - 100 - 8)
      .setSize(width - 8 - 4, 100)
      .setColorBackground(color(27, 27, 27))
      .setFont(new ControlFont(createFont("Helvetica", 10, true)))
      .setLineHeight(14);

    console = _gui.addConsole(consoleDebug);

    _gui.getTooltip().setDelay(300);   
    _gui.getTooltip().register("buttonSystem", "system define");

    checkboxDebugger.activate("debuger");
    checkboxDebugger.activate("draw");
    
  }

  void set() {

    for (int relay = 0; relay <= 6; relay++) {
      ((Toggle)(_gui.getController("relayToggle" + (relay + 1)))).setState(_driver._arduinoRelay[relay] == Arduino.HIGH);
    }

//    for (int relay = 0; relay <= 7; relay++) {
//      ((Toggle)(_gui.getController("relayControl" + (relay + 1)))).setState(_driver357._portRelay[relay]);
//    }

    if (_step.isPlaying() | _audio.isPlaying()) 
      sequencePlay.setImages(loadImage("pause_red.png"), loadImage("pause_blue.png"), loadImage("pause_green.png"));
    else 
      sequencePlay.setImages(loadImage("play_red.png"), loadImage("play_blue.png"), loadImage("play_green.png"));
  
  }

  void draw() {   

    
    //camera(width/2.0  + 300 * cos(frameCount/300.0), height/2.0 - 100, height/2.0 + 300 * sin(frameCount/300.0), width/2.0, height/2.0, 0, 0, 1, 0);
    //rotate(frameCount*0.001);

    background(backgroundColor);
    stroke(strokeColor);
    fill(fillColor);
    
    smooth();
    lights();
    
    if (this.drawDebug()) _audio.draw(0);
      
    //_gui.show();
    //_gui.draw();
              
  }
  
  void sequencePlay() {
    if (!_audio.isPlaying()) {
      if (repeatDebug()) {
        _audio.loop();
      }
      else {
        _audio.play();
      }
      sequencePlay.setImages(loadImage("pause_red.png"), loadImage("pause_blue.png"), loadImage("pause_green.png"));
    }
    else {
      _audio.stop();
      sequencePlay.setImages(loadImage("play_red.png"), loadImage("play_blue.png"), loadImage("play_green.png"));
    }
    
    if (!_step.isPlaying()) {
      if (repeatDebug()) {
        _step.loop();
      }
      else {
        _step.play();
      }
    }
    else {
      _step.stop();
    }
    
    if (this.muteDebug()) this.audioVolume(-255);
    
  }
  
  void menuSystem() {
    if (_groupSystem.isVisible()) {
      _groupSystem.hide();
    } 
    else {
      _groupSystem.show();
    }
  }
  
  void debugSystem() {
    if (consoleDebug.isVisible()) {
      consoleDebug.hide();
    } 
    else {
      consoleDebug.show();
    }
  }

  void audioVolume(int value) {
    _audio.volume(value);
  }

  void servoAngle(int value) {
    _driver.servo(value);
  }

  boolean consoleDebug() {
    return checkboxDebugger.getItem(0).getState();
  }
  boolean drawDebug() {
    return checkboxDebugger.getItem(1).getState();
  }
  boolean muteDebug() {
    return checkboxDebugger.getItem(2).getState();
  } 
  boolean repeatDebug() {
    return checkboxDebugger.getItem(3).getState();
  }
  
  public void controlEvent(ControlEvent _event) {

    int value;
    int id;

    int type = _event.getType();
    
    switch ( type ) {
      case GROUP:
        controlP5.ControlGroup _group = _event.getGroup();
        id = _group.getId();
        value = (int) _group.getValue();
        
//        if (_event.isGroup()) {
//          println(_event.getGroup().getName() + ".");
//        }

        break;
      case CONTROLLER:
        controlP5.Controller _controller = _event.getController();
        value = (int) _controller.getValue();
        id = _controller.getId();
        
//        if (_event.isController()) {
//          println(_event.getController().getName() + ".");
//        }

        if (_event.isFrom(_buttonSystem))
          if (_event.getName() == "menuSystem") this.menuSystem();

        if (_event.isFrom(sequencePlay))
          if (_event.getName() == "sequencePlay") this.sequencePlay();
        //if (_event.isFrom(audioVolume)) 
        //  if (_event.getName() == "audioVolume") this.audioVolume(value);
        //if (_event.isFrom(servoAngle)) 
        //  if (_event.getName() == "servoAngle") this.servoAngle(value);
                
        break;
    }
        
  }

}

void controlEvent(ControlEvent _event) {
  _gui.controlEvent(_event);
}

void keyPressed() {
  switch( key ) {
    case ' ':
      break;
    case 'm' | 'M':
      _gui.menuSystem();
      break;
    case 'd' | 'D':
      _gui.debugSystem();
      break;
  }
}

class portListener implements ControlListener {
  public void controlEvent(ControlEvent _event) {
    try {
      if (_event.isGroup()) {
        
        if (_gui.consoleDebug()) println(_event);
      
        _driver.setup(_driver.list()[(int)_event.getGroup().getValue()]);
      }
      if (_event.isController()) {}       
    }
    catch (Exception e) {}
  }
}

class port357Listener implements ControlListener {
  public void controlEvent(ControlEvent _event) {
    try {
      if (_event.isGroup()) {
        
        if (_gui.consoleDebug()) println(_event);
      
        _driver357.setup(_driver357.list()[(int)_event.getGroup().getValue()]);
      }
      if (_event.isController()) {}       
    }
    catch (Exception e) {}
  }
}

class relayToggleListener implements ControlListener {
  public void controlEvent(ControlEvent _event) {
    if (_event.isController()) {
      
      //if (_gui.consoleDebug()) println(_event);
      
      try {      
        _driver.write(_event.getController().getId(), _event.getController().getValue() > 0);
      }
      catch(Exception e) {}
      
    }
  }

}
class relayControlListener implements ControlListener {
  public void controlEvent(ControlEvent _event) {
    if (_event.isController()) {
      
      //if (_gui.consoleDebug()) println(_event);
      
      try {      
        _driver357.write(_event.getController().getId(), _event.getController().getValue() > 0);
      }
      catch(Exception e) {}

    }
  }

}


class relayRangeListener implements ControlListener {
  public void controlEvent(ControlEvent _event) {
    if (_event.isController()) {
      
      if (_gui.consoleDebug()) println(" index :: " + _event.getController().getId() + " | " + _event.getController().getArrayValue(0) + " | " + _event.getController().getArrayValue(1));
      
      //_step.delay(_event.getController().getId(), _event.getController().getArrayValue(1) - _event.getController().getArrayValue(0));
      _step.duration(_event.getController().getId(), _event.getController().getArrayValue(0));
          
    }
  }

}
