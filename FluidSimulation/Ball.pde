class Ball {
  PVector pos;
  int rad;
  PVector vel;
  Ball(PVector p, int r) {
    this.pos=p;
    this.rad=r;
    this.vel=new PVector(0, 0);
  }

  void applyforce(PVector f) {
    this.vel.add(f);
    //this.vel.setMag(constrain(this.vel.mag(),0,80));
    this.vel.mult(0.99);
  }

  void update() {
    if (this.pos.x-this.rad<0) {
      this.vel.x=abs(this.vel.x)*0.8;
    }
    //if (this.pos.x+this.rad>width/SCALE) {
    //  this.vel.x=-abs(this.vel.x)*0.8;
    //}
    if (this.pos.y+this.rad>height/SCALE) {
      this.vel.y=-abs(this.vel.y)*0.65;
    }

    this.pos.add(this.vel);
    
  }

  void render() {
    fill(100);
    circle(this.pos.x*SCALE, this.pos.y*SCALE, this.rad*SCALE*2);
  }
}
