class Butterfly {
  // store a reference to the Box2D physics body
  Body body;

  // store width and height as floats
  float w, h;

  // constructor
  Butterfly(float x, float y) {
    // set width and height
    w = 16;
    h = 16;

    // Create a definition of what the box2d body should be
    BodyDef bodyDefinition = new BodyDef();
    bodyDefinition.type = BodyType.DYNAMIC;
    // set the position of the Box2D Body by translating x y pixels
    // to box2D world
    bodyDefinition.position.set(box2d.coordPixelsToWorld(x, y));
    body = box2d.createBody(bodyDefinition); // actually create it

    // define the shape for the Butterfly
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
  } // end constructor

  // draw a butterfly!
  void display() {
    // get the Body's location and angle out of Box2d and translate it to pixels
    Vec2 position = box2d.getBodyPixelCoord(body);
    float angle = body.getAngle();

    pushMatrix(); // store original canvas

    // translate the processing canvas so that the center is at the position
    // of the butterfly, and we can draw relative to that as the origin
    translate(position.x, position.y);
    rotate(-angle);

    // colors
    fill(127);
    stroke(0);
    strokeWeight(2);

    // draw the shape
    rectMode(CENTER); // (instead of from top left, draw from center)
    rect(0, 0, w, h); // draw at origin, which is the shape's position

    popMatrix(); // reset the canvas
  } // end display
} // end class  

