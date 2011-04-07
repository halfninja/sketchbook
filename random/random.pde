
final int PARTICLES = 100;
float[][] particles = new float[PARTICLES][2];

void setup()
{
  size(500,300);
  frameRate(30);
  smooth();
  for (int i=0;i<PARTICLES;i++) 
  {
    particles[i][0] = random(width);  
    particles[i][1] = random(height);
  }
}

void draw()
{
  background(50);
  stroke(255);
  for (int i=0;i<PARTICLES;i++) 
  {
    float[] p = particles[i];
    
    point(p[0], p[1]);  
  }
}

