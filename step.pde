
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
  
  float y1, y2;

  public step(PApplet context) {

    this.context = context;
    
    Motion.setup(context);
    
    _timeline = new Timeline("relay timeline");
    _timeline.setTimeMode(Motion.SECONDS);
    _timeline.addEventListener(new TimelineEventListener());
    
  }

  void setup() {

    _motion = _timeline.call(this, "init", 0);
    
    _motion = _timeline.call(this, "uno", 1);
        
    _motion = _timeline.call(this, "dos", 2);
    _motion = _timeline.call(this, "tres", 3);   
    _motion = _timeline.call(this, "cuatro", 4);
    _motion = _timeline.call(this, "cinco", 5);
    _motion = _timeline.call(this, "seis", 6);
    _motion = _timeline.call(this, "siete", 7);
    _motion = _timeline.call(this, "ocho", 8);
    
    _motion = _timeline.call(this, "done", 9);

    y1 = y2 = -height;
 
    //tween = new Tween("uno", -width, width, 100).onBegin(this, "onUnoBegin").onEnd(this, "onUnoEnd").onChange(this, "onUnoChange");
    //_tween.addEventListener(new TweenEventListener());
    
    _tween = new Tween("init", 5).add(this, "y1", (float)height)
      .onBegin(new ICallback() {
        public void run(Object t) {
          println(t+" begin");
          _driver.write(11, true);
        }
      })
      .onEnd(new ICallback() {
        public void run(Object t) {
          println(t+" end");
        }
      })
      .onChange(new ICallback() {
        public void run(Object t) {
          //println(t+" change");
        }
      });
      
    //_tween.addEventListener(new TweenEventListener());
    _timeline.add(_tween, 10);
    
    _tween = new Tween("done", 5).add(this, "y2", (float)height)
      .onBegin(new ICallback() {
        public void run(Object t) {
          println(t+" begin");
          _driver.write(11, false);
        }
      })
      .onEnd(new ICallback() {
        public void run(Object t) {
          println(t+" end");
        }
      })
      .onChange(new ICallback() {
        public void run(Object t) {
          //println(t+" change");
        }
      });

    //_tween.addEventListener(new TweenEventListener());
    _timeline.add(_tween, 15);
    
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
  void done() {
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
  void ocho() {
    _driver.toggle(8);
  }

//  void onUnoBegin() {
//    _driver.toggle(1);
//  }
//  void onUnoChange() {
//    _driver.toggle(1);
//  }
//  void onUnoEnd() {
//    _driver.toggle(1);
//  }

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

//void onUnoBegin() {
//  _driver.toggle(1);
//}
//void onUnoChange() {
//  _driver.toggle(1);
//}
//void onUnoEnd() {
//  _driver.toggle(1);
//}
//
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

public class TimelineEventListener implements MotionEventListener {
  
  void onMotionEvent(MotionEvent te) {
    
    //((Timeline) te.getSource()).printKeyFrames();
    
    if (te.type == MotionEvent.TIMELINE_STARTED)
      println(((Timeline) te.getSource()).getName() + " started");
    else if (te.type == MotionEvent.TIMELINE_CHANGED)
      println(((Timeline) te.getSource()).getName() + " changed");
    else if (te.type == MotionEvent.TIMELINE_REPEATED)
      println(((Timeline) te.getSource()).getName() + " repeated");
    else if (te.type == MotionEvent.TIMELINE_ENDED)
      println(((Timeline) te.getSource()).getName() + " ended");

//    if (te.type == MotionEvent.CALLBACK_STARTED)
//      println(((Callback) te.getSource()).getName() + " started");
//    else if (te.type == MotionEvent.CALLBACK_ENDED)
//      println(((Callback) te.getSource()).getName() + " ended");
//
//    if (te.type == MotionEvent.TWEEN_STARTED)
//      println(((Tween) te.getSource()).getName() + " started");
//    else if (te.type == MotionEvent.TWEEN_CHANGED)
//     println(((Tween) te.getSource()).getName() + " changed");
//    else if (te.type == MotionEvent.TWEEN_REPEATED)
//      println(((Tween) te.getSource()).getName() + " repeated");
//    else if (te.type == MotionEvent.TWEEN_ENDED)
//      println(((Tween) te.getSource()).getName() + " ended");
//      
//    if (te.type == MotionEvent.MOTION_STARTED)
//      println(((Motion) te.getSource()).getName() + " started");
//    else if (te.type == MotionEvent.MOTION_CHANGED)
//     println(((Motion) te.getSource()).getName() + " changed");
//    else if (te.type == MotionEvent.MOTION_REPEATED)
//      println(((Motion) te.getSource()).getName() + " repeated");
//    else if (te.type == MotionEvent.MOTION_ENDED)
//      println(((Motion) te.getSource()).getName() + " ended");
//
//    if (te.type == MotionEvent.TWEEN_SEQUENCE_STARTED)
//      println(((Sequence) te.getSource()).getName() + " started");
//    else if (te.type == MotionEvent.TWEEN_SEQUENCE_CHANGED)
//      println(((Sequence) te.getSource()).getName() + " changed");
//    else if (te.type == MotionEvent.TWEEN_SEQUENCE_REPEATED)
//      println(((Sequence) te.getSource()).getName() + " repeated");
//    else if (te.type == MotionEvent.TWEEN_SEQUENCE_ENDED)
//      println(((Sequence) te.getSource()).getName() + " ended");
//      
//    if (te.type == MotionEvent.KEYFRAME_STARTED)
//      println(((KeyFrame) te.getSource()).getName() + " started");
//    else if (te.type == MotionEvent.KEYFRAME_CHANGED)
//      println(((KeyFrame) te.getSource()).getName() + " changed");
//    else if (te.type == MotionEvent.KEYFRAME_REPEATED)
//      println(((KeyFrame) te.getSource()).getName() + " repeated");
//    else if (te.type == MotionEvent.KEYFRAME_ENDED)
//      println(((KeyFrame) te.getSource()).getName() + " ended");
//  
//    if (te.type == MotionEvent.TWEEN_PARALLEL_STARTED)
//      println(((Parallel) te.getSource()).getName() + " started");
//    else if (te.type == MotionEvent.TWEEN_PARALLEL_CHANGED)
//      println(((Parallel) te.getSource()).getName() + " changed");
//    else if (te.type == MotionEvent.TWEEN_PARALLEL_REPEATED)
//      println(((Parallel) te.getSource()).getName() + " repeated");
//    else if (te.type == MotionEvent.TWEEN_PARALLEL_ENDED)
//      println(((Parallel) te.getSource()).getName() + " ended");

  }
  
} 

public class CallbackEventListener implements MotionEventListener {
  
  void onMotionEvent(MotionEvent te) {
    
    if (te.type == MotionEvent.CALLBACK_STARTED)
      println(((Motion) te.getSource()).getName() + " started");
    else if (te.type == MotionEvent.CALLBACK_ENDED)
      println(((Motion) te.getSource()).getName() + " ended");

  }
  
}

public class TweenEventListener implements MotionEventListener {
  
  void onMotionEvent(MotionEvent te) {
    
    if (te.type == MotionEvent.TWEEN_STARTED)
      println(((Tween) te.getSource()).getName() + " started");
    else if (te.type == MotionEvent.TWEEN_CHANGED)
     println(((Tween) te.getSource()).getName() + " changed");
    else if (te.type == MotionEvent.TWEEN_REPEATED)
      println(((Tween) te.getSource()).getName() + " repeated");
    else if (te.type == MotionEvent.TWEEN_ENDED)
      println(((Tween) te.getSource()).getName() + " ended");

  }
  
}
