
class Vehicle {
  public FBody chassis;
  private float steer;
  private PVector direction;
  private float acceleration;
  public Vehicle(float len, float wid) {
    chassis = new FBox(len, wid);
    //chassis.setNoStroke();
    //chassis.setFill(255);
    chassis.setNoFill();
    chassis.setStroke(0,128,0);
    chassis.setRestitution(0.3);
    chassis.setDamping(0.4);
    chassis.setAngularDamping(5);
    world.add(chassis); 
    direction = unitVector(chassis.getRotation());
  }
  public void update() {
    direction = unitVector(chassis.getRotation());
    applyLateralFriction(chassis);
    float speed = getSpeed();
    if (steer != 0) {
       chassis.addTorque(steer * 0.01 * speed);
    }
    if (acceleration != 0) {
       PVector f = new PVector(direction.x, direction.y);
       f.mult(acceleration);
       chassis.addForce(f.x, f.y); 
    }
  }
  
  public float getSpeed() {
    return mag(chassis.getVelocityX(), chassis.getVelocityY()); 
  }
  
  public void setAcceleration(float acc) {
    this.acceleration = acc; 
  }
  
  public void setPosition(float x, float y) {
    chassis.setPosition(x, y);
  }
  
  public void setRotation(float r) {
    chassis.setRotation(r); 
  }
  
  public void setVelocity(float x, float y) {
    chassis.setVelocity(x, y);
  }
  
  public void setSteering(float steer) {
    this.steer = steer;
  }
}

