
/*
 *
 * gui class
 * 
 * copyright 2014 identy [ www.identy.org ]
 *
 */

import controlP5.*;
//import processing.opengl.*;

//import org.json.*; 
//import org.json.JSONArray;
//import org.json.JSONObject;

//import processing.data;

//import java.awt.Frame;
//import java.awt.BorderLayout;

//import deadpixel.keystone.*;

import org.multiply.processing.TimedEventGenerator;
//import com.dhchoi.CountdownTimer;

class gui extends Canvas {

  final static int CONTROLLER = 0, TAB = 1, GROUP = 2;
  
  private color backgroundColor = color(0, 0, 0);
  private PImage backgroundImage = null;
  
  //private color strokeColor = color(0xff660000); // color(225, 225, 225);
  private color strokeColor = color(102, 153, 51);
  
  //private color fillColor = color(0xffdddddd); // color(245, 245, 245);
  private color fillColor = color(204, 102, 0);
  
  controlP5.ControlP5 _gui;
  
  private controlP5.Button _buttonAbout;
  ControlGroup _groupAbout;

  private controlP5.Button _buttonSystem;
  controlP5.ControlGroup _groupSystem;

  private controlP5.Button _buttonExit;
  
  private controlP5.Button _buttonSequence;
  
  private controlP5.CheckBox _checkOptions;
    
  private controlP5.ListBox _listDriverPort;
  
  private controlP5.Textlabel title;  
  private controlP5.Textarea consoleDebug;
  
  audio _audio;
  environment _environment;

  Dong[][] dong;
  
  private TimedEventGenerator _timedEventGenerator;

  JSONObject serializerjson;

  //Keystone ks;
  //CornerPinSurface surface;
  
  PGraphics offscreen;

  private PApplet context;

    //private boolean _logo = false;
    
    private Println console;
   
  public gui(PApplet context) {

    this.context = context;

    stroke(strokeColor);
    fill(fillColor);

    //textFont(createFont("MS UI GOTHIC", 12));
    textFont(createFont("Tahoma", 12));
    
    _gui = new ControlP5(context);
    _gui.addControllersFor(context);   
    _gui.setAutoDraw(true);
    //_gui.enableShortcuts();
    
    //_gui.addCanvas(this);

    _gui.getTooltip().setDelay(300);   
    _gui.getTooltip().register("buttonSystem", "system define");
  
    //_gui.setControlFont(createFont("Tahoma", 11));
    _gui.setFont(createFont("Tahoma", 11));
    _gui.setControlFont(createFont("MS UI GOTHIC", 12));

    _gui.setColorBackground(0xff660000);  
    _gui.setColorForeground(0xffaa0000);
    _gui.setColorLabel(0xffdddddd);
    _gui.setColorValue(0xffff88ff);
    _gui.setColorActive(0xffff0000);
    
  }

  void setup(PApplet context) {

    try { 
   
      serializerjson = loadJSONObject("data/alpheny.json");
      
//      int __id = serializerjson.getInt("id");     
      serializerjson.setString("sound", "Audio/soft.mp3");
      serializerjson.setString("environment", "Objects/cassini.obj");
      serializerjson.setString("background", "back.png");
      
      serializerjson.setBoolean("debug", false);
      serializerjson.setBoolean("mute", false);
      
      serializerjson.setString("font", "Fonts/KaiTi-30.vlw");
      serializerjson.setString("font.title", "Fonts/Moire-Light-48.vlw");
      
      saveJSONObject(serializerjson, "data/alpheny.json");

   } 
   catch (Exception E) 
   { 
 
      serializerjson = new JSONObject();
  
//      serializerjson.setInt("id", 0);
      
      serializerjson.setString("sound", "Audio/soft.mp3");
      serializerjson.setString("environment", "Objects/cassini.obj");
      serializerjson.setString("background", "back.png");
      
      serializerjson.setBoolean("debug", true);
      serializerjson.setBoolean("mute", false);
      
      serializerjson.setString("font", "Fonts/KaiTi-30.vlw");
      serializerjson.setString("font.title", "Fonts/Moire-Light-48.vlw");
      
      saveJSONObject(serializerjson, "data/alpheny.json");
      
   }

      //backgroundImage = loadImage(serializerjson.getString("background"));
   
    if (backgroundImage == null) background(backgroundColor);
    else background(backgroundImage);

    textFont(loadFont(serializerjson.getString("font")), 12);
    
    _audio = new audio(context);   
    _audio.setup(serializerjson.getString("sound"));
                 
    _environment = new environment(context);
    //_environment = new environment(serializerjson.getString("environment"), context);
    _environment.setup();

    _gui.setFont(loadFont(serializerjson.getString("font")), 14);
    _gui.setControlFont(loadFont(serializerjson.getString("font")), 14);

    //ks = new Keystone(context);
    //surface = ks.createCornerPinSurface(width, height, 2);
    
    //offscreen = createGraphics(width, height, P3D);
    //offscreen = createGraphics(width, height, JAVA2D);
    offscreen = createGraphics(width, height, OPENGL);
    
    //title = new Textlabel(_gui, "untited." , 110, 36, width - 220, height - 220);
    //title.setControlFont(new ControlFont(loadFont(serializerjson.getString("font.title")), 48));
    
    title = _gui.addTextlabel("title")
                    .setText("mqtt controller")
                    .setPosition(110, 36)
                    .setColorValue(0xffffffff)
                    .setFont(new ControlFont(loadFont(serializerjson.getString("font.title")), 42));
                    
    consoleDebug = _gui.addTextarea("consoleDebug")
      .setPosition(4, height - 60 - 8)
      .setSize(width - 8 - 4, 60)
      //.setColorBackground(color(27, 27, 27))
      .setFont(new ControlFont(createFont("Helvetica", 10, true)))
      .setLineHeight(14);
    
    console = _gui.addConsole(consoleDebug);          

    _buttonAbout = _gui.addButton("about", 1, 1, 1, 20, 20);
    _buttonAbout.getCaptionLabel().set("? ");
    _buttonAbout.getCaptionLabel().align(CENTER,CENTER);
    _buttonAbout.getCaptionLabel().setLetterSpacing(2);
    _buttonAbout.getCaptionLabel().toUpperCase(false);
    //_buttonAbout.setImages(loadImage("Texture/about.png"), loadImage("Texture/about.png"), loadImage("Texture/about.png"));
        
    _buttonSystem = _gui.addButton("system", 1, 21, 1, 70, 20);
    _buttonSystem.getCaptionLabel().set(" system ");
    _buttonSystem.getCaptionLabel().align(LEFT,CENTER);
    _buttonSystem.getCaptionLabel().setLetterSpacing(2);
    _buttonSystem.getCaptionLabel().toUpperCase(false);
    
    _groupSystem = _gui.addGroup("groupSystem", 1, 22, width - 2);
    _groupSystem.setBackgroundHeight(height - 44);
    //_groupSystem.setBackgroundColor(color(17, 17, 17));
    //_groupSystem.setBackgroundColor(color(0,51,102,100));
    _groupSystem.activateEvent(true);
    _groupSystem.hideBar();
    _groupSystem.hide();

    _buttonExit = _gui.addButton("exit", 1, width - 16 - 1, height - 16 - 1, 14, 14);
    _buttonExit.getCaptionLabel().set("x ");
    _buttonExit.getCaptionLabel().align(CENTER,CENTER);
    //_buttonExit.getCaptionLabel().setLetterSpacing(2);
    _buttonExit.getCaptionLabel().toUpperCase(false);
    //_buttonExit.setImages(loadImage("Texture/exit.png"), loadImage("Texture/exit.png"), loadImage("Texture/exit.png"));
    _buttonExit.hide();
      
    _listDriverPort = _gui.addListBox("driverPort", 580, 2, 110, 80);
    _listDriverPort.moveTo(_groupSystem);
    //_listDriverPort.setPosition(110, 40);
    _listDriverPort.setBarHeight(24);
    _listDriverPort.toUpperCase(false);
    _listDriverPort.getCaptionLabel().set("port");
    _listDriverPort.getCaptionLabel().align(LEFT,CENTER);
    _listDriverPort.actAsPulldownMenu(true);
    _listDriverPort.setItemHeight(24);
    _listDriverPort.enableCollapse();
    
    for (int i = 0; i < _driverMqtt.list().length; i++) {
      _listDriverPort.addItem(_driverMqtt.list()[i], i);
    }
      
    _listDriverPort.addListener(new portListener());
    //_listDriverPort.setValue(0);
    //_listDriverPort.setVisible(false);

    _buttonSequence = _gui.addButton("sequence")
      .moveTo(_groupSystem)
      .setBroadcast(false)
      .setValue(0)
      .setPosition(24, 68)
      .setImages(loadImage("Texture/play_red.png"), loadImage("Texture/play_blue.png"), loadImage("Texture/play_green.png"))
      .setBroadcast(true)
      .updateSize();
      //.hide();
      
    //_buttonSequence.setVisible(false);

    //Range rangeRelay = _gui.addRange("rangeRelay")
    Slider rangeRelay = _gui.addSlider("rangeRelay")
        .moveTo(_groupSystem)
        //.setBroadcast(false)
        //.setId(0)
        //.setHandleSize(3)
                
        .setSliderMode(Slider.FLEXIBLE)
        //.setSliderMode(Slider.FIX)
        //.setBroadcast(true)
        .setDecimalPrecision(0)
        .setPosition(180, 50 + 18)
        .setSize(400, 18);

         try { 
           
            JSONObject jrangeRelay = serializerjson.getJSONObject("rangeRelay");
        
            rangeRelay.setRange(jrangeRelay.getInt("range0"), jrangeRelay.getInt("range1"));
            
            //rangeRelay.setRangeValues(jrangeRelay.getInt("value0"), jrangeRelay.getInt("value1"));
            
//            rangeRelay.setBroadcast(false); 
//            rangeRelay.setValue(jrangeRelay.getInt("value"));
//            rangeRelay.setBroadcast(true);


            //rangeRelay.setNumberOfTickMarks(jrangeRelay.getInt("ticks"));
        
         } 
         catch (Exception E) {
           
            JSONObject jrangeRelay = new JSONObject();
          
            jrangeRelay.setInt("range0", 0);
            jrangeRelay.setInt("range1", 9);
            rangeRelay.setRange(jrangeRelay.getInt("range0"), jrangeRelay.getInt("range1"));
            
            //jrangeRelay.setInt("value0", 0);
            //jrangeRelay.setInt("value1", 255);
            //rangeRelay.setRangeValues(jrangeRelay.getInt("value0"), jrangeRelay.getInt("value1"));
            
//            jrangeRelay.setInt("value", int(0));            
//            rangeRelay.setBroadcast(false); 
//            rangeRelay.setValue(jrangeRelay.getInt("value"));
//            rangeRelay.setBroadcast(true);

            //jrangeRelay.setInt("ticks", 10);
            //rangeRelay.setNumberOfTickMarks(jrangeRelay.getInt("ticks"));

            serializerjson.setJSONObject("rangeRelay", jrangeRelay);
            
            saveJSONObject(serializerjson, "data/alpheny.json");
           
         } 
     
     rangeRelay.getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
     rangeRelay.getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
             
     rangeRelay.getCaptionLabel().set(" time ");
     rangeRelay.getCaptionLabel().toUpperCase(false);
  
     controlP5.Label valueLabel = rangeRelay.valueLabel();
     valueLabel.setColor(color(255,128));
      
     controlP5.Label captionLabel = rangeRelay.captionLabel();
     captionLabel.toUpperCase(false);
    
     //_gui.getController("rangeRelay").addListener(new relayRangeListener());
     
//     Numberbox rangeRelayPrecition = _gui.addNumberbox("rangeRelayPrecition")
//            .moveTo(_groupSystem)
//            .setPosition(110 + 400 + 20, 50 + 18)
//            .setSize(80,18)
//            .setRange(0, 10)
//            .setScrollSensitivity(1.1)
//            .setDecimalPrecision(0)
//            //.setMultiplier(0.1)
//            //.setDirection(controlP5.Controller.HORIZONTAL)
//            .setValue(100)
//            ;
//     rangeRelayPrecition.getCaptionLabel().set(" ");
     
//     Numberbox rangeRelayStep = _gui.addNumberbox("rangeRelayStep")
//            .moveTo(_groupSystem)
//            .setPosition(110 + 400 + 20, 50 + 18 + 18 + 2)
//            .setSize(80,18)
//            .setRange(0, pow(2, 8) - 1)
//            .setScrollSensitivity(1.1)
//            .setDecimalPrecision(0)
//            .setValue(0)
//             ;
//     rangeRelayStep.getCaptionLabel().set(" ");

     for (int index = 0; index <= 7; index++) {

       Toggle relayToggle = _gui.addToggle("relayToggle" + index)
        .moveTo(_groupSystem)
        .setBroadcast(false)
        .setId(index)
        .setPosition(110, 92 + (38 * index) + 16)
        .setSize(50, 20)
        .setValue(false)
        .setBroadcast(true)
        .setMode(ControlP5.SWITCH);
        
       //relayToggle.getCaptionLabel().set("relay " + index);
       relayToggle.getCaptionLabel().set(" " + index);
       relayToggle.getCaptionLabel().toUpperCase(false);
      
       _gui.getController("relayToggle" + index).addListener(new relayToggleListener());
      
       try { 
         JSONObject jrangeRelay = serializerjson.getJSONObject("relayToggle" + index);        
       } 
       catch (Exception E) {        
         serializerjson.setJSONObject("relayToggle" + index, new JSONObject());
         
         saveJSONObject(serializerjson, "data/alpheny.json");      
       } 
      
     }
    
//     Slider2D scaleSlider2D = _gui.addSlider2D("scaleSlider2D")
//             .moveTo(_groupSystem)
//             .setPosition(180, 108)
//             .setSize(430,300)
//             .setArrayValue(new float[] {0, 0})
// 
//             .setMinX(1)
//             .setMaxX(10)
//             
//             .setMinY(1)
//             .setMaxY(8)
//             
//             .hide()
//             //.disableCrosshair()
//             ;
//     scaleSlider2D.getCaptionLabel().set(" ");
     
     //_gui.printPublicMethodsFor(Matrix.class);

//     Matrix scaleMatrix = _gui.addMatrix("scaleMatrix")
//             .moveTo(_groupSystem)
//             .setPosition(180, 108)
//             .setSize(400,300)
//             .setGrid(10, 8)
//             .setGap(1, 1)
//             .setInterval(300)
//             .setMode(ControlP5.MULTIPLES)
//             .setColorBackground(color(120))
//             .setBackground(color(40))
//             ;
//                  
//     _gui.getController("scaleMatrix").getCaptionLabel().alignX(CENTER);
//     _gui.getController("scaleMatrix").getCaptionLabel().set(" ");
                
     //scaleMatrix.pause();
     //scaleMatrix.clear();

      dong = new Dong[10][8];
      
      for (int x = 0;x<10;x++) {
        for (int y = 0;y<8;y++) {
          dong[x][y] = new Dong();
        }
      }

//      RadioButton selectTheme = _gui.addRadioButton("selectTheme")
//           .moveTo(_groupSystem)
//           .setPosition(24,440)
//           .setSize(40,18)
//           .setColorForeground(color(120))
//           .setColorActive(color(255))
//           .setColorLabel(color(255))
//           .setItemsPerRow(5)
//           .setSpacingColumn(30)
//           .addItem("50",1)
//           .addItem("100",2)
//           .addItem("150",3)
//           .addItem("200",4)
//           .addItem("250",5)
//           .hide()
//           ;
       
//       for(Toggle toggle:selectTheme.getItems()) {
//         toggle.captionLabel().setColorBackground(color(255,80));
////         toggle.captionLabel().style().moveMargin(-7,0,0,-3);
////         toggle.captionLabel().style().movePadding(7,0,0,3);
////         toggle.captionLabel().style().backgroundWidth = 45;
////         toggle.captionLabel().style().backgroundHeight = 13;
//       }
    
    _checkOptions = _gui.addCheckBox("options")
      .moveTo(_groupSystem)
      .setPosition(24, 328)
      .setColorForeground(color(120))
      .setColorActive(color(255))
      .setColorLabel(color(255))
      .setSize(10, 10)
      .setItemsPerRow(1)
      .setSpacingColumn(86)
      .setSpacingRow(20)
      .addItem("debug", 0)
      .addItem("mute", 1);
      
    for(Toggle toggle:_checkOptions.getItems()) {
      toggle.getCaptionLabel().toUpperCase(false);
    }
      
    _groupAbout = _gui.addGroup("groupAbout", width/2 - 200, height/2 - 150, 400);
    _groupAbout.setBackgroundHeight(300);
    _groupAbout.setBackgroundColor(color(0,125.125));
    _groupAbout.hideBar();
    _groupAbout.hide();
    
    Textlabel labelAbout = _gui.addTextlabel("labelAbout", "by identy studio.", 20, 20);
    labelAbout.setFont(createFont("MS UI GOTHIC", 16));
    labelAbout.captionLabel().toUpperCase(false);
    labelAbout.moveTo(_groupAbout);
    
    Textarea textAbout = _gui.addTextarea("textAbout")
                    .setPosition(20,60)
                    .setSize(300,180)
                    //.setFont(createFont("arial",12))
                    .setFont(createFont("MS UI GOTHIC", 12))
                    .setLineHeight(14)
                    //.setColor(color(128))
                    //.setColorBackground(color(255,100))
                    //.setColorForeground(color(255,100))
                    ;
    textAbout.setText("El lenguaje y el problema "
                      +" son la misma cosa."
                      +" John E. Hopcroft, Rajeev Motwani, Jeffrey D. Ullman"
                      );
    textAbout.moveTo(_groupAbout);
    
    Button buttonAbout = _gui.addButton("buttonAbout", 0, 20, 260, 80, 20);
    buttonAbout.moveTo(_groupAbout);
    buttonAbout.setColorBackground(color(40));
    buttonAbout.setColorActive(color(20));
    buttonAbout.setBroadcast(false); 
    buttonAbout.setValue(1);
    buttonAbout.setBroadcast(true);
    buttonAbout.captionLabel().toUpperCase(false);
    buttonAbout.setCaptionLabel("Ok");

    try { 
      if (serializerjson.getBoolean("debug"))
        _checkOptions.activate("debug");
      else 
        _checkOptions.deactivate("debug");
    } 
    catch (Exception E) {}        

    try { 
      if (serializerjson.getBoolean("mute"))
        _checkOptions.activate("mute");
      else 
        _checkOptions.deactivate("mute");
    } 
    catch (Exception E) {}    

    _timedEventGenerator = new TimedEventGenerator(context, "onRangeTimedEventGenerator", false);
    _timedEventGenerator.setIntervalMs(600);
    
    //_timedEventGenerator.setEnabled(true);
    
  }

  boolean set() {

    try {
      
      if (_audio.isPlaying()) _audio.mute(this.isMute());
       
       //_audio.speech();
        
    }
    catch (Exception e) {} 
    
    //return this.isActive();
    return true;
  }
  
  void draw(PApplet context) {   
    //camera(width/2.0  + 300 * cos(frameCount/300.0), height/2.0 - 100, height/2.0 + 300 * sin(frameCount/300.0), width/2.0, height/2.0, 0, 0, 1, 0);
    //rotate(frameCount*0.001);
    
    background(backgroundColor);
    
    stroke(strokeColor);
    strokeWeight(1);
    
    fill(fillColor);
    
    //PVector surfaceMouse = surface.getTransformedMouse();
   
    offscreen.beginDraw();
    offscreen.background(0);
    
    offscreen.stroke(strokeColor);
    offscreen.fill(fillColor);
    
    _environment.draw(offscreen);
    
//    for(int i=1;i<400;i++) {
//      float y0 = cos(map(i-1,0,((Slider2D)(_gui.getController("scaleSlider2D"))).arrayValue()[0],-PI,PI)) * ((Slider2D)(_gui.getController("scaleSlider2D"))).arrayValue()[1]; 
//      float y1 = cos(map(i,0,((Slider2D)(_gui.getController("scaleSlider2D"))).arrayValue()[0],-PI,PI)) * ((Slider2D)(_gui.getController("scaleSlider2D"))).arrayValue()[1];
//      
//      offscreen.line((i-1)+110,y0+78,i+110,y1+78); //++i;
//    }
  
      offscreen.pushMatrix();
      offscreen.translate(width/2 + 150, height/2);
      offscreen.rotate(frameCount*0.001);
      for (int x = 0;x<10;x++) {
        for (int y = 0;y<8;y++) {
          dong[x][y].display(offscreen);
        }
      }
      offscreen.popMatrix();
  
    offscreen.endDraw();
    image(offscreen, 0, 0, width, height);
    //surface.render(offscreen);
    
    // mqtt action
  }
  
  void close() {
    saveJSONObject(serializerjson, "data/alpheny.json");
    
    _audio.close();
  }
      
  void Sequence() {
    
    if (!_audio.isPlaying()) {
              
        //if(this.isRepeat()) 
          _audio.loop();
        //else 
          //_audio.play();
    }
    else {
      _audio.stop();
    }
    
//    if (_gui.get(Matrix.class, "scaleMatrix").isPlaying()) {
//      _gui.get(Matrix.class, "scaleMatrix").pause();
//    } 
//    else {
//      _gui.get(Matrix.class, "scaleMatrix").play();
//    }

    _timedEventGenerator.setEnabled(!_timedEventGenerator.isEnabled());
        
    if (this.isActive())
      _buttonSequence.setImages(loadImage("Texture/pause_red.png"), loadImage("Texture/pause_blue.png"), loadImage("Texture/pause_green.png"));
    else              
      _buttonSequence.setImages(loadImage("Texture/play_red.png"), loadImage("Texture/play_blue.png"), loadImage("Texture/play_green.png"));
         
  }
  
  boolean isActive() {
      return _timedEventGenerator.isEnabled();
  }

  boolean isSystem() {
      return _groupSystem.isVisible();
  }
  void selectSystem(boolean activate) {
    if (activate) {
      if (!_groupSystem.isVisible()) _groupSystem.show();
    } 
    else {
      if (_groupSystem.isVisible()) _groupSystem.hide();
    }
  }
  
  boolean isDebug() {
      return consoleDebug.isVisible();
  }
  void selectDebug(boolean activate) {
    if (activate) {
      if (!consoleDebug.isVisible()) {
        consoleDebug.show();
       }
    } 
    else {
      if (consoleDebug.isVisible()) {
        consoleDebug.hide();
      }
    }
  }
    
  boolean isMute() {
    return _checkOptions.getItem(1).getState();
  }
  
  void selectAbout() {
    if(_groupAbout.isVisible()) {
      _groupAbout.hide();
    } 
    else {
      _groupAbout.show();
    }
  }
        
//  void scaleMatrix(int X, int Y) {
//    try { dong[X][Y].update(); }
//    catch (Exception e) {}
//  }

  public void controlEvent(ControlEvent _event) {

    int value = 0;
    int id = 0;

    int type = _event.getType();
    
    switch ( type ) {
      case GROUP:
      
        controlP5.ControlGroup _group = _event.getGroup();
        
        id = _group.getId();
        value = (int) _group.getValue();
        
        if (_event.isGroup()) {
          println(_event.getGroup().getName() + ".group");
        }

//        if (_event.getName() == "scaleMatrix") {
//          dong[][].update();
//        }

//        if (_event.getName() == "selectTheme") {
//          _gui.setColorForeground(color(int(_event.group().value()*50),0,0));
//          background(color(int(_event.group().value()*50),0,0));
//        }
        
        if (_event.isFrom(_checkOptions)) {

          //.addItem("debug", 0)
            serializerjson.setBoolean("debug", (int)_checkOptions.getArrayValue()[0] == 1);
            //saveJSONObject(serializerjson, "data/alpheny.json");
            this.selectDebug(_checkOptions.getArrayValue()[0] == 1);
          //.addItem("mute", 1)
            serializerjson.setBoolean("mute", (int)_checkOptions.getArrayValue()[1] == 1);
            //saveJSONObject(serializerjson, "data/alpheny.json");
            //if (_audio.isPlaying()) _audio.mute(this.isMute());
           _audio.mute(_checkOptions.getArrayValue()[1] == 1);

        }

        break;
      case CONTROLLER:
      
        controlP5.Controller _controller = _event.getController();

        id = _controller.getId();        
        value = (int) _controller.getValue();
        
        if (_event.isController()) {
          println(_event.getController().getName() + ".controller");
        }

        if (_event.isFrom(_buttonAbout))
          if (_event.getName() == "about") this.selectAbout();
          
        if (_event.isFrom(_buttonSystem))
          if (_event.getName() == "system") this.selectSystem(!_groupSystem.isVisible());
          
        if (_event.isFrom(_buttonSequence))
          if (_event.getName() == "sequence") this.Sequence();
        
    }
        
  }
  
}

void controlEvent(ControlEvent _event) {
  _gui.controlEvent(_event);
}

class portListener implements ControlListener {
  public void controlEvent(ControlEvent _event) {
    try {
      if (_event.isGroup()) {
        
        if (_gui.isDebug()) println(_event);
      
        //_driver.setup(_driver.list()[(int)_event.getGroup().getValue()]);
        //_driver357.setup(_driver357.list()[(int)_event.getGroup().getValue()]);
        _driverMqtt.setup(_driverMqtt.list()[(int)_event.getGroup().getValue()]);
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
        
        //_driver.write(_event.getController().getId(), _event.getController().getValue() > 0);
        //_driver.toggle(_event.getController().getId());
        //_driverMqtt.write(_event.getController().getId(), _event.getController().getValue() > 0);
        //_driver357.write(_event.getController().getId(), _event.getController().getValue() > 0);
        
        _driverMqtt.toggle(_event.getController().getId());
        
         JSONObject jrangeRelay = _gui.serializerjson.getJSONObject("relayToggle" + _event.getController().getId());
            
         //jrangeRelay.setBoolean(str(round(map(_gui._audio.position(), 0, _gui._audio.length(), round(_gui._gui.getController("rangeRelay").getArrayValue(0)), round(_gui._gui.getController("rangeRelay").getArrayValue(1))))), _event.getController().getValue() > 0);
         //jrangeRelay.setBoolean(str(round(map(_gui._audio.position(), 0, _gui._audio.length(), round(_gui._gui.getController("rangeRelay").getMin()), round(_gui._gui.getController("rangeRelay").getMax())))), _event.getController().getValue() > 0);
         jrangeRelay.setBoolean(str(floor(_gui._gui.getController("rangeRelay").getValue())), _event.getController().getValue() > 0);
         
         _gui.serializerjson.setJSONObject("relayToggle" + _event.getController().getId(), jrangeRelay);
         
         saveJSONObject(_gui.serializerjson, "data/alpheny.json");

      }
      catch(Exception e) {}
      
    }
  }

}

class relayRangeListener implements ControlListener {
  public void controlEvent(ControlEvent _event) {
    
    if (_event.isController()) {
      
      //if (_gui.debugisActive()) println(" index :: " + _event.getController().getId() + " | " + _event.getController().getArrayValue(0) + " | " + _event.getController().getArrayValue(1));
      
      //_step.delay(_event.getController().getId(), _event.getController().getArrayValue(1) - _event.getController().getArrayValue(0));
      //_step.duration(_event.getController().getId(), _event.getController().getArrayValue(0));
      
      //if (!_gui.isActive()) {
        
         try {
            //JSONObject jrangeRelay = _gui.serializerjson.getJSONObject("rangeRelay");
            //jrangeRelay.setInt("value", int(_event.getController().getValue()));
            //_event.getController().setValue(round(jrangeRelay.getInt("value")));
         } 
         catch (Exception E) {           
            try {
              //JSONObject jrangeRelay = new JSONObject();
              //jrangeRelay.setInt("value", int(_event.getController().getValue()));
            
              //_gui.serializerjson.setJSONObject("rangeRelay", jrangeRelay);
            }
            catch (Exception _E) {}
         }
      
        try {
           //saveJSONObject(_gui.serializerjson, "data/alpheny.json");
        }
        catch (Exception E) {}
   
      //}  
               
      //if (_gui._audio.isPlaying()) _driver.write(_event.getController().getId(), _event.getController().getArrayValue(0) > _gui._audio._player.position() &  _event.getController().getArrayValue(1) < _gui._audio._player.position());
      
      
    }
    
  }

}

void onRangeTimedEventGenerator() {
  
       //if (_gui.isActive()) { 
         
           if (_gui._audio.isPlaying()) {
           
             //_gui._gui.getController("rangeRelay").setValue(round(map(_gui._audio.position(), 0, _gui._audio.length(), round(_gui._gui.getController("rangeRelay").getArrayValue(0)), round(_gui._gui.getController("rangeRelay").getArrayValue(1)))));
             _gui._gui.getController("rangeRelay").setValue(int(floor(map(int(round(_gui._audio.position())), 0, int(round(_gui._audio.length())), _gui._gui.getController("rangeRelay").getMin(), _gui._gui.getController("rangeRelay").getMax()))));
             
           }
           
       //}
       
       
           //int _position = round(map(_gui._gui.getController("rangeRelay").getValue(), round(_gui._gui.getController("rangeRelay").getArrayValue(0)), round(_gui._gui.getController("rangeRelay").getArrayValue(1)), 0, 400));
           int _position = round(_gui._gui.getController("rangeRelay").getValue());
                           
           for (int relay = 0; relay <= 7; relay++) {
               
             JSONObject jrangeRelay = _gui.serializerjson.getJSONObject("relayToggle" + relay);
             
             //JSONObject jrangePosition = jrangeRelay.getJSONObject("position" + _position);
             try {
               //if (jrangeRelay.getJSONObject("" + _position) == null) continue;
               
               //if (((Toggle)(_gui._gui.getController("relayToggle" + relay))).getState() != jrangeRelay.getBoolean(str(_position))) 
                 //((Slider2D)(_gui._gui.getController("scaleSlider2D"))).setArrayValue(new float[] {_position, relay});
               
               if ((boolean)((Toggle)(_gui._gui.getController("relayToggle" + relay))).getState());
                 _gui.dong[_position][relay].update();
               
               if (((Toggle)(_gui._gui.getController("relayToggle" + relay))).getState() != jrangeRelay.getBoolean(str(_position)))
                 ((Toggle)(_gui._gui.getController("relayToggle" + relay))).setState(jrangeRelay.getBoolean(str(_position)));

             }
             catch (Exception E) {};
             
           }
       
           //println(" range relay . " + " | " + round(_gui._gui.getController("rangeRelay").getValue()));
           
}

void buttonAbout(int theValue) {
  _gui._groupAbout.hide();
}
