class Butterfly {
  // store a reference to the Box2D physics body
  Body body;

  boolean delete = false;

  color col;

  float r;

  boolean windDirection = true;

  // constructor
  Butterfly(float x, float y) {
    // set radius
    r = 5;

    // This function puts the particle in the Box2d world
    makeBody(x, y, r);
    body.setUserData(this);
    col = color(175);
  }

  void makeBody(float x, float y, float r) {
    // Create a definition of what the box2d body should be
    BodyDef bodyDefinition = new BodyDef();
    bodyDefinition.type = BodyType.DYNAMIC;
    // set the position of the Box2D Body by translating x y pixels
    // to box2D world
    bodyDefinition.position.set(box2d.coordPixelsToWorld(x, y));
    bodyDefinition.bullet = true;
    body = box2d.createBody(bodyDefinition); // actually create it

    // define the shape for the Butterfly
    CircleShape shape = new CircleShape();
    shape.m_radius = box2d.scalarPixelsToWorld(r);

    // set up a fixture to tie together the body and the shape
    FixtureDef fixtureDefinition = new FixtureDef();
    fixtureDefinition.shape = shape;

    // assign physics-related parameters
    fixtureDefinition.density = 1;
    fixtureDefinition.friction = 0.5;
    fixtureDefinition.restitution = 0.5;

    // attach Fixture to Body
    body.createFixture(fixtureDefinition);

    // setup initial linear and angular velocities
    float randomXVelocity = random(-3, 3);
    float randomYVelocity = random(-10, 3);
    float randomAngularVelocity = random(-3, 3); 
    body.setLinearVelocity(new Vec2(randomXVelocity, randomYVelocity));
    body.setAngularVelocity(randomAngularVelocity);
  } // end constructor

  void applyForce(Vec2 force) {
    Vec2 position = body.getWorldCenter(); // ask the body for its center
    body.applyForce(force, position);
  }

  void update() {
    // avoidOthers();
  }

  void attractToPoint(float x, float y) {
    Vec2 worldTarget = box2d.coordPixelsToWorld(x, y);
    Vec2 bodyVec = body.getWorldCenter();
    // find the vector going from the body (the butterfly's) going to the
    // specified point
    worldTarget.subLocal(bodyVec);
    // scale the vector to the specified force
    worldTarget.normalize();
    
    // apply it to the body's center of bass
    body.applyForce(worldTarget, bodyVec);
  }

  void applyWind() {
    Vec2 position = box2d.getBodyPixelCoord(body);
    float randomX = random(0, width);
    float randomY = random(0, height);
    float flipY = mouseY + random(0,30);
    
    if (windDirection == false) {
      flipY = mouseY + (-30,0);
    }
    
    Vec2 worldTarget = box2d.coordPixelsToWorld(position.x, flipY);
    Vec2 bodyVec = body.getWorldCenter();
    // find the vector going from the body (the butterfly's) going to the
    // specified point
    worldTarget.subLocal(bodyVec);
    // scale the vector to the specified force
    worldTarget.normalize();
    
    // apply it to the body's center of bass
    body.applyForce(worldTarget, bodyVec);
    
    // apply it to the body's center of bass
    body.applyForce(worldTarget, bodyVec);
    
    windDirection = !windDirection;
  }

  void repelFromPoint(float x, float y) {
    Vec2 worldTarget = box2d.coordPixelsToWorld(x, y);
    Vec2 bodyVec = body.getWorldCenter();
    // find the vector going from the body (the butterfly's) going to the
    // specified point
    worldTarget.addLocal(bodyVec);
    // scale the vector to the specified force
    worldTarget.normalize();
    int force = 1;
    worldTarget.mulLocal((float) force);
    // apply it to the body's center of bass
    body.applyForce(worldTarget, bodyVec);
  }

  /* void avoidOthers() {
   for (Butterfly otherB: butterflies) {
   Vec2 repulsionForce = repel(otherB);
   otherB.applyForce(repulsionForce);
   }
   }
   
   Vec2 repel(Butterfly otherButterfly) {
   // calculate force
   // adjust based on distance and mass
   
   }*/

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
    fill(col);
    stroke(0);
    strokeWeight(1);

    // draw the shape
    ellipse(0, 0, r*2, r*2);

    popMatrix(); // reset the canvas
  } // end display
  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  void delete() {
    delete = true;
  }

  // Change color when hit
  void change() {
    col = color(255, 0, 0);
  }

  // Is the particle ready for deletion?
  // Is the particle ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height+r*2 || delete) {
      killBody();
      return true;
    }
    return false;
  }
} // end class  

