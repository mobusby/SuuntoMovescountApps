/*------------------------------------------------------------------------------
  Pressure Altitude
  Display the current pressure altitude.  See http://en.wikipedia.org/wiki/Pressure_altitude

  Variables:
    none

  Format:
    0 decimals

  Test vector:
    Altitude = 0; Pressure = 1013; result should be 0
------------------------------------------------------------------------------*/

/* Estimate the pressure altitude */
prefix = "PA";
postfix = "ft";

RESULT = 3.28084 * (SUUNTO_ALTI + 30 * (1013.25 - SUUNTO_PRESSURE));
