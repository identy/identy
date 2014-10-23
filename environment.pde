
import saito.objloader.*;

class environment
{

  private String name = "_environment";
  
    //OBJModel model; 
    //OBJModel modeluv;
  
   PShape model;
   
   PShader nebula;
   
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
 
    //model = loadShape(name);
    
//    nebula = loadShader("nebula.glsl");
//    nebula.set("resolution", float(width), float(height));
  
  }
  
  void draw(PGraphics view)
  {
          
    //model.draw(); 
    
//      pushMatrix();
//      noStroke();
//      translate(width - 80, 80, 0);
//        rotateY(radians(frameCount)/2);

        // not logos view.shape(model);
        // _logo .. if (_logo) _environment.draw();
        
//      popMatrix();
  
      //noStroke();
    //nebula.set("time", millis() / 500.0);  
    //view.shader(nebula); 
  
//    for(int i = 0; i < model.getUVCount(); i ++)
//    {
//  
//      PVector u = model.getUV(i);
//      PVector stable_u = modeluv.getUV(i);
//  
//      u.x = stable_u.x + sin(radians(frameCount))/2;
//      
//    }
  
      //view.rect(0, 0, width, height);
  }
  
}
