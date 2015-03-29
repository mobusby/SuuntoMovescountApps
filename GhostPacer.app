/*----------------------------------------------------------------------
  Ghost Pacer
  Outrun the ghost!  Set GHOSTPACE (in seconds per mile), sync your watch, and go for a run.  The app will show you (X), the ghost (0), and the distance between you.

  Variables:
    GHOSTPACE      = 470 <-- Set to your desired pace (seconds per mile)
    GHOSTDISTANCE  = 0   <-- how far the ghost has traveled (m)
    OWNDISTANCE    = 0   <-- how far you have traveled (m)
    INTIALDURATION = 0   <-- for multi-sport modes, duration upon start

  Format:
    0 decimals

  Test Vector:
    obvious
-----------------------------------------------------------------------*/

/* Initialization of all variables upon start */
if (SUUNTO_DURATION == 0 || (SUUNTO_LAP_NUMBER == 1 && SUUNTO_LAP_DURATION == 0)) {
  /* GHOSTPACE		= 480;  /* use the value specified in the app */
  GHOSTDISTANCE		= 0;
  OWNDISTANCE		= 0;
  INITIALDURATION = SUUNTO_DURATION;
}
else {

  /* Calculate distances in yards ( 1 mi = 1.609 km = 1760 yd ) */
  /*
  GHOSTDISTANCE = (1760 / GHOSTPACE) * (SUUNTO_DURATION - INITIALDURATION);
  OWNDISTANCE	  = 1760 * SUUNTO_DISTANCE / 1.609;
  */

  /* Calculate distances in meters ( 1 mi = 1.609 km = 1609 m; 1 km = 1000 m ) */
  GHOSTDISTANCE = (1609 / GHOSTPACE) * (SUUNTO_DURATION - INITIALDURATION);
  OWNDISTANCE = SUUNTO_DISTANCE * 1000;

  /* Result is the difference */
  RESULT 	= Suunto.abs(OWNDISTANCE - GHOSTDISTANCE);

  /* Set prefix and postfix */
  if (OWNDISTANCE > GHOSTDISTANCE) {
    prefix = ">~0";
    postfix = "X~>";
  }
  else {
    prefix = ">~X";
    postfix = "0~>";
  }
}
