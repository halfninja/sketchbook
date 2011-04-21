import processing.pdf.*;
import processing.opengl.*;
import fisica.*;
import java.util.LinkedList;

FWorld world;

// Draw shitloads of debug lines?
boolean linefest = false;
boolean gui = true;

float textY = 24;

ArrayList vehicles = new ArrayList();

Vehicle bestCar;

boolean pdf = false;

PFont font;

PGraphics gfx;

final String PDF_FILE = "output/snapshot.pdf";

String[] OH_GOODNESS = new String[] { "FUCK", "SHIT", "BASTARD", "OW", "SON OF A" };

class Expletive {
  private PVector position = new PVector();
  private String text;
  private int age = 30;
  public FBody body;
  public Expletive(FBody owner, String text, PVector pos) {
    body = owner;
    position.set(pos);
    this.text = text;
  }
  public void draw() {
    textFont(font);
    fill(255,0,0);
    text(this.text, position.x, position.y);
    position.add(0,-1,0); 
    age--;
  }
  public boolean isDead() {
    return age <= 0; 
  }
}

LinkedList expletives = new LinkedList();

void setup() {
  size(600, 400);
  smooth();
  
  Fisica.init(this);
  
  world = new FWorld();
  resetWorld();
  
  frameRate(60);

  font = loadFont("Ubuntu.vlw");
  initText();
  
  gfx = g;
  
  randomSeed(3);
}

void initText() {
  textFont(font);
}

void draw() {  
  textY = 24;
  
  if (pdf) {
    // create as a separate Graphics so we can pass it to Fisica
    gfx = createGraphics(width, height, PDF, PDF_FILE);
    gfx.beginDraw();
    initText();
  } else {
    background(255);
  }
  noStroke();
  
  world.step();
  world.draw(gfx);
  
  if (frameCount < 600 && frameCount % 30 == 0) {
    stupidCar();  
  }
  
  for (int i=0; i<vehicles.size(); i++) {
    Vehicle vehicle = (Vehicle)vehicles.get(i);
    vehicle.update();
  }
  
  if (gui && !pdf) {
    fill(200);
    statusLine("c to spawn car");
    statusLine("d toggles linespam, g toggles this");
    statusLine(vehicles.size()+" vehicles");
    statusLine(floor(frameRate) + " FPS");
  }
  
  if (pdf) {
    gfx.dispose();
    gfx.endDraw();
    gfx = g;
    pdf = false; 
    println("PDF created as " + PDF_FILE);
  }
  
  for (Iterator it=expletives.iterator(); it.hasNext(); ) {
    Expletive e = (Expletive)it.next();
    if (e.isDead()) {
      it.remove();
    } else {
      e.draw(); 
    }
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
  } else if (keyCode == DELETE) {
    resetWorld();
  } else if (key == 'p') {
    pdf = true; 
  }
  
  if (bestCar == null) return;
  switch(keyCode) {
    case LEFT: 
      bestCar.setSteering(-0.8);
      break;
    case RIGHT:
      bestCar.setSteering(0.8);
      break;
    case UP:
      bestCar.setAcceleration(100);
      break;
    case DOWN:
      bestCar.setAcceleration(-100);
      break;
  } 
}

void keyReleased() {
  if (bestCar == null) return;
  switch(keyCode) {
    case LEFT: case RIGHT:
      bestCar.setSteering(0);
      break;
    case UP: case DOWN:
      bestCar.setAcceleration(0);
      break;
  } 
}

void contactStarted(FContact contact) {
  FBody body = contact.getBody1();
  if (linefest) {
    body.setFill(255, 0, 0);
    
    noFill();
    stroke(255);
    ellipse(contact.getX(), contact.getY(), 30, 30);
  }
  
  for (Iterator it=expletives.iterator(); it.hasNext(); ) {
    Expletive e = (Expletive)it.next();
    if (e.body == body) {
      return; 
    }
  }
  
  int r = int(random(OH_GOODNESS.length));
  expletives.add(new Expletive(body, OH_GOODNESS[r], new PVector(contact.getX(), contact.getY())));
}

void contactEnded(FContact contact) {
  if (linefest) {
    FBody body = contact.getBody1();
    body.setFill(255);
  }
}




