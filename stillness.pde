// import libraries

// for the butterflies and modelling a person
import pbox2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

// create a reference to the box2d world
PBox2D box2d;
// make an reference to an arraylist for or Butterfly Objects
ArrayList<Butterfly> butterflies;
Person person;

ArrayList<Boundary> boundaries;

void setup() {
  // setup window
  int windowWidth = 640;
  int windowHeight = 360;
  size(windowWidth, windowHeight);

  // Initialize and create the Box2D world and stick it in
  // the global reference variable
  box2d = new PBox2D(this);
  box2d.createWorld();
  adjustBox2dWorld();
  
  box2d.listenForCollisions();
  
  

  // Create the ArrayList in which we'll put butterflies
  butterflies = new ArrayList<Butterfly>();
 
  boundaries = new ArrayList<Boundary>();
  createBoundaries();
  
  // Create the Person whose motion we'll track
  person = new Person();
}

void draw() {
  // redraw background
  int backgroundColor = 255;
  background(backgroundColor);

  // step the box2D world through time
  box2d.step();

  // draw boundaries
  displayBoundaries();

  // if there are no butterflies, ake them
  if ((butterflies == null) || (butterflies.size() < 1)) {
    createButterflies();
  }
  
  // update butterflies attraction/repulsion to person
  person.update();
  person.printDebug();
  
  int randomBNum = (int)random(0, butterflies.size() - 1);
  Butterfly randomB = butterflies.get(randomBNum);
  
  // display all the butterflies
  for (Butterfly b: butterflies) {
    if (person.stillnessDuration > (person.stillnessThreshold * person.numButterfliesAttracted)) {
      // attract one
      b.attractToPoint(mouseX, mouseY);
      person.numButterfliesAttracted++;
    } else {
      // repel all
      b.repelFromPoint(mouseX, mouseY);
    }
    // b.update();
    b.display();
  }

  // update the Person
  
}

void createButterflies() {
  int numButterflies = 5;
  for (int i = 0; i < numButterflies; i++) {
    // create a bunch of Butterfly Objects in random locations
    float randomX = random(0, width);
    float randomY = random(0, height);
    Butterfly b = new Butterfly(randomX, randomY);
    butterflies.add(b); // add the butterfly to the array
  }
}

void createBoundaries() {
  int boundarySize = 10;
  Boundary top = new Boundary(width/2, 0, width, boundarySize); // x, y, w, h relative to center
  boundaries.add(top);
  Boundary bottom = new Boundary(width/2, height, width, boundarySize);
  boundaries.add(bottom);
  Boundary left = new Boundary(0, height/2, boundarySize, height);
  boundaries.add(left);
  Boundary right = new Boundary(width, height/2, boundarySize, height);
  boundaries.add(right);
}

void displayBoundaries() {
  for (Boundary b: boundaries) {
    b.display();
  }
}

void adjustBox2dWorld() {
  // no gravity!
  box2d.setGravity(0, 0);
}

// helper function to calculate displacement between
// two points
float getDistance(float x1, float y1, float x2, float y2) {
  float dX = x2 - x1;
  float dY = y2 - y1;
  float dHypotenuse = sqrt((dX * dX) + (dY * dY)); // pythagoras!
  return dHypotenuse;
}



// Collision event functions!
void beginContact(Contact cp) {
  // Get both shapes
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  // Get both bodies
  Body body1 = f1.getBody();
  Body body2 = f2.getBody();

  // Get our objects that reference these bodies
  Object o1 = body1.getUserData();
  Object o2 = body2.getUserData();

  if (o1.getClass() == Butterfly.class && o2.getClass() == Butterfly.class) {
    Butterfly b1 = (Butterfly) o1;
    b1.delete();
    Butterfly b2 = (Butterfly) o2;
    b2.delete();
  }

  if (o1.getClass() == Boundary.class) {
    Butterfly b = (Butterfly) o2;
    b.change();
  }
  if (o2.getClass() == Boundary.class) {
    Butterfly b = (Butterfly) o1;
    b.change();
  }


}

// Objects stop touching each other
void endContact(Contact cp) {
}
