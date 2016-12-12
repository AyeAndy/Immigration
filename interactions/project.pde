import ddf.minim.analysis.*;
import ddf.minim.*;
import ddf.minim.signals.*;
 
Minim minim;
AudioInput in;

float gain = 200;
int tbase = 1024;
float[] myBuffer;

void setup()
{
  size(900, 900, P3D);
 
  minim = new Minim(this);
  in = minim.getLineIn(Minim.MONO,2048);

  myBuffer = new float[in.bufferSize()];
}
 
void draw()
{
  background(0);
  stroke(random(255));
  
  for (int i = 0; i < in.bufferSize(); ++i) {
    myBuffer[i] = in.left.get(i);
  }
  
  int offset = 0;
  float maxdx = 0;
  for(int i = 0; i < myBuffer.length/4; ++i)
  {
      float dx = myBuffer[i+1] - myBuffer[i]; 
      if (dx > maxdx) {
        offset = i;
        maxdx = dx;
      }
  }
  
  color c = color(random(255), random(255), random(255));
  
  int mylen = min(tbase, myBuffer.length-offset);
  for(int i = 0; i < mylen - 1; i++)
  {
    float x1 = map(i, 0, tbase, 0, width);
    float x2 = map(i+1, 0, tbase, 0, width);
    line(x1, 100 - myBuffer[i+offset]*gain, x2, 100 - myBuffer[i+1+offset]*gain);
    fill(c);
    ellipse(random(900), random(400)+400, myBuffer[i+offset]*gain, myBuffer[i+1+offset]*gain);
  }
}
 
void stop()
{
  in.close();
  minim.stop();
 
  super.stop();
}