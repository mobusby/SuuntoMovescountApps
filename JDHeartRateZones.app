/*------------------------------------------------------------------------------
  JD Heart Rate Zones
  Display your current heart rate zone, based on Jack Daniel's Running Formula, 3rd Edition, Table 5.4.

  Variables:
    none

  Format:
    0 decimals

  Test Vector:
    obvious
------------------------------------------------------------------------------*/

/* Setup */
if (SUUNTO_DURATION == 0) {
  prefix = "Zn";
  RESULT = 0;
  postfix = "NA";
}

if (SUUNTO_HR >= 0.97 * SUUNTO_USER_MAX_HR) {
  RESULT = 5;
  postfix = "I";
}
else if (SUUNTO_HR >= 0.92 * SUUNTO_USER_MAX_HR) {
  RESULT = 4;
  postfix = "10k";
}
else if (SUUNTO_HR >= 0.88 * SUUNTO_USER_MAX_HR) {
  RESULT = 3;
  postfix = "T";
}
else if (SUUNTO_HR >= 0.80 * SUUNTO_USER_MAX_HR) {
  RESULT = 2;
  postfix = "M";
}
else if (SUUNTO_HR >= 0.65 * SUUNTO_USER_MAX_HR) {
  RESULT = 1;
  postfix = "E";
}
else {
  RESULT = 0;
  postfix = "NA";
}
