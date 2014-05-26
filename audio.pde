
/*
 *
 * audio class
 *
 * copyright 2014 by identy [ www.identy.org ]
 * copyright 2009 Martin Schneider 
 *
 */

// audio
import ddf.minim.*;
import ddf.minim.signals.*;

class audio {

  ddf.minim.Minim _minim;
  ddf.minim.AudioPlayer _player;

  ddf.minim.AudioInput _input; 
  ddf.minim.AudioOutput _out; 

  AudioRenderer _vortex, _iso;
  AudioRenderer[] _visuals; 

  public audio(PApplet context) {
    _minim = new Minim(context);
  }

  void setup(String sound) {
    _player = _minim.loadFile(sound, 1024);
    _input = _minim.getLineIn();
    _out = _minim.getLineOut();
    
    _vortex = new VortexRenderer(_player);
    _iso = new IsometricRenderer(_player);
  
    _visuals = new AudioRenderer[] {_vortex,  _iso};
    
    _player.addListener(_visuals[0]);
    
    _visuals[0].setup();
    //_visuals[1].setup();
  }

  void play() {
    if (!isPlaying()) _player.play();
  }
  
  void replay() {
    if (!isPlaying()) {
      _player.rewind();
      _player.play();
    }
  }
  
  void loop() {
    _player.loop();
  }

  void pause() {
    if (isPlaying()) _player.pause();
  }

  void stop() {
    if (isPlaying()) {
      _player.pause();
      _player.rewind();
    }
  }

  boolean isPlaying() {
    if (_player != null) return _player.isPlaying();
    return false;
  }
  
  void volume(float value) {
    if (_player.hasControl(ddf.minim.Controller.VOLUME)) {
      //_player.setVolume(value);
      _player.setVolume(_player.getVolume() + value);
    }
    else { 
      //_player.setGain(value);
      _player.setGain(_player.getGain() + value);
    }

  }

  void draw(int type) {
    if (type == 0) {
      //_player.removeListener(_visuals[0]);
      //_player.addListener(_visuals[0]);
      _visuals[0].setup();
      _visuals[0].draw();
    }
    if (type == 1) {
      //_player.removeListener(_visuals[1]);
      //_player.addListener(_visuals[1]);
      _visuals[1].setup();
      _visuals[1].draw();
    }
  }

  void close() {
    _player.removeListener(_visuals[0]);
    _player.close();
    _out.close();
    _input.close();
    _minim.stop();
  }

}
