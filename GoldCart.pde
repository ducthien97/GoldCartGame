class GoldCart
{
 PVector position;
 PVector velocity;
 PVector acceleration;
 PVector rotation;
 float drag = .9;
 float r = 20;
 PImage img = loadImage("goldCart.png");

 public GoldCart()
 {
  position = new PVector(width/2, height-50);
  acceleration = new PVector(0,0);
  velocity = new PVector(0,0);
  rotation = new PVector(0,1);
 } 
 
 void update()
 {
   PVector below = new PVector(0, -2*r);
   rotate2D(below, heading2D(rotation)+PI/2);
   below.add(position);

   velocity.add(acceleration);
   velocity.mult(drag);//adjust the speed to avoid it moving too fast
   velocity.limit(5);//the maximum speed is 5
   position.add(velocity);

 }
 
 void roundBack()
 {
    if (position.x < r)
      position.x = width-r;
    
    if (position.y < r) 
      position.y = height-r;
    
    if (position.x > width-r) 
      position.x = r;
    
    if (position.y > height-r)
      position.y = r;    
 }
 
 boolean checkCollision(ArrayList<Bomb> bombs)
 {
   for(Bomb a : bombs)
   {
      PVector dist = PVector.sub(a.position, position);
   
      if(dist.mag() < a.radius + r/2)
      {
         a.hit(bombs);
         return true; 
      }
   }
   return false;
 }
 boolean checkCollection(ArrayList<Gold> golds)
 {
   for(Gold a : golds)
   {
      PVector dist = PVector.sub(a.position, position);
   
      if(dist.mag() < a.radius + r/2)
      {
         coin.play();
          golds.remove(a);
         return true; 
      }
   }
   return false;
 }
 
 void render()
 { 
   roundBack();
   
   float theta = heading2D(rotation)  + PI/2;
   theta += PI;
   
   pushMatrix();
   translate(position.x, position.y);
   rotate(theta);
   fill(0);

   image(img,-r,-r*1.5,2*r,3*r); 
   popMatrix();
 }
}
