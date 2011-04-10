
import fisica.*;

FWorld world;

// Draw shitloads of debug lines?
boolean linefest = true;
boolean gui = true;

float textY = 24;

void setup() {
  size(600, 400);
  smooth();
  
  Fisica.init(this);
  
  world = new FWorld();
  world.setGravity(0,0);
  world.setEdges();
  
  frameRate(60);

  //world.add(qbox(10,200,300,PI/6));
  
  textFont(loadFont("Ubuntu.vlw"));
}

void addCar(float x, float y, float angle) {
   
}

void drawLineOff(float x, float y, PVector c) {
  line(x, y, x+c.x, y+c.y);
}


void applyLateralFriction(FBody body) {
  // Lower to make sideways skidding easier.
  final float lateralFrictionCoefficient = 4.0;
  
  PVector velocity = new PVector(body.getVelocityX(), body.getVelocityY());
  
  // Work out a unit vector for direction we're facing, and use that to calculate sideways
  float r = body.getRotation();
  PVector direction = new PVector(cos(r), sin(r));
  PVector sideways = new PVector(-direction.y, direction.x);

  // dot product represents how aligned velocity is with the sideways direction 
  float d = velocity.dot(sideways);
  // apply a force in the opposite direction, to act as lateral friction
  sideways.mult(-lateralFrictionCoefficient * d);
  body.addForce(sideways.x, sideways.y);
  
  if (linefest) {
    stroke(255,0,0);
    float x = body.getX();
    float y = body.getY();
    drawLineOff(x, y, velocity);
    
    stroke(0,255,255);
    drawLineOff(x, y, direction);
    stroke(128,255,255);
    drawLineOff(x, y, sideways);
  }
}

/*
version of applyLateralFriction from an ActionScript version of a car sim.
The version here totally kills all sideways motion, whereas I'm just applying
a force so it's possible to skid sideways to a small extent.

void killOrthogonalVelocity(FBody body){
	PVector localPoint = new PVector();
	PVector b2Vec2 = targetBody.GetLinearVelocityFromLocalPoint(localPoint);
 
	var sidewaysAxis = targetBody.GetXForm().R.col2.Copy();
	sidewaysAxis.Multiply(b2Math.b2Dot(velocity,sidewaysAxis))
 
	targetBody.SetLinearVelocity(sidewaysAxis);//targetBody.GetWorldPoint(localPoint));
}
*/

FBody qbox(float x, float y, float w, float angle) {
  FBox box = new FBox(w, 3);
  box.setRotation(angle);
  box.setPosition(x,y);
  box.setStatic(true);
  return box;
}

void draw() {
  textY = 24;
  
  background(0);
  noStroke();
  
  world.step();
  world.draw(this);
  
  if (frameCount == 1 || frameCount == 6) {
    stupidCar();  
  }
  
  ArrayList<FBody> bodies = world.getBodies();
  for (int i=0; i<bodies.size(); i++) {
    FBody body = (FBody)bodies.get(i); 
    applyLateralFriction(body);
  }
  
  if (gui) {
    fill(255);
    statusLine("c to spawn car");
    statusLine("d toggles linespam, g toggles this");
    statusLine(bodies.size()+" bodies");
    statusLine(frameRate + " FPS");
  }
}

void statusLine(String msg) {
  text(msg, width - textWidth(msg) - 20,textY);
  textY += 20;
}

void keyPressed() {
  if (key == 'c') {
    stupidCar();
  } else if (key == 'd') {
    linefest = !linefest; 
  } else if (key == 'g') {
    gui = !gui; 
  }
}

void stupidCar() {
    FBox car = new FBox(20,8);
    car.setNoStroke();
    car.setFill(255);
    car.setRotation(0);
    car.setPosition(20, height/2 + random(30));
    car.setVelocity(400, 0);
    car.setRestitution(0.3);
    car.setDamping(0.4);
    car.setAngularDamping(5);
    world.add(car); 
}

void contactStarted(FContact contact) {
  if (linefest) {
    FBody body = contact.getBody1();
    body.setFill(255, 0, 0);
    
    noFill();
    stroke(255);
    ellipse(contact.getX(), contact.getY(), 30, 30);
  }
}

void contactEnded(FContact contact) {
  FBody body = contact.getBody1();
  body.setFill(255);
}




