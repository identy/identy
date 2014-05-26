
/*
 *
 * gui class
 * 
 * copyright 2014 by identy [ www.identy.org ]
 *
 */

// gui
import java.awt.Frame;
import java.awt.BorderLayout;

import controlP5.*;

class gui {

  final static int CONTROLLER = 0, TAB = 1, GROUP = 2;
  
  //color backgroundColor = color(4, 79, 111);
  private color backgroundColor = color(0, 0, 0);
  private color strokeColor = color(84, 145, 158);
  
  private color activeColor = color(#818181);
  private color textColor = color(84, 145, 158);

  private color relayoffColor = color(4, 79, 111);
  private color relayonColor = color(84, 145, 158);

  private controlP5.ControlP5 _gui;

  private controlP5.Button _buttonSystem;
  private controlP5.ControlGroup _groupSystem;

  private controlP5.ListBox _listArduinoPort;

  private controlP5.Button sequencePlay;
  
  private controlP5.CheckBox checkboxReplay;
  private controlP5.CheckBox checkboxRelay;
  private controlP5.CheckBox checkboxAudio;
  
  //controlP5.Knob audioVolume;
  controlP5.Knob servoAngle;

  private controlP5.Button _buttonDebug;
  private controlP5.ControlGroup _groupDebug;
  
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
                
    _buttonSystem = _gui.addButton("toggleSystem", 1, 1, 1, 100, 20);
    //_buttonSystem.setLabel("System");
    _buttonSystem.getCaptionLabel().set("System ");
    _buttonSystem.getCaptionLabel().align(LEFT,CENTER);
    _buttonSystem.getCaptionLabel().setLetterSpacing(2);
    _buttonSystem.getCaptionLabel().toUpperCase(false);
    
    _groupSystem = _gui.addGroup("groupSystem", 1, 22, 680);
    _groupSystem.setBackgroundHeight(height - (22 * 2));
    _groupSystem.setBackgroundColor(color(0, 100));
    _groupSystem.activateEvent(true);
    _groupSystem.hideBar();
    _groupSystem.hide();

    _gui.addTextlabel("Port", "Connection", 20, 20)
      .moveTo(_groupSystem);

    //_gui.printPublicMethodsFor(ListBox.class);
    
    _listArduinoPort = _gui.addListBox("arduinoPort", 20, 60, 200, 60);
    _listArduinoPort.setBarHeight(18);
    _listArduinoPort.moveTo(_groupSystem);
    _listArduinoPort.toUpperCase(false);
    _listArduinoPort.getCaptionLabel().set("port");
    _listArduinoPort.actAsPulldownMenu(true);
    _listArduinoPort.setItemHeight(20);
    
    for (int i = 0; i < _driver.list().length; i++) {
      _listArduinoPort.addItem(_driver.list()[i], i);
    }
   
    _listArduinoPort.addListener(new portListener());

    //_listArduinoPort.setBroadcast(false);
    _listArduinoPort.setValue(0);
    //_listArduinoPort.setBroadcast(true);
    
    for (int index = 1; index <= 7; index++) {
      Toggle toggleRelay = _gui.addToggle("toggleRelay" + index)
        .setBroadcast(false)
        .setId(index)
        .setPosition(20, 40 + (40 * index))
        .setSize(50, 20)
        .moveTo(_groupSystem)
        .setValue(false)
        .setBroadcast(true)
        .setMode(ControlP5.SWITCH);
        
      toggleRelay.getCaptionLabel().set("relay " + index);
      toggleRelay.getCaptionLabel().toUpperCase(false);
      
      _gui.getController("toggleRelay" + index).addListener(new relayToggleListener());
      
      Range rangeRelay = _gui.addRange("rangeRelay" + index)
        .setBroadcast(false)
        .setId(index)
        .moveTo(_groupSystem)
        .setPosition(110, 40 + (40 * index))
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
    
    sequencePlay = _gui.addButton("sequencePlay")
      .setBroadcast(false)
      .moveTo(_groupSystem)
      .setValue(128)
      .setPosition(20, 420)
      .setImages(loadImage("play_red.png"), loadImage("play_blue.png"), loadImage("play_green.png"))
      .setBroadcast(true)
      .updateSize();

    checkboxRelay = _gui.addCheckBox("checkboxRelay")
      .setPosition(86, 420)
      .setColorForeground(color(120))
      .setColorActive(color(255))
      .setColorLabel(color(255))
      .setSize(10, 10)
      .setItemsPerRow(5)
      .setSpacingColumn(84)
      .setSpacingRow(20)
      .moveTo(_groupSystem)
      .addItem("relay", 0);

    //checkboxDebug.setImages(loadImage("check_box_normal.png"), loadImage("check_box_selected.png"), loadImage("check_box_normal.png"));
    
    for(Toggle toggle:checkboxRelay.getItems()) {
      toggle.getCaptionLabel().toUpperCase(false);
    }

    checkboxReplay = _gui.addCheckBox("checkboxReplay")
      .setPosition(86, 440)
      .setColorForeground(color(120))
      .setColorActive(color(255))
      .setColorLabel(color(255))
      .setSize(10, 10)
      .setItemsPerRow(1)
      .setSpacingColumn(64)
      .setSpacingRow(20)
      .moveTo(_groupSystem)
      .addItem("replay", 0);
       
    //checkboxReplay.setImages(loadImage("check_box_normal.png"), loadImage("check_box_normal.png"), loadImage("check_box_selected.png"));
    
    for(Toggle toggle:checkboxReplay.getItems()) {
      toggle.getCaptionLabel().toUpperCase(false);
    }

    checkboxAudio = _gui.addCheckBox("checkboxAudio")
      .setPosition(86, 460)
      .setColorForeground(color(120))
      .setColorActive(color(255))
      .setColorLabel(color(255))
      .setSize(10, 10)
      .setItemsPerRow(2)
      .setSpacingColumn(64)
      .setSpacingRow(20)
      .moveTo(_groupSystem)
      .addItem("mute", 0)
      .addItem("vertex", 1);
      
    //checkboxAudio.setImages(loadImage("check_box_normal.png"), loadImage("check_box_normal.png"), loadImage("check_box_selected.png"));
    
    for(Toggle toggle:checkboxAudio.getItems()) {
      toggle.getCaptionLabel().toUpperCase(false);
    }

    servoAngle = _gui.addKnob("servoAngle")
      .setBroadcast(false)
      .moveTo(_groupSystem)
      .setRange(0, 180)
      .setValue(20)
      .setPosition(500, 420)
      .setRadius(36)
      .setNumberOfTickMarks(9)
      .setTickMarkLength(6)
      .snapToTickMarks(true)
      .setBroadcast(true)
      .setColorForeground(color(255))
      .setColorBackground(color(0, 160, 100))
      .setColorActive(color(255, 255, 0))
      .setDragDirection(Knob.HORIZONTAL);

    servoAngle.captionLabel().set("angle ");
    servoAngle.captionLabel().toUpperCase(false);

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
    
    _buttonDebug = _gui.addButton("toggleDebug", 1, 1, height - 22, 100, 20);
    //_buttonDebug.setLabel("System");
    _buttonDebug.getCaptionLabel().set("Debug ");
    _buttonDebug.getCaptionLabel().align(LEFT,CENTER);
    _buttonDebug.getCaptionLabel().setLetterSpacing(2);
    _buttonDebug.getCaptionLabel().toUpperCase(false);
    
    _groupDebug = _gui.addGroup("groupDebug", 1, 2, height - 82);
    _groupDebug.setBackgroundHeight(82);
    //_groupDebug.setBackgroundColor(color(0, 100));
    _groupDebug.activateEvent(true);
    _groupDebug.hideBar();
    _groupDebug.hide();

    console = _gui.addConsole(_gui.addTextarea("consoleTexter")
      .moveTo(_groupDebug)
      .setPosition(2, height - 82)
      .setSize(width - 4, 80)
      .setFont(new ControlFont(createFont("Helvetica", 10, true)))
      .setLineHeight(14)
      .bringToFront());
    
    _gui.getTooltip().setDelay(300);
    _gui.getTooltip().register("toggleSystem", "system define");
    _gui.getTooltip().register("toggleDebug", "debug console");
  
  }

  void set() {

    for (int relay = 0; relay <= 6; relay++) {
      ((Toggle)(_gui.getController("toggleRelay" + (relay + 1)))).setState(_driver._arduinoRelay[relay] == Arduino.LOW);
    }
  
  }

  void draw() {   

    background(backgroundColor);
    
    //camera(width/2.0  + 300 * cos(frameCount/300.0), height/2.0 - 100, height/2.0 + 300 * sin(frameCount/300.0), width/2.0, height/2.0, 0, 0, 1, 0);
    //rotate(frameCount*0.001);

    //pushMatrix();
    if (this.vertexDebug()) _audio.draw(0);
    //popMatrix();
      
    //_gui.show();
    //_gui.draw();
              
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

        if (_event.isFrom(sequencePlay))
          if (_event.getName() == "sequencePlay") this.sequencePlay();
          
//        if (_event.isFrom(audioVolume)) 
//          if (_event.getName() == "audioVolume") this.audioVolume(value);
          
        if (_event.isFrom(servoAngle)) 
          if (_event.getName() == "servoAngle") this.servoAngle(value);

        if (_event.getName() == "toggleDebug") this.toggleDebug();
        
        if (_event.getName() == "toggleSystem") this.toggleSystem();
        
        break;
    }
        
  }

  void toggleSystem() {
    if (_groupSystem.isVisible()) {
      _groupSystem.hide();
    } 
    else {
      _groupSystem.show();
    }
  }

  void toggleDebug() {
    if (_groupDebug.isVisible()) {
      _groupDebug.hide();
    } 
    else {
      _groupDebug.show();
    }
  }
  
  void sequencePlay() {
    if (!_audio.isPlaying()) {
      if (replayDebug()) {
        _audio.loop();
        _step.loop();
      }
      else {
        _audio.play();
        _step.play();
      }
      sequencePlay.setImages(loadImage("pause_red.png"), loadImage("pause_blue.png"), loadImage("pause_green.png"));
    }
    else {
      _audio.stop();
      _step.stop();
      sequencePlay.setImages(loadImage("play_red.png"), loadImage("play_blue.png"), loadImage("play_green.png"));
    }
    if (this.muteDebug()) this.audioVolume(-255);
  }
  
  boolean replayDebug() {
    return checkboxReplay.getItem(0).getState();
  }
  
  boolean muteDebug() {
    return checkboxAudio.getItem(0).getState();
  } 
  boolean vertexDebug() {
    return checkboxAudio.getItem(1).getState();
  }
  
  boolean consoleDebug() {
    return checkboxRelay.getItem(0).getState();
  }
  
  void audioVolume(int value) {
    _audio.volume(value);
  }

  void servoAngle(int value) {
    _driver.servo(value);
  }

  void heading(String name, String caption, int x, int y, int width, int height) {
    _gui.addTextlabel("heading_" + name, caption, x, y)
      .setFont(_gui.grixel)
      .setColorValue(0)
      .setLetterSpacing(2)
      .setWidth(height)
      .setWidth(width);
  }
  
  int imageWidth;
  int imageHeight;

  int spacing = 20;

  void drawImage(PImage image) {
    pushMatrix();
    translate(spacing, spacing);
    noFill();
    stroke(0);
    rect(-1, -1, imageWidth + 1, imageHeight + 1);
    image(image, 0, 0, imageWidth, imageHeight);
    popMatrix();
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
      if (_gui._gui.getGroup("groupSystem").isVisible()) 
        _gui._gui.getGroup("groupSystem").hide();
      else 
        _gui._gui.getGroup("groupSystem").show();
      break;
    case 'd' | 'D':
      if (_gui._gui.getGroup("groupDebug").isVisible()) 
        _gui._gui.getGroup("groupDebug").hide();
      else 
        _gui._gui.getGroup("groupDebug").show();
      break;
  }
}

class portListener implements ControlListener {
  public void controlEvent(ControlEvent _event) {
    try {
      if (_event.isGroup()) {
        _driver.setup(_driver.list()[(int)_event.getGroup().getValue()]);
      }
      if (_event.isController()) {}       
    }
    catch (Exception e) {}
  }
}

class relayToggleListener implements ControlListener {
  public void controlEvent(ControlEvent _event) {
    if (_event.isController()) {
      
      _driver.write(_event.getController().getId(), _event.getController().getValue() == 0);
          
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