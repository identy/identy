
import saito.objloader.*;

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

  void setup() {
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
    nebula.set("resolution", float(width), float(height));
  
  }
  
  void draw(PGraphics view)
  {
      
//      pushMatrix();
//      noStroke();
//      translate(width - 80, 80, 0);
//        rotateY(radians(frameCount)/2);

      nebula.set("time", millis() / 500.0);  
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
  
  PShape can(float r, float h, int detail, PImage tex) {
    //textureMode(NORMAL);
    PShape sh = createShape();
    sh.beginShape(QUAD_STRIP);
    sh.noStroke();
    sh.texture(tex);
    for (int i = 0; i <= detail; i++) {
      float angle = TWO_PI / detail;
      float x = sin(i * angle);
      float z = cos(i * angle);
      float u = float(i) / detail;
      sh.normal(x, 0, z);
      sh.vertex(x * r, -h/2, z * r, u, 0);
      sh.vertex(x * r, +h/2, z * r, u, 1);    
    }
    sh.endShape(); 
    return sh;
  }
  
}

class Dong {
  float x, y;
  float s0, s1;

  Dong() {
    float f= random(-PI, PI);
    x = cos(f)*random(100, 150);
    y = sin(f)*random(100, 150);
    s0 = random(2, 10);
  }

  void display(PGraphics view) {
    s1 += (s0-s1)*0.1;
    view.ellipse(x, y, s1, s1);
  }

  void update() {
    s1 = 50;
  }
}
