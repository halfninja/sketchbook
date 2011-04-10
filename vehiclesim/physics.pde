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
    gfx.stroke(255,0,0);
    float x = body.getX();
    float y = body.getY();
    drawLineOff(x, y, velocity);
    
    gfx.stroke(0,255,255);
    drawLineOff(x, y, direction);
    gfx.stroke(128,255,255);
    drawLineOff(x, y, sideways);
  }
}

FBody qbox(float x, float y, float w, float angle) {
  FBox box = new FBox(w, 3);
  box.setRotation(angle);
  box.setPosition(x,y);
  box.setStatic(true);
  return box;
}

void stupidCar() {
    Vehicle car = new Vehicle(20,10);
    if (vehicles.size() % 2 == 0) {
      car.setRotation(0);
      car.setPosition(20, height/2 + random(30));
      car.setVelocity(400, 0);
    } else {
      car.setRotation(-PI/2.0);
      car.setPosition(width/2, height-50);
      car.setVelocity(0, -400); 
    }
    vehicles.add(car); 
}

void resetWorld() {
  world.clear();  
  world.setGravity(0,0);
  world.setEdges();
}
