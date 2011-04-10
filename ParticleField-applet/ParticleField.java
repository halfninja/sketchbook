import processing.core.*; 
import processing.xml.*; 

import processing.opengl.*; 

import java.applet.*; 
import java.awt.*; 
import java.awt.image.*; 
import java.awt.event.*; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class ParticleField extends PApplet {



final boolean drawText = false;
final int spawnRate = 50;

// Perlin force field
final float noiseSize = 100;
final float friction = 0.95f;
final float force = 0.4f;
final float fieldMorphRate = 0.05f;

public void setup() {
  size(1024,512, OPENGL);
  background(0);
  PFont guiFont = loadFont("coolfont.vlw");
  textFont(guiFont);
  smooth();
}

// few static PVectors to work with.
PVector v1 = new PVector();
PVector v2 = new PVector();

public void draw() {
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
      float distance = v1.mag() * 0.1f;
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

public void keyPressed() {
  if (key == 's') {
    saveFrame("screeny.png");
  } 
}

public boolean randomb() {
  return (int)random(2) == 1; 
}
public class Particle {
  float x,y;
  float vx,vy;
  int c;
  public boolean active = true;
  public Particle() {
     
  }
  public Particle next; //linkedlist
}


public class ParticleList {
  public Particle first;
  public Particle last; 
}

ArrayList particles = new ArrayList();
int unused = -1;
int aliveParticles = 0;

// Naive particle spawn/kill system.

public void killParticle(int i, Particle p) {
  particles.remove(i);
}

public Particle spawnParticle() {
  Particle p = new Particle();
  particles.add(p);
  return p;
}

// Attempt at clever particle re-use system, to reduce memory churn.
// In practice it seems the same or worse than the naive system above.

/*
void killParticle(int i, Particle p) {
  p.active = false;
  unused = i; 
  aliveParticles--;
}

Particle spawnParticle() {
  Particle p;
  aliveParticles++;
  if (unused > -1) {
    p = (Particle)particles.get(unused);
    p.active = true;
    unused = -1;
    return p;
  } else {
    int l = particles.size();
    for (int i=0; i<l; i++) {
      p = (Particle)particles.get(i);
      if (!p.active) {
        p.active = true;
        return p; 
      }
    }
    p = new Particle();
    particles.add(p);
    return p;
  }
}
*/


  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#DFDFDF", "ParticleField" });
  }
}
