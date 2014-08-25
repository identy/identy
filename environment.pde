
import saito.objloader.*;

class environment
{

  OBJModel model; 
  OBJModel modeluv;
  
  environment(String s, PApplet parent)
  {
    //model = new OBJModel(parent, s, OBJModel.ABSOLUTE, QUADS);
    //modeluv = new OBJModel(parent, s, OBJModel.ABSOLUTE, QUADS);
    
    //model = new OBJModel(parent, s, "relative", TRIANGLES);
    model = new OBJModel(parent, s, "relative");
    //modeluv = new OBJModel(parent, s, "relative");
    
    //model.enableMaterial();
    //model.enableTexture();
    
    //model.scale(7);
    model.translateToCenter();
    
    model.enableDebug();
  }

  void draw()
  {
          
    model.draw(); 
    
  
//    for(int i = 0; i < model.getUVCount(); i ++)
//    {
//  
//      PVector u = model.getUV(i);
//      PVector stable_u = modeluv.getUV(i);
//  
//      u.x = stable_u.x + sin(radians(frameCount))/2;
//      
//    }
  
  }
  
}
