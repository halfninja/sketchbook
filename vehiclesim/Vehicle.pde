
class Vehicle {
  public FBody chassis;
  private float steer;
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
  }
  public void update() {
    applyLateralFriction(chassis);
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

