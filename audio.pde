
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
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;

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
    _minim = new Minim(context);
  }

  void setup(String sound) {
    
    _player = _minim.loadFile(sound, 1024);
    _input = _minim.getLineIn();
    _out = _minim.getLineOut();
    
    meta = _player.getMetaData();
    
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

  void mute(boolean activate) {
    this.volume(activate? -255: 255);
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

  void move() {

  }
  
  void forward() {
    _player.skip(10);
    
    //_player.forward();
     _player.cue( _player.length() );
  }

  void rewind() {
    _player.skip(-10);
    
    //_player.rewind();
  }

  void drawFFT(PGraphics view) {

      strokeWeight(1);
      stroke(204, 102, 0);
        
      _fft.forward( _player.mix );
  
       if (_gui.FFTisActive())
          for(int i = 0; i < _fft.specSize(); i++)
          {
            float _position = map(i, 0, _fft.specSize(), 0, width);
            view.line( _position, height, _position, height - _fft.getBand(i)*8 );
          }
  
  }
  
  void drawPos(PGraphics view) {
    
//      stroke( 128, 0, 0 );
//      
 
     //float x = map(_player.position(), 0, _player.length(), 0, width);
    float _position = map(_player.position(), 0, _player.length(), 0, 400);
     stroke(255, 0, 0);
     //line(_position, height - 100 - 8 - 20, _position, height - 100 - 8 + 20);
     if (_gui.systemisActive())
       line(_position + 110, 110, _position + 110, 400);

      //_player.removeListener(_visuals[0]);
      //_player.addListener(_visuals[0]);
      
      //_visuals[0].setup();
      //_visuals[0].draw();

}
  
  void close() {
    _player.removeListener(_visuals[0]);
    _player.close();
    _out.close();
    _input.close();
    _minim.stop();
  }

}
