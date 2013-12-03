// the thing or individual which is moving, to which the butterflies react
class Person {
  float positionX;
  float positionY;

  float currentVelocity = 0;
  float averageVelocity = 0;
  float cumulativeVelocity = 0;

  int startStillnessTime = 0;
  int stillnessDuration = 0;
  
  int timePositionWasLastSampled = 0;
  int timeBetweenSamples = 0;
  int numVelocitiesCaptured = 0;
  
  // box2d
  Body body;

  // constructor
  Person() {
    setPosition();
    update();
    createBox2dObject();
  }

  // get data about the person's position
  //  for now the person is the mouse
  void update() {
    timeBetweenSamples = millis() - timePositionWasLastSampled;
    timePositionWasLastSampled = millis();
    captureVelocity();
    updateAverageVelocity();
    setPosition();
  }

  void setPosition() {
    positionX = mouseX;
    positionY = mouseY;
  }

  float getCurrentPosition(char xOrY) {
    if (xOrY == 'x') {
      return mouseX;
    } 
    else {
      return mouseY;
    }
  }

  // get the difference between the last position recorded
  // and this one to figure out velocity
  void captureVelocity() {
    float distance = getDistance(getCurrentPosition('x'), getCurrentPosition('y'), positionX, positionY);
    float velocity = distance/timeBetweenSamples;
    cumulativeVelocity += velocity;
    numVelocitiesCaptured++;
    currentVelocity = velocity;
    
    // if not moving
    if (velocity == 0.0) {
      // and was moving before
      if (stillnessDuration < 1) {
        // record time
        startStillnessTime = millis();
        stillnessDuration = 1;
      // wasn't moving before
      } else {
        // update time since last motion
        stillnessDuration = millis() - startStillnessTime;
      }
    // moving
    } else {
      // reset stillness time
      stillnessDuration = 0;
    }
  }

  void updateAverageVelocity() {
    float newAverage = cumulativeVelocity / numVelocitiesCaptured;
    println("new average " + newAverage);
    averageVelocity = newAverage;
  }

  void printDebug() {
    println("X Position " + positionX);
    println("Y Position " + positionY);
    println("Time Position was Last Sampled " + timePositionWasLastSampled);
    println("Time Between Samples " + timeBetweenSamples);
    println("Current Velocity " + currentVelocity);
    println("Average Velocity " + averageVelocity);
    println("Cumulative Velocity " + cumulativeVelocity);
    println("Velocities Captured " + numVelocitiesCaptured);
    println("Stillness Duration " + stillnessDuration);
    println("Start Stillness Time " + startStillnessTime);
  }
  
  void createBox2dObject() {
    // set width and height
    int w = 16;
    int h = 16;

    // Create a definition of what the box2d body should be
    BodyDef bodyDefinition = new BodyDef();
    // "A kinematic body can be moved manually by setting its velocity directly. 
    // If you have a user-controlled object in your world, you can use a kinematic body"
    // - http://natureofcode.com/book/chapter-5-physics-libraries/
    bodyDefinition.type = BodyType.KINEMATIC;
    // set the position of the Box2D Body by translating x y pixels
    // to box2D world
    bodyDefinition.position.set(box2d.coordPixelsToWorld(positionX, positionY));
    body = box2d.createBody(bodyDefinition); // actually create it
    
    // define the shape for the Person
    PolygonShape shape = new PolygonShape();
    // in box2d, the width and height are the distance from the center to the edge,
    // so half of the processing values for width and height
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);

    shape.setAsBox(box2dW, box2dH);

    // set up a fixture to tie together the body and the shape
    FixtureDef fixtureDefinition = new FixtureDef();
    fixtureDefinition.shape = shape;

    // assign physics-related parameters
    fixtureDefinition.density = 1;
    fixtureDefinition.friction = 0.3;
    fixtureDefinition.restitution = 0.5;

    // attach Fixture to Body
    body.createFixture(fixtureDefinition);
  }
}

