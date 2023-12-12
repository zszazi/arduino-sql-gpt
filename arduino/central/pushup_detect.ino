#include <Arduino_APDS9960.h>
int pushupState = 0;
int pushup_counter = -1;

const int startThreshold = 230; // <--- the lowest threshold distance from a person's chest to the floor
const int endThreshold = 235; // <--- the highest threshold distance from a person's chest to the floor

int pushupDetect() {
  // check if a proximity reading is available

  if (APDS.proximityAvailable()) {
    int proximity = APDS.readProximity();
    if (proximity > endThreshold) {
      if (pushupState == 3) {
        pushupState = 0;
        pushup_counter += 1;
        Serial.print("add a push up: ");
        Serial.println(pushup_counter);
        return pushup_counter;
      }

      pushupState = 0;
    } else if (proximity < startThreshold) {
      pushupState = 2;
    } else {
      if (pushupState == 0) {
        pushupState = 1;
      } else if (pushupState == 2) {
        pushupState = 3;
      }
    }
  }

  return pushup_counter;
}
