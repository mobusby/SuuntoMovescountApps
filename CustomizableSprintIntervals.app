/*------------------------------------------------------------------------------
  Customizable Sprint Intervals
  Complete sprint interval workout with customizable Warmup, Sprints, Recovery, Cooldown.  Default is to use distances for each, but set the distances to 0 and times will be used instead.

  No need to press the lap button, the app takes care of everything.  Just follow the instructions on the screen ("Warm", "*HI*, "rcvr", "cool").  At the end, the screen will tell you how far you went, and how long it took.

  Variables: (declarations in Movescount are meaningless -- use the app editor)
    WARMUP_DIST = 0.25 * 1.60934 <-- km to run for warm up
    WARMUP_Time = 0 <-- sec to run for warm up; used iff WARMUP_DIST == 0
    NUM_SPRINTS = 8 <-- number of sprints to do
    SPRINT_DIST = 0.25 * 1.60934 <-- km to sprint
    SPRINT_TIME = 0 <-- seconds to sprint; used iff SPRINT_DIST == 0
    REST_DIST   = 0  <-- km to recover between sprints
    REST_TIME   = 60 <-- sec to recover between sprints; used iff REST_DIST == 0
    COOLDN_DIST = 0.25 * 1.60934 <-- km to run for cool down
    COOLDN_TIME = 0 <-- sec to run for cool down; used iff COOLDN_DIST == 0

    interval           = 0 <-- current interval number, numbering starts at 0
    intervalDone       = 0 <-- 1 if current interval complete, 2 if program complete
    intervalDistance   = 0 <-- distance gone during this interval so far
    intervalTime       = 0 <-- time spent on current interval
    cumulativeDistance = 0 <-- total distance gone, excluding the current interval
    cumulativeTime     = 0 <-- total time gone so far, excluding the current interval
    beepsRemaining     = 0 <-- number of beeps remaining

  Format:
    2 decimals

  Test Vector:
    Mostly obvious -- play with time and distance and ensure reaction makes sense based on initial parameter declarations.
------------------------------------------------------------------------------*/

/*----------------------------------------------------------------------
	Initialization of ALL variables before start
    Initial values don't matter as they are initialized here.
----------------------------------------------------------------------*/
if (SUUNTO_DURATION == 0) {
  /*--------------------------------------------------------------------
    Parameters -- Set these as desired.  Each must be declared in
    Movescount, but the value there doesn't matter.  Distance values
    are taken as km, time values as seconds.  For reference,
    0.621371 mi/km, 1.60934 km/mi
  --------------------------------------------------------------------*/
  WARMUP_DIST = 0.25 * 1.60934; /* km to run for warm up */
  WARMUP_TIME = 0;              /* sec to run for warm up; used iff WARMUP_DIST == 0 */
  NUM_SPRINTS = 8;              /* number of sprints to do */
  SPRINT_DIST = 0.25 * 1.60934; /* km to sprint */
  SPRINT_TIME = 0;              /* seconds to sprint; used iff SPRINT_DIST == 0 */
  REST_DIST = 0;                /* km to recover between sprints */
  REST_TIME = 60;               /* sec to recover between sprints; used iff REST_DIST == 0 */
  COOLDN_DIST = 0.25 * 1.60934; /* km to run for cool down */
  COOLDN_TIME = 0;              /* sec to run for cool down; used iff COOLDN_DIST == 0 */

  /*--------------------------------------------------------------------
    Working variables -- Don't mess with these!  However, the must be
    declared in Movescount, but the value there doesn't matter.
  --------------------------------------------------------------------*/
  interval = 0;            /* current interval number, numbering starts at 0 */
  intervalDone = 0;        /* will be 1 if current interval is complete, 2 if program complete */
  intervalDistance = 0;    /* distance gone during this interval so far */
  intervalTime = 0;        /* time spent on current interval */
  cumulativeDistance = 0;  /* total distance gone so far, excluding the current interval */
  cumulativeTime = 0;      /* total time gone so far, excluding the current interval */
  beepsRemaining = 0;      /* number of beeps remaining */
}

/* Intervals */
if (interval < 1) {
  /* Initial Warmup (the first interval) */
  prefix = "Warm";

  if (WARMUP_DIST == 0) {
    /* Display time remaining in warmup */
    RESULT = WARMUP_TIME - SUUNTO_DURATION;
    postfix = "s";

    /* Test for completed interval */
    if (SUUNTO_DURATION >= WARMUP_TIME) {
      intervalDone = 1;
      beepsRemaining = 3; /* Beep three times to sprint */
    }
  }
  else {
    /* Display distance remaining in warmup */
    RESULT = 0.621371 * (WARMUP_DIST - SUUNTO_DISTANCE);
    postfix = "mi";

    /* Test for completed interval */
    if (SUUNTO_DISTANCE >= WARMUP_DIST) {
      intervalDone = 1;
      beepsRemaining = 3; /* Beep three times to sprint */
    }
  }
}
else if (interval == NUM_SPRINTS * 2) {
  /* Final cool down (the last interval) */
  prefix = "cool";

  if (COOLDN_DIST == 0) {
    intervalTime = SUUNTO_DURATION - cumulativeTime;
    RESULT = COOLDN_TIME - intervalTime;
    postfix = "s";

    if (intervalTime >= COOLDN_TIME && intervalDone == 0) {
      intervalDone = 2;
      beepsRemaining = 2; /* Beep two times to slow down (stop) */
    }
  }
  else {
    intervalDistance = SUUNTO_DISTANCE - cumulativeDistance;
    RESULT = 0.621371 * (COOLDN_DIST - intervalDistance);
    postfix = "mi";

    if (intervalDistance >= COOLDN_DIST && intervalDone == 0) {
      intervalDone = 2;
      beepsRemaining = 2; /* Beep two times to slow down (stop) */
    }
  }
}
else if (Suunto.mod(interval - 1, 2) == 0) {
  /* Sprints (are odd intervals) */
  prefix = "*HI*";

  if (SPRINT_DIST == 0) {
    intervalTime = SUUNTO_DURATION - cumulativeTime;
    RESULT = SPRINT_TIME - intervalTime;
    postfix = "s";

    if (intervalTime >= SPRINT_TIME) {
      intervalDone = 1;
      beepsRemaining = 2; /* Beep two times to slow down */
    }
  }
  else {
    intervalDistance = SUUNTO_DISTANCE - cumulativeDistance;
    RESULT = 0.621371 * (SPRINT_DIST - intervalDistance);
    postfix = "mi";

    if (intervalDistance >= SPRINT_DIST) {
      intervalDone = 1;
      beepsRemaining = 2; /* Beep two times to slow down */
    }
  }
}
else {
  /* Recovery intervals (even intervals that aren't warm up or cool down) */
  prefix = "rcvr";

  if (REST_DIST == 0) {
    intervalTime = SUUNTO_DURATION - cumulativeTime;
    RESULT = REST_TIME - intervalTime;
    postfix = "s";

    if (intervalTime >= REST_TIME) {
      intervalDone = 1;
      beepsRemaining = 3; /* Beep three time to sprint */
    }
  }
  else {
    intervalDistance = SUUNTO_DISTANCE - cumulativeDistance;
    RESULT = 0.621371 * (REST_DIST - intervalDistance);
    postfix = "mi";

    if (intervalDistance >= REST_DIST) {
      intervalDone = 1;
      beepsRemaining = 3;
    }
  }
}

/* Set everything up for the next interval, whatever it may be */
if (intervalDone == 1) {
  /* move on to next interval, until program complete */
  interval = interval + 1;

  intervalDone = 0;
  intervalDistance = 0;
  intervalTime = 0;
  cumulativeDistance = SUUNTO_DISTANCE;
  cumulativeTime = SUUNTO_DURATION;
}
else if (intervalDone >= 2) {
  /* Program complete, show totals */
  prefix = "DONE";
  RESULT = NUM_SPRINTS;
  postfix = "SP";
}

/* Beep as needed */
if (beepsRemaining > 0) {
  Suunto.alarmBeep();
  beepsRemaining = beepsRemaining - 1;
}
