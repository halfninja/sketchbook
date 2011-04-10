import processing.opengl.*;

final boolean drawText = false;
final int spawnRate = 50;

// Perlin force field
final float noiseSize = 100;
final float friction = 0.95;
final float force = 0.4;
final float fieldMorphRate = 0.05;

void setup() {
  size(1024,512, OPENGL);
  background(0);
  PFont guiFont = loadFont("coolfont.vlw");
  textFont(guiFont);
  smooth();
}

// few static PVectors to work with.
PVector v1 = new PVector();
PVector v2 = new PVector();

void draw() {
  fill(0,0,0,32);
  rect(0,0,width,height);

  // spawn a bunch of particles around the edge
  for (int i=0; i<spawnRate; i++) {  
    boolean opposite = randomb();
    boolean side = randomb();
    Particle particle = spawnParticle();
    if (side) {
      particle.x = (opposite)?width:0;
      particle.y = random(height);
      particle.vx = opposite?-1:1;
    } else {
      particle.x = random(width);
      particle.y = (opposite)?height:0; 
      particle.vy = opposite?-1:1;
    }
  }
  
  
  int l = particles.size();
  for (int i=l-1; i>=0; --i) {
    Particle p = (Particle)particles.get(i); 
    
    if (!p.active) continue;
    
    int m = (int)((abs(mag(p.vx,p.vy))-1)*30);
    stroke(255,255,255,m);
    
    if (mousePressed) { //fatal attraction
      v1.set(mouseX,mouseY,0);
      v1.sub(p.x,p.y,0);
      float distance = v1.mag() * 0.1;
      if (distance > 10) { //nip div/0 in the bud
        v1.div(distance*distance);
        p.vx += v1.x;
        p.vy += v1.y;
      }
    }
    
    // Multiply by 15 to get a spread of angles roughly between 0 and 2PI
    float perlin = noise(p.x/noiseSize,p.y/noiseSize, second()*fieldMorphRate) * 15;
    p.vx *= friction;
    p.vy *= friction;
    p.vx += cos(perlin) * force;
    p.vy -= sin(perlin) * force;
    
    float ox = p.x;
    float oy = p.y;
    p.x += p.vx;
    p.y += p.vy;
    line(ox,oy,p.x,p.y);
    
    if (p.x < 0 || p.x > width || p.y < 0 || p.y > height) {
      killParticle(i, p);
    }
  }
  
  if (drawText) {
    noStroke();
    fill(0);
    rect(5,5,170,90);
    fill(255);
    text("FPS:  "+(int)frameRate, 10, 30);
    text("Num:  "+particles.size(), 10, 60);
    text("Live: "+aliveParticles, 10, 90);
  }
  
  if (frameCount % 25 == 0) {
    //println("Particles: " + particles.size()); 
  }
  
  //saveFrame("output/%04d.png");
}

void keyPressed() {
  if (key == 's') {
    saveFrame("screeny.png");
  } 
}

boolean randomb() {
  return (int)random(2) == 1; 
}
