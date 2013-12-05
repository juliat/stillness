// import libraries

// for the butterflies and modelling a person
import pbox2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

// create a reference to the box2d world
PBox2D box2d;
// make an reference to an arraylist for or Butterfly Objects
ArrayList<Butterfly> butterflies;
Person person;

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
  
  createBoundaries();

  // Create the ArrayList in which we'll put butterflies
  butterflies = new ArrayList<Butterfly>();

  // Create the Person whose motion we'll track
  person = new Person();
}

void draw() {
  // redraw background
  int backgroundColor = 255;
  background(backgroundColor);

  // step the box2D world through time
  box2d.step();

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
  Boundary top = new Boundary(0, 0, width, boundarySize); // x, y, w, h
  Boundary bottom = new Boundary(0, height, width, boundarySize);
  Boundary left = new Boundary(0, 0, boundarySize, height);
  Boundary right = new Boundary(width, 0, boundarySize, height);
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

