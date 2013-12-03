// import libraries

// for the butterflies and modelling a person
import pbox2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

// create a reference to the box2d world
PBox2D box2d;
// make an reference to an arraylist for our Butterfly Objects
ArrayList<Butterfly> butterflies;

void setup() {
  // setup window
  int windowWidth = 640;
  int windowHeight = 360;
  size(windowWidth, windowHeight);

  // Initialize and create the Box2D world and stick it in
  // the global reference variable
  box2d = new PBox2D(this);
  box2d.createWorld();

  // Create the ArrayList in which we'll put butterflies
  butterflies = new ArrayList<Butterfly>();
}

void createButterflies() {
  int numButterflies = 50;
  for (int i = 0; i < numButterflies; i++) {
    // create a bunch of Butterfly Objects in random locations
    float randomX = random(0, width);
    float randomY = random(0, height);
    Butterfly b = new Butterfly(randomX, randomY);
    butterflies.add(b); // add the butterfly to the array
  }
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
  // display all the butterflies
  for (Butterfly b: butterflies) {
    b.display();
  }
}

