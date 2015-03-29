/*------------------------------------------------------------------------------
  1 Minute Countdown
  Countdown starts from 1:10 when lap button is pressed, beeps at 1:00, and 0:00, then shows time since 0:00.

  Variables:
    timer = 0 <-- time remaining

  Format:
    time

  Test Vector:
    obvious
------------------------------------------------------------------------------*/

/* Lap button pressed - setup */
if (SUUNTO_MANUAL_LAP_DURATION == 0) {
  prefix = "";
  timer = 70;
  postfix = "s";
}

if (SUUNTO_LAP_NUMBER == 1) {
  /* The first lap (before lap button pressed) show the total countdown */

  RESULT = timer;
  prefix = "";
}
else if (SUUNTO_MANUAL_LAP_DURATION <= timer) {
  /* Subsequent laps - show time remaining until time runs out */

  RESULT = timer - SUUNTO_MANUAL_LAP_DURATION;
  prefix = "";

  if (RESULT == timer - 8 || RESULT == timer - 9 || RESULT == timer - 10 || RESULT == 2 || RESULT == 1 || RESULT == 0) {
    Suunto.alarmBeep();
  }
}
else {
  /* After time runs out, show time past */

  RESULT = SUUNTO_MANUAL_LAP_DURATION - timer;
  prefix = "past";
}
