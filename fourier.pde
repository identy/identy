                                                      
 //  Music Visualizer                                        
 //                                                          
 //  a quick sketch to do WimAmp-style music visualization   
 //  using Processing and the Minim Library ...              
 //                                                          
 //  (c) Martin Schneider 2009                               
 //                                                          
 
import ddf.minim.analysis.*;

abstract class AudioRenderer implements AudioListener {
  
  float[] left;
  float[] right;
  
  public synchronized void samples(float[] sample) { left = sample; }
  public synchronized void samples(float[] sampleLeft, float[] sampleRight) { left = sampleLeft; right = sampleRight; }
  
  abstract void setup();
  abstract void draw();
  
}

abstract class FourierRenderer extends AudioRenderer {
  
  FFT fft; 
  float maxFFT;
  float[] leftFFT;
  float[] rightFFT;
  
  FourierRenderer(AudioSource source) {
    float gain = .125;
    fft = new FFT(source.bufferSize(), source.sampleRate());
    maxFFT =  source.sampleRate() / source.bufferSize() * gain;
    fft.window(FFT.HAMMING);
  }
  
  void calc(int bands) {
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
  float squeeze = .5;

  float a, d;
  float val[];
  int n;
  
  IsometricRenderer(AudioSource source) {
    super(source);
    n = ceil(sqrt(2) * r);
    d = min(width,height) / r / 5;
    val = new float[n];
  }

  void setup() { 
    //colorMode(RGB, 6, 6, 6); 
    //stroke(0);
  } 
  
  void draw() {
    
    if(left != null) {
     
      super.calc(n);
      
      for(int i=0; i<n; i++) val[i] = lerp(val[i], pow(leftFFT[i], squeeze), .1);
      
      a -= 0.08; 
      background(6);  
      for (int x = -r; x <= r; x++) { 
        for (int z = -r; z <= r; z++) { 
          int y = int( height/3 * val[(int) dist(x,z,0,0)]); 
  
          float xm = x*d - d/2; 
          float xt = x*d + d/2; 
          float zm = z*d - d/2; 
          float zt = z*d + d/2; 
  
          int w0 = (int) width/2; 
          int h0 = (int) height * 2/3; 
  
          int isox1 = int(xm - zm + w0); 
          int isoy1 = int((xm + zm) * 0.5 + h0); 
          int isox2 = int(xm - zt + w0); 
          int isoy2 = int((xm + zt) * 0.5 + h0); 
          int isox3 = int(xt - zt + w0); 
          int isoy3 = int((xt + zt) * 0.5 + h0); 
          int isox4 = int(xt - zm + w0); 
          int isoy4 = int((xt + zm) * 0.5 + h0); 
  
          fill (2); 
          quad(isox2, isoy2-y, isox3, isoy3-y, isox3, isoy3+d, isox2, isoy2+d); 
          fill (4); 
          quad(isox3, isoy3-y, isox4, isoy4-y, isox4, isoy4+d, isox3, isoy3+d); 
  
          fill(4 + y / 2.0 / d); 
          quad(isox1, isoy1-y, isox2, isoy2-y, isox3, isoy3-y, isox4, isoy4-y); 
        } 
      }
    }
  } 

}

class VortexRenderer extends FourierRenderer {

  int n = 48;
  float squeeze = .5;

  float val[];

  VortexRenderer(AudioSource source) {
    super(source); 
    val = new float[n];
  }

  void setup() {
    //colorMode(HSB, n, n, n);
    //rectMode(CORNERS);
    //noStroke();     
  }

  synchronized void draw() {

    if(left != null) {  
      
      float t = map(millis(),0, 3000, 0, TWO_PI);
      float dx = width / n;
      float dy = height / n * .5;
      super.calc(n);
      pushMatrix();
      //background(0); 
      //lights();
      translate(width/2, height, -width/2);
      rotateZ(HALF_PI); 
      rotateY(-2.2 - HALF_PI + float(mouseY)/height * HALF_PI);
      rotateX(t);
      translate(0,width/4,0);
      rotateX(t);

      // draw coloured slices
      for(int i=0; i < n; i++)
      {
        val[i] = lerp(val[i], pow(leftFFT[i] * (i+1), squeeze), .1);
        float x = map(i, 0, n, height, 0);
        float y = map(val[i], 0, maxFFT, 0, width/2);
        pushMatrix();
          translate(x, 0, 0);
          rotateX(PI/16 * i);
          fill(i, n * .7 + i * .3, n-i);
          box(dy, dx + y, dx + y);
        popMatrix();
      }
      popMatrix();
    }
  }
}
