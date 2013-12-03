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

  // constructor
  Person() {
    setPosition();
    update();
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
    println("capturing s " + distance);
    float velocity = distance/timeBetweenSamples;
    println("capturing v " + velocity);
    cumulativeVelocity += velocity;
    numVelocitiesCaptured++;
    currentVelocity = velocity;
    
    // if not moving
    if (velocity == 0.0) {
      // and was moving before
      if (stillnessDuration < 1) {
        // record time
        println("record time");
        startStillnessTime = millis();
        stillnessDuration = 1;
      // wasn't moving before
      } else {
        // update time since last motion
        println("get duration");
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
}

