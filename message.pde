
/*
 *
 * messague class
 * 
 * copyright 2014 identy [ www.identy.org ]
 *
 */
 
class message {

  PGraphics messageLayer;
  
  public message() {
    rectMode(CENTER);
    smooth();
    messageLayer = createGraphics(width, height);
  }
  
  void display(String title, String subtitle) {

    pushMatrix();

    messageLayer.fill(0);
    messageLayer.stroke(255,0,0);
    messageLayer.strokeWeight(1);
    
    messageLayer.rect(40, 60, 800 - (40 * 2), 600 - (60 * 2));

    messageLayer.textAlign(CENTER);
    messageLayer.textSize(37);
    messageLayer.fill(10, 10, 10);
    messageLayer.text(title, 215, 100);
  
    messageLayer.textSize(17);
    messageLayer.text(subtitle, 215, 140);

    popMatrix();

    image(messageLayer,0,0);    
  }
 
}
