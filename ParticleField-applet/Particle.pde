public class Particle {
  float x,y;
  float vx,vy;
  color c;
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

void killParticle(int i, Particle p) {
  particles.remove(i);
}

Particle spawnParticle() {
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

