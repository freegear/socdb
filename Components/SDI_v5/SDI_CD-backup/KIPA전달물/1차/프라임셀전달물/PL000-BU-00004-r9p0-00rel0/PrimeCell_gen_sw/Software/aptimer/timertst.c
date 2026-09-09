/*
 * Copyright: 
 * ----------------------------------------------------------------
 * This confidential and proprietary software may be used only as
 * authorised by a licensing agreement from ARM Limited
 *   (C) COPYRIGHT 2000,2001 ARM Limited
 *       ALL RIGHTS RESERVED
 * The entire notice above must be reproduced on all authorised
 * copies and copies may only be made to the extent permitted
 * by a licensing agreement from ARM Limited.
 * ----------------------------------------------------------------
 * File:     timertst.c,v
 * Revision: 1.43
 * ----------------------------------------------------------------
 * 
 *  ----------------------------------------
 *  Version and Release Control Information:
 * 
 *  File Name              : timertst.c.rca
 *  File Revision          : 1.2
 * 
 *  Release Information    : PrimeCell(TM)-GLOBAL-r9p0-00rel0
 *  ----------------------------------------
 *
 * Test code for Timers
 */

#include "../apcommon/aptypes.h"
#include "../apos/apos.h"
#include "../apint/apint.h"
#include "../aptest/aptest.h"
#include "aptimer.h"

#include <time.h>
#include <stdio.h>

#define TIMER_NO_TESTS 0
#define TIMER_MINIMUM_TESTS 1
#define TIMER_ALL_TESTS 2

#define TIMER_RUN_TESTS  TIMER_NO_TESTS

PRIVATE volatile apTIMER_eSize TIMER_eSize;

#if TIMER_RUN_TESTS != TIMER_NO_TESTS
PRIVATE volatile UWORD32 TIMER_Finished;

#if TIMER_RUN_TESTS == TIMER_ALL_TESTS
PRIVATE volatile UWORD32 TIMER_Print;
PRIVATE volatile UWORD32 TIMER_Repeat;

PRIVATE void TIMER_FrequencyRoutine  (UWORD32 Param, apTIMER_eCallbackCondition eCondition);
PRIVATE void TIMER_SquareRoutine     (UWORD32 Param, apTIMER_eCallbackCondition eCondition);
PRIVATE void TIMER_WraparoundRoutine (UWORD32 Param, apTIMER_eCallbackCondition eCondition);
#endif

PRIVATE void TIMER_CallbackRoutine   (UWORD32 Param, apTIMER_eCallbackCondition eCondition);

PRIVATE void TIMER_Test(apOS_TIMER_oId oId);

PRIVATE void TIMER_IntervalTest(apOS_TIMER_oId oId,
                                apTIMER_rCallBackHandler rHandler,
                                apTIMER_sIntervalData *Interval,
                                UWORD32 repeat);
#endif

PROTECTED apTEST_eResult apTIMER_SelfTest(UWORD32 Id,
                                          UWORD32 Base_addr,
                                          UWORD32 NumSources,
                                          CONST apOS_INT_oInterruptSource * CONST pInt);

/*====================================================================*/
PROTECTED apTEST_eResult apTIMER_SelfTest(UWORD32 Id,
                                          UWORD32 Base_addr,
                                          UWORD32 NumSources,
                                          CONST apOS_INT_oInterruptSource * CONST pInt)
{
apTIMER_sInitialData sTimerData;
CONST apOS_TIMER_oId oId=(apOS_TIMER_oId) Id;

#if (defined(apTIMER_VERSION) && (apTIMER_VERSION ==  apVERSION_ARMULATOR))
  sTimerData.Clock = (UWORD32) ((UWORD32)((oId==0)?20:24)*(UWORD32)100);
#else
  sTimerData.Clock = (UWORD32) (((oId==0)?20UL:24UL)*1000000UL);
#endif

#if (defined(apTIMER_VERSION) && (apTIMER_VERSION == apTIMER_ADK))
  if(oId != 0)
  {
    sTimerData.Clock = 32768;
  }
#endif

#if (defined(apTIMER_VERSION) && (apTIMER_VERSION == apTIMER_ADK))
  sTimerData.eSize = apTIMER_32_BIT;
  TIMER_eSize = apTIMER_32_BIT;
#else
  sTimerData.eSize = apTIMER_16_BIT;
  TIMER_eSize = apTIMER_16_BIT;
#endif
  sTimerData.eReserve = apTIMER_NO_RESERVE_ON_INIT;

  apTIMER_Initialize (oId,
                      (apOS_System_eBaseAddress) Base_addr,
                      NumSources,
                      pInt,
                      &sTimerData);

#if TIMER_RUN_TESTS != TIMER_NO_TESTS
  TIMER_Test (oId);
#endif

  return apTEST_PASS;    
}

#if TIMER_RUN_TESTS != TIMER_NO_TESTS
/*====================================================================*/
PRIVATE void TIMER_Test (apOS_TIMER_oId oId)
{
  apTIMER_sIntervalData sIntervalData;

#if TIMER_RUN_TESTS == TIMER_ALL_TESTS
  time_t start_time;
  time_t end_time;
  double total_time;
  double Frequency;
#endif

//Test 1     
  sIntervalData.eMode            =  apTIMER_MODE_SINGLE_SHOT;
  sIntervalData.Interval         =  (UWORD32) 10;
  sIntervalData.eIntervalUnits   =  apTIMER_SECONDS;
  sIntervalData.LoInterval       =  (UWORD32) 4;
  sIntervalData.eLoIntervalUnits =  apTIMER_SECONDS;
  sIntervalData.RepeatCount      =  1;
  sIntervalData.eStart           =  apTIMER_SET_AND_START;
  
  printf("%ld Second interval test\n", sIntervalData.Interval);
  TIMER_IntervalTest (oId, &TIMER_CallbackRoutine, &sIntervalData, sIntervalData.RepeatCount); 

#if TIMER_RUN_TESTS == TIMER_ALL_TESTS
//Test 2 
  sIntervalData.eMode            =  apTIMER_MODE_PERIODIC;
  sIntervalData.Interval         =  (UWORD32) 1;
  sIntervalData.eIntervalUnits   =  apTIMER_SECONDS;
  sIntervalData.LoInterval       =  (UWORD32) 4;
  sIntervalData.eLoIntervalUnits =  apTIMER_SECONDS;
  sIntervalData.RepeatCount      =  10;

  printf("%ld Second Averaged interval test\n", sIntervalData.Interval);
  TIMER_IntervalTest (oId, &TIMER_CallbackRoutine, &sIntervalData, sIntervalData.RepeatCount); 

//Test 3
  sIntervalData.Interval       = (UWORD32) 1000000;
  sIntervalData.eIntervalUnits = apTIMER_MICROSECONDS;
  printf("%ld Millisecond Averaged interval test\n", sIntervalData.Interval);
  TIMER_IntervalTest (oId, &TIMER_CallbackRoutine, &sIntervalData, sIntervalData.RepeatCount); 

//Test 4
  printf("Square wave mode test\n");

  sIntervalData.eMode            =  apTIMER_MODE_SQUARE_WAVE;
  sIntervalData.Interval         =  (UWORD32) 10;
  sIntervalData.eIntervalUnits   =  apTIMER_SECONDS;
  sIntervalData.LoInterval       =  (UWORD32) 5;
  sIntervalData.eLoIntervalUnits =  apTIMER_SECONDS;
  sIntervalData.RepeatCount      =  3;

  TIMER_Finished = 0;
  start_time = time(aNULL);
  apTIMER_IntervalSet (oId, &TIMER_SquareRoutine, 0, &sIntervalData);

  while (!TIMER_Finished || TIMER_Print)
  {
    if (TIMER_Print == 1)
    {
        end_time = time(aNULL);
        printf ("Interval time: %f seconds\n", difftime(end_time, start_time));
        TIMER_Print = 0;
        start_time = time(aNULL);
    }
  }

//Test 5
  if(TIMER_eSize == apTIMER_16_BIT)
  {
    printf("Wrap arround mode\n");
  
    sIntervalData.eMode =    apTIMER_MODE_WRAPAROUND;
    sIntervalData.Interval =    (UWORD32) 10;
    sIntervalData.eIntervalUnits =  apTIMER_SECONDS;
    sIntervalData.LoInterval =  (UWORD32) 5;
    sIntervalData.eLoIntervalUnits =  apTIMER_SECONDS;
    sIntervalData.RepeatCount =   3;

    TIMER_Finished = 0;
    TIMER_Repeat = 10;
    start_time = time(aNULL);
    apTIMER_IntervalSet (oId, &TIMER_WraparoundRoutine, 0, &sIntervalData);

    while (!TIMER_Finished || TIMER_Print)
    {
    if (TIMER_Print == 1)
      {
         end_time = time(aNULL);
         printf ("Interval time: %f seconds\n", difftime(end_time, start_time));
         TIMER_Print = 0;
         start_time = time(aNULL);
      }
    }
 
    apTIMER_Stop(oId);
  }
  
//Test 6
  printf("Frequency Mode\n");
  
  apTIMER_FrequencySet (oId, &TIMER_FrequencyRoutine, 0,(double)0.5);
  Frequency = apTIMER_FrequencyGet (oId);
  printf("Frequency Set = %f Hz\n",Frequency);
  start_time = time(aNULL);

  TIMER_Repeat = 3;
  TIMER_Finished = 0;
  while (!TIMER_Finished)
  { 
  }
  apTIMER_Stop(oId);
  
  end_time = time(aNULL);
  total_time = difftime(end_time, start_time);
  printf ("Total time Interval time: %f seconds\n", difftime(end_time, start_time));
  printf ("Average actual interval time: %f seconds\n\n", total_time/3);

//Test 7 Check for 0 Interval
  sIntervalData.eMode            =  apTIMER_MODE_SINGLE_SHOT;
  sIntervalData.Interval         =  (UWORD32) 0;
  sIntervalData.eIntervalUnits   =  apTIMER_SECONDS;
  sIntervalData.LoInterval       =  (UWORD32) 0;
  sIntervalData.eLoIntervalUnits =  apTIMER_SECONDS;
  sIntervalData.RepeatCount      =  1;
  sIntervalData.eStart           =  apTIMER_SET_AND_START;
  
  TIMER_IntervalTest (oId, &TIMER_CallbackRoutine, &sIntervalData, sIntervalData.RepeatCount); 

//Test 8 Code Coverage Checks
 {
  apError error;
  apTIMER_ePrescale ePrescale;
  UWORD32 value;
  /* Set timer reserve should return apERR_NONE */
  error = apTIMER_SetReserve(oId);
  
  /* Attempt to set reserve again should return busy */
  error = apTIMER_SetReserve(oId);
  
  /* Check status, should return apERR_BUSY */ 
  error = apTIMER_CheckStatus(oId);
  
  /* Low level setup of timer */
  apTIMER_CallbackSet(oId, &TIMER_CallbackRoutine);
  
  apTIMER_Load(oId, 1000);
  
  apTIMER_LoadBackground(oId, 1000);
  
  apTIMER_PrescaleSet(oId, apTIMER_DIVIDE_BY_1);
  
  ePrescale = apTIMER_PrescaleGet(oId);
  
  error = apTIMER_ModeSet(oId, apTIMER_MODE_PERIODIC);
  
  apTIMER_Start(oId);
  
  /* Attempt to set free should return busy*/
  error = apTIMER_SetFree(oId);
  
  apTIMER_Stop(oId);
  
  value = apTIMER_ValueGet(oId);
  
  /* Free timer should return apERR_NONE */
  error = apTIMER_SetFree(oId);

  /* Check status, should return apERR_NONE */ 
  error = apTIMER_CheckStatus(oId);
 } 
#endif   
}

/*====================================================================*/
PRIVATE void TIMER_IntervalTest (apOS_TIMER_oId oId,
                                     apTIMER_rCallBackHandler rHandler,
                                     apTIMER_sIntervalData *pInterval,
                                     UWORD32 Repeat)
{
  double total_time;
  time_t end_time;
  time_t start_time = time(aNULL);
    
  TIMER_Finished = 0;
  apTIMER_IntervalSet (oId, rHandler, 0, pInterval);

  while (!TIMER_Finished)
  {
  }
  
  end_time = time(aNULL);
  total_time = difftime(end_time, start_time);

#if TIMER_RUN_TESTS == TIMER_ALL_TESTS
  if (Repeat == 1)
  {
    printf ("\nInterval Time = %f seconds\n\n", total_time);
  }
  else
  {  
    printf ("\nTotal Time for %ld Intervals: %f seconds\n", Repeat, total_time);
    printf ("Average actual interval time: %f seconds\n\n", total_time/Repeat);
  }
#else
  IGNORE(Repeat);
#endif
}

/*====================================================================*/
PRIVATE void TIMER_CallbackRoutine (UWORD32 Param, apTIMER_eCallbackCondition eCondition)
{
  IGNORE (Param);
  if (eCondition == apTIMER_END)
  {
    TIMER_Finished = 1;
  }
}
#endif  // end of #if TIMER_RUN_TESTS != TIMER_NO_TESTS

#if TIMER_RUN_TESTS == TIMER_ALL_TESTS
/*====================================================================*/

PRIVATE void TIMER_FrequencyRoutine(UWORD32 Param, apTIMER_eCallbackCondition eCondition)
{
  IGNORE (Param);
  IGNORE (eCondition);
  TIMER_Repeat--;
  if (TIMER_Repeat == 0)
  {
    TIMER_Finished = 1;
  }
}

/*====================================================================*/
PRIVATE void TIMER_WraparoundRoutine (UWORD32 Param, apTIMER_eCallbackCondition eCondition)
{
  IGNORE (Param);
  TIMER_Print = 1;

  if(--TIMER_Repeat)
  {
    if (eCondition == apTIMER_END)
    {
      TIMER_Finished = 1;
    }
  }
  else
  {
    TIMER_Finished = 1;
  }
}
/*====================================================================*/
PRIVATE void TIMER_SquareRoutine (UWORD32 Param, apTIMER_eCallbackCondition eCondition)
{
  IGNORE (Param);
  TIMER_Print = 1;
  if (eCondition == apTIMER_LOW_END)
  {
    printf("LOW END = ");
  }
  if (eCondition == apTIMER_HIGH_END)
  {
    printf("HIGH END = ");
  }
  if (eCondition == apTIMER_END)
  {
    printf("HIGH END = ");
    TIMER_Finished = 1;
  }
}
#endif
