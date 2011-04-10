import processing.pdf.*;
import processing.opengl.*;
import fisica.*;

FWorld world;

// Draw shitloads of debug lines?
boolean linefest = false;
boolean gui = true;

float textY = 24;

ArrayList vehicles = new ArrayList();

boolean pdf = false;

PFont font;

PGraphics gfx;

final String PDF_FILE = "output/snapshot.pdf";

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
  if (linefest) {
    FBody body = contact.getBody1();
    body.setFill(255);
  }
}




