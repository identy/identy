
/*
 *
 * time line class
 *
 * copyright 2014 identy [ www.identy.org ] 
 *
 */

import ijeoma.motion.*; 
import ijeoma.motion.tween.*; 

import ijeoma.motion.tween.Tween;
import ijeoma.motion.tween.Parallel;
import ijeoma.motion.tween.Sequence;
import ijeoma.motion.tween.Timeline;

import ijeoma.motion.tween.KeyFrame;

import ijeoma.motion.tween.IProperty;

import ijeoma.motion.event.MotionEvent;
import ijeoma.motion.event.MotionEventListener;

class step {

  Timeline _timeline;
  
  Motion _motion;
  Tween _tween;
  
  private PApplet context;

  float control1, control2, control3, control4, control5, control6, control7, control8;
  
  float relay1, relay2, relay3, relay4, relay5, relay6, relay7;
  
  float relayInit = 0, relayDone = 0;
  
  public step(PApplet context) {

    this.context = context;
    
    Motion.setup(context);
    
    _timeline = new Timeline("relay timeline");
    _timeline.setTimeMode(Motion.SECONDS);
    _timeline.addEventListener(new TimelineListener());
    
  }

  void setup() {
            
//    _motion = _timeline.call(this, "init", 1);
//    _tween = new Tween("init", 1).add(this, "relayInit", (float)height)
//      .onBegin(new ICallback() {
//        public void run(Object t) {
//          println(t+" init [begin]");
//          _driver.init(true);
//        }
//      })
//      .onEnd(new ICallback() {
//        public void run(Object t) {
//          println(t+" end");
//        }
//      })
//      .onChange(new ICallback() { public void run(Object t) {} });
//    //_tween.addEventListener(new TweenEventListener());
//    _timeline.add(_tween, 1);
    
    _motion = _timeline.call(this, "uno", 1);
        
    _motion = _timeline.call(this, "dos", 2);
    _motion = _timeline.call(this, "tres", 3);   
    _motion = _timeline.call(this, "cuatro", 4);
    _motion = _timeline.call(this, "cinco", 5);
    _motion = _timeline.call(this, "seis", 6);
    _motion = _timeline.call(this, "siete", 7);
            
    TweenListener _tweenListener = new TweenListener();

    _tween = new Tween("control1", 1).add(this, "control1", (float)width);
    _tween.addEventListener(_tweenListener);
    _timeline.add(_tween, 1);
    _tween = new Tween("control2", 2).add(this, "control2", (float)width);
    _tween.addEventListener(_tweenListener);
    _timeline.add(_tween, 2);
    _tween = new Tween("control3", 3).add(this, "control3", (float)width);
    _tween.addEventListener(_tweenListener);
    _timeline.add(_tween, 3);
    _tween = new Tween("control4", 4).add(this, "control4", (float)width);
    _tween.addEventListener(_tweenListener);
    _timeline.add(_tween, 4);
    _tween = new Tween("control5", 5).add(this, "control5", (float)width);
    _tween.addEventListener(_tweenListener);
    _timeline.add(_tween, 5);
    _tween = new Tween("control6", 6).add(this, "control6", (float)width);
    _tween.addEventListener(_tweenListener);
    _timeline.add(_tween, 6);
    _tween = new Tween("control7", 7).add(this, "control7", (float)width);
    _tween.addEventListener(_tweenListener);
    _timeline.add(_tween, 7);
    _tween = new Tween("control8", 8).add(this, "control8", (float)width);
    _tween.addEventListener(_tweenListener);
    _timeline.add(_tween, 8);
    
//    _tween = new Tween("done", 1).add(this, "relayDone", (float)height)
//      .onBegin(new ICallback() {
//        public void run(Object t) {
//          println(t+" done [begin]");
//          _driver.done(false);
//        }
//      })
//      .onEnd(new ICallback() {
//        public void run(Object t) {
//          println(t+" end");
//        }
//      })
//      .onChange(new ICallback() { public void run(Object t) {} });
//    //_tween.addEventListener(new TweenEventListener());
//    _timeline.add(_tween, 9);
//    _motion = _timeline.call(this, "done", 10);
    

  }

  void play() {
    _timeline.play();
  }

  void loop() {
    _timeline.repeat().play();
  }

  void stop() {
    _timeline.stop();
  }

  boolean isPlaying() {
    return _timeline.isPlaying(); 
  }

  void delay(int index, float value) {
    //println(_timeline.toString());
    
    //println(_timeline.get(index).toString());
    //_timeline.get(index).delay(value);
    //_timeline.getCallback(index).
  }

  void duration(int index, float value) {
    //println(_timeline.toString());
    
    //println(_timeline.get(index).toString());
    //_timeline.get(index).setDuration(value); //<>//
    //_timeline.getCallback(index).
  }

  // timeline callback

  void init() {
    _driver.reset();
  }

  void uno() {
    _driver.toggle(1);
  }
  void dos() {
    _driver.toggle(2);
  }
  void tres() {
    _driver.toggle(3);
  }
  void cuatro() {
    _driver.toggle(4);
  }
  void cinco() {
    _driver.toggle(5);
  }
  void seis() {
    _driver.toggle(6);
  }
  void siete() {
    _driver.toggle(7);
  }
  
  void done() {
    _driver.reset();
  }

//  void tweenStarted(Tween _t) {
//    println(_t + " started");
//  }
//  
//  void tweenEnded(Tween _t) {
//    println(_t + " ended");
//  }
//  
//  void tweenChanged(Tween _t) {
//    println(_t + " changed");
//  }
//  
//  void tweenRepeated(Tween _t) {
//    println(_t + " repeated");
//  }
  
}

//void tweenStarted(Tween _t) {
//  println(_t + " started");
//}
//
//void tweenEnded(Tween _t) {
//  println(_t + " ended");
//}
//
//void tweenChanged(Tween _t) {
//  println(_t + " changed");
//}
//
//void tweenRepeated(Tween _t) {
//  println(_t + " repeated");
//}

public class TimelineListener implements MotionEventListener {
  
  void onMotionEvent(MotionEvent te) {
       
    //println(te);
    
    if (te.type == MotionEvent.TIMELINE_STARTED)
      println(((Timeline)te.getSource()).getName() + " started");
    else if (te.type == MotionEvent.TIMELINE_CHANGED)
      println(((Timeline)te.getSource()).getName() + " changed");
    else if (te.type == MotionEvent.TIMELINE_REPEATED)
      println(((Timeline)te.getSource()).getName() + " repeated");
    else if (te.type == MotionEvent.TIMELINE_ENDED)
      println(((Timeline)te.getSource()).getName() + " ended");
    
  }
  
}

public class SecuenceListener implements MotionEventListener {
  
  void onMotionEvent(MotionEvent te) {

    //println(te);
    
    if (te.type == MotionEvent.TWEEN_SEQUENCE_STARTED)
      println(((Sequence)te.getSource()).getName() + " started");
    else if (te.type == MotionEvent.TWEEN_SEQUENCE_CHANGED)
      println(((Sequence)te.getSource()).getName() + " changed");
    else if (te.type == MotionEvent.TWEEN_SEQUENCE_REPEATED)
      println(((Sequence)te.getSource()).getName() + " repeated");
    else if (te.type == MotionEvent.TWEEN_SEQUENCE_ENDED)
      println(((Sequence)te.getSource()).getName() + " ended");

  }
  
} 

public class TweenListener implements MotionEventListener {
  
  void onMotionEvent(MotionEvent te) {
    
    println(te);
    
    if (te.type == MotionEvent.TWEEN_STARTED)
      println(((Tween)te.getSource()).getName() + " started");
    else if (te.type == MotionEvent.TWEEN_CHANGED)
     println(((Tween)te.getSource()).getName() + " changed");
    else if (te.type == MotionEvent.TWEEN_REPEATED)
      println(((Tween)te.getSource()).getName() + " repeated");
    else if (te.type == MotionEvent.TWEEN_ENDED)
      println(((Tween)te.getSource()).getName() + " ended");

    try {
      _driver357.toggle(Integer.parseInt(((Tween)te.getSource()).getName().substring(((Tween)te.getSource()).getName().length() - 1)));
    }
    catch(Exception e) { e.printStackTrace(); }

  }
  
}

public class CallbackListener implements MotionEventListener {
  
  void onMotionEvent(MotionEvent te) {
    
    println(te);
    
    if (te.type == MotionEvent.CALLBACK_STARTED)
      println(((Motion)te.getSource()).getName() + " started");
    else if (te.type == MotionEvent.CALLBACK_ENDED)
      println(((Motion)te.getSource()).getName() + " ended");

  }
  
}

public class MotionListener implements MotionEventListener {
  
  void onMotionEvent(MotionEvent te) {
    
    println(te);
    
    if (te.type == MotionEvent.MOTION_STARTED)
      println(((Motion)te.getSource()).getName() + " started");
    else if (te.type == MotionEvent.MOTION_CHANGED)
     println(((Motion)te.getSource()).getName() + " changed");
    else if (te.type == MotionEvent.MOTION_REPEATED)
      println(((Motion)te.getSource()).getName() + " repeated");
    else if (te.type == MotionEvent.MOTION_ENDED)
      println(((Motion)te.getSource()).getName() + " ended");

  }
  
}
