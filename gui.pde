
/*
 *
 * gui class
 * 
 * copyright 2014 identy [ www.identy.org ]
 *
 */

//import org.json.*; 
//import org.json.JSONArray;
//import org.json.JSONObject;

//import java.awt.Frame;
//import java.awt.BorderLayout;

//import deadpixel.keystone.*;

import controlP5.*;

class gui {

  final static int CONTROLLER = 0, TAB = 1, GROUP = 2;
  
  private color backgroundColor = color(0, 0, 0);
  private PImage backgroundImage = null;
  
  //private color strokeColor = color(0xff660000); // color(225, 225, 225);
  private color strokeColor = color(102, 153, 51);
  
  //private color fillColor = color(0xffdddddd); // color(245, 245, 245);
  private color fillColor = color(204, 102, 0);
  
  private controlP5.ControlP5 _gui;
  
  private controlP5.Button _buttonAbout;
  private controlP5.Button _buttonExit;

  private controlP5.Button _buttonSystem;
  private controlP5.ControlGroup _groupSystem;

  private controlP5.ListBox _listArduinoPort;
  private controlP5.ListBox _listSerial357Port;
  
  private controlP5.Button sequencePlay;
  
  //private controlP5.Button sequenceRewind;
  //private controlP5.Button sequenceForward;
  
  private controlP5.Textarea consoleDebug;
  
  private controlP5.CheckBox checkboxDebugger;
  
  private controlP5.Textlabel titleTextlabel;
    
  //controlP5.Knob audioVolume;
  
  //controlP5.Knob servoAngle;
  
  audio _audio;
  environment _environment;

  time _time;
  
  JSONObject serializerjson;

  //Keystone ks;
  //CornerPinSurface surface;
  
  PGraphics offscreen;

  private PApplet context;

    private boolean _logo = false;
    
    private Println console;
   
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

     try 
   { 
   
      //serializerjson = loadJSONObject("data/alpheny.json");
      serializerjson = new JSONObject();
      
//      int __id = serializerjson.getInt("id");
      
      serializerjson.setString("sound", "Audio/soft.mp3");
      serializerjson.setString("environment", "Objects/cassini.obj");
      serializerjson.setString("background", "back.png");
      
      serializerjson.setBoolean("debug", false);
      serializerjson.setBoolean("draw", false);
      serializerjson.setBoolean("mute", false);
      serializerjson.setBoolean("repeat", false);
      
      serializerjson.setString("font", "Fonts/KaiTi-30.vlw");
      serializerjson.setString("font.title", "Fonts/Moire-Light-48.vlw");
      
      //saveJSONObject(serializerjson, "data/alpheny.json");

   } 
   catch (Exception E) 
   { 
 
      serializerjson = new JSONObject();
  
      //serializerjson.setInt("id", 0);
      
      serializerjson.setString("sound", "Audio/soft.mp3");
      serializerjson.setString("environment", "Objects/cassini.obj");
      serializerjson.setString("background", "back.png");
      
      serializerjson.setBoolean("debug", true);
      serializerjson.setBoolean("draw", false);
      serializerjson.setBoolean("mute", false);
      serializerjson.setBoolean("repeat", false);
      
      serializerjson.setString("font", "Fonts/KaiTi-30.vlw");
      serializerjson.setString("font.title", "Fonts/Moire-Light-48.vlw");
      
      //saveJSONObject(serializerjson, "data/alpheny.json");
      
   }

    if (_logo) backgroundImage = loadImage(serializerjson.getString("background"));
    
    if (backgroundImage == null) background(backgroundColor);
    else background(backgroundImage);
    
    stroke(strokeColor);
    fill(fillColor);

    _audio = new audio(context);   
    //_audio.setup(serializerjson.getString("sound"));
                 
    //_environment = new environment(context);
    //_environment = new environment(serializerjson.getString("environment"), context);
    //_environment.setup();

    _gui.setControlFont(loadFont(serializerjson.getString("font")), 13);
    
    //ks = new Keystone(context);
    //surface = ks.createCornerPinSurface(width, height, 2);
    
    offscreen = createGraphics(width, height, P3D);
    
    titleTextlabel = new Textlabel(_gui,"untited." , 110, 40, width - 40, height - 220);
    titleTextlabel.setControlFont(new ControlFont(loadFont(serializerjson.getString("font.title")), 48));

    consoleDebug = _gui.addTextarea("consoleDebug")
      .setPosition(4, height - 100 - 8)
      .setSize(width - 8 - 4, 100)
      .setColorBackground(color(27, 27, 27))
      .setFont(new ControlFont(createFont("Helvetica", 10, true)))
      .setLineHeight(14);
    
    console = _gui.addConsole(consoleDebug);          

    _buttonAbout = _gui.addButton("about", 1, 1, 1, 20, 20);
    _buttonAbout.getCaptionLabel().set("? ");
    _buttonAbout.getCaptionLabel().align(LEFT,CENTER);
    _buttonAbout.getCaptionLabel().setLetterSpacing(2);
    _buttonAbout.getCaptionLabel().toUpperCase(false);
    //_buttonAbout.setImages(loadImage("Texture/about.png"), loadImage("Texture/about.png"), loadImage("Texture/about.png"));
    
    _buttonSystem = _gui.addButton("system", 1, 21, 1, 70, 20);
    _buttonSystem.getCaptionLabel().set(" system ");
    _buttonSystem.getCaptionLabel().align(LEFT,CENTER);
    _buttonSystem.getCaptionLabel().setLetterSpacing(2);
    _buttonSystem.getCaptionLabel().toUpperCase(false);

    _buttonExit = _gui.addButton("exit", 1, width - 16 - 1, height - 16 - 1, 14, 14);
    _buttonExit.getCaptionLabel().set("x ");
    _buttonExit.getCaptionLabel().align(LEFT,CENTER);
    _buttonExit.getCaptionLabel().setLetterSpacing(2);
    _buttonExit.getCaptionLabel().toUpperCase(false);
    //_buttonExit.setImages(loadImage("Texture/exit.png"), loadImage("Texture/exit.png"), loadImage("Texture/exit.png"));
    
    _groupSystem = _gui.addGroup("groupSystem", 1, 22, width - 2);
    _groupSystem.setBackgroundHeight(height - 44);
    //_groupSystem.setBackgroundColor(color(17, 17, 17));
    //_groupSystem.setBackgroundColor(color(0,51,102,100));
    _groupSystem.activateEvent(true);
    _groupSystem.hideBar();
    _groupSystem.hide();

    sequencePlay = _gui.addButton("sequencePlay")
      .moveTo(_groupSystem)
      .setBroadcast(false)
      .setValue(0)
      .setPosition(580, 46)
      .setImages(loadImage("Texture/play_red.png"), loadImage("Texture/play_blue.png"), loadImage("Texture/play_green.png"))
      .setBroadcast(true)
      .updateSize();
      //.hide();
      
    //sequencePlay.setVisible(false);
    
//    _gui.addTextlabel("PortArduino", "arduino port", 110, 20)
//      .moveTo(_groupSystem);
//    
    _listArduinoPort = _gui.addListBox("arduinoPort", 580, 40, 110, 80);
    _listArduinoPort.moveTo(_groupSystem);
    //_listArduinoPort.setPosition(110, 40);
    _listArduinoPort.setBarHeight(24);
    _listArduinoPort.toUpperCase(false);
    _listArduinoPort.getCaptionLabel().set("port");
    _listArduinoPort.getCaptionLabel().align(LEFT,CENTER);
    _listArduinoPort.actAsPulldownMenu(true);
    _listArduinoPort.setItemHeight(24);
    _listArduinoPort.enableCollapse();
    
    for (int i = 0; i < _driverMqtt.list().length; i++) {
      _listArduinoPort.addItem(_driverMqtt.list()[i], i);
    }
       
    _listArduinoPort.addListener(new portListener());
    //_listArduinoPort.setValue(0);

    //_listArduinoPort.setVisible(false);
    
//    _gui.addTextlabel("Port357", "serial357 port", 240, 20)
//      .moveTo(_groupSystem);
//    
//    _listSerial357Port = _gui.addListBox("serial357Port", 240, 60, 200, 60);
//    _listSerial357Port.moveTo(_groupSystem);
//    _listSerial357Port.setBarHeight(18);
//    _listSerial357Port.toUpperCase(false);
//    _listSerial357Port.getCaptionLabel().set("port");
//    _listSerial357Port.actAsPulldownMenu(true);
//    _listSerial357Port.setItemHeight(20);
//    _listSerial357Port.enableCollapse();
//    
//    for (int i = 0; i < _driver.list().length; i++) {
//      _listSerial357Port.addItem(_driver357.list()[i], i);
//    }
//   
//    _listSerial357Port.addListener(new port357Listener());
//    //_listSerial357Port.setValue(0);
    
    for (int index = 0; index <= 7; index++) {

      Toggle relayToggle = _gui.addToggle("relayToggle" + index)
        .moveTo(_groupSystem)
        .setBroadcast(false)
        .setId(index)
        .setPosition(20, 60 + (36 * index) + 16)
        .setSize(50, 20)
        .setValue(false)
        .setBroadcast(true)
        .setMode(ControlP5.SWITCH);
        
      //relayToggle.getCaptionLabel().set("relay " + index);
      relayToggle.getCaptionLabel().set(" ");
      relayToggle.getCaptionLabel().toUpperCase(false);
      
      _gui.getController("relayToggle" + index).addListener(new relayToggleListener());
      
      Range rangeRelay = _gui.addRange("rangeRelay" + index)
        .moveTo(_groupSystem)
        .setBroadcast(false)
        .setId(index)
        .setPosition(110, 60 + (36 * index) + 16)
        .setSize(400, 20)
        .setHandleSize(1)
        
        .setRange(0, 700)
        //.setRange(0, _audio._player.bufferSize())
        //.setRange(0, _audio._player.length())
        
        //.setRangeValues(((_audio._player.length() / 8) * (index)), ((_audio._player.length() / 8) * (index)) + (_audio._player.length() / 8))
        .setRangeValues(((700 / 8) * (index)), ((700 / 8) * (index)) + (700 / 8))
        
        .setSliderMode(Slider.FLEXIBLE)
        .setBroadcast(true)
        .setColorForeground(color(255, 40))
        .setColorBackground(color(255, 40));
      
         try { 
           
            JSONObject jrangeRelay = serializerjson.getJSONObject("rangeRelay" + index);
            rangeRelay.setRangeValues(jrangeRelay.getFloat("value0"), jrangeRelay.getFloat("value1"));
            
         } 
         catch (Exception E) {
           
            JSONObject jrangeRelay = new JSONObject();
            
            //jrangeRelay.setFloat("value0", ((_audio._player.length() / 7) * (index - 1)));
            //jrangeRelay.setFloat("value1", ((_audio._player.length() / 7) * (index - 1 )) + (_audio._player.length() / 7));

             serializerjson.setJSONObject("rangeRelay" + index, jrangeRelay);
 
            //saveJSONObject(serializerjson, "data/alpheny.json");
           
         } 
             
      //rangeRelay.getCaptionLabel().set("range " + index);
      rangeRelay.getCaptionLabel().set(" " + index);
      rangeRelay.getCaptionLabel().toUpperCase(false);
      
      _gui.getController("rangeRelay" + index).addListener(new relayRangeListener());
      
    }
        
//    for (int index = 1; index <= 8; index++) {
//      
//      Toggle relayControl = _gui.addToggle("relayControl" + index)
//        .moveTo(_groupSystem)
//        .setBroadcast(false)
//        .setId(index)
//        .setPosition(580, 60 + (40 * index))
//        .setSize(50, 20)
//        .setValue(false)
//        .setBroadcast(true)
//        .setMode(ControlP5.SWITCH);
//        
//      relayControl.getCaptionLabel().set("relay " + index);
//      relayControl.getCaptionLabel().toUpperCase(false);
//      
//      _gui.getController("relayControl" + index).addListener(new relayControlListener());
//
//    }
    
//    sequenceRewind = _gui.addButton("sequenceRewind")
//      .moveTo(_groupSystem)
//      .setBroadcast(false)
//      .setValue(-1)
//      .setPosition(540, 30)
//      .setSize(20, 20)
//      .setImages(loadImage("Texture/_box_.png"), loadImage("Texture/_box_.png"), loadImage("Texture/_box_.png"))
//      .setBroadcast(true);
//
//    sequenceForward = _gui.addButton("sequenceForward")
//      .moveTo(_groupSystem)
//      .setBroadcast(false)
//      .setValue(1)
//      .setPosition(540, 60)
//      .setSize(20, 20)
//      .setImages(loadImage("Texture/_box_.png"), loadImage("Texture/_box_.png"), loadImage("Texture/_box_.png"))
//      .setBroadcast(true);

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
      .setPosition(580, 160)
      .setColorForeground(color(120))
      .setColorActive(color(255))
      .setColorLabel(color(255))
      .setSize(10, 10)
      .setItemsPerRow(1)
      .setSpacingColumn(86)
      .setSpacingRow(20)
      .addItem("debug", 0)
      .addItem("draw", 1)
      .addItem("mute", 2)
      .addItem("repeat", 3)
      .addItem("active", 4);
      
    for(Toggle toggle:checkboxDebugger.getItems()) {
      toggle.getCaptionLabel().toUpperCase(false);
    }

    // this.debugToggle(false);
    if (serializerjson.getBoolean("debug"))
      checkboxDebugger.activate("debug");
      else 
      checkboxDebugger.deactivate("debug");

    _gui.getTooltip().setDelay(300);   
    _gui.getTooltip().register("buttonSystem", "system define");
      
    _time = new time(context);
    _time.setup();
    
//    _time.play();

  }

  boolean set() {

     try {
       
//          for (int relay = 0; relay <= 7; relay++) {
//            ((Toggle)(_gui.getController("relayToggle" + (relay)))).setState(_driver._arduinoRelay[relay] == Arduino.HIGH);
//          }
      
      //    for (int relay = 0; relay <= 7; relay++) {
      //      ((Toggle)(_gui.getController("relayControl" + (relay)))).setState(_driver357._portRelay[relay]);
      //    }
        
          //_audio.speech();
          
       }
    catch (Exception e) {
      //
    } 
    
    return this.isActive();
    
  }
  
  void draw() {   


    //camera(width/2.0  + 300 * cos(frameCount/300.0), height/2.0 - 100, height/2.0 + 300 * sin(frameCount/300.0), width/2.0, height/2.0, 0, 0, 1, 0);
    
    //rotate(frameCount*0.001);
    
    background(backgroundColor);
    
    stroke(strokeColor);
    fill(fillColor);
          
    //PVector surfaceMouse = surface.getTransformedMouse();
    
//    offscreen.beginDraw();
//    offscreen.background(0);
//    
//    offscreen.stroke(strokeColor);
//    offscreen.fill(fillColor);
//    
//    if (this.isActive()) {
//           
//      //if (this.drawisActive()) _environment.draw(offscreen);
//
//      if (_audio.isPlaying()) _audio.mute(this.muteisActive());
//      //if (_audio.isPlaying()) _audio.drawPosition(offscreen);
//
//      // if (this.drawisActive() && _audio.isPlaying() && !this.muteisActive()) _audio.drawFFT(offscreen);
//      
//    }
//    
//    offscreen.endDraw();
//    image(offscreen, width, height);
//    //surface.render(offscreen);
    
    titleTextlabel.draw();
    
    // mqtt action
    
    if (!this.isActive()) return;
    
    float _position = map(_audio.position(), 0, _audio.length(), 0, 400);
      
    for (int index = 0; index <= 7; index++) {

      float _init = map(_gui.getController("rangeRelay" + index).getArrayValue(0), 0, _audio.length(), 0, 400);
      float _done = map(_gui.getController("rangeRelay" + index).getArrayValue(1), 0, _audio.length(), 0, 400);
    
      int _id =_gui.getController("rangeRelay" + index).getId();

//      if (this.isActive()) {
//      
//        if (_position > _init  &&  _done > _position) {
//        //if (_position == _init  ||  _position == _done) {
//          
//          //_driver.write(_id, true); 
//          _driverMqtt.write(_id, true);
//          
//          //_driverMqtt.toggle(_id);
//          
//        }
//        else {
//          
//          //_driver.write(_id, false);
//          _driverMqtt.write(_id, false);
//          
//        }
//        
//        //println(" index :: " + _id + " | " + _init + " | " + _done + " | position " + _position);
//        
//      }
        
    }
             
  }
  
    void close() {
    
    _time.stop();
    _audio.close();
    
    //saveJSONObject(serializerjson, "data/alpheny.json");
    
  }

  void sequencePlay() {
    
    if (_audio == null) return;
    
    if (!_audio.isPlaying()) {
      
        //if (!this.isActive())
        checkboxDebugger.activate("active");
        
        if(this.repeatisActive()) 
          _audio.loop();
        else 
          _audio.play();
        
        sequencePlay.setImages(loadImage("Texture/pause_red.png"), loadImage("Texture/pause_blue.png"), loadImage("Texture/pause_green.png"));
        
    }
    else {
      _audio.stop();
      
      //if (this.isActive())
      checkboxDebugger.deactivate("active");
      sequencePlay.setImages(loadImage("Texture/play_red.png"), loadImage("Texture/play_blue.png"), loadImage("Texture/play_green.png"));
      
    }
   
  }
  
  boolean systemisActive() {
      return _groupSystem.isVisible();
  }
  void systemToggle(boolean activate) {
    if (activate) {
      if (!_groupSystem.isVisible()) _groupSystem.show();
    } 
    else {
      if (_groupSystem.isVisible()) _groupSystem.hide();
    }
  }
  
  boolean debugisActive() {
      return consoleDebug.isVisible();
  }
  void debugToggle(boolean activate) {
    if (activate) {
      if (!consoleDebug.isVisible()) {
        consoleDebug.show();
        _buttonExit.setVisible(true);
       }
    } 
    else {
      if (consoleDebug.isVisible()) {
        consoleDebug.hide();
        _buttonExit.setVisible(false);
      }
    }
  }
    
  boolean drawisActive() {
    return checkboxDebugger.getItem(1).getState();
  }
  void drawToggle(boolean activate) {
      if (activate) checkboxDebugger.activate("draw");
      else checkboxDebugger.deactivate("draw");
  }
  
  boolean muteisActive() {
    return checkboxDebugger.getItem(2).getState();
  }
  
  boolean repeatisActive() {
    return checkboxDebugger.getItem(3).getState();
  }
    
  boolean isActive() {
      return checkboxDebugger.getItem(4).getState();
  }

  public void controlEvent(ControlEvent _event) {

    int value = 0;
    int id = 0;

    int type = _event.getType();
    
    switch ( type ) {
      case GROUP:
        controlP5.ControlGroup _group = _event.getGroup();
        id = _group.getId();
        value = (int) _group.getValue();
        
//        if (_event.isGroup()) {
//          println(_event.getGroup().getName() + ".group");
//        }

        if (_event.isFrom(checkboxDebugger)) {

          //.addItem("debug", 0)
            serializerjson.setBoolean("debug", (int)checkboxDebugger.getArrayValue()[0] == 1);
            //saveJSONObject(serializerjson, "data/alpheny.json");
          //.addItem("draw", 1)     
            serializerjson.setBoolean("draw", (int)checkboxDebugger.getArrayValue()[1] == 1);
            //saveJSONObject(serializerjson, "data/alpheny.json");
          //.addItem("mute", 2)
            serializerjson.setBoolean("mute", (int)checkboxDebugger.getArrayValue()[2] == 1);
            //saveJSONObject(serializerjson, "data/alpheny.json");
          //.addItem("repeat", 3)
            serializerjson.setBoolean("repeat", (int)checkboxDebugger.getArrayValue()[3] == 1);
            //saveJSONObject(serializerjson, "data/alpheny.json");

           //saveJSONObject(serializerjson, "data/alpheny.json");
           
           this.debugToggle(checkboxDebugger.getArrayValue()[0] == 1);
           
        }

        break;
      case CONTROLLER:
        controlP5.Controller _controller = _event.getController();
        value = (int) _controller.getValue();
        id = _controller.getId();
        
        //if (_event.isController()) {
          //println(_event.getController().getName() + ".controller");
        //}

        if (_event.isFrom(_buttonSystem))
          if (_event.getName() == "system") this.systemToggle(!_groupSystem.isVisible());
        if (_event.isFrom(_buttonExit))
          if (_event.getName() == "exit") exit();
        //if (_event.isFrom(_buttonAbout))
          //if (_event.getName() == "about") this.showABout();
          
        if (_event.isFrom(sequencePlay))
          if (_event.getName() == "sequencePlay") this.sequencePlay();

//        if (_event.isFrom(sequenceRewind))
//          if (_event.getName() == "sequenceRewind") _audio.rewind();
//        if (_event.isFrom(sequenceForward))
//          if (_event.getName() == "sequenceRewind") _audio.forward();

        //if (_event.isFrom(audioVolume)) 
        //  if (_event.getName() == "audioVolume") this.audioVolume(value);
        //if (_event.isFrom(servoAngle)) 
        //  if (_event.getName() == "servoAngle") this.servoAngle(value);
              
        if (_event.isFrom(checkboxDebugger)) {

          //.addItem("debug", 0)
            serializerjson.setBoolean("debug", (int)checkboxDebugger.getArrayValue()[0] == 1);
            //saveJSONObject(serializerjson, "data/alpheny.json");           
          //.addItem("draw", 1)     
            serializerjson.setBoolean("draw", (int)checkboxDebugger.getArrayValue()[1] == 1);
            //saveJSONObject(serializerjson, "data/alpheny.json");
          //.addItem("mute", 2)
            serializerjson.setBoolean("mute", (int)checkboxDebugger.getArrayValue()[2] == 1);
            //saveJSONObject(serializerjson, "data/alpheny.json");
          //.addItem("repeat", 3)
            serializerjson.setBoolean("repeat", (int)checkboxDebugger.getArrayValue()[3] == 1);
            //saveJSONObject(serializerjson, "data/alpheny.json");

           //saveJSONObject(serializerjson, "data/alpheny.json");
           
           this.debugToggle(checkboxDebugger.getArrayValue()[0] == 1);            

        }
        
    }
        
  }

}

void controlEvent(ControlEvent _event) {
  _gui.controlEvent(_event);
}

//void keyPressed() {
//  switch( key ) {
//    case ' ':
//      break;
//    case 'm' | 'M':
//      _gui.System();
//      break;
//    case 'd' | 'D':
//      _gui.Debug();
//      break;
//  }
//}

class portListener implements ControlListener {
  public void controlEvent(ControlEvent _event) {
    try {
      if (_event.isGroup()) {
        
        if (_gui.debugisActive()) println(_event);
      
        //_driver.setup(_driver.list()[(int)_event.getGroup().getValue()]);
        _driverMqtt.setup(_driverMqtt.list()[(int)_event.getGroup().getValue()]);
      }
      if (_event.isController()) {}       
    }
    catch (Exception e) {}
  }
}

//class port357Listener implements ControlListener {
//  public void controlEvent(ControlEvent _event) {
//    try {
//      if (_event.isGroup()) {
//        
//        if (_gui.debugisActive()) println(_event);
//      
//        _driver357.setup(_driver357.list()[(int)_event.getGroup().getValue()]);
//      }
//      if (_event.isController()) {}       
//    }
//    catch (Exception e) {}
//  }
//}

class relayToggleListener implements ControlListener {
  public void controlEvent(ControlEvent _event) {
    if (_event.isController()) {
      
      //if (_gui.consoleDebug()) println(_event);
      
      try {      
        //_driver.write(_event.getController().getId(), _event.getController().getValue() > 0);
        //_driver.toggle(_event.getController().getId());
        //_driverMqtt.write(_event.getController().getId(), _event.getController().getValue() > 0);
        _driverMqtt.toggle(_event.getController().getId());
      }
      catch(Exception e) {}
      
    }
  }

}

class relayRangeListener implements ControlListener {
  public void controlEvent(ControlEvent _event) {
    if (_event.isController()) {
      
      if (_gui.debugisActive()) 
        println(" index :: " + _event.getController().getId() + " | " + _event.getController().getArrayValue(0) + " | " + _event.getController().getArrayValue(1));
      
      //_step.delay(_event.getController().getId(), _event.getController().getArrayValue(1) - _event.getController().getArrayValue(0));
      //_step.duration(_event.getController().getId(), _event.getController().getArrayValue(0));
      
         try { 
            JSONObject jrangeRelay = _gui.serializerjson.getJSONObject("rangeRelay" + _event.getController().getId());
            
            jrangeRelay.setFloat("value0", _event.getController().getArrayValue(0));
            jrangeRelay.setFloat("value1", _event.getController().getArrayValue(1));

             _gui.serializerjson.setJSONObject("rangeRelay" + _event.getController().getId(), jrangeRelay);
             //saveJSONObject(_gui.serializerjson, "data/alpheny.json");
         } 
         catch (Exception E) {
            JSONObject jrangeRelay = new JSONObject();
            
            try {
            jrangeRelay.setFloat("value0", _event.getController().getArrayValue(0));
            jrangeRelay.setFloat("value1", _event.getController().getArrayValue(1));
            
            _gui.serializerjson.setJSONObject("rangeRelay" + _event.getController().getId(), jrangeRelay); 
            }
            catch (Exception _E) {}
            
         } 

      //if (_gui._audio.isPlaying()) _driver.write(_event.getController().getId(), _event.getController().getArrayValue(0) > _gui._audio._player.position() &  _event.getController().getArrayValue(1) < _gui._audio._player.position());
      
    }
  }

}

//class relayControlListener implements ControlListener {
//  public void controlEvent(ControlEvent _event) {
//    if (_event.isController()) {
//      
//      //if (_gui.consoleDebug()) println(_event);
//      
//      try {      
//        _driver357.write(_event.getController().getId(), _event.getController().getValue() > 0);
//      }
//      catch(Exception e) {}
//
//    }
//  }
//
//}

