
GoldCart cart;

boolean upPressed = false;//CHANGE LEFT AND RIGHT TO UP AND DOWN( IN SHIP TOO)
boolean downPressed = false;
boolean rightPressed = false;
boolean leftPressed = false;
import processing.sound.*;
SoundFile pew;
SoundFile crash;
SoundFile coin;
Timer timer;
float shipSpeed = 5;
float bulletSpeed = 10;
int numGold = 3; 
int numBombs = 3; //the number of asteroids
int startingRadius = 50; //the size of an asteroid
int numGoldCollected = 0;
PImage bombPic;
PImage goldPic;
PImage cartPic;
int goldDestroyed = 0;
int asteroidDestroyed = 0; //keep score of the asteroid destroyed
int finalScore = 0;
int bulletShot = 0;
ArrayList<Bullet> bullets;
ArrayList<Bomb> bombs;
ArrayList<Gold> golds;
int bulletCap;
PFont font;

// game state variables
int gameState;
public final int INTRO = 1;
public final int PLAY = 2;
public final int PAUSE = 3;
public final int GAMEOVERWIN = 4;
public final int GAMEOVERLOSE = 5;
public final int CREDIT = 6;
public final int INSTRUCTION = 7;

void setup()
{
 background(0);
 size(800,500);
 font = createFont("Cambria", 32); 
 frameRate(24);
 pew = new SoundFile(this, "pew.wav");
 crash = new SoundFile(this,"crash.wav");
 coin = new SoundFile(this, "coin.mp3");
 bombPic = loadImage("goldBomb.png");
 goldPic = loadImage("gold.png");
 cartPic = loadImage("goldCart.png");
 timer = new Timer(30000);
 bombs = new ArrayList<Bomb>(0);
 golds = new ArrayList<Gold>(0);
 gameState = INTRO;
}


void draw()
{  
  
  switch(gameState) 
  {
    case INTRO:
      drawScreen("Welcome Gamer!", "Press s to play. Press i for instruction. Press c for credit");
      break;
    case CREDIT:
      drawInstruction("Credit: " , "Developed by Thien Duong (GitHub: ducthien97) with the components used in Dr. Ling Xu's asteroid game in CS 3310 at the University of Houston Downtown", "Press s to play the game. Press i for instruction");
      break;
    case INSTRUCTION:
      drawInstruction("Instruction: ", "* Press Space to shoot.                                                              * It takes 10 bullet to destroy a bomb.                                   * It takes 2 bullet to destroy a gold.                                       * You have to collect all the gold and destroy all the bomb on time to win the game.                                                               * Drive your gold cart toward the gold to collect.                                     * Drive your gold cart toward the bomb will lose the game", "Press s to play the game");
      break;
    case PAUSE:
      drawScreen("PAUSED", "Press p to resume");
      break;
    case GAMEOVERWIN:
      drawScreen("YOU WON", "Score: " + str(finalScore) + " . Press s to keep conquering");
       asteroidDestroyed = 0;//reset to 0 every time game is over
       numGoldCollected = 0;
       bulletShot = 0;
       timer.start();
      break;
     case GAMEOVERLOSE:
      drawScreen("YOU LOSE", "Score: " + str(finalScore) + ". Press s to try again");
      asteroidDestroyed = 0; //reset to 0 every time game is over
      numGoldCollected = 0;
      goldDestroyed = 0;
      bulletShot = 0;
      timer.start();
      break;
    case PLAY:
     
      background(0);
      int timeDisplay = timer.getCurrentTime()/1000;
      drawScore("Bullet left: " + bulletCap, "Score: " + (asteroidDestroyed + numGoldCollected) , "Time: " + (str(timeDisplay) + " / " + str(timer.totalTime/1000)));
      //drawScore("Gold Collected: ", str(numGoldCollected));
      cart.update();
      cart.render(); 
      if(cart.checkCollection(golds)) {
            numGoldCollected++;
       }
      if(cart.checkCollision(bombs) || goldDestroyed > 0 || bulletCap < 0 || timer.isFinished()) {
            finalScore = asteroidDestroyed + numGoldCollected; 
            gameState = GAMEOVERLOSE;}
      else if ((bombs.size() == 0) && (golds.size()) == 0){
          finalScore = asteroidDestroyed + numGoldCollected;   
          gameState = GAMEOVERWIN;
      }
      else
      {                    
          for(int i = 0; i < bullets.size(); i++)
          {    
             bullets.get(i).update();
             bullets.get(i).render();
    
            if(bullets.get(i).checkCollision(bombs) ||bullets.get(i).checkCollisionGold(golds) )
            {
               bullets.remove(i);
               i--;
            }                        
          }
          for(int i=0; i<bombs.size(); i++)//(Asteroid a : asteroids)
          {
             bombs.get(i).update();            
             bombs.get(i).render(); 
          }
           for(int i=0; i<golds.size(); i++)//(Asteroid a : asteroids)
          {
             golds.get(i).update();            
             golds.get(i).render(); 
          }
          
         float theta = heading2D(cart.rotation)+PI/2;    
             
         if(leftPressed)
            rotate2D(cart.rotation,-radians(5));
        
         if(rightPressed)
            rotate2D(cart.rotation, radians(5));
   
         if(upPressed)
         {
            cart.acceleration = new PVector(0,shipSpeed); 
            rotate2D(cart.acceleration, theta);
         }    
          
       }
       break;
    }
}

//Initialize the game settings. Create ship, bullets, and asteroids
void initializeGame() 
{
   cart  = new GoldCart();
   bullets = new ArrayList<Bullet>();   
   bombs = new ArrayList<Bomb>();
   golds = new ArrayList<Gold>();
   bulletCap = 50;
   for(int i = 0; i <numBombs; i++)
   {
      PVector position = new PVector((int)(Math.random()*width), 50);      
      bombs.add(new Bomb(position, startingRadius, bombPic));
   }
   for(int i = 0; i <numGold; i++)
   {
      PVector position = new PVector((int)(Math.random()*width), 50);      
      golds.add(new Gold(position, startingRadius, goldPic));
   }
}


//
void fireBullet()
{ 
  pew.play();
  //println("fire");//this line is for debugging purpose
  bulletCap--;
  PVector pos = new PVector(0, cart.r*2);
  rotate2D(pos,heading2D(cart.rotation) + PI/2);
  pos.add(cart.position);
  PVector vel  = new PVector(0, bulletSpeed);
  rotate2D(vel, heading2D(cart.rotation) + PI/2);
  bullets.add(new Bullet(pos, vel));
  bulletShot++;
}



void keyPressed()
{ 
  if(key== 's' && ( gameState==INTRO || gameState==GAMEOVERLOSE || gameState == GAMEOVERWIN || gameState == CREDIT || gameState == INSTRUCTION)) 
  {
    initializeGame();  
    gameState=PLAY;    
  }
  if (key == 'c' && (gameState != CREDIT)){
    gameState = CREDIT;
  } 
  if (key == 'i' && (gameState != INSTRUCTION)){
    gameState = INSTRUCTION;
  } 
  
  if(key=='p' && gameState==PLAY)
    gameState=PAUSE;
  else if(key=='p' && gameState==PAUSE)
    gameState=PLAY;
  
  
  //when space key is pressed, fire a bullet
  if(key == ' ' && gameState == PLAY)
     fireBullet();
   
   
  if(key==CODED && gameState == PLAY)
  {         
     if(keyCode==UP) 
       upPressed=true;
     else if(keyCode==DOWN)
       downPressed=true;
     else if(keyCode == LEFT)
       leftPressed = true;  
     else if(keyCode==RIGHT)
       rightPressed = true;        
  }

}
 

void keyReleased()
{
  if(key==CODED)
  {
   if(keyCode==UP)
   {
     upPressed=false;
     cart.acceleration = new PVector(0,0);  
   } 
   else if(keyCode==DOWN)
   {
     downPressed=false;
     cart.acceleration = new PVector(0,0); 
   } 
   else if(keyCode==LEFT)
      leftPressed = false; 
   else if(keyCode==RIGHT)
      rightPressed = false;           
  } 
}


void drawScreen(String title, String instructions) 
{
  background(0,0,0);
  
  // draw title
  fill(255,100,0);
  textSize(45);
  textAlign(CENTER, BOTTOM);
  text(title, width/2, height/2);
  
  // draw instructions
  fill(255,255,255);
  textSize(20);
  textAlign(CENTER, TOP);
  text(instructions, width/2, height/2);
  
}
void drawInstruction(String title, String instruction, String end){
  background(0,0,0);
  //draw title
  fill(255,100,0);
  textSize(45);
  textAlign(CENTER, BOTTOM);
  text(title, width/2, height/9);
  
  // draw instructions
  fill(255,255,255);
  textSize(20);
  textAlign(CENTER, TOP);
  text(instruction, width/8, height/9, 600,600);

  fill(0,255,255);
  textSize(20);
  textAlign(CENTER, TOP);
  text(end, width/8, height * 0.85, 600,600);

}
void drawScore(String bullet, String score, String time) 
{
  background(0,0,0);
  
  // draw title
  fill(255,100,0);
  textSize(20);
  textAlign(CENTER, BOTTOM);
  text(bullet, width/9, height/9);
  
  // draw instructions
  fill(255,255,255);
  textSize(20);
  textAlign(CENTER, TOP);
  text(score, width/9, height/9);
  
  fill(255,255,0);
  textSize(18);
  textAlign(CENTER, BOTTOM);
  text(time, width /10, height /5 );
  
}
float heading2D(PVector pvect)
{
   return (float)(Math.atan2(pvect.y, pvect.x));  
}
void rotate2D(PVector v, float theta) 
{
  float xTemp = v.x;
  v.x = v.x*cos(theta) - v.y*sin(theta);
  v.y = xTemp*sin(theta) + v.y*cos(theta);
}
