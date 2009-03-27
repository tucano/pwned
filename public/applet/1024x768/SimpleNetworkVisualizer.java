import processing.core.*; 
import processing.xml.*; 

import traer.physics.*; 
import traer.animation.*; 

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

public class SimpleNetworkVisualizer extends PApplet {




// CONSTANTS /////////////////////////////////
final int FRAMERATE = 24;
final float PYSICSTICK = 1.0f;            // advance the simulation by some time t, or by the default 1.0. 

// CLASSES /////////////////////////////////
Config c;
Config classic;
Config mrblue;
Config web;
Config directed;

ParticleSystem physics;
Smoother3D centroid;
NetworkReader reader;
AnnotationReader annotation;
Network network;

PFont font;

// GLOBAL VARS and SWITCHERS ////////////////////////////////
int counter;                // counter frames
int objcounter;             // counter objects
boolean toggle_resize;      // Update centroid T/F
boolean toggle_centroid;    // show hide centroid
boolean toggle_zoomout;     // Toggle ZoomOut (set update to false and zoom out)
boolean toggle_zoombox;     // remember a box is drawing
int prevX;                  // store start X in dragging
int prevY;                  // store start Y in dragging
int speed;                  // regulate speed add_node

public void setup()
{
  // size must stay in the main file with real numbers 
  // or the Proccessing applet will be 100,100 size.... bug?!
  size( 1024, 768 );         
  frameRate( FRAMERATE );
  config();      // this is called one time
  initialize();  // this is called on reset/load_new
}

public void draw()
{
  physics.tick( PYSICSTICK );
  
  if ( ( toggle_resize ) && ( physics.numberOfParticles() > 0 )) updateCentroid();
    
  centroid.tick();     // advance time for the smoother.
  background( c.b_rgb[0], c.b_rgb[1], c.b_rgb[2] );
  
  // ******* Space coordinates ***********
  pushMatrix();
  translate( width/2 , height/2 );
  scale( centroid.z() );
  translate( -centroid.x(), -centroid.y() );
  
  // add nodes each C % n == 0
  if (counter % speed == 0) {
    addEdge(objcounter);
    objcounter += 1;
  }
  counter += 1;
  
  if (c.draw_edges) drawEdges();
  if (c.draw_nodes) drawNodes(); 
  if (toggle_centroid) drawCentroid();
  
  popMatrix();

  // ******* Viewport coordinates ***********  
  network.update(mouseX, mouseY);
  if (toggle_zoombox) drawZoomBox( prevX, prevY, mouseX, mouseY ); 
}

public void addEdge(int n) {
  Node[] edge = network.add_edge(reader.get_edge(n)); 
  if (edge == null) return;

  Particle p = edge[0].particle;
  Particle q = edge[1].particle;
  // if we add by edges we must add spacers 2 times
  // reversing particles... was a bug in socialzoo ;-)
  addSpacersToNode( p, q );
  addSpacersToNode( q, p );
  makeEdgeBetween( p, q );
  p.moveTo( q.position().x() + random( -1, 1 ), q.position().y() + random( -1, 1 ), 0 );
}
/* 
/ Annotatio format: KEY LABEL LINK
*/
class AnnotationReader
{
  
  String[] lines;
  HashMap lines_hash;
  
  AnnotationReader(String filename)
  {
    lines = loadStrings(filename);
    generate_map(lines);
  }
  
  private void generate_map(String[] lines)
  {
    lines_hash = new HashMap();
    for (int i =0; i < lines.length; i++) {
      String[] note = get_line(i);
      if (note != null) {
        lines_hash.put(note[0], i);
      }
    }
  }
  
  public String[] get_annotation(String mykey)
  {
    Object hash_val = lines_hash.get(mykey);
    String i = hash_val.toString();
    int line_index = PApplet.parseInt(i);
    String[] pieces = get_line(line_index);
    String[] annotation = new String[3];
    switch(pieces.length) {
      case 3:
        annotation[0] = pieces[0];
        annotation[1] = pieces[1];
        annotation[2] = pieces[2];
        break;
      case 2:
        annotation[0] = pieces[0];
        annotation[1] = pieces[1];
        annotation[2] = "";
        break;
      case 1:
        annotation = null;
        break;
    }
    return annotation;
  }
  
  private String[] get_line(int ix)
  {
    if (ix > lines.length-1) return null; 
    if (lines[ix].equals("")) return null;
    return split(lines[ix], ' ');
  }
}
class Config
{
  // NODE
  public float NODE_SIZE;            // size in Space
  public float SPACER_STRENGTH;      // repulsive force
  public float SPACER_MAX;           // max distance repulsive force
  public float EDGE_LENGTH;          // the spring wants to be at this length 
  public float EDGE_STRENGTH;        // If they are strong they act like a stick. If they are weak they take a long time to return to their rest length. 
  public float EDGE_DAMPING;         // If springs have high damping they don't overshoot and they settle down quickly, with low damping springs oscillate.
  public int STROKE_WEIGHT;          // global stroke weight
  public int FONTSIZE;               // label
  
  public int[] b_rgb;                // background coor
  public int[] e_rgb;                // edge color
  public int[] n_rgb;                // node color
  public int[] nh_rgb;               // node over
  public int[] n2_rgb;               // node2 color
  public int[] n2h_rgb;              // node2 over
  public int[] l_rgb;                // label
  
  public boolean draw_edges;
  public boolean draw_nodes;
  public boolean draw_labels;
  public boolean with_links;
  public boolean directed;
  
  public void set_background(int r, int g, int b)
  {
    b_rgb = new int[3];
    b_rgb[0] = r;
    b_rgb[1] = g;
    b_rgb[2] = b;
  }
  
  public void set_e_rgb(int r, int g, int b)
  {
    e_rgb = new int[3];
    e_rgb[0] = r;
    e_rgb[1] = g;
    e_rgb[2] = b;
  }
  
  public void set_n_rgb(int r, int g, int b)
  {
    n_rgb = new int[3];
    n_rgb[0] = r;
    n_rgb[1] = g;
    n_rgb[2] = b;
  }
  
  public void set_nh_rgb(int r, int g, int b)
  {
    nh_rgb = new int[3];
    nh_rgb[0] = r;
    nh_rgb[1] = g;
    nh_rgb[2] = b;
  }
  
  public void set_n2_rgb(int r, int g, int b)
  {
    n2_rgb = new int[3];
    n2_rgb[0] = r;
    n2_rgb[1] = g;
    n2_rgb[2] = b;
  }
  
  public void set_n2h_rgb(int r, int g, int b)
  {
    n2h_rgb = new int[3];
    n2h_rgb[0] = r;
    n2h_rgb[1] = g;
    n2h_rgb[2] = b;
  }
  
  public void set_l_rgb(int r, int g, int b)
  {
    l_rgb = new int[3];
    l_rgb[0] = r;
    l_rgb[1] = g;
    l_rgb[2] = b;
  }
  
}
class Network
{ 
  
  HashMap nodes;
  java.util.List edges;  // a growable list 
  int nodeid;
  
  Network()
  {
     nodes = new HashMap();
     edges = new Vector();
     nodeid = 0;
  }
  
  public Node[] add_edge(String[] myedge)
  {
    if (myedge == null) return null;
    
    add_node(myedge[0]);
    add_node(myedge[1]);
    
    Node[] mynodes = new Node[2];
    mynodes[0] = (Node)nodes.get(myedge[0]);
    mynodes[1] = (Node)nodes.get(myedge[1]);
    edges.add(mynodes);
    return mynodes;
  }
  
  public void update(int x, int y) 
  {
    Iterator it = nodes.values().iterator();
    while(it.hasNext()) {
      Node node = (Node)it.next();
      Particle p = node.particle;
      float realx = xspaceToViewport(p.position().x());
      float realy = yspaceToViewport(p.position().y());
      float disX = realx - x;
      float disY = realy - y;
      float diameter = node.nodesize * centroid.z();
      node.update( disX, disY, diameter);
    }
  }
  
  public void debug()
  {
    Iterator it = nodes.values().iterator();
    while(it.hasNext()) {
      Node node = (Node)it.next();
      Particle p = node.particle;
      println(node.label);
      println(p.position());
      println("centroid (X,Y,Z):" + centroid.x() + "," + centroid.y() + "," + centroid.z());
      float realx = xspaceToViewport(p.position().x());
      float realy = yspaceToViewport(p.position().y());
      println("realx: " + realx);
      println("realy: " + realy);
    }     
  }
  
  private void add_node(String mykey)
  {
    if (! nodes.containsKey(mykey))
    {
      if (annotation != null) {
        String[] notes = annotation.get_annotation(mykey);
        nodes.put(mykey, new Node(nodeid,notes[1],notes[2]));
      } else {
        nodes.put(mykey, new Node(nodeid,mykey,""));
      }
      nodeid++;
    }
  }
  
}
class NetworkReader
{
  String[] lines;
  int index;
  
  NetworkReader(String filename)
  {
    lines = loadStrings(filename);
    index = 0; 
  }
  
  // reseved space to parse line
  public String[] get_edge(int ix)
  {
    String[] edge = get_line(ix);
    return edge;
  }
  
  private String[] get_line(int ix)
  {
    if (ix > lines.length-1) return null;
    if (lines[ix].equals("")) return null;
    return split(lines[ix], ' ');
  }
}
class Node
{
  int id;
  String label;
  String hlink;
  Particle particle;
  
  boolean over = false;
  boolean locked = false;
  boolean have_link = false;
  
  int nodecolor = color(c.n_rgb[0],c.n_rgb[1],c.n_rgb[2]);
  int highlight = color(c.nh_rgb[0],c.nh_rgb[1],c.nh_rgb[2]);
  int linkcolor = color(c.n2_rgb[0],c.n2_rgb[1],c.n2_rgb[2]);
  int highlightlink = color(c.n2h_rgb[0],c.n2h_rgb[1],c.n2h_rgb[2]);
  int currentcolor;
  float nodesize;
  
  Node(int myid, String mystring, String mylink)
  {
    label = mystring;
    id = myid;
    particle = physics.makeParticle();
    hlink = mylink;
    
    if (hlink == "") {
      nodesize = c.NODE_SIZE / 1.5f;
      currentcolor = nodecolor;
    } else {
      have_link = true;
      nodesize = c.NODE_SIZE;
      currentcolor = linkcolor;
    }
  }
  
  public void update(float x, float y, float d) 
  {
    // Over circle: sqrt(X^2 + Y^2) < diametro / 2
    if(sqrt(sq(x) + sq(y)) < d /2 ) {
      over = true;
      set_over_color();
    } else {
      over = false;
      set_color();
    }
  }
  
  public void set_color()
  {
    currentcolor = have_link ? linkcolor : nodecolor;
  }
  
  public void set_over_color()
  {
    currentcolor = have_link ? highlightlink : highlight;
  }
  
  public void lock() { 
    locked = true;
    turn_off_repulsors(particle);
    turn_off_springs(particle);
  }
  
  public void unlock() { 
    locked = false;
    turn_on_repulsors(particle);
    turn_on_springs(particle);
  }
  
  public void move (float x, float y)
  {
    particle.moveTo(x,y, 0);
  }
   
}
public float xspaceToViewport(float x)
{
  return (((x - centroid.x()) * centroid.z()) + width / 2 );
}

public float yspaceToViewport(float y)
{
  return (((y - centroid.y()) * centroid.z()) + height / 2 );
}

public float xviewToSpace( float x )
{
  return( ((x - width / 2) / centroid.z()) + centroid.x() );
}

public float yviewToSpace( float y )
{
  return( ((y - height / 2) / centroid.z()) + centroid.y() );
}
// MOUSE STUFFS ////////////////////////////////////////
public void mouseDragged()
{
  int x = mouseX;
  int y = mouseY;
  if ( rightClick() ) {
    drawZoomBox( prevX, prevY, x, y );
  } else if (mouseButton == LEFT) {
    Iterator it = network.nodes.values().iterator();
    while(it.hasNext()) {
      Node node = (Node)it.next();
      if (node.locked == true) {
        float xs = xviewToSpace(x);
        float ys = yviewToSpace(y);
        node.move(xs,ys);
      }
    }
  }
}

public void mousePressed()
{
  if ( rightClick() ) {
    // set drag start X, Y
    prevX = mouseX;
    prevY = mouseY;
    toggle_zoombox = true;
  } else if (mouseButton == LEFT) {
    Iterator it = network.nodes.values().iterator();
    while(it.hasNext()) {
      Node node = (Node)it.next();
      if ((node.over == true) && (node.locked == false)) {
        node.lock();
      }
    }
  }
}

public void mouseReleased()
{
  if ( rightClick() ) {
    toggle_zoombox = false;
    zoomArea( prevX, prevY, mouseX, mouseY );
  } else if ( mouseButton == LEFT ) {
    Iterator it = network.nodes.values().iterator();
    while(it.hasNext()) {
      Node node = (Node)it.next();
      if ( node.locked == true ) {
        node.unlock();
      }
    }
  }
}

public void mouseClicked()
{
  if (mouseButton == LEFT) {
    Iterator it = network.nodes.values().iterator();
    while(it.hasNext()) {
      Node node = (Node)it.next();
      if ((node.over == true) && (node.hlink != "") && c.with_links) {
        link(node.hlink, "_new");
      }
    }
  }
}

// call always before if (mouseButton == left)
public boolean rightClick()
{
  if ((mouseButton == LEFT) && (keyPressed) && (key == CODED) && (keyCode == CONTROL) ) {
    return true;
  } else if (mouseButton == RIGHT) {
    return true;
  } else {
    return false;
  }
}

// KEYS STUFFS ////////////////////////////////////////

public void keyPressed()
{
  if ( key == 'c' )
  {
    initialize();
  }

  if ( key == ' ')
  {
    addEdge(objcounter);
    objcounter += 1;  
  }
     
  if ( key == 's' )
  {
    toggle_centroid = !toggle_centroid;
  }
  
  if ( key == 'z' )
  {
    ZoomOut();  
  }
}

public void keyTyped() {
  //println("typed " + key + " code: " + keyCode);
  if (key == '+') {
    if (speed <= 1) {
      return;
    } else {
      speed -= 1;
    }
    println("speed " + speed);
  } else if (key == '-') {
    speed += 1;
    println("speed " + speed);
  }
}
// DRAW STUFFS //////////////////////////////////////////
public void drawZoomBox( int x1, int y1, int x2, int y2 )
{
  int rwidth = x2 - x1;
  int rheight = y2 - y1;
  stroke( 100 );
  noFill();
  rect( x1, y1, rwidth, rheight );
}

public void drawCentroid()
{
  fill(0,0,255);
  ellipse( centroid.x(), centroid.y(), 1, 1 );
  strokeWeight( 0.5f );
  stroke ( 0,0,255 );
  line( centroid.x(), centroid.y(), (centroid.x() + 100), centroid.y() );
  line( centroid.x(), centroid.y(), (centroid.x() - 100), centroid.y() );
  line( centroid.x(), centroid.y(), centroid.x(), (centroid.y() + 100) );
  line( centroid.x(), centroid.y(), centroid.x(), (centroid.y() - 100) );
  noFill();
  beginShape();
  vertex(centroid.x() - 10, centroid.y() - 10);
  vertex(centroid.x() + 10, centroid.y() - 10);
  vertex(centroid.x() + 10, centroid.y() + 10);
  vertex(centroid.x() - 10, centroid.y() + 10);
  endShape( CLOSE );
  strokeWeight( c.STROKE_WEIGHT );
}

public void drawEdges()
{
  stroke( c.e_rgb[0], c.e_rgb[1], c.e_rgb[2] );
  for ( int i = 0; i < physics.numberOfSprings(); ++i )
  {
    Spring e = physics.getSpring( i );
    Particle a = e.getOneEnd();
    Particle b = e.getTheOtherEnd();
    float x1 = a.position().x();
    float y1 = a.position().y();
    float x2 = b.position().x();
    float y2 = b.position().y();
    line(a.position().x(), a.position().y(),b.position().x(), b.position().y());
    if ( c.directed ) {
      pushMatrix();
      translate(b.position().x(),b.position().y());
      float z = atan2(x1-x2, y2-y1);
      rotate(z);
      translate(0,(-c.NODE_SIZE / 2)+1);
      fill( c.e_rgb[0], c.e_rgb[1], c.e_rgb[2] );
      triangle(0, 0, -3, -3, 3, -3);
      popMatrix();
    }
  }
}

public void drawNodes()
{  
  noStroke();
  Iterator it = network.nodes.values().iterator();
  while(it.hasNext()) {
    Node node = (Node)it.next();
    Particle v = node.particle;
    fill( node.currentcolor );
    ellipse( v.position().x(), v.position().y(), node.nodesize, node.nodesize );
    if (c.draw_labels) drawLabel(node, v.position().x(), v.position().y());
  }
}

public void drawLabel(Node node, float x, float y)
{
  if (node == null) return;
  int labelcolor = color(c.l_rgb[0], c.l_rgb[1], c.l_rgb[2]);
  textFont(font, c.FONTSIZE);
  fill ( labelcolor );
  text(node.label, x + node.nodesize/2, y);
}

// ACTIONS ////////////////////////////////////
public void ZoomOut() 
{
  if ( toggle_zoomout == true ) {
    toggle_resize = true;
    toggle_zoomout = false;
  } else {
    toggle_resize = false;
    toggle_zoomout = true;
    centroid.setTarget(centroid.x(), centroid.y(), centroid.z() / 10);
  }
}

public void zoomArea(int x1, int y1, int x2, int y2)
{
    float newx1;
    float newy1;    
    float newx2;
    float newy2;
    
    // avoid 0 size boxes
    if ((x1 == x2) && (y1 == y2)) {
      return;
    }
    
    // switch x and y (depend on drag gesture)
    if (x1 > x2) {
      newx1 = xviewToSpace(x2);
      newx2 = xviewToSpace(x1);
    } else {
      newx1 = xviewToSpace(x1);
      newx2 = xviewToSpace(x2);
    }
    if (y1 > y2) {
       newy1 = yviewToSpace(y2);
       newy2 = yviewToSpace(y1); 
    } else {
       newy1 = yviewToSpace(y1);
       newy2 = yviewToSpace(y2);
    }
    
    // we have 4 quadrants x and y are already ordered (x1 < x2)
    float cx;
    float cy;
    float cz;
    float boxl;
    float boxh;
    boxl = newx2 - newx1;
    boxh = newy2 - newy1;
    cx = newx1 + ( boxl / 2 );
    cy = newy1 + ( boxh / 2 );
    cz = boxh > boxl ? height/boxh : width/boxl;

    //println( "DRAG gesture: x1:" + x1 + ", y1:" + y1 + " , x2:" + x2 + ", y2:" + y2 );
    //println( "New viewport (X1,Y1,X2,Y2): " + newx1 + "," + newy1 + "," + newx2 + "," + newy2 );
    //println("centroid go to: " + cx + "," + cy + "," + cz);
    //println("box l,h: " + boxl + " ," + boxh);
    
    toggle_resize = false;
    centroid.setTarget( cx, cy, cz);
}

public void updateCentroid()
{
  float 
    xMax = Float.NEGATIVE_INFINITY, 
    xMin = Float.POSITIVE_INFINITY, 
    yMin = Float.POSITIVE_INFINITY, 
    yMax = Float.NEGATIVE_INFINITY;

  for ( int i = 0; i < physics.numberOfParticles(); ++i )
  {
    Particle p = physics.getParticle( i );
    xMax = max( xMax, p.position().x() );
    xMin = min( xMin, p.position().x() );
    yMin = min( yMin, p.position().y() );
    yMax = max( yMax, p.position().y() );
  }
  float deltaX = xMax-xMin;
  float deltaY = yMax-yMin;
  if ( deltaY > deltaX )
    centroid.setTarget( xMin + 0.5f*deltaX, yMin +0.5f*deltaY, height/(deltaY+50) );
  else
    centroid.setTarget( xMin + 0.5f*deltaX, yMin +0.5f*deltaY, width/(deltaX+50) );
}


// addd a repulsive force to the other particles
// Attraction makeAttraction( Particle a, Particle b, float strength, float minimumDistance )
public void addSpacersToNode( Particle p, Particle r )
{
  for ( int i = 0; i < physics.numberOfParticles(); ++i )
  {
    Particle q = physics.getParticle( i );
    if ( p != q && p != r ) {
      physics.makeAttraction( p, q, -c.SPACER_STRENGTH, c.SPACER_MAX );
    }
  }
}

// add a spring between the two nodes
// Spring makeSpring( Particle a, Particle b, float strength, float damping, float restLength )
public void makeEdgeBetween( Particle a, Particle b )
{
  physics.makeSpring( a, b, c.EDGE_STRENGTH, c.EDGE_DAMPING, c.EDGE_LENGTH );
}

public void turn_off_repulsors(Particle p)
{
  // turn off repulsive forces
  for ( int i = 0; i < physics.numberOfAttractions(); ++i )
  {
    Attraction a = physics.getAttraction(i);
    Particle m = a.getOneEnd();
    Particle n = a.getTheOtherEnd();
    if ((p == m) || (p == n)) { a.turnOff(); }
  }
}

public void turn_off_springs(Particle p)
{
  // relax spring forces
  for ( int i = 0; i < physics.numberOfSprings(); ++i )
  {
    Spring s = physics.getSpring(i);
    Particle m = s.getOneEnd();
    Particle n = s.getTheOtherEnd();
    if ((p == m) || (p == n)) { s.setStrength(c.EDGE_STRENGTH / 10); }
  }
}

public void turn_on_repulsors(Particle p)
{
  // turn on repulsive forces
  for ( int i = 0; i < physics.numberOfAttractions(); ++i )
  {
    Attraction a = physics.getAttraction(i);
    Particle m = a.getOneEnd();
    Particle n = a.getTheOtherEnd();
    if ((p == m) || (p == n)) { a.turnOn(); }
  }
}

public void turn_on_springs(Particle p)
{
  // restore spring forces
  for ( int i = 0; i < physics.numberOfSprings(); ++i )
  {
    Spring s = physics.getSpring(i);
    Particle m = s.getOneEnd();
    Particle n = s.getTheOtherEnd();
    if ((p == m) || (p == n)) { s.setStrength(c.EDGE_STRENGTH); }
  }
}
public void config()
{
  XMLElement xml;
  xml = new XMLElement(this, param("config"));
  //xml = new XMLElement(this, "classic.xml");
  parse_xml(xml);
  

  // PROCESSING CONFIG
  ellipseMode( CENTER );
  rectMode ( CORNER );
  smooth();
  font = createFont("Verdana",10);
  speed = FRAMERATE / 2;

  // PYSHICS CONFIG
  // 2D particle system new ParticleSystem( float gravityY, float drag )
  // new Smoother3D( float smoothness )
  physics = new ParticleSystem( 0, 0.25f );
  centroid = new Smoother3D( 0.8f );

  // FIXME
  //reader = new NetworkReader("directed.txt");
  reader = new NetworkReader(param("edges"));
  String notefile = param("nodes");
  //String notefile = "sitenodes.txt";
  //String notefile = "directednote.txt";
  if (notefile == null) {
    annotation = null;
  } else {
    annotation = new AnnotationReader(notefile);
  }
}

public void initialize()
{ 
  network = new Network();
  strokeWeight( c.STROKE_WEIGHT );
  counter = 0;      // frames reset
  objcounter = 0;   // obj reset
  physics.clear();  // clear particles
  centroid.setValue( 0, 0, 1.0f );  // set centroid to 0,0 and zoom 1.0 void setValue( float x, float y, float z )
  toggle_resize = true;
  toggle_centroid = false;
  toggle_zoomout = false;
  toggle_zoombox = false;
}

public void parse_xml(XMLElement xml)
{
// SLURP XML CONFIG
  
  c = new Config();

  // params
  XMLElement params = xml.getChild("params");

  XMLElement obj = params.getChild("node");
  XMLElement kid = obj.getChild("size");
  String content = kid.getContent().toString();
  c.NODE_SIZE = PApplet.parseFloat(content);

  obj = params.getChild("spacer");
  kid = obj.getChild("strength");
  content = kid.getContent().toString();
  c.SPACER_STRENGTH = PApplet.parseFloat(content);
  kid = obj.getChild("max");
  content = kid.getContent().toString();
  c.SPACER_MAX = PApplet.parseFloat(content);
  
  obj = params.getChild("edge");
  kid = obj.getChild("length");
  content = kid.getContent().toString();
  c.EDGE_LENGTH = PApplet.parseFloat(content);
  kid = obj.getChild("strength");
  content = kid.getContent().toString();
  c.EDGE_STRENGTH = PApplet.parseFloat(content);
  kid = obj.getChild("damping");
  content = kid.getContent().toString();
  c.EDGE_DAMPING = PApplet.parseFloat(content);

  obj = params.getChild("stroke");
  kid = obj.getChild("weight");
  content = kid.getContent().toString();
  c.STROKE_WEIGHT = PApplet.parseInt(content);
  obj = params.getChild("font");
  kid = obj.getChild("size");
  content = kid.getContent().toString();
  c.FONTSIZE = PApplet.parseInt(content);
  
  // COLORS
  XMLElement colors = xml.getChild("colors");

  obj = colors.getChild("background");
  kid = obj.getChild("r");
  content = kid.getContent().toString();
  int r = PApplet.parseInt (content);
  kid = obj.getChild("g");
  content = kid.getContent().toString();
  int g = PApplet.parseInt (content);
  kid = obj.getChild("b");
  content = kid.getContent().toString();
  int b = PApplet.parseInt (content);
  c.set_background(r,g,b);

  obj = colors.getChild("edge");
  kid = obj.getChild("r");
  content = kid.getContent().toString();
  r = PApplet.parseInt (content);
  kid = obj.getChild("g");
  content = kid.getContent().toString();
  g = PApplet.parseInt (content);
  kid = obj.getChild("b");
  content = kid.getContent().toString();
  b = PApplet.parseInt (content);  
  c.set_e_rgb(r,g,b);

  obj = colors.getChild("node1");
  kid = obj.getChild("r");
  content = kid.getContent().toString();
  r = PApplet.parseInt (content);
  kid = obj.getChild("g");
  content = kid.getContent().toString();
  g = PApplet.parseInt (content);
  kid = obj.getChild("b");
  content = kid.getContent().toString();
  b = PApplet.parseInt (content);    
  c.set_n_rgb(r,g,b);
  kid = obj.getChild("rh");
  content = kid.getContent().toString();
  r = PApplet.parseInt (content);
  kid = obj.getChild("gh");
  content = kid.getContent().toString();
  g = PApplet.parseInt (content);
  kid = obj.getChild("bh");
  content = kid.getContent().toString();
  b = PApplet.parseInt (content);      
  c.set_nh_rgb(r,g,b);
  
  obj = colors.getChild("node2");
  kid = obj.getChild("r");
  content = kid.getContent().toString();
  r = PApplet.parseInt (content);
  kid = obj.getChild("g");
  content = kid.getContent().toString();
  g = PApplet.parseInt (content);
  kid = obj.getChild("b");
  content = kid.getContent().toString();
  b = PApplet.parseInt (content);    
  c.set_n2_rgb(r,g,b);
  kid = obj.getChild("rh");
  content = kid.getContent().toString();
  r = PApplet.parseInt (content);
  kid = obj.getChild("gh");
  content = kid.getContent().toString();
  g = PApplet.parseInt (content);
  kid = obj.getChild("bh");
  content = kid.getContent().toString();
  b = PApplet.parseInt (content);      
  c.set_n2h_rgb(r,g,b);

  obj = colors.getChild("label");
  kid = obj.getChild("r");
  content = kid.getContent().toString();
  r = PApplet.parseInt (content);
  kid = obj.getChild("g");
  content = kid.getContent().toString();
  g = PApplet.parseInt (content);
  kid = obj.getChild("b");
  content = kid.getContent().toString();
  b = PApplet.parseInt (content); 
  c.set_l_rgb(r,g,b);
 
  // COLORS
  XMLElement flags = xml.getChild("flags"); 
  obj = flags.getChild("drawedges");
  content = obj.getContent().toString();
  c.draw_edges  = PApplet.parseBoolean(PApplet.parseInt(content));
  obj = flags.getChild("drawnodes");
  content = obj.getContent().toString();
  c.draw_nodes  = PApplet.parseBoolean(PApplet.parseInt(content));
  obj = flags.getChild("drawlabels");
  content = obj.getContent().toString();
  c.draw_labels = PApplet.parseBoolean(PApplet.parseInt(content));
  obj = flags.getChild("withlinks");
  content = obj.getContent().toString();
  c.with_links  = PApplet.parseBoolean(PApplet.parseInt(content));
  obj = flags.getChild("directed");
  content = obj.getContent().toString();
  c.directed  = PApplet.parseBoolean(PApplet.parseInt(content));  
}

  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#ffffff", "SimpleNetworkVisualizer" });
  }
}
