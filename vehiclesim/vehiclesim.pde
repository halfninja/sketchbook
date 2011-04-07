/**
 *  Droppings Remade
 *
 *  This example shows how to create a simple remake of my favorite
 *  soundtoy:<br/>
 *
 *    <a href=http://www.balldroppings.com/>BallDroppings</a> 
 *       by Josh Nimoy.
 */
 
import fisica.*;

FWorld world;

void setup() {
  size(400, 400);
  smooth();
  
  Fisica.init(this);
  
  world = new FWorld();
  world.setGravity(0,0);
  
  frameRate(24);

  world.add(qbox(10,200,300,0));
}

void addCar(float x, float y, float angle) {
   
}

/*
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
  background(0);
  noStroke();
  
  world.step();
  world.draw(this);
}

void keyPressed() {
  if (key == 'c') {
    FBox car = new FBox(20,8);
    car.setNoStroke();
    car.setFill(255);
    car.setRotation(PI * 1.5);
    car.setPosition(100+random(10), 20);
    car.setVelocity(0, 400);
    car.setRestitution(0.3);
    car.setDamping(0.4);
    world.add(car);
  } 
}

void contactStarted(FContact contact) {
  FBody body = contact.getBody1();
  body.setFill(255, 0, 0);
  
  noFill();
  stroke(255);
  ellipse(contact.getX(), contact.getY(), 30, 30);
}

void contactEnded(FContact contact) {
  FBody body = contact.getBody1();
  body.setFill(255);
}




