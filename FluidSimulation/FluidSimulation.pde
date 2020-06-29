// Fluid Simulation
// Daniel Shiffman
// https://thecodingtrain.com/CodingChallenges/132-fluid-simulation.html
// https://youtu.be/alhpH6ECFvQ

// This would not be possible without:
// Real-Time Fluid Dynamics for Games by Jos Stam
// http://www.dgp.toronto.edu/people/stam/reality/Research/pdf/GDC03.pdf
// Fluid Simulation for Dummies by Mike Ash
// https://mikeash.com/pyblog/fluid-simulation-for-dummies.html

final int N = 128;
final int iter = 16;
final int SCALE = 4;
float noiseScl=0.1;
float t = 0;
float dt=0.2;
float diffusion=0;
float viscosity=0.000001;
float ballPush=0.4;


PImage image;
Fluid fluid;
Fluid fluidg;
Fluid fluidb;
Ball ball;
PVector gravity=new PVector(0,0.9);

void settings() {
  size(N*SCALE, N*SCALE);
}

void setup() {
  image = loadImage("cat.jpeg");
  image.resize(width/SCALE,height/SCALE);
  fluid = new Fluid(dt,diffusion,viscosity);
  fluidg = new Fluid(dt,diffusion,viscosity);
  fluidb = new Fluid(dt,diffusion,viscosity);
  PVector pos=new PVector(-20,-15);
  ball=new Ball(pos,10);
  PVector f=new PVector(12,0);
  ball.applyforce(f);
  
  for (int x=0;x<width/SCALE;x++){
   for (int y=0;y<height/SCALE;y++){
    //float amt=map(noise((x)*noiseScl,(y)*noiseScl),0,1,10,220);
    float amt=map(red(image.get(x,y)),0,255,0,200);
    fluid.addDensity(x,y,amt);
    amt=map(green(image.get(x,y)),0,255,0,200);
    fluidg.addDensity(x,y,amt);
    amt=map(blue(image.get(x,y)),0,255,0,200);
    fluidb.addDensity(x,y,amt);
   }
  }
  
}

//void mouseDragged() {
//  //fluid.addDensity(mouseX/SCALE,mouseY/SCALE,random(50, 150));
//  int x=int(mouseX/SCALE);
//  int y=int(mouseY/SCALE);
//  fluid.addVelocity(x,y,abs(mouseX-pmouseX),abs(mouseY-pmouseY));
//}

void draw() {
  background(0);
  ball.applyforce(gravity);
  ball.update();
  PVector dir=ball.vel.copy();
  dir.setMag(ball.rad);
  dir.add(ball.pos);
  fluid.addVelocity(int(dir.x),int(dir.y),ball.vel.x*ballPush,ball.vel.y*ballPush);
  fluidg.addVelocity(int(dir.x),int(dir.y),ball.vel.x*ballPush,ball.vel.y*ballPush);
  fluidb.addVelocity(int(dir.x),int(dir.y),ball.vel.x*ballPush,ball.vel.y*ballPush);
  

  for (int x=int(ball.pos.x-ball.rad);x<ball.pos.x+ball.rad;x++){
    for(int y=int(ball.pos.y-ball.rad);y<ball.pos.y+ball.rad;y++){
      PVector curr=new PVector(x,y);
      if (curr.dist(ball.pos)<float(ball.rad)){
        
        PVector v=curr.copy();
        v.sub(ball.pos);
        v.setMag(0.1);
        fluid.addVelocity(int(curr.x),int(curr.y),v.x,v.y);
        fluidg.addVelocity(int(curr.x),int(curr.y),v.x,v.y);
        fluidb.addVelocity(int(curr.x),int(curr.y),v.x,v.y);
      }
    }
  }
  fluid.step();
  fluidg.step();
  fluidb.step();
  float[] reds=fluid.getD(); //lmao
  float[] greens = fluidg.getD();
  float[] blues = fluidb.getD();
  float rmax=max(reds);
  float gmax=max(greens);
  float bmax=max(blues);
  for (int x=0;x<width;x++){
   for (int y=0;y<height;y++){
     int i=x+y*width;
     float r=map(reds[i],0,rmax,0,255);
     float g=map(greens[i],0,gmax,0,255);
     float b=map(blues[i],0,bmax,0,255);
    set(x,y,color(r,g,b)); 
   }
  }
  //fluid.renderD();
  //fluid.renderV();
  //fluid.fadeD();
  
  ball.render();
}
