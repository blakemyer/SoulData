// Daniel Shiffman
// http://codingtra.in
// http://patreon.com/codingtrain
// Code for: https://youtu.be/akM4wMZIBWg
import muthesius.net.*;
import org.webbitserver.*;
import peasy.*;
import ddf.minim.*;//audiovisuals

Minim minim;//audiovisuals
AudioInput in;//audiovisuals


boolean voice;

WebSocketP5 socket;
PeasyCam cam;

PVector[][] globe;
int total = 120; //subdivisions

float offset = 0;

float m = 0;
float mchange = 0;

float gs = 0;
float gsn = 0;
float ge = 60;
float gen = 60;
float m1 = 6;
float m2 = 9;
float n1 = 1;
float n2 = -.4;
float n3 = 3;

float m1n = 6;
float m2n = 9;
float n1n = 1;
float n2n = -.4;
float n3n = 3;

float as = 0.04;

float rotateval = 0.0;

String mic = "Your words appear here";

void setup() {
  fullScreen(P3D);
  //textMode(SHAPE);
  colorMode(HSB, 360, 100, 100, 100);
  //cam = new PeasyCam(this, 700);
  //camera(40.0, 700.0, 120.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0);
  lightSpecular(100,100,100);
  smooth(8);
  noCursor();
  minim = new Minim(this);//audiovisuals
  minim.debugOn();//audiovisuals
  in = minim.getLineIn(Minim.STEREO, 512);//audiovisuals
  PFont soulFont;
  soulFont = loadFont("Akkurat-Mono-13.vlw");
  textFont(soulFont);
  globe = new PVector[total+1][total+1];
      {
    socket = new WebSocketP5(this,8080);
  }

}

float a = 1.1;
float b = 1.1;

float supershape(float theta, float m, float n1, float n2, float n3) {
  float t1 = abs((1/a)*cos(m * theta /4));
  t1 = pow(t1, n2);
  float t2 = abs((1/b)*sin(m * theta/4));
  t2 = pow(t2, n3);
  float t3 = t1 + t2;
  float r = pow(t3, - 1 / n1);
  return r;
}

void draw() {
  
  m = map(sin(mchange), -1, 1, m1, m2);//
  mchange += as;//animationspeed 
  background(0);
  noStroke();
  for(int i = 300; i < in.bufferSize() - 1; i++)
  {
    pushStyle();
    pushMatrix();
    //rotateZ(PI/3);
    rotateZ(radians(90));
    translate(250, -200);
    stroke(ge,100,100);
    line(i, 50 + in.left.get(i)*80, i+1, 50 + in.left.get(i+1)*80);
    popMatrix();
    popStyle();
  }
  textSize(13);
  textLeading(19);
  textMode(SHAPE);
  fill(0,0,100);
  pushMatrix();
  rotateZ(radians(90));
  text("MIC INPUT", 550, -221);
  text("WORDs", 160, -221);
  text(mic,160,-200,166,200);
  pushStyle();
  textAlign(RIGHT);
  fill(0,0,70);
  text("FORMs", 136, -221);
  text(m1 + ":M1",-30,-200,166,20);
  text(n1 + ":N1",-30,-179,166,20); 
  text(n2 + ":N2",-30,-158,166,20); 
  text(n3 + ":N3",-30,-137,166,20);
  text(gs + ":GS",-30,-116,166,20); 
  text(ge + ":GE",-30,-95,166,20); 
  popStyle();
  popMatrix();
  rotateval += 0.007;
  //println(rotateval);
  translate(931,450);
  scale(2);
  rotateY(rotateval);
  rotateZ(rotateval);
  float r = 200;//radius
  for (int i = 0; i < total+1; i++) {
    float lat = map(i, 0, total, -HALF_PI, HALF_PI);  
    float r2 = supershape(lat, m, n1, n2, n3);
    for (int j = 0; j < total+1; j++) {
      float lon = map(j, 0, total, -PI, PI);
      float r1 = supershape(lon, m, n1, n2, n3);
      //supershape(lon, m=the basis for the following numbers , d, generalsize, e)typically have e > d to yeild more interesting shapes
      float x = r * r1 * cos(lon) * r2 * cos(lat);
      float y = r * r1 * sin(lon) * r2 * cos(lat);
      float z = r * r2 * sin(lat);
      globe[i][j] = new PVector(x, y, z);
    }
  }
  
  if(m1 < m1n){
    m1 = m1n + .09;}
    else if(m1 > m1n){
      m1 = m1 - .09;}
      else if(m1 == m1n){};
if(m2 < m2n){
    m2 = m2n + .09;}
    else if(m2 > m2n){
      m2 = m2 - .09;}
      else if(m2 == m2n){};
if(n1 < n1n){
    n1 = n1n + .09;}
    else if(n1 > n1n){
      n1 = n1 - .09;}
      else if(n1 == n1n){};
 if(n2 < n2n){
    n2 = n2n + .09;}
    else if(n2 > n2n){
      n2 = n2 - .09;}
      else if(n2 == n2n){};
 if(n3 < n3n){
    n3 = n3n + .09;}
    else if(n3 > n3n){
      n3 = n3 - .09;}
      else if(n3 == n3n){};
      
  if(gs < gsn){
    gs = gs + 1;}
    else if(gs > gsn){
      gs = gs - 1;}
      else if(gs == gsn){};
      
  if(ge < gen){
    ge = ge + 1;}
    else if(ge > gen){
      ge = ge - 1;}
      else if(ge == gen){};

  for (int i = 0; i < total; i++) {
    float hu = map(i, 0, total, gs, ge);//colors i, from 0 to total then from 0, 0)
    //control the two gradient points with the last two numbers
    fill(hu, 100, 100);
    beginShape(TRIANGLE_STRIP);
    for (int j = 0; j < total+1; j++) {
      PVector v1 = globe[i][j];
      vertex(v1.x, v1.y, v1.z);
      PVector v2 = globe[i+1][j];
      vertex(v2.x, v2.y, v2.z);

    }
    endShape();
  }
  //fill(255);
}
    
      
void stop(){
  socket.stop();
  in.close();//audiovisuals
  minim.stop();//audiovisuals
  super.stop();//audiovisuals
}

void websocketOnMessage(WebSocketConnection con, String msg){
  for (int i = 0; i < msg.length(); i++) {
  if(msg.contains("test")) println("thanks");
  char letter = msg.charAt(i);
  
  switch(letter) {
  case 'a':
  case 'A': 
    println("Alpha");  
    gsn = 200;
    gen = 270;
    m1n = 14;
    m2n = 20;
    n1n = n1n + 3;
    n2n = n2n - 10;
    n3n = n3n+ 2;
    break;
  case 'b':
  case 'B': 
    println("Bravo");
    gsn = 190;
    gen = 230;
    m1n = 1;
    m2n = 2;
    n1n = 1;
    n2n = 2;
    n3n = .4;
    break;
  case 'c':
  case 'C': 
    println("Classic");
    gsn = 0;
    gen = 60;
    m1n = 6;
    m2n = 9;
    n1n = 1;
    n2n = -.4;
    n3n = 3;
    break;
  case 'd':
  case 'D': 
    println("Data");
    gsn = 30;
    gen = 180;
    m1n = 3;
    m2n = 4;
    n1n = n1n + 3;
    n2n = n2n - 2;
    n3n = n3n - 1;
    break;
  case 'e':
  case 'E': 
    println("Elpha");
    gsn = 250;
    gen = 360;
    m1n = 3;
    m2n = 9;
    n1n = n1n - 2;
    n2n = n2n + 5;
    n3n = n3n - 1;
    break;
  case 'f':
  case 'F': 
    println("Franklin");
    gsn = 280;
    gen = 360;
    m1n = 1;
    m2n = 3;
    n1n = n1n - 10;
    n2n = n2n + 20;
    n3n = n3n - 1;
    break;
  case 'g':
  case 'G': 
    println("Gorgeous");
    gsn = 280;
    gen = 310;
    m1n = 6;
    m2n = 10;
    n1n = 4;
    n2n = 8;
    n3n = -1;
    break;
  case 'h':
  case 'H': 
    println("Happy");
    gsn = 150;
    gen = 220;
    m1n = 2;
    m2n = 10;
    n1n = n1n - 7;
    n2n = n2n + 2;
    n3n = n3n - 1;
    break;
  case 'i':
  case 'I': 
    println("Iliad");
    gsn = 50;
    gen = 150;
    m1n = 1;
    m2n = 3;
    n1n = 5;
    n2n = -3;
    n3n = 5;
    break;
  case 'j':
  case 'J': 
    println("Jump");
    gsn = 100;
    gen = 220;
    m1n = 5;
    m2n = 8;
    n1n = -2;
    n2n = -3;
    n3n = -2;
    break;
  case 'k':
  case 'K': 
    println("Koko");
    gsn = 160;
    gen = 201;
    m1n = 5;
    m2n = 10;
    n1n = n1n + 5;
    n2n = n2n - 4;
    n3n = n3n + 2;
    break;
  case 'l':
  case 'L': 
    println("Lazy");
    gsn = 30;
    gen = 120;
    m1n = 8;
    m2n = 12;
    n1n = n1n + 1;
    n2n = n2n - 2;
    n3n = n3n - 1;
    break;
  case 'm':
  case 'M': 
    println("Mind");
    gsn = 60;
    gen = 190;
    m1n = 10;
    m2n = 14;
    n1n = n1n + 5;
    n2n = n2n - 3;
    n3n = 3;
    break;
  case 'n':
  case 'N': 
    println("Nopes");
    gsn = 100;
    gen = 180;
    m1n = 3;
    m2n = 8;
    n1n = n1n +.5;
    n2n = n2n + 10;
    n3n = n3n - 5;
    break;
  case 'o':
  case 'O': 
    println("Oops");
    gsn = 130;
    gen = 200;
    m1n = 20;
    m2n = 25;
    n1n = 1;
    n2n = 5;
    n3n = -4;
    break;
  case 'p':
  case 'P': 
    println("Puff");
    gsn = 200;
    gen = 280;
    m1n = 10;
    m2n = 15;
    n1n = n1n + 4;
    n2n = n2n + 1;
    n3n = n3n -2;
    break;
  case 'q':
  case 'Q': 
    println("Quality");
    gsn = 60;
    gen = 150;
    m1n = 3;
    m2n = 13;
    n1n = n1n + 1;
    n2n = n2n - 2;
    n3n = n3n + 5;
    break;
  case 'r':
  case 'R': 
    println("Right");
    gsn = 200;
    gen = 250;
    m1n = 0;
    m2n = 4;
    n1n = n1n + 3;
    n2n = n2n + 2;
    n3n = n3n - 1;
    break;
  case 's':
  case 'S': 
    println("Super");
    gsn = 0;
    gen = 360;
    m1n = 5;
    m2n = 15;
    n1n = n1n + 2;
    n2n = n2n + 3;
    n3n = n3n - 5;
    break;
  case 't':
  case 'T': 
    println("Tata-Reset");  
    gsn = 200;
    gen = 270;
    m1n = 18;
    m2n = 20;
    n1n = 5;
    n2n = 1;
    n3n = -1;
    break;
  case 'u':
  case 'U': 
    println("Upper");  
    gsn = 100;
    gen = 200;
    m1n = 19;
    m2n = 25;
    n1n = 5;
    n2n = 1;
    n3n = -1;
    break;
  case 'v':
  case 'V': 
    println("Vapor");  
    gsn = 280;
    gen = 350;
    m1n = 20;
    m2n = 30;
    n1n = n1n - 4;
    n2n = n2n - 2;
    n3n = n3n + 2;
    break;
  case 'w':
  case 'W': 
    println("Wawa");  
    gsn = 150;
    gen = 250;
    m1n = 5;
    m2n = 10;
    n1n = 10;
    n2n = 2;
    n3n = 15;
    break;
  case 'y':
  case 'Y': 
    println("Yeti");  
    gsn = 100;
    gen = 200;
    m1n = 20;
    m2n = 30;
    n1n = n1n + 2;
    n2n = n2n - 1;
    n3n = n3n + 10;
    break;
  case 'z':
  case 'Z': 
    println("Zoo");  
    gsn = 0;
    gen = 360;
    m1n = 50;
    m2n = 100;
    n1n = 10;
    n2n = 8;
    n3n = 1;
    break;
  
    }
  }
  voice = true;
  println(msg);
  mic = msg + mic;
}

void websocketOnOpen(WebSocketConnection con){
  println("A client joined");
}

void websocketOnClosed(WebSocketConnection con){
  println("A client left");
}

void keyPressed(){
if(key==48){background(0);}

if(mousePressed == true) {
       as = as + 0.05;
       m1n = 0;
  } else { 
    as = 0.04;
    m1n = m2 - 2;
  };
}