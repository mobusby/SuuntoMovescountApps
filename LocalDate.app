/*------------------------------------------------------------------------------
  Local Date
  Display the current local date as "20YY" M.DD "WW".

  Before 2015 and after 2020 the app does not display the year.  The app gives false values after 2099 (2100 is not a leap year, but the app thinks it is).

  Variables:
    days = 0  <-- will = SUUNTO_DAYS_AFTER_1_1_2000, except during calculation, then will be epoch days (days elapsed since start of current 4-year epoch)
	monthDay = 0   <-- day of current month
	workingVar = 0 <-- Working Variable; ends as current month

  Format:
    2 decimal

  Test Vector:
    Thursday, Jan 1, 2015 = 5479 days
 -----------------------------------------------------------------------------*/

/* only run if needed */
if (SUUNTO_DAYS_AFTER_1_1_2000 != days) {

  /* 1 epoch = 1461 days = 4 years = days between 1 Jan of sequential leap
     years; definition fails in 2100 */
  days = Suunto.mod(SUUNTO_DAYS_AFTER_1_1_2000, 1461);

  /* Calculate the current year (workingVar = years since 2000.1.1) */
  workingVar = 4 * (SUUNTO_DAYS_AFTER_1_1_2000 - days) / 1461;
  if (days > 365)  { workingVar = workingVar + 1; }
  if (days > 730)  { workingVar = workingVar + 1; }
  if (days > 1095) { workingVar = workingVar + 1; }

  /* set the prefix */
       if (workingVar == 15) { prefix = "2015"; }
  else if (workingVar == 16) { prefix = "2016"; }
  else if (workingVar == 17) { prefix = "2017"; }
  else if (workingVar == 18) { prefix = "2018"; }
  else if (workingVar == 19) { prefix = "2019"; }
  else if (workingVar == 20) { prefix = "2020"; }
  else { prefix = ""; }

  /* Determine day of week (workingVar = days since beginning of week) */
  workingVar = Suunto.mod(SUUNTO_DAYS_AFTER_1_1_2000, 7);
       if (workingVar == 0) { postfix = "Sa"; }
  else if (workingVar == 1) { postfix = "Su"; }
  else if (workingVar == 2) { postfix = "Mo"; }
  else if (workingVar == 3) { postfix = "Tu"; }
  else if (workingVar == 4) { postfix = "We"; }
  else if (workingVar == 5) { postfix = "Th"; }
  else                      { postfix = "Fr"; }

  /* Get day of Month (workingVar = days since beginning of year); monthDay acts as leap-year place holder until needed */
  if (days > 366) {
    workingVar = Suunto.mod(days - 366, 365);
    monthDay = 0;
  }
  else {
    workingVar = days;
    monthDay = 1;
  }

  /* Determine Month and Day of Month */
       if (workingVar < 31 )            { monthDay = workingVar;                  workingVar = 1; }
  else if (workingVar < 59  + monthDay) { monthDay = workingVar -  30;            workingVar = 2; }
  else if (workingVar < 90  + monthDay) { monthDay = workingVar -  58 - monthDay; workingVar = 3; }
  else if (workingVar < 120 + monthDay) { monthDay = workingVar -  89 - monthDay; workingVar = 4; }
  else if (workingVar < 151 + monthDay) { monthDay = workingVar - 119 - monthDay; workingVar = 5; }
  else if (workingVar < 181 + monthDay) { monthDay = workingVar - 150 - monthDay; workingVar = 6; }
  else if (workingVar < 212 + monthDay) { monthDay = workingVar - 180 - monthDay; workingVar = 7; }
  else if (workingVar < 243 + monthDay) { monthDay = workingVar - 211 - monthDay; workingVar = 8; }
  else if (workingVar < 273 + monthDay) { monthDay = workingVar - 242 - monthDay; workingVar = 9; }
  else if (workingVar < 304 + monthDay) { monthDay = workingVar - 272 - monthDay; workingVar = 10; }
  else if (workingVar < 334 + monthDay) { monthDay = workingVar - 303 - monthDay; workingVar = 11; }
  else                                  { monthDay = workingVar - 333 - monthDay; workingVar = 12; }

  days = SUUNTO_DAYS_AFTER_1_1_2000;
}

RESULT = workingVar + monthDay / 100;
