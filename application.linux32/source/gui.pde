
/*
 *
 * gui class
 * 
 * copyright 2014 identy [ www.identy.org ]
 *
 */

//import java.awt.Frame;
//import java.awt.BorderLayout;

import controlP5.*;

//import org.json.*; 

//import deadpixel.keystone.*;

class gui {

  final static int CONTROLLER = 0, TAB = 1, GROUP = 2;
  
  private color backgroundColor = color(0, 0, 0);
  
  private color strokeColor = color(0xff660000); // color(225, 225, 225);
  private color fillColor = color(0xffdddddd); // color(245, 245, 245);
  
  private controlP5.ControlP5 _gui;

  private controlP5.Button _buttonSystem;
  private controlP5.ControlGroup _groupSystem;

  private controlP5.ListBox _listArduinoPort;
  private controlP5.ListBox _listSerial357Port;
  
  private controlP5.Button sequencePlay;
  
  private controlP5.Button sequenceRewind;
  private controlP5.Button sequenceForward;
  
  private controlP5.Textarea consoleDebug;
  
  private controlP5.CheckBox checkboxDebugger;
  
  private controlP5.Textlabel titleTextlabel;
  private controlP5.Textlabel positionTextlabel;
  
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

    background(backgroundColor);
    stroke(strokeColor);
    fill(fillColor);

     try 
   { 
   
      //serializerjson = loadJSONObject("data/alpheny.json");
      serializerjson = new JSONObject();
      
//      int __id = serializerjson.getInt("id");
//      String __specie = serializerjson.getString("specie");
//      String __environment = serializerjson.getString("environment");

        serializerjson.setString("environment", "Objects/cassini.obj");
        serializerjson.setInt("id", 0);
        
      serializerjson.setBoolean("debug", false);
      serializerjson.setBoolean("draw", true);
      serializerjson.setBoolean("mute", true);
      serializerjson.setBoolean("repeat", false);
      
      serializerjson.setString("font", "Fonts/KaiTi-30.vlw");
      serializerjson.setString("font.secuence", "Fonts/Moire-Light-48.vlw");

   } 
   catch (Exception E) 
   { 
 
      serializerjson = new JSONObject();
  
      serializerjson.setInt("id", 0);
      //serializerjson.setString("specie", "Audio/soft.mp3");
      //serializerjson.setString("specie.description", _audio.meta.title());
      //serializerjson.setString("environment", "Objects/cassini.obj");
           
      serializerjson.setBoolean("debug", false);
      serializerjson.setBoolean("draw", true);
      serializerjson.setBoolean("mute", true);
      serializerjson.setBoolean("repeat", false);
      
      serializerjson.setString("font", "Fonts/KaiTi-30.vlw");
      serializerjson.setString("font.secuence", "Fonts/Moire-Light-48.vlw");
      
      //saveJSONObject(serializerjson, "data/alpheny.json");
      
   }

    //_audio = new audio(context);

    //_audio.setup("soft.mp3");    
    //_audio.setup(serializerjson.getString("specie"));
    
    //serializerjson.setString("specie.description", _audio.meta.title());
    //saveJSONObject(serializerjson, "data/alpheny.json");
             
    //_environment = new environment(serializerjson.getString("environment"), context);
    //_environment.setup();

    _gui.setControlFont(loadFont(serializerjson.getString("font")), 13);

    titleTextlabel = new Textlabel(_gui,"untitled .1" , 80, 180, width - 10, height - 40);
    titleTextlabel.setControlFont(new ControlFont(loadFont(serializerjson.getString("font.secuence")), 32));

    positionTextlabel = new Textlabel(_gui,"." , 80, 180, 100, 40);
    positionTextlabel.setControlFont(new ControlFont(loadFont(serializerjson.getString("font.secuence")), 14));
    
    //ks = new Keystone(context);
    //surface = ks.createCornerPinSurface(800, 600, 2);
    
    offscreen = createGraphics(1280, 1024, P3D);

    _buttonSystem = _gui.addButton("system", 1, 1, 1, 100, 20);
    _buttonSystem.getCaptionLabel().set("system ");
    _buttonSystem.getCaptionLabel().align(LEFT,CENTER);
    _buttonSystem.getCaptionLabel().setLetterSpacing(2);
    _buttonSystem.getCaptionLabel().toUpperCase(false);
    
    _groupSystem = _gui.addGroup("groupSystem", 1, 22, width - 2);
    _groupSystem.setBackgroundHeight(height - 140);
    //_groupSystem.setBackgroundColor(color(17, 17, 17));
    _groupSystem.setBackgroundColor(color(0,51,102,100));
    _groupSystem.activateEvent(true);
    _groupSystem.hideBar();
    _groupSystem.hide();

    sequencePlay = _gui.addButton("sequencePlay")
      .moveTo(_groupSystem)
      .setBroadcast(false)
      .setValue(0)
      .setPosition(20, 20)
      .setImages(loadImage("Texture/play_red.png"), loadImage("Texture/play_blue.png"), loadImage("Texture/play_green.png"))
      .setBroadcast(true)
      .updateSize();

    _gui.addTextlabel("PortArduino", "arduino port", 110, 20)
      .moveTo(_groupSystem);
    
    _listArduinoPort = _gui.addListBox("arduinoPort", 110, 60, 200, 60);
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
        .setPosition(20, 60 + (40 * index) + 50)
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
        .setPosition(110, 60 + (40 * index) + 50)
        .setSize(400, 20)
        .setHandleSize(1)
        
        //.setRange(0, _audio._player.length())
        .setRange(0, 700)
        //.setRange(0, _audio._player.bufferSize())
        
        //.setRangeValues(((_audio._player.length() / 7) * (index - 1)), ((_audio._player.length() / 7) * (index - 1 )) + (_audio._player.length() / 7))
        .setRangeValues(((700 / 7) * (index - 1)), ((700 / 7) * (index - 1 )) + (700 / 7))
        
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
             
      rangeRelay.getCaptionLabel().set("range " + index);
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
      .setPosition(670, 280)
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
        
    _gui.getTooltip().setDelay(300);   
    _gui.getTooltip().register("buttonSystem", "system define");

    consoleDebug = _gui.addTextarea("consoleDebug")
      .setPosition(4, height - 100 - 8)
      .setSize(width - 8 - 4, 100)
      .setColorBackground(color(27, 27, 27))
      .setFont(new ControlFont(createFont("Helvetica", 10, true)))
      .setLineHeight(14);

    console = _gui.addConsole(consoleDebug);

    if (serializerjson.getBoolean("debug"))
      checkboxDebugger.activate("debug");
      else checkboxDebugger.deactivate("debug");
      
    if (serializerjson.getBoolean("draw"))
      checkboxDebugger.activate("draw");
      else checkboxDebugger.deactivate("draw");
      
    if (serializerjson.getBoolean("mute"))
      checkboxDebugger.activate("mute");
      else checkboxDebugger.deactivate("mute");
      
    if (serializerjson.getBoolean("repeat"))
      checkboxDebugger.activate("repeat");
      else checkboxDebugger.deactivate("repeat");
          
          
    _time = new time(context);
    _time.setup();
    _time.play();

  }

  boolean set() {

     try {
       
          for (int relay = 0; relay <= 7; relay++) {
            ((Toggle)(_gui.getController("relayToggle" + (relay)))).setState(_driver._arduinoRelay[relay] == Arduino.HIGH);
          }
      
      //    for (int relay = 0; relay <= 7; relay++) {
      //      ((Toggle)(_gui.getController("relayControl" + (relay)))).setState(_driver357._portRelay[relay]);
      //    }
      
          //if (_audio.isPlaying())
         if (this.isActive()) 
            sequencePlay.setImages(loadImage("Texture/pause_red.png"), loadImage("Texture/pause_blue.png"), loadImage("Texture/pause_green.png"));
          else 
            sequencePlay.setImages(loadImage("Texture/play_red.png"), loadImage("Texture/play_blue.png"), loadImage("Texture/play_green.png"));
  
       }
    catch (Exception e) {
      //
    } 
    return this.isActive();
  }

  void close() {
    
    _time.stop();
    
    //saveJSONObject(serializerjson, "data/alpheny.json");
    //_audio.close();
  }
  
  void draw() {   

    //camera(width/2.0  + 300 * cos(frameCount/300.0), height/2.0 - 100, height/2.0 + 300 * sin(frameCount/300.0), width/2.0, height/2.0, 0, 0, 1, 0);
    //rotate(frameCount*0.001);
    
    background(backgroundColor);
    stroke(strokeColor);
    fill(fillColor);

    //_audio.mute(muteisActive());
        
    //PVector surfaceMouse = surface.getTransformedMouse();
    
    // scene, offscreen
    offscreen.beginDraw();
    offscreen.background(0);
    offscreen.stroke(204, 102, 0);
    
    //if (this.isActive() && this.debugisActive()) _audio.drawFFT(offscreen);
   
        //_environment.draw();
        //if (_logo && this.drawisActive()) _environment.draw(offscreen);

    offscreen.endDraw();
    //surface.render(offscreen);

    titleTextlabel.draw();
    
//    if (_audio.isActive()) {
//      
//      //_audio.drawPosition();
//      
//      float __position = map(_audio.position(), 0, _audio.length(), 0, 400) + 110;
//      
//      positionTextlabel.setText(Float.toString(_audio.position()));
//      positionTextlabel.setPosition(__position, positionTextlabel.getPosition().y);
//      positionTextlabel.draw(context);
//      
//      stroke(102, 153, 51);
//      fill(0, 102, 153, 51);
//      line(80, 170, 400, 170);
//      //line(_position, 70, __position, 110);
//
//    }
    
//    _audio.speech();
    
//    float _position = map(_audio.position(), 0, _audio.length(), 0, 400);
    
//    for (int index = 0; index <= 7; index++) {
//
//    float _init = map(_gui.getController("rangeRelay" + index).getArrayValue(0), 0, _audio.length(), 0, 400);
//    float _done = map(_gui.getController("rangeRelay" + index).getArrayValue(1), 0, _audio.length(), 0, 400);
//    
//    int _id =_gui.getController("rangeRelay" + index).getId();
//
//      //if (_audio.isPlaying())
//      if (_audio.isPlaying())
//      
//        if (_position > _init  &&  _done > _position) _driver.write(_id, true);
//        else _driver.write(_id, false);
//        
//        //println(" index :: " + _id + " | " + _init + " | " + _done + " | position " + _position);
//
//    }
         
    //_gui.show();
    //_gui.draw();
    
  }
  
  void sequencePlay() {
    
    //_audio.mute(this.muteDebug());
    
//    if (!_audio.isPlaying()) {
//        _audio.play();
//      //sequencePlay.setImages(loadImage("Texture/pause_red.png"), loadImage("Texture/pause_blue.png"), loadImage("Texture/pause_green.png"));
//    }
//    else {
//      _audio.stop();
//      //sequencePlay.setImages(loadImage("Texture/play_red.png"), loadImage("Texture/play_blue.png"), loadImage("Texture/play_green.png"));
//    }
   
     checkboxDebugger.activate("active");
  }
  
  boolean systemisActive() {
      return _groupSystem.isVisible();
  }
  void systemToggle(boolean activate) {
    if (activate) {
      if (!_groupSystem.isVisible()) _groupSystem.show();
    } 
    else {
      //saveJSONObject(serializerjson, "data/alpheny.json");
      if (_groupSystem.isVisible()) _groupSystem.hide();
    }
  }
  
  boolean debugisActive() {
      return checkboxDebugger.getItem(0).getState();
  }
  void debugToggle(boolean activate) {
    //if (consoleDebug.isVisible()) {
    if (activate) {
      if (!consoleDebug.isVisible()) consoleDebug.show();
    } 
    else {
      if (consoleDebug.isVisible()) consoleDebug.hide();
    }
  }

  boolean drawisActive() {
    return checkboxDebugger.getItem(1).getState();
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

           this.debugToggle(debugisActive());
           
        }

        break;
      case CONTROLLER:
        controlP5.Controller _controller = _event.getController();
        value = (int) _controller.getValue();
        id = _controller.getId();
        
        if (_event.isController()) {
          println(_event.getController().getName() + ".controller");
        }

        if (_event.isFrom(_buttonSystem))
          if (_event.getName() == "system") this.systemToggle(!_groupSystem.isVisible());

        if (_event.isFrom(sequencePlay))
          if (_event.getName() == "sequencePlay") this.sequencePlay();

        if (_event.isFrom(sequenceRewind))
          if (_event.getName() == "sequenceRewind") _audio.rewind();
        if (_event.isFrom(sequenceForward))
          if (_event.getName() == "sequenceRewind") _audio.forward();

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

           this.debugToggle(debugisActive());            
           
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
      
        _driver.setup(_driver.list()[(int)_event.getGroup().getValue()]);
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
        _driver.write(_event.getController().getId(), _event.getController().getValue() > 0);
      }
      catch(Exception e) {}
      
    }
  }

}

class relayRangeListener implements ControlListener {
  public void controlEvent(ControlEvent _event) {
    if (_event.isController()) {
      
      if (_gui.debugisActive()) println(" index :: " + _event.getController().getId() + " | " + _event.getController().getArrayValue(0) + " | " + _event.getController().getArrayValue(1));
      
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