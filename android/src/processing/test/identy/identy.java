package processing.test.identy;

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 
import ddf.minim.signals.*; 
import ddf.minim.analysis.*; 
import ddf.minim.ugens.*; 
import org.firmata.*; 
import processing.serial.*; 
import cc.arduino.*; 
import processing.serial.*; 
import org.firmata.*; 
import processing.serial.*; 
import cc.arduino.*; 
import se.goransson.qatja.messages.*; 
import se.goransson.qatja.*; 
import saito.objloader.*; 
import java.lang.reflect.InvocationTargetException; 
import java.lang.reflect.Method; 
import ddf.minim.analysis.*; 
import controlP5.*; 
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

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class identy extends PApplet {


/*
 *
 * identy 
 *
 * interactive
 * 
 * copyright 2014 by identy [ www.identy.org ] 
 *
 */

// driver :: Mqtt
driverMqtt _driverMqtt;
// driver :: arduino
//driver _driver;
// driver :: serial
//driver357 _driver357;

// gui
gui _gui;

public void setup() {
 
  //size(800, 600, P3D) colorMode(HSB) frameRate(30);
 
  
//    smooth();
//    lights();
//    
//      noStroke();
      
  //cursor(CROSS);
  
  //H.init(this).background(#202020).autoClear(true);
  
  _driverMqtt = new driverMqtt(this);
  _driverMqtt.setup();

  //_driver = new driver(this);
  //_driver.setup();

  //_driver357 = new driver357(this);
  //_driver357.setup();
  
  _gui = new gui(this);
  _gui.setup();
  
}

public void draw() {
  
  if (_gui.set()) _gui.draw();
  else _gui.draw();
  
}

public void stop() {
  
  _gui.close();
  _driverMqtt.close();
  //_driver.close();
  super.stop();
}

public void exit(){
  super.exit();
}  

public void keyPressed() {
  
  switch(key) {
    case ' ':
      break;
    case 'a' | 'A':
    case 'p' | 'P':
      _gui.sequencePlay();
      break;
    case 'm' | 'M':
      _gui.systemToggle(!_gui.systemisActive());
      break;
    case 'd' | 'D':
      _gui.drawToggle(!_gui.drawisActive());
      break;
    case 'g' | 'G':
      _gui.debugToggle(!_gui.debugisActive());
      break;
    case 'c':
      //_gui.ks.toggleCalibration();
      break;
    case 'l':
      //_gui.ks.load();
      break;
    case 's':
      //_gui.ks.save();
      break;
  }

}

public void mouseMoved() { }


/*
 *
 * HYPE class
 *
 * copyright 2014 identy [ www.identy.org ]
 * copyright 2013 Joshua Davis & James Cruz
 * copyright 2009-2010 Branden Hall & Joshua Davis 
 *
 */
 
public static abstract class HBehavior extends HNode<HBehavior> { 
  protected HBehaviorRegistry _registry; 
  public HBehavior register() { 
    H.behaviors().register(this); 
    return this;
  } 
  public HBehavior unregister() { 
    H.behaviors().unregister(this); 
    return this;
  } 
  public boolean poppedOut() { 
    return _registry == null;
  } 
  public void popOut() { 
    super.popOut(); 
    _registry = null;
  } 
  public void swapLeft() { 
    if (_prev._prev == null) return; 
    super.swapLeft();
  } 
  public void putAfter(HBehavior dest) { 
    if (dest._registry == null) return; 
    super.putAfter(dest); 
    _registry = dest._registry;
  } 
  public void putBefore(HBehavior dest) { 
    if (dest._registry == null) return; 
    super.putBefore(dest); 
    _registry = dest._registry;
  } 
  public void replaceNode(HBehavior target) { 
    super.replaceNode(target); 
    _registry = target._registry; 
    target._registry = null;
  } 
  public abstract void runBehavior(PApplet app);
} 
public static class HBehaviorRegistry { 
  private HBehaviorSentinel _firstSentinel; 
  public HBehaviorRegistry() { 
    _firstSentinel = new HBehaviorSentinel(this);
  } 
  public boolean isRegistered(HBehavior b) { 
    return (b._registry != null && b._registry.equals(this));
  } 
  public void register(HBehavior b) { 
    if (b.poppedOut()) b.putAfter(_firstSentinel);
  } 
  public void unregister(HBehavior b) { 
    if (isRegistered(b)) b.popOut();
  } 
  public void runAll(PApplet app) { 
    HBehavior n = _firstSentinel.next(); 
    while (n != null) { 
      n.runBehavior(app); 
      n = n.next();
    }
  } 
  public static class HBehaviorSentinel extends HBehavior { 
    public HBehaviorSentinel(HBehaviorRegistry r) { 
      _registry = r;
    } 
    public void runBehavior(PApplet app) {
    }
  }
}
public static class HFollow extends HBehavior { 
  protected float _ease, _spring, _dx, _dy; 
  protected HFollowable _goal; 
  protected HMovable _follower; 
  public HFollow() { 
    this(1);
  } 
  public HFollow(float ease) { 
    this(ease, 0);
  } 
  public HFollow(float ease, float spring) { 
    this(ease, spring, H.mouse());
  } 
  public HFollow(float ease, float spring, HFollowable goal) { 
    _ease = ease; 
    _spring = spring; 
    _goal = goal;
  } 
  public HFollow ease(float f) { 
    _ease = f; 
    return this;
  } 
  public float ease() { 
    return _ease;
  } 
  public HFollow spring(float f) { 
    _spring = f; 
    return this;
  } 
  public float spring() { 
    return _spring;
  } 
  public HFollow goal(HFollowable g) { 
    _goal = g; 
    return this;
  } 
  public HFollowable goal() { 
    return _goal;
  } 
  public HFollow followMouse() { 
    _goal = H.mouse(); 
    return this;
  } 
  public HFollow target(HMovable f) { 
    if (f == null) unregister(); 
    else register(); 
    _follower = f; 
    return this;
  } 
  public HMovable target() { 
    return _follower;
  } 
  public void runBehavior(PApplet app) { 
    if (_follower==null || ! H.mouse().started()) return; 
    _dx = _dx*_spring + (_goal.followableX()-_follower.x()) * _ease; 
    _dy = _dy*_spring + (_goal.followableY()-_follower.y()) * _ease; 
    _follower.move(_dx, _dy);
  } 
  public HFollow register() { 
    return (HFollow) super.register();
  } 
  public HFollow unregister() { 
    return (HFollow) super.unregister();
  }
} 
public static class HMagneticField extends HBehavior { 
  protected ArrayList<HMagnet> _magnets; 
  protected HLinkedHashSet<HDrawable> _targets; 
  public HMagneticField() { 
    _magnets = new ArrayList<HMagneticField.HMagnet>(); 
    _targets = new HLinkedHashSet<HDrawable>();
  } 
  public HMagneticField addMagnet(float sx, float sy, float nx, float ny) { 
    HMagnet m = new HMagnet(); 
    m.southx = sx; 
    m.southy = sy; 
    m.northx = nx; 
    m.northy = ny; 
    _magnets.add(m); 
    return this;
  } 
  public HMagnet magnet(int index) { 
    return _magnets.get(index);
  } 
  public HMagneticField removeMagnet(int index) { 
    _magnets.remove(index); 
    return this;
  } 
  public HMagneticField addTarget(HDrawable d) { 
    if (_targets.size() <= 0) register(); 
    _targets.add(d); 
    return this;
  } 
  public HMagneticField removeTarget(HDrawable d) { 
    _targets.remove(d); 
    if (_targets.size() <= 0) unregister(); 
    return this;
  } 
  public float getRotation(float x, float y) { 
    float northRot = 0; 
    float southRot = 0; 
    int numMagnets = _magnets.size(); 
    for (int i=0; i<numMagnets; i++) { 
      HMagnet m = _magnets.get(i); 
      northRot += HMath.xAxisAngle(x, y, m.northx, m.northy); 
      southRot += HMath.xAxisAngle(x, y, m.southx, m.southy);
    } 
    return (northRot + southRot) / numMagnets;
  } 
  public void runBehavior(PApplet app) { 
    for (HIterator<HDrawable> it=_targets.iterator (); it.hasNext(); ) { 
      HDrawable d = it.next(); 
      d.rotationRad( getRotation(d.x(), d.y()) );
    }
  } 
  public HMagneticField register() { 
    return (HMagneticField) super.register();
  } 
  public HMagneticField unregister() { 
    return (HMagneticField) super.unregister();
  } 
  public static class HMagnet { 
    public float southx, southy, northx, northy;
  }
} 
public static class HOscillator extends HBehavior { 
  protected HDrawable _target; 
  protected float _stepDeg, _speed, _min, _max, _freq, _relValue, _origW, _origH; 
  protected int _propertyId, _waveform; 
  public HOscillator() { 
    _speed = 1; 
    _min = -1; 
    _max = 1; 
    _freq = 1; 
    _propertyId = HConstants.Y; 
    _waveform = HConstants.SINE;
  } 
  public HOscillator(HDrawable newTarget) { 
    this(); 
    target(newTarget);
  } 
  public HOscillator createCopy() { 
    HOscillator osc = new HOscillator() .currentStep(_stepDeg) .speed(_speed) .range(_min, _max) .freq(_freq) .relativeVal(_relValue) .property(_propertyId) .waveform(_waveform); 
    return osc;
  } 
  public HOscillator target(HDrawable newTarget) { 
    if (newTarget == null) unregister(); 
    else register(); 
    _target = newTarget; 
    if (_target != null) { 
      _origW = _target.width(); 
      _origH = _target.height();
    } 
    return this;
  } 
  public HDrawable target() { 
    return _target;
  } 
  public HOscillator currentStep(float stepDegrees) { 
    _stepDeg = stepDegrees; 
    return this;
  } 
  public float currentStep() { 
    return _stepDeg;
  } 
  public HOscillator speed(float spd) { 
    _speed = spd; 
    return this;
  } 
  public float speed() { 
    return _speed;
  } 
  public HOscillator range(float minimum, float maximum) { 
    _min = minimum; 
    _max = maximum; 
    return this;
  } 
  public HOscillator min(float minimum) { 
    _min = minimum; 
    return this;
  } 
  public float min() { 
    return _min;
  } 
  public HOscillator max(float maximum) { 
    _max = maximum; 
    return this;
  } 
  public float max() { 
    return _max;
  } 
  public HOscillator freq(float frequency) { 
    _freq = frequency; 
    return this;
  } 
  public float freq() { 
    return _freq;
  } 
  public HOscillator relativeVal(float relativeValue) { 
    _relValue = relativeValue; 
    return this;
  } 
  public float relativeVal() { 
    return _relValue;
  } 
  public HOscillator property(int propertyId) { 
    _propertyId = propertyId; 
    return this;
  } 
  public int property() { 
    return _propertyId;
  } 
  public HOscillator waveform(int form) { 
    _waveform = form; 
    return this;
  } 
  public int waveform() { 
    return _waveform;
  } 
  public float nextVal() { 
    float currentDeg = _stepDeg * _freq; 
    float outVal = 0; 
    switch(_waveform) { 
    case HConstants.SINE: 
      outVal = HMath.sineWave(currentDeg); 
      break; 
    case HConstants.TRIANGLE:
      outVal = HMath.triangleWave(currentDeg);
      break; 
    case HConstants.SAW: 
      outVal = HMath.sawWave(currentDeg); 
      break; 
    case HConstants.SQUARE: 
      outVal = HMath.squareWave(currentDeg); 
      break;
    } 
    outVal = H.app().map(outVal, -1, 1, _min, _max) + _relValue; 
    _stepDeg += speed(); 
    return outVal;
  } 
  public void runBehavior(PApplet app) { 
    if (_target == null) return; 
    float val = nextVal(); 
    switch(_propertyId) { 
    case HConstants.WIDTH: 
      _target.width(val); 
      break; 
    case HConstants.HEIGHT: 
      _target.height(val); 
      break; 
    case HConstants.SIZE: 
      _target.size(val); 
      break; 
    case HConstants.ALPHA: 
      _target.alpha(H.app().round(val)); 
      break; 
    case HConstants.X: 
      _target.x(val); 
      break; 
    case HConstants.Y: 
      _target.y(val); 
      break; 
    case HConstants.LOCATION: 
      _target.loc(val, val); 
      break; 
    case HConstants.ROTATION: 
      _target.rotation(val); 
      break; 
    case HConstants.DROTATION: 
      _target.rotate(val); 
      break; 
    case HConstants.DX: 
      _target.move(val, 0); 
      break; 
    case HConstants.DY: 
      _target.move(0, val); 
      break; 
    case HConstants.DLOC: 
      _target.move(val, val); 
      break; 
    case HConstants.SCALE: 
      _target.size(_origW*val, _origH*val); 
      break; 
    default: 
      break;
    }
  } 
  public HOscillator register() { 
    return (HOscillator) super.register();
  } 
  public HOscillator unregister() { 
    return (HOscillator) super.unregister();
  }
} 
public static class HRotate extends HBehavior { 
  protected HRotatable _target; 
  protected float _speedRad; 
  public HRotate() {
  } 
  public HRotate(HRotatable newTarget, float dDeg) { 
    target(newTarget); 
    _speedRad = dDeg * HConstants.D2R;
  } 
  public HRotate target(HRotatable r) { 
    if (r == null) unregister(); 
    else register(); 
    _target = r; 
    return this;
  } 
  public HRotatable target() { 
    return _target;
  } 
  public HRotate speed(float dDeg) { 
    _speedRad = dDeg * HConstants.D2R; 
    return this;
  } 
  public float speed() { 
    return _speedRad * HConstants.R2D;
  } 
  public HRotate speedRad(float dRad) { 
    _speedRad = dRad; 
    return this;
  } 
  public float speedRad() { 
    return _speedRad;
  } 
  public void runBehavior(PApplet app) { 
    float rot = _target.rotationRad() + _speedRad; 
    _target.rotationRad(rot);
  } 
  public HRotate register() { 
    return (HRotate) super.register();
  } 
  public HRotate unregister() { 
    return (HRotate) super.unregister();
  }
} 
public static class HSwarm extends HBehavior implements HMovable, HFollowable { 
  protected float _goalX, _goalY, _speed, _turnEase, _twitch; 
  protected HLinkedHashSet<HSwarmer> _swarmers; 
  public HSwarm() { 
    _speed = 1; 
    _turnEase = 1; 
    _twitch = 16; 
    _swarmers = new HLinkedHashSet<HSwarmer>();
  } 
  public HSwarm addTarget(HSwarmer d) { 
    if (_swarmers.size() <= 0) register(); 
    _swarmers.add(d); 
    return this;
  } 
  public HSwarm removeTarget(HSwarmer d) { 
    _swarmers.remove(d); 
    if (_swarmers.size() <= 0) unregister(); 
    return this;
  } 
  public HSwarm goal(float x, float y) { 
    _goalX = x; 
    _goalY = y; 
    return this;
  } 
  public PVector goal() { 
    return new PVector(_goalX, _goalY);
  } 
  public HSwarm goalX(float x) { 
    _goalX = x; 
    return this;
  } 
  public float goalX() { 
    return _goalX;
  } 
  public HSwarm goalY(float y) { 
    _goalY = y; 
    return this;
  } 
  public float goalY() { 
    return _goalY;
  } 
  public HSwarm speed(float s) { 
    _speed = s; 
    return this;
  } 
  public float speed() { 
    return _speed;
  } 
  public HSwarm turnEase(float e) { 
    _turnEase = e; 
    return this;
  } 
  public float turnEase() { 
    return _turnEase;
  } 
  public HSwarm twitch(float deg) { 
    _twitch = deg * HConstants.D2R; 
    return this;
  } 
  public HSwarm twitchRad(float rad) { 
    _twitch = rad; 
    return this;
  } 
  public float twitch() { 
    return _twitch * HConstants.R2D;
  } 
  public float twitchRad() { 
    return _twitch;
  } 
  public float x() { 
    return _goalX;
  } 
  public float y() { 
    return _goalY;
  } 
  public float followableX() { 
    return _goalX;
  } 
  public float followableY() { 
    return _goalY;
  } 
  public HSwarm move(float dx, float dy) { 
    _goalX += dx; 
    _goalY += dy; 
    return this;
  } 
  public void runBehavior(PApplet app) { 
    int numSwarmers = _swarmers.size(); 
    HIterator<HSwarmer> it = _swarmers.iterator(); 
    for (int i=0; i<numSwarmers; ++i) { 
      HSwarmer swarmer = it.next(); 
      float rot = swarmer.rotationRad(); 
      float tx = swarmer.x(); 
      float ty = swarmer.y(); 
      float tmp = HMath.xAxisAngle(tx, ty, _goalX, _goalY) - rot; 
      float dRot = app.atan2(app.sin(tmp), app.cos(tmp)) * _turnEase; 
      rot += dRot; 
      float noise = app.noise(i*numSwarmers + app.frameCount/8f); 
      rot += app.map(noise, 0, 1, -_twitch, _twitch); 
      swarmer.rotationRad(rot); 
      swarmer.move(app.cos(rot)*_speed, app.sin(rot)*_speed);
    }
  } 
  public HSwarm register() { 
    return (HSwarm) super.register();
  } 
  public HSwarm unregister() { 
    return (HSwarm) super.unregister();
  }
} 
public static class HVelocity extends HBehavior { 
  protected boolean _autoRegisters; 
  protected float _velocityX, _velocityY, _accelX, _accelY; 
  protected HMovable _target; 
  public HVelocity() { 
    _autoRegisters = true;
  } 
  public HVelocity(boolean isAutoRegister) { 
    _autoRegisters = isAutoRegister;
  } 
  public HVelocity autoRegisters(boolean b) { 
    _autoRegisters = b; 
    return this;
  } 
  public boolean autoRegisters() { 
    return _autoRegisters;
  } 
  public HVelocity target(HMovable t) { 
    if (_autoRegisters) { 
      if (t == null) unregister(); 
      else register();
    } 
    _target = t; 
    return this;
  } 
  public HMovable target() { 
    return _target;
  } 
  public HVelocity velocity(float velocity, float deg) { 
    return velocityRad(velocity, deg*HConstants.D2R);
  } 
  public HVelocity velocityRad(float velocity, float rad) { 
    PApplet app = H.app(); 
    _velocityX = velocity * app.cos(rad); 
    _velocityY = velocity * app.sin(rad); 
    return this;
  } 
  public HVelocity velocityX(float dx) { 
    _velocityX = dx; 
    return this;
  } 
  public float velocityX() { 
    return _velocityX;
  } 
  public HVelocity velocityY(float dy) { 
    _velocityY = dy; 
    return this;
  } 
  public float velocityY() { 
    return _velocityY;
  } 
  public HVelocity launchTo(float goalX, float goalY, float time) { 
    if (_target == null) { 
      HWarnings.warn("Null Target", "HVelocity.launchTo()", HWarnings.NULL_TARGET);
    } else { 
      float numFrames = time*60/1000; 
      float nfsq = numFrames*numFrames; 
      _velocityX = (goalX - _target.x() - _accelX*nfsq/2) / numFrames; 
      _velocityY = (goalY - _target.y() - _accelY*nfsq/2) / numFrames;
    } 
    return this;
  } 
  public HVelocity accel(float acceleration, float deg) { 
    return accelRad(acceleration, deg*HConstants.D2R);
  } 
  public HVelocity accelRad(float acceleration, float rad) { 
    PApplet app = H.app(); 
    _accelX = acceleration * app.cos(rad); 
    _accelY = acceleration * app.sin(rad); 
    return this;
  } 
  public HVelocity accelX(float ddx) { 
    _accelX = ddx; 
    return this;
  } 
  public float accelX() { 
    return _accelX;
  } 
  public HVelocity accelY(float ddy) { 
    _accelY = ddy; 
    return this;
  } 
  public float accelY() { 
    return _accelY;
  } 
  public void runBehavior(PApplet app) { 
    _target.move(_velocityX, _velocityY); 
    _velocityX += _accelX; 
    _velocityY += _accelY;
  } 
  public HVelocity register() { 
    return (HVelocity) super.register();
  } 
  public HVelocity unregister() { 
    return (HVelocity) super.unregister();
  }
} 
public static interface HIterator<U> { 
  public boolean hasNext(); 
  public U next(); 
  public void remove();
} 
public static class HLinkedHashSet<T> extends HLinkedList<T> { 
  protected HashMap<T, HLinkedListNode<T>> nodeMap; 
  public HLinkedHashSet() { 
    nodeMap = new HashMap<T, HLinkedListNode<T>>();
  } 
  public boolean remove(T content) { 
    HLinkedListNode<T> node = nodeMap.get(content); 
    if (node==null) return false; 
    unregister(content); 
    node.popOut(); 
    --_size; 
    return true;
  } 
  public boolean add(T content) { 
    return contains(content)? false : super.add(content);
  } 
  public boolean push(T content) { 
    return contains(content)? false : super.push(content);
  } 
  public boolean insert(T content, int index) { 
    return contains(content)? false : super.insert(content, index);
  } 
  public T pull() { 
    return unregister(super.pull());
  } 
  public T pop() { 
    return unregister(super.pop());
  } 
  public T removeAt(int index) { 
    return unregister(super.removeAt(index));
  } 
  public void removeAll() { 
    while (_size > 0) pop();
  } 
  public boolean contains(T obj) { 
    return nodeMap.get(obj) != null;
  } 
  protected HLinkedListNode<T> register(T obj) { 
    HLinkedListNode<T> node = new HLinkedListNode<T>(obj); 
    nodeMap.put(obj, node); 
    return node;
  } 
  protected T unregister(T obj) { 
    nodeMap.remove(obj); 
    return obj;
  }
} 
public static class HLinkedList<T> { 
  protected HLinkedListNode<T> _firstSentinel, _lastSentinel; 
  protected int _size; 
  public HLinkedList() { 
    _firstSentinel = new HLinkedListNode<T>(null); 
    _lastSentinel = new HLinkedListNode<T>(null); 
    _lastSentinel.putAfter(_firstSentinel);
  } 
  public T first() { 
    return _firstSentinel._next._content;
  } 
  public T last() { 
    return _lastSentinel._prev._content;
  } 
  public T get(int index) { 
    HLinkedListNode<T> n = nodeAt(index); 
    return (n==null)? null : n._content;
  } 
  public boolean push(T content) { 
    if (content==null) return false; 
    register(content).putAfter(_firstSentinel); 
    ++_size; 
    return true;
  } 
  public boolean add(T content) { 
    if (content==null) return false; 
    register(content).putBefore(_lastSentinel); 
    ++_size; 
    return true;
  } 
  public boolean insert(T content, int index) { 
    if (content==null) return false; 
    HLinkedListNode<T> n = (index==_size)? _lastSentinel : nodeAt(index); 
    if (n==null) return false; 
    register(content).putBefore(n); 
    ++_size; 
    return true;
  } 
  public T pop() { 
    HLinkedListNode<T> firstNode = _firstSentinel._next; 
    if (firstNode._content != null) { 
      firstNode.popOut(); 
      --_size;
    } 
    return firstNode._content;
  } 
  public T pull() { 
    HLinkedListNode<T> lastNode = _lastSentinel._prev; 
    if (lastNode._content != null) { 
      lastNode.popOut(); 
      --_size;
    } 
    return lastNode._content;
  } 
  public T removeAt(int index) { 
    HLinkedListNode<T> n = nodeAt(index); 
    if (n==null) return null; 
    n.popOut(); 
    --_size; 
    return n._content;
  } 
  public void removeAll() { 
    _lastSentinel.putAfter(_firstSentinel); 
    _size = 0;
  } 
  public int size() { 
    return _size;
  } 
  public boolean inRange(int index) { 
    return (0 <= index) && (index < _size);
  } 
  public HLinkedListIterator<T> iterator() { 
    return new HLinkedListIterator<T>(this);
  } 
  protected HLinkedListNode<T> nodeAt(int i) { 
    int ri; 
    if (i<0) { 
      ri = -i; 
      i += _size;
    } else { 
      ri = _size-i;
    } 
    if (!inRange(i)) { 
      HWarnings.warn("Out of Range: "+i, "HLinkedList.nodeAt()", null); 
      return null;
    } 
    HLinkedListNode<T> node; 
    if (ri < i) { 
      node = _lastSentinel._prev; 
      while (--ri > 0) node = node._prev;
    } else { 
      node = _firstSentinel._next; 
      while (i-- > 0) node = node._next;
    } 
    return node;
  } 
  protected HLinkedListNode<T> register(T obj) { 
    return new HLinkedListNode<T>(obj);
  } 
  public static class HLinkedListNode<U> extends HNode<HLinkedListNode<U>> { 
    private U _content; 
    public HLinkedListNode(U nodeContent) { 
      _content = nodeContent;
    } 
    public U content() { 
      return _content;
    }
  } 
  public static class HLinkedListIterator<U> implements HIterator<U> { 
    private HLinkedList<U> list; 
    private HLinkedListNode<U> n1, n2; 
    public HLinkedListIterator(HLinkedList<U> parent) { 
      list = parent; 
      n1 = list._firstSentinel._next; 
      if (n1 != null) n2 = n1._next;
    } 
    public boolean hasNext() { 
      return (n1._content != null);
    } 
    public U next() { 
      U content = n1._content; 
      n1 = n2; 
      if (n2 != null) n2 = n2._next; 
      return content;
    } 
    public void remove() { 
      if (n1._content != null) { 
        n1.popOut(); 
        --list._size;
      }
    }
  }
} 
public static abstract class HNode<T extends HNode<T>> { 
  protected T _prev, _next; 
  public T prev() { 
    return _prev;
  } 
  public T next() { 
    return _next;
  } 
  public boolean poppedOut() { 
    return (_prev==null) && (_next==null);
  } 
  public void popOut() { 
    if (_prev!=null) _prev._next = _next; 
    if (_next!=null) _next._prev = _prev; 
    _prev = _next = null;
  } 
  public void putBefore(T dest) { 
    if (dest==null || dest.equals(this)) return; 
    if (!poppedOut()) popOut(); 
    T p = dest._prev; 
    if (p!=null) p._next = (T) this; 
    _prev = p; 
    _next = dest; 
    dest._prev = (T) this;
  } 
  public void putAfter(T dest) { 
    if (dest==null || dest.equals(this)) return; 
    if (!poppedOut()) popOut(); 
    T n = dest.next(); 
    dest._next = (T) this; 
    _prev = dest; 
    _next = n; 
    if (n!=null) n._prev = (T) this;
  } 
  public void replaceNode(T dest) { 
    if (dest==null || dest.equals(this)) return; 
    if (!poppedOut()) popOut(); 
    T p = dest._prev; 
    T n = dest._next; 
    dest._prev = dest._next = null; 
    _prev = p; 
    _next = n;
  } 
  public void swapLeft() { 
    if (_prev==null) return; 
    T pairPrev = _prev._prev; 
    T pairNext = _next; 
    _next = _prev; 
    _prev._prev = (T) this; 
    _prev._next = pairNext; 
    if (pairNext != null) pairNext._prev = _prev; 
    _prev = pairPrev; 
    if (pairPrev != null) pairPrev._next = (T) this;
  } 
  public void swapRight() { 
    if (_next==null) return; 
    T pairPrev = _prev; 
    T pairNext = _next._next; 
    _next._next = (T) this; 
    _prev = _next; 
    _next._prev = pairPrev; 
    if (pairPrev != null) pairPrev._next = _next; 
    _next = pairNext; 
    if (pairNext != null) pairNext._prev = (T) this;
  }
} 
public static class HColorField implements HColorist { 
  protected ArrayList<HColorPoint> _colorPoints; 
  protected float _maxDist; 
  protected boolean _appliesFill, _appliesStroke, _appliesAlpha; 
  public HColorField() { 
    this(H.app().width, H.app().height);
  } 
  public HColorField(float xBound, float yBound) { 
    this(H.app().sqrt(xBound*xBound + yBound*yBound));
  } 
  public HColorField(float maximumDistance) { 
    _colorPoints = new ArrayList<HColorField.HColorPoint>(); 
    _maxDist = maximumDistance; 
    fillAndStroke();
  } 
  public HColorField addPoint(PVector loc, int clr, float radius) { 
    return addPoint(loc.x, loc.y, clr, radius);
  } 
  public HColorField addPoint(float x, float y, int clr, float radius) { 
    HColorPoint pt = new HColorPoint(); 
    pt.x = x; 
    pt.y = y; 
    pt.radius = radius; 
    pt.clr = clr; 
    _colorPoints.add(pt); 
    return this;
  } 
  public int getColor(float x, float y, int baseColor) { 
    PApplet app = H.app(); 
    int[] baseClrs = HColorUtil.explode(baseColor); 
    int[] maxClrs = new int[4]; 
    int initJ; 
    if (_appliesAlpha) { 
      initJ = 0;
    } else { 
      initJ = 1; 
      maxClrs[0] = baseClrs[0];
    } 
    for (int i=0; i<_colorPoints.size (); ++i) { 
      HColorPoint pt = _colorPoints.get(i); 
      int[] ptClrs = HColorUtil.explode(pt.clr); 
      float distLimit = _maxDist * pt.radius; 
      float dist = app.dist(x, y, pt.x, pt.y); 
      if (dist > distLimit) dist = distLimit; 
      for (int j=initJ; j<4; ++j) { 
        int newClrVal = app.round( app.map(dist, 0, distLimit, ptClrs[j], baseClrs[j])); 
        if (newClrVal > maxClrs[j]) maxClrs[j] = newClrVal;
      }
    } 
    return HColorUtil.merge(maxClrs[0], maxClrs[1], maxClrs[2], maxClrs[3]);
  } 
  public HColorField appliesAlpha(boolean b) { 
    _appliesAlpha = b; 
    return this;
  } 
  public boolean appliesAlpha() { 
    return _appliesAlpha;
  } 
  public HColorField fillOnly() { 
    _appliesFill = true; 
    _appliesStroke = false; 
    return this;
  } 
  public HColorField strokeOnly() { 
    _appliesFill = false; 
    _appliesStroke = true; 
    return this;
  } 
  public HColorField fillAndStroke() { 
    _appliesFill = _appliesStroke = true; 
    return this;
  } 
  public boolean appliesFill() { 
    return _appliesFill;
  } 
  public boolean appliesStroke() { 
    return _appliesStroke;
  } 
  public HDrawable applyColor(HDrawable drawable) { 
    float x = drawable.x(); 
    float y = drawable.y(); 
    if (_appliesFill) { 
      int baseFill = drawable.fill(); 
      drawable.fill( getColor(x, y, baseFill) );
    } 
    if (_appliesStroke) { 
      int baseStroke = drawable.stroke(); 
      drawable.stroke( getColor(x, y, baseStroke) );
    } 
    return drawable;
  } 
  public static class HColorPoint { 
    public float x, y, radius; 
    public int clr;
  }
} 
public static interface HColorist { 
  public HColorist fillOnly(); 
  public HColorist strokeOnly(); 
  public HColorist fillAndStroke(); 
  public boolean appliesFill(); 
  public boolean appliesStroke(); 
  public HDrawable applyColor(HDrawable drawable);
} 
public static class HColorPool implements HColorist { 
  protected ArrayList<Integer> _colorList; 
  protected boolean _fillFlag, _strokeFlag; 
  public HColorPool(int... colors) { 
    _colorList = new ArrayList<Integer>(); 
    for (int i=0; i<colors.length; ++i) add(colors[i]); 
    fillAndStroke();
  } 
  public HColorPool createCopy() { 
    HColorPool copy = new HColorPool(); 
    copy._fillFlag = _fillFlag; 
    copy._strokeFlag = _strokeFlag; 
    for (int i=0; i<_colorList.size (); ++i) { 
      int clr = _colorList.get(i); 
      copy._colorList.add( clr );
    } 
    return copy;
  } 
  public int size() { 
    return _colorList.size();
  } 
  public HColorPool add(int clr) { 
    _colorList.add(clr); 
    return this;
  } 
  public HColorPool add(int clr, int freq) { 
    while (freq-- > 0) _colorList.add(clr); 
    return this;
  } 
  public int getColor() { 
    if (_colorList.size() <= 0) return 0; 
    PApplet app = H.app(); 
    int index = app.round(app.random(_colorList.size()-1)); 
    return _colorList.get(index);
  } 
  public int getColor(int seed) { 
    HMath.tempSeed(seed); 
    int clr = getColor(); 
    HMath.removeTempSeed(); 
    return clr;
  } 
  public HColorPool fillOnly() { 
    _fillFlag = true; 
    _strokeFlag = false; 
    return this;
  } 
  public HColorPool strokeOnly() { 
    _fillFlag = false; 
    _strokeFlag = true; 
    return this;
  } 
  public HColorPool fillAndStroke() { 
    _fillFlag = _strokeFlag = true; 
    return this;
  } 
  public boolean appliesFill() { 
    return _fillFlag;
  } 
  public boolean appliesStroke() { 
    return _strokeFlag;
  } 
  public HDrawable applyColor(HDrawable drawable) { 
    if (_fillFlag) drawable.fill(getColor()); 
    if (_strokeFlag) drawable.stroke(getColor()); 
    return drawable;
  }
} 
public static class HColorTransform implements HColorist { 
  public float _percA, _percR, _percG, _percB; 
  public int _offsetA, _offsetR, _offsetG, _offsetB; 
  protected boolean fillFlag, strokeFlag; 
  public HColorTransform() { 
    _percA = _percR = _percG = _percB = 1; 
    fillAndStroke();
  } 
  public HColorTransform offset(int off) { 
    _offsetA = _offsetR = _offsetG = _offsetB = off; 
    return this;
  } 
  public HColorTransform offset(int r, int g, int b, int a) { 
    _offsetA = a; 
    _offsetR = r; 
    _offsetG = g; 
    _offsetB = b; 
    return this;
  } 
  public HColorTransform offsetA(int a) { 
    _offsetA = a; 
    return this;
  } 
  public int offsetA() { 
    return _offsetA;
  } 
  public HColorTransform offsetR(int r) { 
    _offsetR = r; 
    return this;
  } 
  public int offsetR() { 
    return _offsetR;
  } 
  public HColorTransform offsetG(int g) { 
    _offsetG = g; 
    return this;
  } 
  public int offsetG() { 
    return _offsetG;
  } 
  public HColorTransform offsetB(int b) { 
    _offsetB = b; 
    return this;
  } 
  public int offsetB() { 
    return _offsetB;
  } 
  public HColorTransform perc(float percentage) { 
    _percA = _percR = _percG = _percB = percentage; 
    return this;
  } 
  public HColorTransform perc(int r, int g, int b, int a) { 
    _percA = a; 
    _percR = r; 
    _percG = g; 
    _percB = b; 
    return this;
  } 
  public HColorTransform percA(float a) { 
    _percA = a; 
    return this;
  } 
  public float percA() { 
    return _percA;
  } 
  public HColorTransform percR(float r) { 
    _percR = r; 
    return this;
  } 
  public float percR() { 
    return _percR;
  } 
  public HColorTransform percG(float g) { 
    _percG = g; 
    return this;
  } 
  public float percG() { 
    return _percG;
  } 
  public HColorTransform percB(float b) { 
    _percB = b; 
    return this;
  } 
  public float percB() { 
    return _percB;
  } 
  public HColorTransform mergeWith(HColorTransform other) { 
    if (other != null) { 
      _percA *= other._percA; 
      _percR *= other._percR; 
      _percG *= other._percG; 
      _percB *= other._percB; 
      _offsetA += other._offsetA; 
      _offsetR += other._offsetR; 
      _offsetG += other._offsetG; 
      _offsetB += other._offsetB;
    } 
    return this;
  } 
  public HColorTransform createCopy() { 
    HColorTransform copy = new HColorTransform(); 
    copy._percA = _percA; 
    copy._percR = _percR; 
    copy._percG = _percG; 
    copy._percB = _percB; 
    copy._offsetA = _offsetA; 
    copy._offsetR = _offsetR; 
    copy._offsetG = _offsetG; 
    copy._offsetB = _offsetB; 
    return copy;
  } 
  public HColorTransform createNew(HColorTransform other) { 
    return createCopy().mergeWith(other);
  } 
  public int getColor(int origColor) { 
    PApplet app = H.app(); 
    int[] clrs = HColorUtil.explode(origColor); 
    clrs[0] = app.round(clrs[0] * _percA) + _offsetA; 
    clrs[1] = app.round(clrs[1] * _percR) + _offsetR; 
    clrs[2] = app.round(clrs[2] * _percG) + _offsetG; 
    clrs[3] = app.round(clrs[3] * _percB) + _offsetB; 
    return HColorUtil.merge(clrs[0], clrs[1], clrs[2], clrs[3]);
  } 
  public HColorTransform fillOnly() { 
    fillFlag = true; 
    strokeFlag = false; 
    return this;
  } 
  public HColorTransform strokeOnly() { 
    fillFlag = false; 
    strokeFlag = true; 
    return this;
  } 
  public HColorTransform fillAndStroke() { 
    fillFlag = strokeFlag = true; 
    return this;
  } 
  public boolean appliesFill() { 
    return fillFlag;
  } 
  public boolean appliesStroke() { 
    return strokeFlag;
  } 
  public HDrawable applyColor(HDrawable drawable) { 
    if (fillFlag) { 
      int fill = drawable.fill(); 
      drawable.fill( getColor(fill) );
    } 
    if (strokeFlag) { 
      int stroke = drawable.stroke(); 
      drawable.stroke( getColor(stroke) );
    } 
    return drawable;
  }
} 
public static class HPixelColorist implements HColorist { 
  protected PImage img; 
  protected boolean fillFlag, strokeFlag; 
  public HPixelColorist() { 
    fillAndStroke();
  } 
  public HPixelColorist(Object imgArg) { 
    this(); 
    setImage(imgArg);
  } 
  public HPixelColorist setImage(Object imgArg) { 
    if (imgArg instanceof PImage) { 
      img = (PImage) imgArg;
    } else if (imgArg instanceof HImage) { 
      img = ((HImage) imgArg).image();
    } else if (imgArg instanceof String) { 
      img = H.app().loadImage((String) imgArg);
    } else if (imgArg == null) { 
      img = null;
    } 
    return this;
  } 
  public PImage getImage() { 
    return img;
  } 
  public int getColor(float x, float y) { 
    if (img == null) return 0; 
    PApplet app = H.app(); 
    return img.get(app.round(x), app.round(y));
  } 
  public HPixelColorist fillOnly() { 
    fillFlag = true; 
    strokeFlag = false; 
    return this;
  } 
  public HPixelColorist strokeOnly() { 
    fillFlag = false; 
    strokeFlag = true; 
    return this;
  } 
  public HPixelColorist fillAndStroke() { 
    fillFlag = strokeFlag = true; 
    return this;
  } 
  public boolean appliesFill() { 
    return fillFlag;
  } 
  public boolean appliesStroke() { 
    return strokeFlag;
  } 
  public HDrawable applyColor(HDrawable drawable) { 
    int clr = getColor(drawable.x(), drawable.y()); 
    if (fillFlag) drawable.fill(clr); 
    if (strokeFlag) drawable.stroke(clr); 
    return drawable;
  }
} 
public static abstract class HDrawable extends HNode<HDrawable> implements HSwarmer, HFollowable, HHittable { 
  protected HDrawable _parent, _firstChild, _lastChild; 
  protected HBundle _extras; 
  protected float _x, _y, _anchorPercX, _anchorPercY, _width, _height, _rotationRad, _strokeWeight, _alpha; 
  protected int _numChildren, _fill, _stroke, _strokeCap, _strokeJoin; 
  public HDrawable() { 
    _alpha = 1; 
    _fill = HConstants.DEFAULT_FILL; 
    _stroke = HConstants.DEFAULT_STROKE; 
    _strokeCap = PConstants.ROUND; 
    _strokeJoin = PConstants.MITER; 
    _strokeWeight = 1; 
    _width = HConstants.DEFAULT_WIDTH; 
    _height = HConstants.DEFAULT_HEIGHT;
  } 
  public void copyPropertiesFrom(HDrawable other) { 
    _x = other._x; 
    _y = other._y; 
    _anchorPercX = other._anchorPercX; 
    _anchorPercY = other._anchorPercY; 
    _width = other._width; 
    _height = other._height; 
    _rotationRad = other._rotationRad; 
    _alpha = other._alpha; 
    _strokeWeight = other._strokeWeight; 
    _fill = other._fill; 
    _stroke = other._stroke; 
    _strokeCap = other._strokeCap; 
    _strokeJoin = other._strokeJoin;
  } 
  public abstract HDrawable createCopy(); 
  protected boolean invalidDest(HDrawable dest, String warnLoc) { 
    String warnType; 
    String warnMsg; 
    if ( dest == null ) { 
      warnType = "Null Destination"; 
      warnMsg = HWarnings.NULL_ARGUMENT;
    } else if ( dest._parent == null ) { 
      warnType = "Invalid Destination"; 
      warnMsg = HWarnings.INVALID_DEST;
    } else if ( dest._parent.equals(this) ) { 
      warnType = "Recursive Child"; 
      warnMsg = HWarnings.CHILDCEPTION;
    } else if ( dest.equals(this) ) { 
      warnType = "Invalid Destination"; 
      warnMsg = HWarnings.DESTCEPTION;
    } else return false; 
    HWarnings.warn(warnType, warnLoc, warnMsg); 
    return true;
  } 
  public boolean poppedOut() { 
    return (_parent == null);
  } 
  public void popOut() { 
    if (_parent == null) return; 
    if (_prev == null) _parent._firstChild = _next; 
    if (_next == null) _parent._lastChild = _prev; 
    --_parent._numChildren; 
    _parent = null; 
    super.popOut();
  } 
  public void putBefore(HDrawable dest) { 
    if (invalidDest(dest, "HDrawable.putBefore()")) return; 
    popOut(); 
    super.putBefore(dest); 
    _parent = dest._parent; 
    if (_prev == null) _parent._firstChild = this; 
    ++_parent._numChildren;
  } 
  public void putAfter(HDrawable dest) { 
    if (invalidDest(dest, "HDrawable.putAfter()")) return; 
    popOut(); 
    super.putAfter(dest); 
    _parent = dest._parent; 
    if (_next == null) _parent._lastChild = this; 
    ++_parent._numChildren;
  } 
  public void swapLeft() { 
    boolean isLast = (_next == null); 
    super.swapLeft(); 
    if (_prev == null) _parent._firstChild = this; 
    if (_next != null && isLast) _parent._lastChild = _next;
  } 
  public void swapRight() { 
    boolean isFirst = (_prev == null); 
    super.swapRight(); 
    if (_next == null) _parent._lastChild = this; 
    if (_prev != null && isFirst) _parent._firstChild = _prev;
  } 
  public void replaceNode(HDrawable dest) { 
    if (invalidDest(dest, "HDrawable.replaceNode()")) return; 
    super.replaceNode(dest); 
    _parent = dest._parent; 
    dest._parent = null; 
    if (_prev == null) _parent._firstChild = this; 
    if (_next == null) _parent._lastChild = this;
  } 
  public HDrawable parent() { 
    return _parent;
  } 
  public boolean parentOf(HDrawable d) { 
    return (d != null) && (d._parent != null) && (d._parent.equals(this));
  } 
  public int numChildren() { 
    return _numChildren;
  } 
  public HDrawable add(HDrawable child) { 
    if (child == null) { 
      HWarnings.warn("An Empty Child", "HDrawable.add()", HWarnings.NULL_ARGUMENT);
    } else if ( !parentOf(child) ) { 
      if (_lastChild == null) { 
        _firstChild = _lastChild = child; 
        child.popOut(); 
        child._parent = this; 
        ++_numChildren;
      } else child.putAfter(_lastChild);
    } 
    return child;
  } 
  public HDrawable remove(HDrawable child) { 
    if ( parentOf(child) ) child.popOut(); 
    else HWarnings.warn("Not a Child", "HDrawable.remove()", null); 
    return child;
  } 
  public HDrawableIterator iterator() { 
    return new HDrawableIterator(this);
  } 
  public HDrawable loc(float newX, float newY) { 
    _x = newX; 
    _y = newY; 
    return this;
  } 
  public HDrawable loc(PVector pt) { 
    _x = pt.x; 
    _y = pt.y; 
    return this;
  } 
  public PVector loc() { 
    return new PVector(_x, _y);
  } 
  public HDrawable x(float newX) { 
    _x = newX; 
    return this;
  } 
  public float x() { 
    return _x;
  } 
  public HDrawable y(float newY) { 
    _y = newY; 
    return this;
  } 
  public float y() { 
    return _y;
  } 
  public HDrawable move(float dx, float dy) { 
    _x += dx; 
    _y += dy; 
    return this;
  } 
  public HDrawable locAt(int where) { 
    if (_parent!=null) { 
      if (HMath.hasBits(where, HConstants.CENTER_X)) _x = _parent.width()/2 - _parent.anchorX(); 
      else if (HMath.hasBits(where, HConstants.LEFT)) _x = -_parent.anchorX(); 
      else if (HMath.hasBits(where, HConstants.RIGHT)) _x = _parent.width() - _parent.anchorX(); 
      if (HMath.hasBits(where, HConstants.CENTER_Y)) _y = _parent.height()/2 - _parent.anchorY(); 
      else if (HMath.hasBits(where, HConstants.TOP)) _y = -_parent.anchorY(); 
      else if (HMath.hasBits(where, HConstants.BOTTOM)) _y = _parent.height() - _parent.anchorY();
    } 
    return this;
  } 
  public HDrawable anchor(float pxX, float pxY) { 
    if (_height == 0 || _width == 0) { 
      HWarnings.warn("Division by 0", "HDrawable.anchor()", HWarnings.ANCHORPX_ERR);
    } else { 
      _anchorPercX = pxX / _width; 
      _anchorPercY = pxY / _height;
    } 
    return this;
  } 
  public HDrawable anchor(PVector pt) { 
    return anchor(pt.x, pt.y);
  } 
  public PVector anchor() { 
    return new PVector( anchorX(), anchorY() );
  } 
  public HDrawable anchorX(float pxX) { 
    if (_width == 0) { 
      HWarnings.warn("Division by 0", "HDrawable.anchorX()", HWarnings.ANCHORPX_ERR);
    } else { 
      _anchorPercX = pxX / _width;
    } 
    return this;
  } 
  public float anchorX() { 
    return _width * _anchorPercX;
  } 
  public HDrawable anchorY(float pxY) { 
    if (_height == 0) { 
      HWarnings.warn("Division by 0", "HDrawable.anchorY()", HWarnings.ANCHORPX_ERR);
    } else { 
      _anchorPercY = pxY / _height;
    } 
    return this;
  } 
  public float anchorY() { 
    return _height * _anchorPercY;
  } 
  public HDrawable anchorPerc(float percX, float percY) { 
    _anchorPercX = percX; 
    _anchorPercY = percY; 
    return this;
  } 
  public PVector anchorPerc() { 
    return new PVector(_anchorPercX, _anchorPercY);
  } 
  public HDrawable anchorPercX(float percX) { 
    _anchorPercX = percX; 
    return this;
  } 
  public float anchorPercX() { 
    return _anchorPercX;
  } 
  public HDrawable anchorPercY(float percY) { 
    _anchorPercY = percY; 
    return this;
  } 
  public float anchorPercY() { 
    return _anchorPercY;
  } 
  public HDrawable anchorAt(int where) { 
    if (HMath.hasBits(where, HConstants.CENTER_X)) _anchorPercX = 0.5f; 
    else if (HMath.hasBits(where, HConstants.LEFT)) _anchorPercX = 0; 
    else if (HMath.hasBits(where, HConstants.RIGHT)) _anchorPercX = 1; 
    if (HMath.hasBits(where, HConstants.CENTER_Y)) _anchorPercY = 0.5f; 
    else if (HMath.hasBits(where, HConstants.TOP)) _anchorPercY = 0; 
    else if (HMath.hasBits(where, HConstants.BOTTOM)) _anchorPercY = 1; 
    return this;
  } 
  public HDrawable size(float w, float h) { 
    width(w); 
    height(h); 
    return this;
  } 
  public HDrawable size(float s) { 
    size(s, s); 
    return this;
  } 
  public PVector size() { 
    return new PVector(_width, _height);
  } 
  public HDrawable width(float w) { 
    _width = w; 
    return this;
  } 
  public float width() { 
    return _width;
  } 
  public HDrawable height(float h) { 
    _height = h; 
    return this;
  } 
  public float height() { 
    return _height;
  } 
  public HDrawable scale(float s) { 
    size(_width*s, _height*s); 
    return this;
  } 
  public HDrawable scale(float sw, float sh) { 
    size(_width*sw, _height*sh); 
    return this;
  } 
  public PVector boundingSize() { 
    PApplet app = H.app(); 
    float cosVal = app.cos(_rotationRad); 
    float sinVal = app.sin(_rotationRad); 
    float drawX = -anchorX(); 
    float drawY = -anchorY(); 
    float x1 = drawX; 
    float x2 = _width + drawX; 
    float y1 = drawY; 
    float y2 = _height + drawY; 
    float[] xCoords = new float[4]; 
    float[] yCoords = new float[4]; 
    xCoords[0] = x1*cosVal + y1*sinVal; 
    yCoords[0] = x1*sinVal + y1*cosVal; 
    xCoords[1] = x2*cosVal + y1*sinVal; 
    yCoords[1] = x2*sinVal + y1*cosVal; 
    xCoords[2] = x1*cosVal + y2*sinVal; 
    yCoords[2] = x1*sinVal + y2*cosVal; 
    xCoords[3] = x2*cosVal + y2*sinVal; 
    yCoords[3] = x2*sinVal + y2*cosVal; 
    float minX = xCoords[3]; 
    float maxX = minX; 
    float minY = yCoords[3]; 
    float maxY = maxX; 
    for (int i=0; i<3; ++i) { 
      float x = xCoords[i]; 
      float y = yCoords[i]; 
      if (x < minX) minX = x; 
      else if (x > maxX) maxX = x; 
      if (y < minY) minY = y; 
      else if (y > maxY) maxY = y;
    } 
    return new PVector(maxX-minX, maxY-minY);
  } 
  public HDrawable fill(int clr) { 
    if (0 <= clr && clr <= 255) clr |= clr<<8 | clr<<16 | 0xFF000000; 
    _fill = clr; 
    return this;
  } 
  public HDrawable fill(int clr, int alpha) { 
    if (0 <= clr && clr <= 255) clr |= clr<<8 | clr<<16; 
    _fill = HColorUtil.setAlpha(clr, alpha); 
    return this;
  } 
  public HDrawable fill(int r, int g, int b) { 
    _fill = HColorUtil.merge(255, r, g, b); 
    return this;
  } 
  public HDrawable fill(int r, int g, int b, int a) { 
    _fill = HColorUtil.merge(a, r, g, b); 
    return this;
  } 
  public int fill() { 
    return _fill;
  } 
  public HDrawable noFill() { 
    return fill(HConstants.CLEAR);
  } 
  public HDrawable stroke(int clr) { 
    if (0 <= clr && clr <= 255) clr |= clr<<8 | clr<<16 | 0xFF000000; 
    _stroke = clr; 
    return this;
  } 
  public HDrawable stroke(int clr, int alpha) { 
    if (0 <= clr && clr <= 255) clr |= clr<<8 | clr<<16; 
    _stroke = HColorUtil.setAlpha(clr, alpha); 
    return this;
  } 
  public HDrawable stroke(int r, int g, int b) { 
    _stroke = HColorUtil.merge(255, r, g, b); 
    return this;
  } 
  public HDrawable stroke(int r, int g, int b, int a) { 
    _stroke = HColorUtil.merge(a, r, g, b); 
    return this;
  } 
  public int stroke() { 
    return _stroke;
  } 
  public HDrawable noStroke() { 
    return stroke(HConstants.CLEAR);
  } 
  public HDrawable strokeCap(int type) { 
    _strokeCap = type; 
    return this;
  } 
  public int strokeCap() { 
    return _strokeCap;
  } 
  public HDrawable strokeJoin(int type) { 
    _strokeJoin = type; 
    return this;
  } 
  public int strokeJoin() { 
    return _strokeJoin;
  } 
  public HDrawable strokeWeight(float f) { 
    _strokeWeight = f; 
    return this;
  } 
  public float strokeWeight() { 
    return _strokeWeight;
  } 
  public HDrawable rotation(float deg) { 
    _rotationRad = deg * HConstants.D2R; 
    return this;
  } 
  public float rotation() { 
    return _rotationRad * HConstants.R2D;
  } 
  public HDrawable rotationRad(float rad) { 
    _rotationRad = rad; 
    return this;
  } 
  public float rotationRad() { 
    return _rotationRad;
  } 
  public HDrawable rotate(float deg) { 
    _rotationRad += deg * HConstants.D2R; 
    return this;
  } 
  public HDrawable rotateRad(float rad) { 
    _rotationRad += rad; 
    return this;
  } 
  public HDrawable alpha(int a) { 
    return alphaPerc(a/255f);
  } 
  public int alpha() { 
    return H.app().round( alphaPerc()*255 );
  } 
  public HDrawable alphaPerc(float aPerc) { 
    _alpha = (aPerc<0)? 0 : (aPerc>1)? 1 : aPerc; 
    return this;
  } 
  public float alphaPerc() { 
    return (_alpha<0)? 0 : _alpha;
  } 
  public HDrawable visibility(boolean v) { 
    if (v && _alpha == 0) { 
      _alpha = 1;
    } else if (v == _alpha < 0) { 
      _alpha = -_alpha;
    } 
    return this;
  } 
  public boolean visibility() { 
    return _alpha > 0;
  } 
  public HDrawable show() { 
    return visibility(true);
  } 
  public HDrawable hide() { 
    return visibility(false);
  } 
  public HDrawable alphaShift(int da) { 
    return alphaShiftPerc( da/255f );
  } 
  public HDrawable alphaShiftPerc(float daPerc) { 
    return alphaPerc(_alpha + daPerc);
  } 
  public float followableX() { 
    return _x;
  } 
  public float followableY() { 
    return _y;
  } 
  public HDrawable extras(HBundle b) { 
    _extras = b; 
    return this;
  } 
  public HBundle extras() { 
    return _extras;
  } 
  public boolean contains(float absX, float absY) { 
    float[] rel = HMath.relLocArr(this, absX, absY); 
    rel[0] += anchorX(); 
    rel[1] += anchorY(); 
    return containsRel(rel[0], rel[1]);
  } 
  public boolean containsRel(float relX, float relY) { 
    return (0 <= relX) && (relX <= width()) && (0 <= relY) && (relY <= height());
  } 
  protected void applyStyle(PApplet app, float currAlphaPerc) { 
    float faPerc = currAlphaPerc * (_fill >>> 24); 
    app.fill(_fill | 0xFF000000, app.round(faPerc)); 
    if (_strokeWeight > 0) { 
      float saPerc = currAlphaPerc * (_stroke >>> 24); 
      app.stroke(_stroke | 0xFF000000, app.round(saPerc)); 
      app.strokeWeight(_strokeWeight); 
      app.strokeCap(_strokeCap); 
      app.strokeJoin(_strokeJoin);
    } else app.noStroke();
  } 
  public void paintAll(PApplet app, float currAlphaPerc) { 
    if (_alpha<=0 || _width<0 || _height<0) return; 
    app.pushMatrix(); 
    app.translate(_x, _y); 
    app.rotate(_rotationRad); 
    currAlphaPerc *= _alpha; 
    draw(app, -anchorX(), -anchorY(), currAlphaPerc); 
    HDrawable child = _firstChild; 
    while (child != null) { 
      child.paintAll(app, currAlphaPerc); 
      child = child._next;
    } 
    app.popMatrix();
  } 
  public abstract void draw( PApplet app, float drawX, float drawY, float currAlphaPerc); 
  public static class HDrawableIterator implements HIterator<HDrawable> { 
    private HDrawable parent, d1, d2; 
    public HDrawableIterator(HDrawable parentDrawable) { 
      parent = parentDrawable; 
      d1 = parent._firstChild; 
      if (d1 != null) d2 = d1._next;
    } 
    public boolean hasNext() { 
      return (d1 != null);
    } 
    public HDrawable next() { 
      HDrawable nxt = d1; 
      d1 = d2; 
      if (d2 != null) d2 = d2._next; 
      return nxt;
    } 
    public void remove() { 
      if (d1 != null) d1.popOut();
    }
  }
} 
public static class HEllipse extends HDrawable { 
  protected int _mode; 
  protected float _startRad, _endRad; 
  public HEllipse() { 
    _mode = PConstants.PIE;
  } 
  public HEllipse(float ellipseRadius) { 
    this(); 
    radius(ellipseRadius);
  } 
  public HEllipse(float radiusX, float radiusY) { 
    radius(radiusX, radiusY);
  } 
  public HEllipse createCopy() { 
    HEllipse copy = new HEllipse(); 
    copy.copyPropertiesFrom(this); 
    return copy;
  } 
  public HEllipse radius(float r) { 
    size(r*2); 
    return this;
  } 
  public HEllipse radius(float radiusX, float radiusY) { 
    size(radiusX*2, radiusY*2); 
    return this;
  } 
  public HEllipse radiusX(float radiusX) { 
    width(radiusX * 2); 
    return this;
  } 
  public float radiusX() { 
    return _width/2;
  } 
  public HEllipse radiusY(float radiusY) { 
    height(radiusY * 2); 
    return this;
  } 
  public float radiusY() { 
    return _height/2;
  } 
  public boolean isCircle() { 
    return _width == _height;
  } 
  public HEllipse mode(int t) { 
    _mode = t; 
    return this;
  } 
  public float mode() { 
    return _mode;
  } 
  public HEllipse start(float deg) { 
    return startRad(deg * H.D2R);
  } 
  public float start() { 
    return _startRad * H.R2D;
  } 
  public HEllipse startRad(float rad) { 
    _startRad = rad; 
    return this;
  } 
  public float startRad() { 
    return _startRad;
  } 
  public HEllipse end(float deg) { 
    return endRad(deg * H.D2R);
  } 
  public float end() { 
    return _endRad * H.R2D;
  } 
  public HEllipse endRad(float rad) { 
    _endRad = rad; 
    return this;
  } 
  public float endRad() { 
    return _endRad;
  } 
  public boolean containsRel(float relX, float relY) { 
    float cx = _width/2; 
    float cy = _height/2; 
    float dcx = relX - cx; 
    float dcy = relY - cy; 
    boolean b = ((dcx*dcx)/(cx*cx) + (dcy*dcy)/(cy*cy) <= 1); 
    if (_startRad == _endRad) { 
      return b;
    } 
    float f = H.app().atan2(dcy, dcx); 
    switch(_mode) { 
    case PConstants.CHORD: 
    case PConstants.OPEN: 
      return b; 
    default: 
      return b && _startRad <= f && f <= _endRad;
    }
  } 
  public void draw(PApplet app, float drawX, float drawY, float currAlphaPerc) { 
    applyStyle(app, currAlphaPerc); 
    drawX += _width/2; 
    drawY += _height/2; 
    if (_startRad == _endRad) { 
      app.ellipse(drawX, drawY, _width, _height);
    } else { 
      app.arc(drawX, drawY, _width, _height, _startRad, _endRad, _mode);
    }
  }
} 
public static class HGroup extends HDrawable { 
  public HGroup createCopy() { 
    HGroup copy = new HGroup(); 
    copy.copyPropertiesFrom(this); 
    return copy;
  } 
  public void paintAll(PApplet app, float currAlphaPerc) { 
    if (_alpha<=0 || _width<=0 || _height<=0) return; 
    app.pushMatrix(); 
    app.translate(_x, _y); 
    app.rotate(_rotationRad); 
    currAlphaPerc *= _alpha; 
    HDrawable child = _firstChild; 
    while (child != null) { 
      child.paintAll(app, currAlphaPerc); 
      child = child.next();
    } 
    app.popMatrix();
  } 
  public void draw(PApplet app, float drawX, float drawY, float currAlphaPerc) {
  }
} 
public static class HImage extends HDrawable { 
  protected PImage _image; 
  public HImage() { 
    this(null);
  } 
  public HImage(Object imgArg) { 
    image(imgArg);
  } 
  public HImage createCopy() { 
    HImage copy = new HImage(_image); 
    copy.copyPropertiesFrom(this); 
    return copy;
  } 
  public HImage resetSize() { 
    if (_image == null) size(0f, 0f); 
    else size(_image.width, _image.height); 
    return this;
  } 
  public HImage image(Object imgArg) { 
    if (imgArg instanceof PImage) { 
      _image = (PImage) imgArg;
    } else if (imgArg instanceof String) { 
      _image = H.app().loadImage((String) imgArg);
    } else if (imgArg instanceof HImage) { 
      _image = ((HImage) imgArg)._image;
    } else if (imgArg == null) { 
      _image = null;
    } 
    return resetSize();
  } 
  public PImage image() { 
    return _image;
  } 
  public HImage tint(int clr) { 
    fill(clr); 
    return this;
  } 
  public HImage tint(int clr, int alpha) { 
    fill(clr, alpha); 
    return this;
  } 
  public HImage tint(int r, int g, int b) { 
    fill(r, g, b); 
    return this;
  } 
  public HImage tint(int r, int g, int b, int a) { 
    fill(r, g, b, a); 
    return this;
  } 
  public int tint() { 
    return fill();
  } 
  public boolean containsRel(float relX, float relY) { 
    if (_image == null || _image.width <= 0 || _image.height <= 0 || _width <= 0 || _height <= 0) return false; 
    int ix = H.app().round(relX * _image.width/_width); 
    int iy = H.app().round(relY * _image.height/_height); 
    return (0 < _image.get(ix, iy)>>>24);
  } 
  public void draw(PApplet app, float drawX, float drawY, float currAlphaPerc) { 
    if (_image==null) return; 
    currAlphaPerc *= (_fill>>>24); 
    app.tint( _fill | 0xFF000000, app.round(currAlphaPerc) ); 
    app.image(_image, drawX, drawY, _width, _height);
  }
} 
public static class HPath extends HDrawable { 
  protected ArrayList<HVertex> _vertices; 
  protected int _mode; 
  public HPath() { 
    this(PConstants.PATH);
  } 
  public HPath(int pathMode) { 
    _vertices = new ArrayList<HPath.HVertex>(); 
    _mode = pathMode;
  } 
  public HPath createCopy() { 
    HPath copy = new HPath(); 
    copy.copyPropertiesFrom(this); 
    for (int i=0; i<_vertices.size (); ++i) { 
      HVertex v = _vertices.get(i); 
      copy.vertexPerc(v.x, v.y, v.hx1, v.hy1, v.hx2, v.hy2);
    } 
    return copy;
  } 
  public HPath mode(int m) { 
    _mode = m; 
    return this;
  } 
  public int mode() { 
    return _mode;
  } 
  public HVertex vertex(int index) { 
    return _vertices.get(index);
  } 
  public HPath removeVertex(int index) { 
    _vertices.remove(index); 
    return this;
  } 
  public int numVertices() { 
    return _vertices.size();
  } 
  public HPath adjustVertices() { 
    int numVertices = _vertices.size(); 
    float minX, maxX, minY, maxY; 
    minX = maxX = minY = maxY = 0; 
    for (int i=0; i<numVertices; ++i) { 
      HVertex v = _vertices.get(i); 
      if (v.x < minX) minX = v.x; 
      else if (v.x > maxX) maxX = v.x; 
      if (v.y < minY) minY = v.y; 
      else if (v.y > maxY) maxY = v.y;
    } 
    float ratioX = maxX - minX; 
    float ratioY = maxY - minY; 
    scale(ratioX, ratioY); 
    anchorPercX((ratioX==0)? 0 : -minX/ratioX); 
    anchorPercY((ratioY==0)? 0 : -minY/ratioY); 
    for (int j=0; j<numVertices; ++j) { 
      HVertex w = _vertices.get(j); 
      w.x -= minX; 
      w.hx1 -= minX; 
      w.hx2 -= minX; 
      if (ratioX != 0) { 
        w.x /= ratioX; 
        w.hx1 /= ratioX; 
        w.hx2 /= ratioX;
      } 
      w.y -= minY; 
      w.hy1 -= minY; 
      w.hy2 -= minY; 
      if (ratioY != 0) { 
        w.y /= ratioY; 
        w.hy1 /= ratioY; 
        w.hy2 /= ratioY;
      }
    } 
    return this;
  } 
  public HPath vertex(float pxX, float pxY) { 
    if (_height == 0 || _width == 0) { 
      HWarnings.warn("Division by 0", "HPath.vertex()", HWarnings.VERTEXPX_ERR);
    } else { 
      vertexPerc(pxX/_width, pxY/_height);
    } 
    return this;
  } 
  public HPath vertex( float handlePxX1, float handlePxY1, float handlePxX2, float handlePxY2, float pxX, float pxY ) { 
    if (_height == 0 || _width == 0) { 
      HWarnings.warn("Division by 0", "HPath.vertex()", HWarnings.VERTEXPX_ERR);
    } else { 
      vertexPerc( handlePxX1/_width, handlePxY1/_height, handlePxX2/_width, handlePxY2/_height, pxX/_width, pxY/_height);
    } 
    return this;
  } 
  public HPath vertexPerc(float percX, float percY) { 
    HVertex v = new HVertex(); 
    v.x = v.hx1 = v.hx2 = percX; 
    v.y = v.hy1 = v.hy2 = percY; 
    _vertices.add(v); 
    return this;
  } 
  public HPath vertexPerc( float handlePercX1, float handlePercY1, float handlePercX2, float handlePercY2, float percX, float percY ) { 
    HVertex v = new HVertex(); 
    v.isBezier = true; 
    v.x = percX; 
    v.y = percY; 
    v.hx1 = handlePercX1; 
    v.hy1 = handlePercY1; 
    v.hx2 = handlePercX2; 
    v.hy2 = handlePercY2; 
    _vertices.add(v); 
    return this;
  } 
  public HPath polygon(int numEdges) { 
    _vertices.clear(); 
    PApplet app = H.app(); 
    float radInc = PConstants.TWO_PI / numEdges; 
    for (int i=0; i<numEdges; ++i) { 
      float rad = radInc * i; 
      vertexPerc( 0.5f + 0.5f*app.cos(rad), 0.5f + 0.5f*app.sin(rad));
    } 
    _mode = PConstants.POLYGON; 
    return this;
  } 
  public HPath star(int numEdges, float depth) { 
    _vertices.clear(); 
    PApplet app = H.app(); 
    float radInc = PConstants.TWO_PI / numEdges; 
    for (int i=0; i<numEdges; ++i) { 
      float rad = radInc * i; 
      vertexPerc( 0.5f + 0.5f*app.cos(rad), 0.5f + 0.5f*app.sin(rad)); 
      rad = radInc * (i + 0.5f); 
      vertexPerc( 0.5f + 0.5f*app.cos(rad)*(1-depth), 0.5f + 0.5f*app.sin(rad)*(1-depth));
    } 
    _mode = PConstants.POLYGON; 
    return this;
  } 
  public HPath clear() { 
    _vertices.clear(); 
    return this;
  } 
  public boolean containsRel(float relX, float relY) { 
    boolean isIn = false; 
    float xPerc = relX / _width; 
    float yPerc = relY / _height; 
    for (int i=0; i<numVertices (); ++i) { 
      HVertex v1 = _vertices.get(i); 
      HVertex v2 = _vertices.get((i>=numVertices()-1)? 0 : i+1); 
      if ((v1.y<yPerc && yPerc<=v2.y) || (v2.y<yPerc && yPerc<=v1.y)) { 
        float t = (yPerc-v1.y) / (v2.y - v1.y); 
        float currX = v1.x + (v2.x-v1.x)*t; 
        if (currX == xPerc) return true; 
        if (currX < xPerc) isIn = !isIn;
      }
    } 
    return isIn;
  } 
  public void draw(PApplet app, float drawX, float drawY, float currAlphaPerc) { 
    int numVertices = _vertices.size(); 
    if (numVertices <= 0) return; 
    applyStyle(app, currAlphaPerc); 
    if (_mode == PConstants.POINTS) app.beginShape(PConstants.POINTS); 
    else app.beginShape(); 
    boolean startFlag = true; 
    for (int i=0; i<numVertices; ++i) { 
      HVertex v = _vertices.get(i); 
      float x = drawX + _width*v.x; 
      float y = drawY + _height*v.y; 
      if (!v.isBezier || _mode == PConstants.POINTS || startFlag) { 
        app.vertex(x, y);
      } else { 
        float hx1 = drawX + _width * v.hx1; 
        float hy1 = drawY + _height* v.hy1; 
        float hx2 = drawX + _width * v.hx2; 
        float hy2 = drawY + _height* v.hy2; 
        app.bezierVertex(hx1, hy1, hx2, hy2, x, y);
      } 
      if (startFlag) startFlag = false; 
      else if (i==0) break; 
      if (_mode==PConstants.POLYGON && i>=numVertices-1) i = -1;
    } 
    if (_mode == PConstants.POLYGON) app.endShape(PConstants.CLOSE); 
    else app.endShape();
  } 
  public static class HVertex { 
    public float x, y, hx1, hy1, hx2, hy2; 
    public boolean isBezier;
  }
} 
public static class HRect extends HDrawable { 
  public float _tl, _tr, _bl, _br; 
  public HRect() {
  } 
  public HRect(float s) { 
    size(s);
  } 
  public HRect(float w, float h) { 
    size(w, h);
  } 
  public HRect(float w, float h, float roundingRadius) { 
    size(w, h); 
    rounding(roundingRadius);
  } 
  public HRect createCopy() { 
    HRect copy = new HRect(); 
    copy._tl = _tl; 
    copy._tr = _tr; 
    copy._bl = _bl; 
    copy._br = _br; 
    copy.copyPropertiesFrom(this); 
    return copy;
  } 
  public HRect rounding(float radius) { 
    _tl = _tr = _bl = _br = radius; 
    return this;
  } 
  public HRect rounding( float topleft, float topright, float bottomright, float bottomleft ) { 
    _tl = topleft; 
    _tr = topright; 
    _br = bottomright; 
    _bl = bottomleft; 
    return this;
  } 
  public HRect roundingTL(float radius) { 
    _tl = radius; 
    return this;
  } 
  public float roundingTL() { 
    return _tl;
  } 
  public HRect roundingTR(float radius) { 
    _tr = radius; 
    return this;
  } 
  public float roundingTR() { 
    return _tr;
  } 
  public HRect roundingBR(float radius) { 
    _br = radius; 
    return this;
  } 
  public float roundingBR() { 
    return _br;
  } 
  public HRect roundingBL(float radius) { 
    _bl = radius; 
    return this;
  } 
  public float roundingBL() { 
    return _bl;
  } 
  public void draw(PApplet app, float drawX, float drawY, float currAlphaPerc) { 
    applyStyle(app, currAlphaPerc); 
    app.rect(drawX, drawY, _width, _height, _tl, _tr, _br, _bl);
  }
} 
public static class HShape extends HDrawable { 
  protected PShape _shape; 
  protected HColorPool _randomColors; 
  public HShape() { 
    shape(null);
  } 
  public HShape(Object shapeArg) { 
    shape(shapeArg);
  } 
  public HShape createCopy() { 
    HShape copy = new HShape(_shape); 
    copy.copyPropertiesFrom(this); 
    return copy;
  } 
  public HShape resetSize() { 
    if (_shape == null) { 
      size(0, 0);
    } else { 
      size(_shape.width, _shape.height);
    } 
    return this;
  } 
  public HShape shape(Object shapeArg) { 
    if (shapeArg instanceof PShape) { 
      _shape = (PShape) shapeArg;
    } else if (shapeArg instanceof String) { 
      _shape = H.app().loadShape((String) shapeArg);
    } else if (shapeArg instanceof HShape) { 
      _shape = ((HShape) shapeArg)._shape;
    } else if (shapeArg == null) { 
      _shape = null;
    } 
    return resetSize();
  } 
  public PShape shape() { 
    return _shape;
  } 
  public HShape enableStyle(boolean b) { 
    if (b) _shape.enableStyle(); 
    else _shape.disableStyle(); 
    return this;
  } 
  public HColorPool randomColors(HColorPool colorPool) { 
    return randomColors(colorPool, true);
  } 
  public HColorPool randomColors(HColorPool colorPool, boolean isCopy) { 
    if (isCopy) colorPool = colorPool.createCopy(); 
    _shape.disableStyle(); 
    _randomColors = colorPool; 
    return _randomColors;
  } 
  public HColorPool randomColors() { 
    return _randomColors;
  } 
  public HShape resetRandomColors() { 
    _shape.enableStyle(); 
    _randomColors = null; 
    return this;
  } 
  public void draw(PApplet app, float drawX, float drawY, float currAlphaPerc) { 
    if (_shape == null) return; 
    applyStyle(app, currAlphaPerc); 
    if (_randomColors == null) { 
      app.shape(_shape, drawX, drawY, _width, _height);
    } else for (int i=0; i<_shape.getChildCount (); ++i) { 
      PShape childShape = _shape.getChild(i); 
      childShape.width = _shape.width; 
      childShape.height = _shape.height; 
      if (_randomColors.appliesFill()) app.fill(_randomColors.getColor()); 
      if (_randomColors.appliesStroke()) app.stroke(_randomColors.getColor()); 
      app.shape(childShape, drawX, drawY, _width, _height);
    }
  }
} 
public static class HStage extends HDrawable { 
  protected PApplet _app; 
  protected PImage _bgImg; 
  protected boolean _autoClearFlag; 
  public HStage(PApplet papplet) { 
    _app = papplet; 
    _autoClearFlag = true; 
    background(HConstants.DEFAULT_BACKGROUND_COLOR);
  } 
  public void background(int clr) { 
    _fill = clr; 
    clear();
  } 
  public void backgroundImg(Object arg) { 
    if (arg instanceof String) { 
      _bgImg = _app.loadImage((String) arg);
    } else if (arg instanceof PImage) { 
      _bgImg = (PImage) arg;
    } 
    clear();
  } 
  public HStage autoClear(boolean b) { 
    _autoClearFlag = b; 
    return this;
  } 
  public boolean autoClear() { 
    return _autoClearFlag;
  } 
  public HStage clear() { 
    if (_bgImg == null) _app.background(_fill); 
    else _app.background(_bgImg); 
    return this;
  } 
  public HDrawable fill(int clr) { 
    background(clr); 
    return this;
  } 
  public HDrawable fill(int clr, int alpha) { 
    return fill(clr);
  } 
  public HDrawable fill(int r, int g, int b) { 
    return fill(HColorUtil.merge(255, r, g, b));
  } 
  public HDrawable fill(int r, int g, int b, int a) { 
    return fill(r, g, b);
  } 
  public PVector size() { 
    return new PVector(_app.width, _app.height);
  } 
  public float width() { 
    return _app.width;
  } 
  public float height() { 
    return _app.height;
  } 
  public void paintAll(PApplet app, float currAlphaPerc) { 
    app.pushStyle(); 
    if (_autoClearFlag) clear(); 
    HDrawable child = _firstChild; 
    while (child != null) { 
      child.paintAll(app, 1); 
      child = child.next();
    } 
    app.popStyle();
  } 
  public void draw(PApplet app, float drawX, float drawY, float currAlphaPerc) {
  } 
  public void copyPropertiesFrom(HDrawable other) {
  } 
  public HDrawable createCopy() { 
    return null;
  } 
  public HDrawable loc(float newX, float newY) { 
    return this;
  } 
  public HDrawable x(float newX) { 
    return this;
  } 
  public HDrawable y(float newY) { 
    return this;
  } 
  public HDrawable move(float dx, float dy) { 
    return this;
  } 
  public HDrawable locAt(int where) { 
    return this;
  } 
  public HDrawable rotation(float deg) { 
    return this;
  } 
  public HDrawable rotationRad(float rad) { 
    return this;
  } 
  public HDrawable rotate(float deg) { 
    return this;
  } 
  public HDrawable rotateRad(float rad) { 
    return this;
  }
} 
public static class HText extends HDrawable { 
  protected PFont _font; 
  protected String _text; 
  protected float _descent; 
  public HText() { 
    this(null, 16);
  } 
  public HText(String textString) { 
    this(textString, 16, null);
  } 
  public HText(String textString, float size) { 
    this(textString, size, null);
  } 
  public HText(String textString, float size, Object fontArg) { 
    _text = textString; 
    _height = size; 
    font(fontArg); 
    height(size);
  } 
  public HText createCopy() { 
    HText copy = new HText(_text, _height, _font); 
    copy.copyPropertiesFrom(this); 
    copy.adjustMetrics(); 
    return copy;
  } 
  public HText text(String txt) { 
    _text = txt; 
    adjustMetrics(); 
    return this;
  } 
  public String text() { 
    return _text;
  } 
  public HText font(Object arg) { 
    PApplet app = H.app(); 
    if (arg instanceof PFont) { 
      _font = (PFont) arg;
    } else if (arg instanceof String) { 
      String str = (String) arg; 
      _font = (str.indexOf(".vlw", str.length()-4) > 0)? app.loadFont(str) : app.createFont(str, _height);
    } else if (arg instanceof HText) { 
      _font = ((HText) arg)._font;
    } else if (arg == null) { 
      _font = app.createFont("SansSerif", _height);
    } 
    adjustMetrics(); 
    return this;
  } 
  public PFont font() { 
    return _font;
  } 
  public HText fontSize(float f) { 
    return height(f);
  } 
  public float fontSize() { 
    return _height;
  } 
  protected void adjustMetrics() { 
    PApplet app = H.app(); 
    app.pushStyle(); 
    app.textFont(_font, _height); 
    _descent = app.textDescent(); 
    super.width( (_text==null)? 0 : app.textWidth(_text) ); 
    app.popStyle();
  } 
  public HText width(float w) { 
    return this;
  } 
  public HText height(float h) { 
    super.height(h); 
    adjustMetrics(); 
    return this;
  } 
  public HText size(float w, float h) { 
    return height(h);
  } 
  public HText size(float s) { 
    return height(s);
  } 
  public HText scale(float s) { 
    super.scale(s); 
    adjustMetrics(); 
    return this;
  } 
  public HText scale(float sw, float sh) { 
    return scale(sh);
  } 
  public boolean containsRel(float relX, float relY) { 
    if (_text == null || _height == 0) return false; 
    PApplet app = H.app(); 
    int numChars = _text.length(); 
    float ratio = _font.getSize() / _height; 
    float xoff = 0; 
    float yoff = (_height - _descent) * ratio; 
    relX *= ratio; 
    relY *= ratio; 
    for (int i=0; i<numChars; ++i) { 
      char c = _text.charAt(i); 
      PFont.Glyph g = _font.getGlyph(c); 
      int pxx = app.round(relX - xoff); 
      int pxy = app.round(relY - yoff) + g.topExtent; 
      if (g.image.get(pxx, pxy)>>>24 > 0) return true; 
      xoff += g.setWidth;
    } 
    return false;
  } 
  public void draw(PApplet app, float drawX, float drawY, float currAlphaPerc) { 
    if (_text == null) return; 
    applyStyle(app, currAlphaPerc); 
    app.textFont(_font, _height); 
    app.text(_text, drawX, drawY+_height-_descent);
  }
} 
public static class HTriangle extends HDrawable { 
  protected int _type; 
  public HTriangle() {
  } 
  public HTriangle(int triangleType) { 
    type(triangleType);
  } 
  public HTriangle createCopy() { 
    HTriangle copy = new HTriangle(); 
    copy.copyPropertiesFrom(this); 
    copy._type = _type; 
    return copy;
  } 
  public HTriangle type(int triangleType) { 
    _type = triangleType; 
    return this;
  } 
  public int type() { 
    return _type;
  } 
  public HTriangle width(float w) { 
    if (_type == H.EQUILATERAL) { 
      super.height(w * H.app().sin(PConstants.TWO_PI/6));
    } 
    return (HTriangle) super.width(w);
  } 
  public HTriangle height(float h) { 
    if (_type == H.EQUILATERAL) { 
      super.width(h / H.app().sin(PConstants.TWO_PI/6));
    } 
    return (HTriangle) super.height(h);
  } 
  public boolean containsRel(float relX, float relY) { 
    if (_width <= 0 || _height <= 0) return false; 
    float xRatio = relX / _width; 
    if (xRatio < 0 || xRatio > 1) return false; 
    float yRatio = relY / _height; 
    if (yRatio < 0 || yRatio > 1) return false; 
    if (_type == HConstants.RIGHT) { 
      return (xRatio/yRatio > 1);
    } else { 
      float cx = _width/2; 
      float x1 = (1-yRatio) * cx; 
      float x2 = yRatio*cx + cx; 
      return (x1 <= relX) && (relX <= x2) && (0 <= relY) && (relY <= _height);
    }
  } 
  public void draw(PApplet app, float drawX, float drawY, float currAlphaPerc) { 
    applyStyle(app, currAlphaPerc); 
    float x1; 
    float y1; 
    float x2; 
    float y2; 
    float x3; 
    float y3; 
    if (_type == H.RIGHT) { 
      x1 = drawX; 
      y1 = drawY; 
      x2 = drawX + _width; 
      y2 = drawY; 
      x3 = drawX + _width; 
      y3 = drawY + _height;
    } else { 
      x1 = drawX; 
      y1 = drawY + _height; 
      x2 = drawX + _width/2; 
      y2 = drawY; 
      x3 = drawX + _width; 
      y3 = drawY + _height;
    } 
    app.triangle(x1, y1, x2, y2, x3, y3);
  }
} 
public static class HMouse implements HFollowable { 
  private PApplet _app; 
  private boolean _started; 
  public HMouse(PApplet app) { 
    _app = app;
  } 
  public boolean started() { 
    return _started;
  } 
  public void handleEvents() { 
    if (!_started && _app.pmouseX+_app.pmouseY > 0) _started = true;
  } 
  public float followableX() { 
    return _app.mouseX;
  } 
  public float followableY() { 
    return _app.mouseY;
  }
} 
public static interface HCallback { 
  public void run(Object obj);
} 
public static interface HFollowable { 
  public float followableX(); 
  public float followableY();
} 
public static interface HHittable { 
  public boolean contains(float absX, float absY); 
  public boolean containsRel(float relX, float relY);
} 
public static interface HMovable { 
  public float x(); 
  public float y(); 
  public HMovable move(float dx, float dy);
} 
public static class HPoolAdapter implements HPoolListener { 
  public void onCreate(HDrawable d, int index, HDrawablePool pool) {
  } 
  public void onRequest(HDrawable d, int index, HDrawablePool pool) {
  } 
  public void onRelease(HDrawable d, int index, HDrawablePool pool) {
  }
} 
public static interface HPoolListener { 
  public void onCreate(HDrawable d, int index, HDrawablePool pool); 
  public void onRequest(HDrawable d, int index, HDrawablePool pool); 
  public void onRelease(HDrawable d, int index, HDrawablePool pool);
} 
public static interface HRotatable { 
  public float rotationRad(); 
  public HRotatable rotationRad(float rad);
} 
public static interface HSwarmer extends HMovable, HRotatable {
} 
public static class HGridLayout implements HLayout { 
  protected int _currentIndex, _numCols; 
  protected float _startX, _startY, _xSpace, _ySpace; 
  public HGridLayout() { 
    _xSpace = _ySpace = _numCols = 16;
  } 
  public HGridLayout(int numOfColumns) { 
    this(); 
    _numCols = numOfColumns;
  } 
  public HGridLayout currentIndex(int i) { 
    _currentIndex = i; 
    return this;
  } 
  public int currentIndex() { 
    return _currentIndex;
  } 
  public HGridLayout resetIndex() { 
    _currentIndex = 0; 
    return this;
  } 
  public HGridLayout cols(int numOfColumns) { 
    _numCols = numOfColumns; 
    return this;
  } 
  public int cols() { 
    return _numCols;
  } 
  public PVector startLoc() { 
    return new PVector(_startX, _startY);
  } 
  public HGridLayout startLoc(float x, float y) { 
    _startX = x; 
    _startY = y; 
    return this;
  } 
  public float startX() { 
    return _startX;
  } 
  public HGridLayout startX(float x) { 
    _startX = x; 
    return this;
  } 
  public float startY() { 
    return _startY;
  } 
  public HGridLayout startY(float y) { 
    _startY = y; 
    return this;
  } 
  public PVector spacing() { 
    return new PVector(_xSpace, _ySpace);
  } 
  public HGridLayout spacing(float xSpacing, float ySpacing) { 
    _xSpace = xSpacing; 
    _ySpace = ySpacing; 
    return this;
  } 
  public float spacingX() { 
    return _xSpace;
  } 
  public HGridLayout spacingX(float xSpacing) { 
    _xSpace = xSpacing; 
    return this;
  } 
  public float spacingY() { 
    return _ySpace;
  } 
  public HGridLayout spacingY(float ySpacing) { 
    _ySpace = ySpacing; 
    return this;
  } 
  public PVector getNextPoint() { 
    int currentRow = H.app().floor(_currentIndex / _numCols); 
    int currentCol = _currentIndex % _numCols; 
    ++_currentIndex; 
    return new PVector( currentCol*_xSpace + _startX, currentRow*_ySpace + _startY );
  } 
  public void applyTo(HDrawable target) { 
    target.loc(getNextPoint());
  }
} 
public static interface HLayout { 
  public void applyTo(HDrawable target); 
  public abstract PVector getNextPoint();
} 
public static class HRandomTrigger extends HTrigger { 
  public float _chance; 
  public HRandomTrigger() {
  } 
  public HRandomTrigger(float percChance) { 
    _chance = percChance;
  } 
  public HRandomTrigger chance(float perc) { 
    _chance = perc; 
    return this;
  } 
  public float chance() { 
    return _chance;
  } 
  public void runBehavior(PApplet app) { 
    if (app.random(1) <= _chance) { 
      if (_callback != null) _callback.run(null);
    }
  } 
  public HRandomTrigger callback(HCallback cb) { 
    return (HRandomTrigger) super.callback(cb);
  }
} 
public static class HTimer extends HTrigger { 
  protected int _lastInterval, _interval, _cycleCounter, _numCycles; 
  protected boolean _usesFrames; 
  public HTimer() { 
    _interval = 1000; 
    _lastInterval = -1;
  } 
  public HTimer(int timerInterval) { 
    _interval = timerInterval;
  } 
  public HTimer(int timerInterval, int numberOfCycles) { 
    _interval = timerInterval; 
    _numCycles = numberOfCycles;
  } 
  public HTimer interval(int i) { 
    _interval = i; 
    return this;
  } 
  public int interval() { 
    return _interval;
  } 
  public HTimer cycleCounter(int cycleIndex) { 
    _cycleCounter = cycleIndex; 
    return this;
  } 
  public int cycleCounter() { 
    return _cycleCounter;
  } 
  public HTimer numCycles(int cycles) { 
    _numCycles = cycles; 
    return this;
  } 
  public int numCycles() { 
    return _numCycles;
  } 
  public HTimer cycleIndefinitely() { 
    _numCycles = 0; 
    return this;
  } 
  public HTimer useMillis() { 
    _usesFrames = false; 
    return this;
  } 
  public boolean usesMillis() { 
    return !_usesFrames;
  } 
  public HTimer useFrames() { 
    _usesFrames = true; 
    return this;
  } 
  public boolean usesFrames() { 
    return _usesFrames;
  } 
  public void runBehavior(PApplet app) { 
    int curr = (_usesFrames)? app.frameCount : app.millis(); 
    if (_lastInterval < 0) _lastInterval = curr; 
    if (curr-_lastInterval >= _interval) { 
      _lastInterval = curr; 
      if (_callback != null) _callback.run(_cycleCounter); 
      if (_numCycles > 0 && ++_cycleCounter >= _numCycles) unregister();
    }
  } 
  public HTimer callback(HCallback cb) { 
    return (HTimer) super.callback(cb);
  } 
  public HTimer register() { 
    return (HTimer) super.register();
  } 
  public HTimer unregister() { 
    _numCycles = 0; 
    _lastInterval = -1; 
    return (HTimer) super.unregister();
  }
} 
public static abstract class HTrigger extends HBehavior { 
  public HCallback _callback; 
  public HTrigger callback(HCallback cb) { 
    if (cb == null) unregister(); 
    else register(); 
    _callback = cb; 
    return this;
  } 
  public HCallback callback() { 
    return _callback;
  }
} 
public static class H implements HConstants { 
  private static H _self; 
  private static PApplet _app; 
  private static HStage _stage; 
  private static HBehaviorRegistry _behaviors; 
  private static HMouse _mouse; 
  public static H init(PApplet applet) { 
    _app = applet; 
    HMath.init(_app); 
    if (_self == null) _self = new H(); 
    if (_stage == null) _stage = new HStage(_app); 
    if (_behaviors == null) _behaviors = new HBehaviorRegistry(); 
    if (_mouse == null) _mouse = new HMouse(_app); 
    return _self;
  } 
  public static HStage stage() { 
    return _stage;
  } 
  public static PApplet app() { 
    return _app;
  } 
  public static HBehaviorRegistry behaviors() { 
    return _behaviors;
  } 
  public static HMouse mouse() { 
    return _mouse;
  } 
  public static H background(int clr) { 
    _stage.background(clr); 
    return _self;
  } 
  public static H backgroundImg(Object arg) { 
    _stage.backgroundImg(arg); 
    return _self;
  } 
  public static H autoClear(boolean b) { 
    _stage.autoClear(b); 
    return _self;
  } 
  public static boolean autoClear() { 
    return _stage.autoClear();
  } 
  public static H clearStage() { 
    _stage.clear(); 
    return _self;
  } 
  public static HDrawable add(HDrawable stageChild) { 
    return _stage.add(stageChild);
  } 
  public static HDrawable remove(HDrawable stageChild) { 
    return _stage.remove(stageChild);
  } 
  public static H drawStage() { 
    _behaviors.runAll(_app); 
    _mouse.handleEvents(); 
    _stage.paintAll(_app, 0); 
    return _self;
  } 
  public static boolean mouseStarted() { 
    return _mouse.started();
  } 
  private H() {
  }
} 
public static class HBundle { 
  private HashMap<String, Object> objectContents; 
  private HashMap<String, Float> numberContents; 
  public HBundle() { 
    objectContents = new HashMap<String, Object>(); 
    numberContents = new HashMap<String, Float>();
  } 
  public HBundle obj(String key, Object value) { 
    objectContents.put(key, value); 
    return this;
  } 
  public HBundle num(String key, float value) { 
    numberContents.put(key, value); 
    return this;
  } 
  public Object obj(String key) { 
    return objectContents.get(key);
  } 
  public float num(String key) { 
    return numberContents.get(key);
  } 
  public int numI(String key) { 
    return H.app().round(numberContents.get(key));
  } 
  public boolean numB(String key) { 
    return (numberContents.get(key) != 0);
  }
} 
public static class HColorUtil { 
  public static int[] explode(int clr) { 
    int[] explodedColors = new int[4]; 
    for (int i=0; i<4; ++i) explodedColors[3-i] = (clr >>> (i*8)) & 0xFF; 
    return explodedColors;
  } 
  public static int merge(int a, int r, int g, int b) { 
    PApplet app = H.app(); 
    a = app.constrain(a, 0, 0xFF); 
    r = app.constrain(r, 0, 0xFF); 
    g = app.constrain(g, 0, 0xFF); 
    b = app.constrain(b, 0, 0xFF); 
    return (a<<24) | (r<<16) | (g<<8) | b;
  } 
  public static int setAlpha(int clr, int newAlpha) { 
    newAlpha = H.app().constrain(newAlpha, 0, 0xFF); 
    return clr & 0x00FFFFFF | (newAlpha << 24);
  } 
  public static int setRed(int clr, int newRed) { 
    newRed = H.app().constrain(newRed, 0, 0xFF); 
    return clr & 0xFF00FFFF | (newRed << 16);
  } 
  public static int setGreen(int clr, int newGreen) { 
    newGreen = H.app().constrain(newGreen, 0, 0xFF); 
    return clr & 0xFFFF00FF | (newGreen << 8);
  } 
  public static int setBlue(int clr, int newBlue) { 
    newBlue = H.app().constrain(newBlue, 0, 0xFF); 
    return clr & 0xFFFFFF00 | newBlue;
  } 
  public static int getAlpha(int clr) { 
    return clr >>> 24;
  } 
  public static int getRed(int clr) { 
    return (clr >>> 16) & 255;
  } 
  public static int getGreen(int clr) { 
    return (clr >>> 8) & 255;
  } 
  public static int getBlue(int clr) { 
    return clr & 255;
  } 
  public static int multiply(int c1, int c2) { 
    return H.app().round(c1 * c2 / 255f);
  } 
  public static int multiplyAlpha(int clr, int a) { 
    return clr & 0x00FFFFFF | ( multiply(getAlpha(clr), a) << 24 );
  } 
  public static int multiplyRed(int clr, int r) { 
    return clr & 0xFF00FFFF | ( multiply(getRed(clr), r) << 16 );
  } 
  public static int multiplyGreen(int clr, int g) { 
    return clr & 0xFFFF00FF | ( multiply(getGreen(clr), g) << 8 );
  } 
  public static int multiplyBlue(int clr, int b) { 
    return clr & 0xFFFFFF00 | multiply(getBlue(clr), b);
  }
} 
public static interface HConstants { 
  public static final int NONE = 0, LEFT = 1, RIGHT = 2, CENTER_X = 3, TOP = 4, BOTTOM = 8, CENTER_Y = 12, CENTER = 15, TOP_LEFT = 5, TOP_RIGHT = 6, BOTTOM_LEFT = 9, BOTTOM_RIGHT = 10, CENTER_LEFT = 13, CENTER_RIGHT = 14, CENTER_TOP = 7, CENTER_BOTTOM = 11, DEFAULT_BACKGROUND_COLOR = 0xFFECF2F5, DEFAULT_FILL = 0xFFFFFFFF, DEFAULT_STROKE = 0xFF000000, DEFAULT_WIDTH = 64, DEFAULT_HEIGHT = 64, CLEAR = 0x00FFFFFF, WHITE = 0xFFFFFFFF, LGREY = 0xFFC0C0C0, GREY = 0xFF808080, DGREY = 0xFF404040, BLACK = 0xFF000000, RED = 0xFFFF0000, GREEN = 0xFF00FF00, BLUE = 0xFF0000FF, CYAN = 0xFF00FFFF, MAGENTA = 0xFFFF00FF, YELLOW = 0xFFFFFF00, SAW = 0, SINE = 1, TRIANGLE = 2, SQUARE = 3, WIDTH = 0, HEIGHT = 1, SIZE = 2, ALPHA = 3, X = 4, Y = 5, LOCATION = 6, ROTATION = 7, DROTATION = 8, DX = 9, DY = 10, DLOC = 11, SCALE = 12, ISOCELES = 0, EQUILATERAL = 1; 
  public static final float D2R = PConstants.PI / 180f, R2D = 180f / PConstants.PI;
} 
public static class HDrawablePool { 
  protected HLinkedHashSet<HDrawable> _activeSet, _inactiveSet; 
  protected ArrayList<HDrawable> _prototypes; 
  public HCallback _onCreate, _onRequest, _onRelease; 
  public HPoolListener _listener; 
  protected HLayout _layout; 
  protected HColorist _colorist; 
  protected HDrawable _autoParent; 
  protected int _max; 
  public HDrawablePool() { 
    this(64);
  } 
  public HDrawablePool(int maximumDrawables) { 
    _max = maximumDrawables; 
    _activeSet = new HLinkedHashSet<HDrawable>(); 
    _inactiveSet = new HLinkedHashSet<HDrawable>(); 
    _prototypes = new ArrayList<HDrawable>();
  } 
  public int max() { 
    return _max;
  } 
  public HDrawablePool max(int m) { 
    _max = m; 
    return this;
  } 
  public int numActive() { 
    return _activeSet.size();
  } 
  public int numInactive() { 
    return _inactiveSet.size();
  } 
  public int currentIndex() { 
    return _activeSet.size() - 1;
  } 
  public HLayout layout() { 
    return _layout;
  } 
  public HDrawablePool layout(HLayout newLayout) { 
    _layout = newLayout; 
    return this;
  } 
  public HColorist colorist() { 
    return _colorist;
  } 
  public HDrawablePool colorist(HColorist newColorist) { 
    _colorist = newColorist; 
    return this;
  } 
  public HDrawablePool listener(HPoolListener newListener) { 
    _listener = newListener; 
    return this;
  } 
  public HDrawablePool onCreate(HCallback callback) { 
    _onCreate = callback; 
    return this;
  } 
  public HCallback onCreate() { 
    return _onCreate;
  } 
  public HPoolListener listener() { 
    return _listener;
  } 
  public HDrawablePool onRequest(HCallback callback) { 
    _onRequest = callback; 
    return this;
  } 
  public HCallback onRequest() { 
    return _onRequest;
  } 
  public HDrawablePool onRelease(HCallback callback) { 
    _onRelease = callback; 
    return this;
  } 
  public HCallback onRelease() { 
    return _onRelease;
  } 
  public HDrawablePool autoParent(HDrawable parent) { 
    _autoParent = parent; 
    return this;
  } 
  public HDrawablePool autoAddToStage() { 
    _autoParent = H.stage(); 
    return this;
  } 
  public HDrawable autoParent() { 
    return _autoParent;
  } 
  public boolean isFull() { 
    return count() >= _max;
  } 
  public int count() { 
    return _activeSet.size() + _inactiveSet.size();
  } 
  public HDrawablePool destroy() { 
    _activeSet.removeAll(); 
    _inactiveSet.removeAll(); 
    _prototypes.clear(); 
    _onCreate = _onRequest = _onRelease = null; 
    _layout = null; 
    _autoParent = null; 
    _max = 0; 
    return this;
  } 
  public HDrawablePool add(HDrawable prototype, int frequency) { 
    if (prototype == null) { 
      HWarnings.warn("Null Prototype", "HDrawablePool.add()", HWarnings.NULL_ARGUMENT);
    } else { 
      _prototypes.add(prototype); 
      while (frequency-- > 0) _prototypes.add(prototype);
    } 
    return this;
  } 
  public HDrawablePool add(HDrawable prototype) { 
    return add(prototype, 1);
  } 
  public HDrawable request() { 
    if (_prototypes.size() <= 0) { 
      HWarnings.warn("No Prototype", "HDrawablePool.request()", HWarnings.NO_PROTOTYPE); 
      return null;
    } 
    HDrawable drawable; 
    boolean onCreateFlag = false; 
    if (_inactiveSet.size() > 0) { 
      drawable = _inactiveSet.pull();
    } else if (count() < _max) { 
      drawable = createRandomDrawable(); 
      onCreateFlag = true;
    } else return null; 
    _activeSet.add(drawable); 
    if (_autoParent != null) _autoParent.add(drawable); 
    if (_layout != null) _layout.applyTo(drawable); 
    if (_colorist != null) _colorist.applyColor(drawable); 
    if (_listener != null) { 
      int index = currentIndex(); 
      if (onCreateFlag) _listener.onCreate(drawable, index, this); 
      _listener.onRequest(drawable, index, this);
    } 
    if (onCreateFlag && _onCreate != null) _onCreate.run(drawable); 
    if (_onRequest != null) _onRequest.run(drawable); 
    return drawable;
  } 
  public HDrawablePool requestAll() { 
    if (_prototypes.size() <= 0) { 
      HWarnings.warn("No Prototype", "HDrawablePool.requestAll()", HWarnings.NO_PROTOTYPE);
    } else { 
      while (count () < _max) request();
    } 
    return this;
  } 
  public boolean release(HDrawable d) { 
    if (_activeSet.remove(d)) { 
      _inactiveSet.add(d); 
      if (_autoParent != null) _autoParent.remove(d); 
      if (_listener != null) _listener.onRelease(d, currentIndex(), this); 
      if (_onRelease != null) _onRelease.run(d); 
      return true;
    } 
    return false;
  } 
  public HLinkedHashSet<HDrawable> activeSet() { 
    return _activeSet;
  } 
  public HLinkedHashSet<HDrawable> inactiveSet() { 
    return _inactiveSet;
  } 
  protected HDrawable createRandomDrawable() { 
    PApplet app = H.app(); 
    int numPrototypes = _prototypes.size(); 
    int index = app.round( app.random(numPrototypes-1) ); 
    return _prototypes.get(index).createCopy();
  } 
  public HIterator<HDrawable> iterator() { 
    return _activeSet.iterator();
  }
} 
public static class HMath implements HConstants { 
  private static PApplet _app; 
  private static boolean _usingTempSeed; 
  private static int _resetSeedValue; 
  public static void init(PApplet applet) { 
    _app = applet;
  } 
  public static float[] rotatePointArr(float x, float y, float rad) { 
    float[] pt = new float[2]; 
    float c = _app.cos(rad); 
    float s = _app.sin(rad); 
    pt[0] = x*c - y*s; 
    pt[1] = x*s + y*c; 
    return pt;
  } 
  public static PVector rotatePoint(float x, float y, float rad) { 
    float[] f = rotatePointArr(x, y, rad); 
    return new PVector(f[0], f[1]);
  } 
  public static float yAxisAngle(float x1, float y1, float x2, float y2) { 
    return _app.atan2(x2-x1, y2-y1);
  } 
  public static float xAxisAngle(float x1, float y1, float x2, float y2) { 
    return _app.atan2(y2-y1, x2-x1);
  } 
  public static float[] absLocArr(HDrawable ref, float relX, float relY) { 
    float[] f = {
      relX, relY, 0
    }; 
    while (ref != null) { 
      float rot = ref.rotationRad(); 
      float[] g = rotatePointArr(f[0], f[1], rot); 
      f[0] = g[0] + ref.x(); 
      f[1] = g[1] + ref.y(); 
      f[2] += rot; 
      ref = ref.parent();
    } 
    return f;
  } 
  public static PVector absLoc(HDrawable ref, float relX, float relY) { 
    float[] f = absLocArr(ref, relX, relY); 
    return new PVector(f[0], f[1]);
  } 
  public static PVector absLoc(HDrawable d) { 
    return absLoc(d, 0, 0);
  } 
  public static float[] relLocArr(HDrawable ref, float absX, float absY) { 
    float[] f = absLocArr(ref, 0, 0); 
    return rotatePointArr(absX-f[0], absY-f[1], -f[2]);
  } 
  public static PVector relLoc(HDrawable ref, float absX, float absY) { 
    float[] f = relLocArr(ref, absX, absY); 
    return new PVector(f[0], f[1]);
  } 
  public static int randomInt32() { 
    float f = _app.random(1); 
    f = _app.map(f, 0, 1, -2147483648, 2147483647); 
    return _app.round(f);
  } 
  public static void tempSeed(long seed) { 
    if (!_usingTempSeed) { 
      _resetSeedValue = randomInt32(); 
      _usingTempSeed = true;
    } 
    _app.randomSeed(seed);
  } 
  public static void removeTempSeed() { 
    _app.randomSeed(_resetSeedValue);
  } 
  public static float sineWave(float stepDegrees) { 
    return H.app().sin(stepDegrees * H.D2R);
  } 
  public static float triangleWave(float stepDegrees) { 
    float outVal = (stepDegrees % 180) / 90; 
    if (outVal > 1) outVal = 2-outVal; 
    if (stepDegrees % 360 > 180) outVal = -outVal; 
    return outVal;
  } 
  public static float sawWave(float stepDegrees) { 
    float outVal = (stepDegrees % 180) / 180; 
    if (stepDegrees % 360 >= 180) outVal -= 1; 
    return outVal;
  } 
  public static float squareWave(float stepDegrees) { 
    return (stepDegrees % 360 > 180)? -1 : 1;
  } 
  public static boolean hasBits(int target, int val) { 
    return ( (target & val) == val );
  }
} 
public static class HWarnings { 
  public static final String NULL_TARGET = "A target should be assigned before using this method.", NO_PROTOTYPE = "This pool needs at least one prototype before requesting.", NULL_ARGUMENT = "This method does not take null arguments.", INVALID_DEST = "The destination doesn't not belong to any parent.", DESTCEPTION = "The destination cannot be itself", CHILDCEPTION = "Can't add this parent as its own child.", ANCHORPX_ERR = "Set a non-zero size first for this drawable before setting the\n\t" + "anchor by pixels, or use the anchorPerc() & anchorAt() methods\n\t" + "instead.", VERTEXPX_ERR = "Set a non-zero size first for this path before setting the\n\t" + "vertex by pixels, or use the vertexPerc() methods instead."; 
  public static void warn(String type, String loc, String msg) { 
    PApplet app = H.app(); 
    app.println("[Warning: "+type+" @ "+loc+"]"); 
    if ( msg!=null && msg.length()>0 ) app.println("\t"+msg);
  } 
  private HWarnings() {
  }
}

/*
 *
 * audio class
 *
 * copyright 2014 by identy [ www.identy.org ]
 * copyright 2009 Martin Schneider 
 *
 */

// audio





//import voce.*;

//import com.getflourish.stt.*;

//import guru.ttslib.*;

//TTS tts;

class audio {

  ddf.minim.Minim _minim;
  ddf.minim.AudioPlayer _player;
  ddf.minim.AudioMetaData meta;
  
  ddf.minim.AudioInput _input; 
  ddf.minim.AudioOutput _out; 

  //Oscil       _wave;

  FFT         _fft;

  AudioRenderer _vortex, _iso, _radar;
  
  AudioRenderer[] _visuals; 

  public audio(PApplet context) {
    //_minim = new Minim(context);
  }

  public void setup(String sound) {
    
    if (_minim == null) 
      return;
    
    _player = _minim.loadFile(sound, 1024);
    _input = _minim.getLineIn();
    _out = _minim.getLineOut();
    
    meta = _player.getMetaData();
    
    //voce.SpeechInterface.init("library", true, true, "library/gram", "bit");
    
//  tts = new TTS();
//  //the following settings control the voice sound
//  tts.setPitch( 180 );
//  tts.setPitchRange( 90 );
  
    // create a sine wave Oscil, set to 440 Hz, at 0.5 amplitude
    //_wave = new Oscil( 440, 0.5f, Waves.SINE );
    // patch the Oscil to the output
    //_wave.patch( _out );
    
    _vortex = new VortexRenderer(_player);
    _iso = new IsometricRenderer(_player);
    _radar = new RadarRenderer(_player);
    
    _visuals = new AudioRenderer[] {_vortex, _radar, _iso};
     
    _player.addListener(_visuals[0]);
    
    _visuals[0].setup();
    //_visuals[1].setup();
    
    _fft = new FFT( _player.bufferSize(), _player.sampleRate() );
    
  }

  public void play() {
    if (!isPlaying()) _player.play();
  }
  
  public void replay() {
    if (!isPlaying()) {
      _player.rewind();
      _player.play();
    }
  }
  
  public void loop() {
    _player.loop();
  }

  public void pause() {
    if (isPlaying()) _player.pause();
  }

  public void stop() {
    if (isPlaying()) {
      _player.pause();
      _player.rewind();
    }
  }

  public void mute(boolean activate) {
    this.volume(activate? -255: 255);
  }
  
  public boolean isPlaying() {
    if (_player != null) return _player.isPlaying();
    return false;
  }
  
  public void volume(float value) {
//    if (_player.hasControl(ddf.minim.Controller.VOLUME)) {
//      //_player.setVolume(value);
//      _player.setVolume(_player.getVolume() + value);
//    }
//    else { 
      //_player.setGain(value);
      _player.setGain(_player.getGain() + value);
//    }

  }

  public void move() {

  }
  
  public void forward() {
    _player.skip(10);
    
    //_player.forward();
     _player.cue( _player.length() );
  }

  public void rewind() {
    _player.skip(-10);
    
    //_player.rewind();
  }

  public void speech() {
//    if (voce.SpeechInterface.getRecognizerQueueSize() > 0)
//      {
//        String s = voce.SpeechInterface.popRecognizedString();
//        
//        if(-1 != s.indexOf("true")){}
//        else if(-1 != s.indexOf("false")) {}
//        
//        if (-1 != s.indexOf("quit")) {}
//
//        //voce.SpeechInterface.synthesize(s);
//      }
      
  }
  
  public void drawFFT(PGraphics view) {

      //strokeWeight(1);
      //stroke(204, 102, 0);

       //if (_gui.debugisActive()) {
         
          _fft.forward( _player.mix );
               
          for(int i = 0; i < _fft.specSize(); i++)
          {
            float _position = map(i, 0, _fft.specSize(), 0, width);
            //view.line(_position, 100, _position, 110 - _fft.getBand(i)*8 );
            
            //float __position = map(_position, 0, _player.length(), 0, 400) + 110;
            //view.line(__position, 100, __position, 110 - _fft.getBand(i)*8 );
            
            view.line( _position, height, _position, height - _fft.getBand(i)*8 );
            
          }
          
       //}
  
  }
  
  public void drawPosition(PGraphics view) {
    
//      stroke( 128, 0, 0 );
//      
     //stroke(255, 0, 0);
     //stroke(102, 153, 51);
       
     //line(_position, height - 100 - 8 - 20, _position, height - 100 - 8 + 20);
     
     //if (_gui.systemisActive()) {
      //float x = map(_player.position(), 0, _player.length(), 0, width);
      float _position = map(_player.position(), 0, _player.length(), 0, 400) + 110;

       //view.stroke(102, 153, 51);
       //view.fill(0, 102, 153, 51);
       view.line(_position, 10, _position, 20);
       
      //strokeWeight(1);
      //stroke(204, 102, 0);

       //view.fill(0, 102, 153, 204);
       view.textSize(7);
       view.text(Integer.toString((int)ceil(_player.position())), _position, 30);

     //}
     
      //_player.removeListener(_visuals[0]);
      //_player.addListener(_visuals[0]);
      
      //_visuals[0].setup();
      //_visuals[0].draw();

}
  
  public float position() {
    //return map(_player.position(), 0, _player.length(), 0, 400) + 110;
    return _player.position();
  }
  
  public float length() {
    return _player.length();
  }
  
  public void close() {
    
    //voce.SpeechInterface.destroy();
    
    _player.removeListener(_visuals[0]);
    _player.close();
    _out.close();
    _input.close();
    _minim.stop();
  }

}

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


// processing


// arduino


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

  public void setup() {
    
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

  public void setup(String port) {
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
   
  public void init(boolean state) {
    //this._arduinoRelay[pinInit] = state ? Arduino.HIGH : Arduino.LOW;    
    //this._arduino.digitalWrite(pinInit, state ? Arduino.HIGH : Arduino.LOW);
  }
  public void done(boolean state) {
    //this._arduinoRelay[pinDone] = state ? Arduino.HIGH : Arduino.LOW;    
    //this._arduino.digitalWrite(pinDone, state ? Arduino.HIGH : Arduino.LOW);
  }

  public String[] list() {
    return Arduino.list();
  }
      
  public void reset() {
    //this._arduino.digitalWrite(pinInit, Arduino.LOW);
    for (int index = 0; index <= 7; index++) {
      this._arduinoRelay[index] = Arduino.LOW;
    }
    for (int relay = 0; relay <= 7; relay++) {
      this._arduino.digitalWrite(relay + 2, Arduino.LOW);
    }
    //this._arduino.digitalWrite(pinDone, Arduino.LOW);
  }

  public void write(int relay, boolean state) {

    if (this._arduinoRelay[relay] == Arduino.HIGH ? true : false || state) this._arduino.digitalWrite(relay + 2, state ? Arduino.HIGH : Arduino.LOW);
    this._arduinoRelay[relay] = state ? Arduino.HIGH : Arduino.LOW;    
    
  }

  public void toggle(int relay) {

    this._arduinoRelay[relay] = this._arduinoRelay[relay] == Arduino.HIGH ? Arduino.LOW : Arduino.HIGH;
    //if (this._arduinoRelay[relay] == Arduino.HIGH ? true : false || this.read(relay) == 0 ? false : true) this._arduino.digitalWrite(relay + 2, this._arduinoRelay[relay]);
    this._arduino.digitalWrite(relay + 2, this._arduinoRelay[relay]);

  }
  
//  void servo(int value) {
//    this._arduino.servoWrite(pinServo, value);
//  }
  
  public int read(int relay) {
    return this._arduino.digitalRead(relay + 2);
  }
  
  public void close() {}
  
  public void digitalEvent(int pin, int value) {
    //println("Digital pin "+pin+" has new value "+value);
  }
  
  public void analogEvent(int pin, int value) {
    //println("Analog pin "+pin+" has new value "+value);
  }

}

/*
 *
 * driver 357 class
 *
 * microchip
 *
 * copyright 2014 identy [ www.identy.org ] 
 *
 */

// processing


class driver357 {

  // serial control
  Serial _port;
  
  private byte _write = 0;
  private byte _mask = 0;
  
  private PApplet context;
  
  boolean[] _portRelay = { 
    false, false, false, false, false, false, false, false
  };

  public driver357(PApplet context) {
    try {
      
      this.context = context;
      
      //this._port = new Serial(context, Serial.list()[1], 9600);
    }
    catch (Exception e) {
      e.printStackTrace();
    }
  }

  public void setup() {
    try {
      _port.setDTR(false);
      _port.setRTS(false);
      
      //_port.bufferUntil(new String("#").getBytes()[0]);
    }
    catch (Exception e) {
      e.printStackTrace();
    }
  }

  public void setup(String port) {
   try {
      this._port.dispose();
      this._port = null;
      
      this._port = new Serial(context, port, 9600);
      this.setup();
    }
    catch (Exception e) {
      e.printStackTrace();
    }
  }
   
  public String[] list() {
    return Serial.list();
  }
      
  public void reset() {
    for (int relay = 0; relay <= 7; relay++) {
      this._portRelay[relay] = false;
    }
  }
  
  // [*][*][relay pattern][#]
  public void toggle(int relay) {
    
    this.reset();
    
    this._portRelay[relay - 1] = !this._portRelay[relay - 1];

    _write = (byte)pow(2, relay - 1);
    println("write :: " + binary(_write, 8));
    
//    _mask |= _write; _mask &= _write;
    _mask ^= _write;
    println("mask :: " + binary(_mask, 8));
    _write &= _mask;
    
    this._port.write(new byte[] {new String("*").getBytes()[0], new String("*").getBytes()[0], _write, new String("#").getBytes()[0]});
    
  }
  // [*][*][relay pattern][#]
  public void write(int relay, boolean state) {

    //this.reset();
    
    this._portRelay[relay - 1] = state;
    
    _write = (byte)pow(2, relay - 1);
    println("write :: " + binary(_write, 8));
    
//    _mask |= _write; _mask &= _write;
    _mask ^= _write;
    println("mask :: " + binary(_mask, 8));
    _write &= _mask;
    
    this._port.write(new byte[] {new String("*").getBytes()[0], new String("*").getBytes()[0], _write, new String("#").getBytes()[0]});
    
  }
    
  public void read() {
    this._port.write(new byte[] {new String("*").getBytes()[0], new String("*").getBytes()[0], _write, new String("#").getBytes()[0]});
  }
 
  public void close() {}
  
}

public void serialEvent(Serial __port) {
         
  println("read :: " + binary(__port.read(), 8));
    
}

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


// processing


// arduino


/*
 * author: Andreas G\u00f6ransson, 2014
 */



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
      //this._client.DEBUG = true;
      this._client.connect( "192.168.1.3", 1883, "unity-client" );
    }
    catch (Exception e) {
      //e.printStackTrace();
    }
  }

  public void setup() {
    
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

  public void reset() {
    for (int index = 0; index <= 7; index++) {
      this._arduinoRelay[index] = Arduino.LOW;
    }
  }

  public void write(int relay, boolean state) {
    String _bit = state ? "1" : "0";
    String _relay = str(relay);
    
    if (this._arduinoRelay[relay] == Arduino.HIGH ? true : false || state) this._client.publish( "relay", _relay + ", " + _bit);
    this._arduinoRelay[relay] = state ? Arduino.HIGH : Arduino.LOW;
    
    this._client.publish( "relay", _relay + "," + _bit);
  }

  public void toggle(int relay) {
        
    this._arduinoRelay[relay] = this._arduinoRelay[relay] == Arduino.HIGH ? Arduino.LOW : Arduino.HIGH;
    
    String _bit = this._arduinoRelay[relay] == Arduino.HIGH ? "1" : "0";
    String _relay = str(relay);

    this._client.publish( "relay", _relay + "," + _bit);
    
  }

  public void read() {}
  
  public void close() {
   this._client.disconnect();
  }
  
}

  public void mqttCallback(MQTTPublish message){
    
    String payload = new String(message.getPayload());
    String[] coords = split(payload, ",");
    
    //x = parseInt(coords[0]); y = parseInt(coords[1]);
    println("mqtt Callback relay " + coords[0] + ", bit " + coords[1]);
    
  }
  



class environment
{

  private String name = "_environment";
  
    //OBJModel model; 
    //OBJModel modeluv;
  
   PShape model;
   
   PShader nebula;
   
   PImage _label;
   PShape _can;

   private PApplet context;

  environment(PApplet parent)
  {
    context = parent;
  }
 
  environment(String s, PApplet parent)
  {
    name = s;
    context = parent;
  }

  public void setup() {
    //model = new OBJModel(context, name, OBJModel.ABSOLUTE, QUADS);
    //modeluv = new OBJModel(context, name, OBJModel.ABSOLUTE, QUADS);
    
//    //model = new OBJModel(context, name, "relative", TRIANGLES);
//    model = new OBJModel(context, name, "relative");
//    //modeluv = new OBJModel(context, name, "relative");
//    
//    //model.enableMaterial();
//    //model.enableTexture();
//    
//    //model.scale(7);
//    model.translateToCenter();
//    
//    model.enableDebug();
 
 //textureMode(NORMAL);
 
    if (name != "_environment")
      model = loadShape(name);
    
    _label = loadImage("tree.jpg");
    _can = can(100, 200, 32, _label);
  
    nebula = loadShader("nebula.glsl");
    nebula.set("resolution", PApplet.parseFloat(width), PApplet.parseFloat(height));
  
  }
  
  public void draw(PGraphics view)
  {
      
//      pushMatrix();
//      noStroke();
//      translate(width - 80, 80, 0);
//        rotateY(radians(frameCount)/2);

      nebula.set("time", millis() / 500.0f);  
      view.shader(nebula); 

//        // not logos view.shape(model);
//        // _logo .. if (_logo) _environment.draw();
//
//      //if (model != null) model.draw(view); 
//  //
//      //view.shape(_can);
//        
//      popMatrix();
      
//    for(int i = 0; i < model.getUVCount(); i ++)
//    {
//  
//      PVector u = model.getUV(i);
//      PVector stable_u = modeluv.getUV(i);
//  
//      u.x = stable_u.x + sin(radians(frameCount))/2;
//      
//    }
      
      view.rect(0, 0, width, height);
 
      //resetShader();
      
  }
  
  public PShape can(float r, float h, int detail, PImage tex) {
    //textureMode(NORMAL);
    PShape sh = createShape();
    sh.beginShape(QUAD_STRIP);
    sh.noStroke();
    sh.texture(tex);
    for (int i = 0; i <= detail; i++) {
      float angle = TWO_PI / detail;
      float x = sin(i * angle);
      float z = cos(i * angle);
      float u = PApplet.parseFloat(i) / detail;
      sh.normal(x, 0, z);
      sh.vertex(x * r, -h/2, z * r, u, 0);
      sh.vertex(x * r, +h/2, z * r, u, 1);    
    }
    sh.endShape(); 
    return sh;
  }
  
}

/*
 *
 * finite state machine class
 *
 * copyright 2014 identy [ www.identy.org ] 
 *
 */


/*

 A simple Finite State Machine library for Processing!
 
 Based on the AlphaBeta FSM library for Arduino: http://www.arduino.cc/playground/Code/FiniteStateMachine
 (Matches that API as closely as possible (with the exception of using string names for functions instead
 of function pointers since function pointers are not available in Java).)
 
 Learn more about Finite State Machines: http://en.wikipedia.org/wiki/Finite-state_machine
 
 Usage:
 
 Declare one FSM object and as many State objects as you like.
 
 To initialize a State you need to pass in three strings representing the names of three functions
 you've implemented in your sketch. These functions will be called when the state goes through its transitions: 
 
 State playMode = new State("enterPlayMode", "doPlayMode", "exitPlayMode");
 
 The first function will be called once each time the FSM enters this state. (enter function)
 The second function will be called repeated as long as the FSM stays in this state. (execute function)
 The third function will be called one when the FSM transition away from this state. (exit function)
 
 When you initialize the FSM object, you pass it the state you'd like it to begin in:
 
 FSM game;
 
 game = new FSM(startMode);
 
 In draw(), call the game's update() function. This will ensure that the library calls the appropriate state's execute function.
 
 To transition to a different state, call:
 
 game.transitionTo(someState);
 
 To retrieve the state the FSM is currently in, call:
 
 game.getCurrentState();
 
 To test if the game is in a current state, call:
 
 if(game.isInState(someState){
 // do something
 }
 
 
 */




class Finite {
  State currentState;

  Finite(State initialState) {
    currentState = initialState;
  }

  public void update() {
    currentState.executeFunction();
  }

  public State getCurrentState() {
    return currentState;
  }

  public boolean isInState(State state) {
    return currentState == state;
  }

  public void transitionTo(State newState) {
    currentState.exitFunction();
    currentState = newState;
    currentState.enterFunction();
  }
}

class State {
  PApplet parent;
  Method enterFunction;
  Method executeFunction;
  Method exitFunction;

  State(PApplet p, String enterFunctionName, String executeFunctionName, String exitFunctionName) {
    parent = p;

    Class sketchClass = parent.getClass();
    try { 

      enterFunction = sketchClass.getMethod(enterFunctionName);
      executeFunction = sketchClass.getMethod(executeFunctionName);
      exitFunction = sketchClass.getMethod(exitFunctionName);
    }

    catch(NoSuchMethodException e) {
      println("One of the state transition function is missing.");
    }
  }

  public void enterFunction() {
    try {
      enterFunction.invoke(parent);
    } 

    catch(IllegalAccessException e) {
      println("State enter function is missing or something is wrong with it.");
    }
    catch(InvocationTargetException e) {
      println("State enter function is missing.");
    }
  }
  public void executeFunction() {
    try {
      executeFunction.invoke(parent);
    }
    catch(IllegalAccessException e) {
      println("State execute function is missing or something is wrong with it.");
    }
    catch(InvocationTargetException e) {
      println("State execute function is missing.");
    }
  }
  public void exitFunction() {
    try {
      exitFunction.invoke(parent);
    }
    catch(IllegalAccessException e) {
      println("State exit function is missing or something is wrong with it.");
    }
    catch(InvocationTargetException e) {
      println("State exit function is missing.");
    }
  }
}

/* Sample
 
 Finite game;
 
 State attractMode = new State(this, "enterAttract", "doAttract", "exitAttract");
 State playMode = new State(this, "enterPlay", "doPlay", "exitPlay");
 
 void setup() {
 game = new FSM(attractMode);
 }
 
 void draw() {
 game.update();
 }
 
 void enterAttract() {
 println("enter attract");
 }
 
 void doAttract() {
 background(255, 0, 0);
 }
 
 void exitAttract() {
 println("exit Attract");
 }
 
 void enterPlay() {
 println("enter play");
 }
 
 void doPlay() {
 background(0, 255, 0);
 }
 
 void exitPlay() {
 println("exit play");
 }
 
 void mousePressed() {
 if (game.isInState(attractMode)) {
 game.transitionTo(playMode);
 } 
 else if(game.isInState(playMode)) {
 game.transitionTo(attractMode);
 }
 }
 
 */

/*
 *
 * fourier class
 *
 * audio render & visualizer
 * a quick sketch to do WimAmp-style music visualization   
 * using Processing and the Minim Library
 *
 * copyright 2014 identy [ www.identy.org ]
 * copyright 2009 Martin Schneider 
 *
 */
 


abstract class AudioRenderer implements AudioListener {
  
  float[] left;
  float[] right;
  
  public synchronized void samples(float[] sample) { left = sample; }
  public synchronized void samples(float[] sampleLeft, float[] sampleRight) { left = sampleLeft; right = sampleRight; }
  
  public abstract void setup();
  public abstract void draw();
  
}

abstract class FourierRenderer extends AudioRenderer {
  
  FFT fft; 
  float maxFFT;
  float[] leftFFT;
  float[] rightFFT;
  
  FourierRenderer(AudioSource source) {
    float gain = .125f;
    fft = new FFT(source.bufferSize(), source.sampleRate());
    maxFFT =  source.sampleRate() / source.bufferSize() * gain;
    fft.window(FFT.HAMMING);
  }
  
  public void calc(int bands) {
    if(left != null) {
      leftFFT = new float[bands];
      fft.linAverages(bands);
      fft.forward(left);
      for(int i = 0; i < bands; i++) leftFFT[i] = fft.getAvg(i);   
    }
  }
}

class IsometricRenderer extends FourierRenderer {

  int r = 7;
  float squeeze = .5f;

  float a, d;
  float val[];
  int n;
  
  IsometricRenderer(AudioSource source) {
    super(source);
    n = ceil(sqrt(2) * r);
    d = min(width,height) / r / 5;
    val = new float[n];
  }

  public void setup() { 
    //colorMode(RGB, 6, 6, 6); 
    //stroke(0);
  } 
  
  public void draw() {
    
    if(left != null) {
     
      super.calc(n);
      
      for(int i=0; i<n; i++) val[i] = lerp(val[i], pow(leftFFT[i], squeeze), .1f);
      
      a -= 0.08f; 
      background(6);  
      for (int x = -r; x <= r; x++) { 
        for (int z = -r; z <= r; z++) { 
          int y = PApplet.parseInt( height/3 * val[(int) dist(x,z,0,0)]); 
  
          float xm = x*d - d/2; 
          float xt = x*d + d/2; 
          float zm = z*d - d/2; 
          float zt = z*d + d/2; 
  
          int w0 = (int) width/2; 
          int h0 = (int) height * 2/3; 
  
          int isox1 = PApplet.parseInt(xm - zm + w0); 
          int isoy1 = PApplet.parseInt((xm + zm) * 0.5f + h0); 
          int isox2 = PApplet.parseInt(xm - zt + w0); 
          int isoy2 = PApplet.parseInt((xm + zt) * 0.5f + h0); 
          int isox3 = PApplet.parseInt(xt - zt + w0); 
          int isoy3 = PApplet.parseInt((xt + zt) * 0.5f + h0); 
          int isox4 = PApplet.parseInt(xt - zm + w0); 
          int isoy4 = PApplet.parseInt((xt + zm) * 0.5f + h0); 
  
          fill (2); 
          quad(isox2, isoy2-y, isox3, isoy3-y, isox3, isoy3+d, isox2, isoy2+d); 
          fill (4); 
          quad(isox3, isoy3-y, isox4, isoy4-y, isox4, isoy4+d, isox3, isoy3+d); 
  
          fill(4 + y / 2.0f / d); 
          quad(isox1, isoy1-y, isox2, isoy2-y, isox3, isoy3-y, isox4, isoy4-y); 
        } 
      }
    }
  } 

}

class VortexRenderer extends FourierRenderer {

  int n = 48;
  float squeeze = .5f;

  float val[];

  VortexRenderer(AudioSource source) {
    super(source); 
    val = new float[n];
  }

  public void setup() {
    //colorMode(HSB, n, n, n);
    //rectMode(CORNERS);
    //noStroke();     
  }

  public synchronized void draw() {

    if(left != null) {  
      
      float t = map(millis(),0, 3000, 0, TWO_PI);
      float dx = width / n;
      float dy = height / n * .5f;
      super.calc(n);
      pushMatrix();
      //background(0); 
      //lights();
      translate(width/2, height, -width/2);
      rotateZ(HALF_PI); 
      rotateY(-2.2f - HALF_PI + PApplet.parseFloat(mouseY)/height * HALF_PI);
      rotateX(t);
      translate(0,width/4,0);
      rotateX(t);

      // draw coloured slices
      for(int i=0; i < n; i++)
      {
        val[i] = lerp(val[i], pow(leftFFT[i] * (i+1), squeeze), .1f);
        float x = map(i, 0, n, height, 0);
        float y = map(val[i], 0, maxFFT, 0, width/2);
        pushMatrix();
          translate(x, 0, 0);
          rotateX(PI/16 * i);
          fill(i, n * .7f + i * .3f, n-i);
          box(dy, dx + y, dx + y);
        popMatrix();
      }
      popMatrix();
    }
  }
}

class RadarRenderer extends AudioRenderer {
  
  float aura = .25f;
  float orbit = .25f;
  int delay = 2;
  
  int rotations;

  RadarRenderer(AudioSource source) {
    rotations =  (int) source.sampleRate() / source.bufferSize();
  }
  
  public void setup() {
    colorMode(RGB, TWO_PI * rotations, 1, 1);
    background(0);
  }
  
  public synchronized void draw()
  {
    if(left != null) {
   
      float t = map(millis(),0, delay * 1000, 0, PI);   
      int n = left.length;
      
      // center 
      float w = width/2 + cos(t) * width * orbit;
      float h = height/2 + sin(t) * height * orbit; 
      
      // size of the aura
      float w2 = width * aura, h2 = height * aura;
      
      // smoke effect
      if(frameCount % delay == 0 ) image(g,0,0, width+1, height+1); 
      
      // draw polar curve 
      float r1=0, a1=0, x1=0, y1=0, r2=0, a2=0, x2=0, y2=0; 
      for(int i=0; i <= n; i++)
      {
        r1 = r2; a1 = a2; x1 = x2; y1 = y2;
        r2 = left[i % n] ;
        a2 = map(i,0, n, 0, TWO_PI * rotations);
        x2 = w + cos(a2) * r2 * w2;
        y2 = h + sin(a2) * r2 * h2;
        stroke(a1, 1, 1, 30);
        // strokeWeight(dist(x1,y1,x2,y2) / 4);
        if(i>0) line(x1, y1, x2, y2);
      }
    }
  }
  
}

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



class gui {

  final static int CONTROLLER = 0, TAB = 1, GROUP = 2;
  
  private int backgroundColor = color(0, 0, 0);
  private PImage backgroundImage = null;
  
  //private color strokeColor = color(0xff660000); // color(225, 225, 225);
  private int strokeColor = color(102, 153, 51);
  
  //private color fillColor = color(0xffdddddd); // color(245, 245, 245);
  private int fillColor = color(204, 102, 0);
  
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
  //PGraphics offscreen;

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

  public void setup() {

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
      
      serializerjson.setBoolean("debug", false);
      serializerjson.setBoolean("draw", false);
      serializerjson.setBoolean("mute", true);
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
    
    //offscreen = createGraphics(width, height, P2D);
    
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
      .setPosition(20, 20)
      .setImages(loadImage("Texture/play_red.png"), loadImage("Texture/play_blue.png"), loadImage("Texture/play_green.png"))
      .setBroadcast(true)
      .updateSize();

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
    
//    for (int i = 0; i < _driver.list().length; i++) {
//      _listArduinoPort.addItem(_driver.list()[i], i);
//    }
       
    _listArduinoPort.addListener(new portListener());
    //_listArduinoPort.setValue(0);

    _listArduinoPort.setVisible(false);
    
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
        .setPosition(20, 60 + (40 * index) + 30)
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
        .setPosition(110, 60 + (40 * index) + 30)
        .setSize(400, 20)
        .setHandleSize(1)
        
        //.setRange(0, 700)
        //.setRange(0, _audio._player.bufferSize())
        .setRange(0, _audio._player.length())
        
        .setRangeValues(((_audio._player.length() / 8) * (index)), ((_audio._player.length() / 8) * (index)) + (_audio._player.length() / 8))
        //.setRangeValues(((700 / 8) * (index - 1)), ((700 / 8) * (index - 1 )) + (700 / 8))
        
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

  public boolean set() {

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

  public void close() {
    
    _time.stop();
    _audio.close();
    
    //saveJSONObject(serializerjson, "data/alpheny.json");
    
  }
  
  public void draw() {   


    //camera(width/2.0  + 300 * cos(frameCount/300.0), height/2.0 - 100, height/2.0 + 300 * sin(frameCount/300.0), width/2.0, height/2.0, 0, 0, 1, 0);
    
    //rotate(frameCount*0.001);
    
    background(backgroundColor);
    
    stroke(strokeColor);
    fill(fillColor);
          
    //PVector surfaceMouse = surface.getTransformedMouse();
    
    //offscreen.beginDraw();
    //offscreen.background(0);
    
    //offscreen.stroke(strokeColor);
    //offscreen.fill(fillColor);
    
    if (this.isActive()) {
           
      //if (this.drawisActive()) _environment.draw(offscreen);

      if (_audio.isPlaying()) _audio.mute(this.muteisActive());
      //if (_audio.isPlaying()) _audio.drawPosition(offscreen);

      // if (this.drawisActive() && _audio.isPlaying() && !this.muteisActive()) _audio.drawFFT(offscreen);
      
    }
    
    //offscreen.endDraw();
    //image(offscreen, width, height);
    //surface.render(offscreen);
    
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
  
  public void sequencePlay() {
    
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
  
  public boolean systemisActive() {
      return _groupSystem.isVisible();
  }
  public void systemToggle(boolean activate) {
    if (activate) {
      if (!_groupSystem.isVisible()) _groupSystem.show();
    } 
    else {
      if (_groupSystem.isVisible()) _groupSystem.hide();
    }
  }
  
  public boolean debugisActive() {
      return consoleDebug.isVisible();
  }
  public void debugToggle(boolean activate) {
    if (activate) {
      if (!consoleDebug.isVisible()) consoleDebug.show();
    } 
    else {
      if (consoleDebug.isVisible()) consoleDebug.hide();
    }
  }
    
  public boolean drawisActive() {
    return checkboxDebugger.getItem(1).getState();
  }
  public void drawToggle(boolean activate) {
      if (activate) checkboxDebugger.activate("draw");
      else checkboxDebugger.deactivate("draw");
  }
  
  public boolean muteisActive() {
    return checkboxDebugger.getItem(2).getState();
  }
  
  public boolean repeatisActive() {
    return checkboxDebugger.getItem(3).getState();
  }
    
  public boolean isActive() {
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

public void controlEvent(ControlEvent _event) {
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

/*
 *
 * time line class
 *
 * copyright 2014 identy [ www.identy.org ] 
 *
 */

 
 













//import org.multiply.processing.TimedEventGenerator;

//import com.dhchoi.CountdownTimer;

class time {

  Timeline _timeline;
  
  Motion _motion;
  Tween _tween;

//  private TimedEventGenerator _TimedEventGenerator;
//  
//  private CountdownTimer _CircleTimer;

  private PApplet context;

  //float control1, control2, control3, control4, control5, control6, control7, control8;
  
  //float relay1, relay2, relay3, relay4, relay5, relay6, relay7;
  
  //float relayInit = 0, relayDone = 0;
  
  public time(PApplet context) {

    this.context = context;
    
//    Motion.setup(context);
//    
//    _timeline = new Timeline("relay timeline");
//    _timeline.setTimeMode(Motion.SECONDS);
//    _timeline.addEventListener(new TimelineListener());
    
  }

  public void setup() {
              
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

//    _motion = _timeline.call(this, "init", 0);    
//    _motion = _timeline.call(this, "uno", 1);
//    _motion = _timeline.call(this, "dos", 2);
//    _motion = _timeline.call(this, "tres", 3);   
//    _motion = _timeline.call(this, "cuatro", 4);
//    _motion = _timeline.call(this, "cinco", 5);
//    _motion = _timeline.call(this, "seis", 6);
//    _motion = _timeline.call(this, "siete", 7);
//    _motion = _timeline.call(this, "done", 8);
//
//    TweenListener _tweenListener = new TweenListener();
//
//    _tween = new Tween("control1", 10).add(this, "control1", (float)width);
//    _tween.addEventListener(_tweenListener);
//    _timeline.add(_tween, 10);
//    _tween = new Tween("control2", 10).add(this, "control2", (float)width);
//    _tween.addEventListener(_tweenListener);
//    _timeline.add(_tween, 20);
//    _tween = new Tween("control3", 10).add(this, "control3", (float)width);
//    _tween.addEventListener(_tweenListener);
//    _timeline.add(_tween, 30);
//    _tween = new Tween("control4", 10).add(this, "control4", (float)width);
//    _tween.addEventListener(_tweenListener);
//    _timeline.add(_tween, 40);
//    _tween = new Tween("control5", 10).add(this, "control5", (float)width);
//    _tween.addEventListener(_tweenListener);
//    _timeline.add(_tween, 50);
//    _tween = new Tween("control6", 10).add(this, "control6", (float)width);
//    _tween.addEventListener(_tweenListener);
//    _timeline.add(_tween, 60);
//    _tween = new Tween("control7", 10).add(this, "control7", (float)width);
//    _tween.addEventListener(_tweenListener);
//    _timeline.add(_tween, 70);
//    _tween = new Tween("control8", 10).add(this, "control8", (float)width);
//    _tween.addEventListener(_tweenListener);
//    _timeline.add(_tween, 80);
    
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
    
//    _TimedEventGenerator = new TimedEventGenerator(context, "onTimedEventGenerator", false);
//    _TimedEventGenerator.setIntervalMs(1000);
//
//    _CircleTimer = CountdownTimer.getNewCountdownTimer(context).configure(100, 6000); //.start(); // this timer will have timerId = 0
    
  }

  public void play() {
    
//    _timeline.play();    
//    for (Tween _tween : _timeline.getTweenList()) {
//      _tween.play(); 
//    }
    
//    _TimedEventGenerator.setEnabled(!_TimedEventGenerator.isEnabled());
//
//    _CircleTimer.start();

  }

  public void loop() {
   
//    for (Tween _tween : _timeline.getTweenList()) {
//      _tween.repeat().play(); 
//    }
//    _timeline.repeat().play();
    
  }

  public void stop() {
    
//    for (Tween _tween : _timeline.getTweenList()) {
//      _tween.repeat().stop(); 
//    }
//    _timeline.stop();
    
    //_TimedEventGenerator.setEnabled(false);
  }

  public boolean isPlaying() {
    //return _timeline.isPlaying(); 
    //return _TimedEventGenerator.isEnabled();
    return false;
  }

  public void delay(int index, float value) {
    //println(_timeline.toString());
    
    //println(_timeline.get(index).toString());
    //_timeline.get(index).delay(value);
    //_timeline.getCallback(index).
  }

  public void duration(int index, float value) {
    //println(_timeline.toString());
    
    //println(_timeline.get(index).toString());
    //_timeline.get(index).setDuration(value); //<>//
    //_timeline.getCallback(index).
  }

  public boolean isEnabled() {
    //return _TimedEventGenerator.isEnabled();
    return false;
  }
  
  // timeline callback

//  void init() {
//    _driver.reset();
//  }

//  void uno() {
//    _driver.toggle(1);
//  }
//  void dos() {
//    _driver.toggle(2);
//  }
//  void tres() {
//    _driver.toggle(3);
//  }
//  void cuatro() {
//    _driver.toggle(4);
//  }
//  void cinco() {
//    _driver.toggle(5);
//  }
//  void seis() {
//    _driver.toggle(6);
//  }
//  void siete() {
//    _driver.toggle(7);
//  }
//  
//  void done() {
//    _driver.reset();
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

public void onTimedEventGenerator() {
  
}

public void onTickEvent(int timerId, long timeLeftUntilFinish) {

  switch (timerId) {
    case 0:
      break;
    case 1:
      break;
    }
    
}

public void onFinishEvent(int timerId) {

  switch (timerId) {
    case 0:
      break;
    case 1:
      break;
  }
  
  println("[timerId:" + timerId + "] finished");
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
  
  public void onMotionEvent(MotionEvent te) {
       
    println(te);
    
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
  
  public void onMotionEvent(MotionEvent te) {

    println(te);
    
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
  
  public void onMotionEvent(MotionEvent te) {
    
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
      // lock // _driver357.toggle(Integer.parseInt(((Tween)te.getSource()).getName().substring(((Tween)te.getSource()).getName().length() - 1)));
    }
    catch(Exception e) { e.printStackTrace(); }

  }
  
}

public class CallbackListener implements MotionEventListener {
  
  public void onMotionEvent(MotionEvent te) {
    
    println(te);
    
    if (te.type == MotionEvent.CALLBACK_STARTED)
      println(((Motion)te.getSource()).getName() + " started");
    else if (te.type == MotionEvent.CALLBACK_ENDED)
      println(((Motion)te.getSource()).getName() + " ended");

  }
  
}

public class MotionListener implements MotionEventListener {
  
  public void onMotionEvent(MotionEvent te) {
    
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

  public int sketchWidth() { return 800; }
  public int sketchHeight() { return 500; }
  public String sketchRenderer() { return P3D; }
}
