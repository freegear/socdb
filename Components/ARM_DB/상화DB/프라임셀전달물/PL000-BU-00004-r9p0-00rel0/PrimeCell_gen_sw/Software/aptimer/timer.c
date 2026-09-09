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
 * File:     timer.c,v
 * Revision: 1.33
 * ----------------------------------------------------------------
 * 
 *  ----------------------------------------
 *  Version and Release Control Information:
 * 
 *  File Name              : timer.c.rca
 *  File Revision          : 1.2
 * 
 *  Release Information    : PrimeCell(TM)-GLOBAL-r9p0-00rel0
 *  ----------------------------------------
 *
 * Initialisation code for Timers
 */

#include "../apcommon/aptypes.h"
#include "../apcommon/apbitops.h"
#include "../apos/apos.h"
#include "aptimer.h"
#include "timer.h"


// Current default version is Integrator Timer. So if version not set, set to AP
#if !defined(apTIMER_VERSION)
  #define apTIMER_VERSION apTIMER_AP
#endif


/*
 * --------Data declarations--------
 */
#if !defined(apOS_NO_STATIC_STATE) || (!apOS_NO_STATIC_STATE)
  PRIVATE TIMER_sStateStruct TIMER_sState[apOS_TIMER_MAXIMUM];
#endif


/*====================================================================*/
PUBLIC UWORD32 apTIMER_StateSizeGet(void)
{
  return sizeof(TIMER_sStateStruct);
}


/*====================================================================*/
/*
 * This function is a raw interrupt service routine entry point, 
 * which can be called from the interrupt vector
 */
PUBLIC IRQ void apTIMER_RawISR(void)
{
  UWORD32 oId;
  apOS_INT_oInterruptSource oSource;

#if !apOS_NO_STATIC_STATE
  /*peripheral instance 0 if only one in use*/
  if (apOS_TIMER_MAXIMUM == 1)
  {
    oId= 0;
  }
  else
#endif
  {
    /*retrieve the peripheral instance*/
    oId= apOS_INT_InstanceGet();
  }
    
  /*retrieve the active interrupt source*/
  oSource= apOS_INT_SourceGet();

  /*call the normal ISR entry point*/
  apTIMER_IntHandler( oSource, oId);
}


/*====================================================================*/
PUBLIC void apTIMER_IntHandler(CONST apOS_INT_oInterruptSource oInterruptId,
                                     UWORD32 Timer)
{
  apOS_TIMER_oId oId = (apOS_TIMER_oId) Timer;
  TIMER_sStateStruct * pState = apSTATE_GET( TIMER, oId);
  TIMER_sRegisters * pBase = pState->pBaseAddress;
  apTIMER_eCallbackCondition eCondition;
  BOOL ReEnable = FALSE;
  BOOL ReturnFlag = FALSE;

  apINSTANCE_CHECK(TIMER);
     
  apOS_ISR_InterruptDisable(oInterruptId);
  apOS_INT_InterruptClear(oInterruptId);

#if !apOS_NO_STATIC_STATE && defined(apTIMER_VERSION) && apTIMER_VERSION == apTIMER_ADK
  /* ADK timers can have combined interrupt for two timers
   * so if first timer has not interrupted check second.
   * Only works if apOS_NO_STATIC_STATE is FALSE and oId's are sequential.
   */
  if(!apBIT_GET(pBase->MaskIntStatus,TIMER_INTERRUPT))
  {
    if(oId & 0x1)
    {
      oId =(apOS_TIMER_oId) (Timer - 1);
    }
    else
    {
      oId =(apOS_TIMER_oId) (Timer + 1);
    }  
    pState = apSTATE_GET( TIMER, oId);
    pBase = pState->pBaseAddress;
  }

#endif

#if defined(apTIMER_VERSION) && apTIMER_VERSION == apTIMER_ADK
  apBIT_SET(pBase->Control, TIMER_INT_ENABLE, TIMER_INT_DISABLED);
#endif
  apBIT_SET(pBase->Control, TIMER_ENABLE, TIMER_DISABLED);
  
  pBase->Clear = 0;

  /* If Square wave mode and in the Lo interval then check for extra time in the Lo entries
   * else just use normal extra counts for Hi square wave and any non square wave modes
   */
  if ((pState->eMode == apTIMER_MODE_SQUARE_WAVE) && (pState->eCurrentInterval == TIMER_LO))
  {
    if (pState->ExtraLoSaveCount)
    {
      if (pState->ExtraLoCount--) 
      {
        ReEnable = TRUE;
        ReturnFlag = TRUE;
      }
      else
      {
        pState->ExtraLoCount = pState->ExtraLoSaveCount;      
      }
    }
  }
  else
  {
    if (pState->ExtraSaveCount)
    {
      if (pState->ExtraCount--)
      {
        ReEnable = TRUE;
        ReturnFlag = TRUE;
      }
      else
      {
        pState->ExtraCount = pState->ExtraSaveCount;            
      }
    }
  }
  
  if (ReturnFlag == FALSE)
  {  
    switch (pState->eMode)
    {
      case apTIMER_MODE_SINGLE_SHOT:
        ReEnable = FALSE;
        eCondition = apTIMER_END;
        break;
      case apTIMER_MODE_PERIODIC:
        if (pState->RepeatCount == apTIMER_REPEAT_FOREVER)
        {
          ReEnable = TRUE;
          eCondition = apTIMER_CONTINUE;
        }
        else 
        {
          if (--pState->RepeatCount)
          {
            ReEnable = TRUE;
            eCondition = apTIMER_CONTINUE;
          }
          else
          {
            ReEnable = FALSE;
            eCondition = apTIMER_END;
          }
        }
        break;
      case apTIMER_MODE_WRAPAROUND:
        if (!(--pState->RepeatCount))
        {
          pState->RepeatCount = apTIMER_REPEAT_FOREVER;
          pState->eMode = apTIMER_MODE_PERIODIC;
          pState->ExtraSaveCount = 0;
          pState->ExtraCount = 0;
          pBase->Load = (pState->eSize == apTIMER_32_BIT) ? 0xffffffff : 0x0000ffff;
#if defined(apTIMER_VERSION) && apTIMER_VERSION == apTIMER_ADK
          apBIT_SET(pBase->Control, TIMER_PRESCALE, apTIMER_DIVIDE_BY_1);
#endif
         }
         ReEnable =TRUE;
         eCondition = apTIMER_CONTINUE;
         break;
      case apTIMER_MODE_SQUARE_WAVE:
        if (pState->eCurrentInterval == TIMER_HI)
        {
          if (--pState->RepeatCount)
          {
            pState->eCurrentInterval = TIMER_LO;
            eCondition = apTIMER_HIGH_END;
            pState->ExtraLoCount = pState->ExtraLoSaveCount;
            apBIT_SET(pBase->Control, TIMER_PRESCALE, pState->eLoIntervalPreScale);
            pBase->Load = pState->LoIntervalLoadValue;
            ReEnable = TRUE;
          }
          else
          {
          ReEnable = FALSE;
          eCondition = apTIMER_END;
          }
        }
        else
        {
          pState->eCurrentInterval = TIMER_HI;
          eCondition = apTIMER_LOW_END;
          pState->ExtraCount = pState->ExtraSaveCount;
          apBIT_SET(pBase->Control, TIMER_PRESCALE, pState->eIntervalPreScale);
          pBase->Load = pState->IntervalLoadValue;
          ReEnable = TRUE;
        }
        break;
      default:
          ReEnable = FALSE;
          eCondition = apTIMER_END;
      }
  
      /* run the user handler */
      if (pState->rHandler)
      {
        (pState->rHandler)(pState->HandlerParam, eCondition);
      }
    }
  
    if (ReEnable == TRUE)
    {
      apBIT_SET(pBase->Control, TIMER_ENABLE, TIMER_ENABLED);
#if defined(apTIMER_VERSION) && apTIMER_VERSION == apTIMER_ADK
      apBIT_SET(pBase->Control, TIMER_INT_ENABLE, TIMER_INT_ENABLED);
#endif
    }
  apOS_ISR_InterruptEnable(oInterruptId);

}


/*====================================================================*/
PUBLIC void apTIMER_Initialize (apOS_TIMER_oId oId,
                                apOS_System_eBaseAddress eBase,
                                UWORD32 Interrupts,
                                CONST apOS_INT_oInterruptSource * pSources,
                    apTIMER_sInitialData *pInitial)
{ 
  TIMER_sStateStruct * CONST pState = apSTATE_GET(TIMER, oId);
      
  apINSTANCE_CHECK(TIMER);

  apASSERT(pInitial->Clock > 0);
  
  pState->pBaseAddress = (TIMER_sRegisters *) eBase; 

  apTIMER_Stop( oId);
  apTIMER_Clear( oId);

  pState->ClockFrequency = pInitial->Clock;  
  pState->rHandler = aNULL;
  pState->eStatus = TIMER_FREE;
  pState->ExtraSaveCount = 0;
  pState->ExtraCount = 0;
  pState->ExtraLoSaveCount = 0;
  pState->ExtraLoCount = 0;
  pState->IntervalLoadValue = 0;
  pState->LoIntervalLoadValue = 0;
    
#if defined(apTIMER_VERSION) && apTIMER_VERSION == apTIMER_ADK
  pState->eSize = pInitial->eSize;
  apBIT_SET(pState->pBaseAddress->Control, TIMER_SIZE, pInitial->eSize);
#else
  pState->eSize = apTIMER_16_BIT;
#endif

  apBIND_ALL_INTERRUPTS( apTIMER_IntHandler, apTIMER_RawISR);

  /* Must have cast to apTIMER_eStatus because conditional operator has a result type
   * and because values on rhs are enums the result type is int. 
   * This then causes a compiler warning about casting int to enum type so need implicit cast.
   */
  pState->eStatus = (TIMER_eStatus) ((pInitial->eReserve ==  apTIMER_RESERVE_ON_INIT)
                                             ? TIMER_RESERVED : TIMER_FREE);
  }


/*====================================================================*/
PUBLIC void apTIMER_FrequencySet (apOS_TIMER_oId oId,
                                  apTIMER_rCallBackHandler rHandler,
                                  UWORD32 HandlerParam,
                                  double Frequency)
{
  long long longtemp;
  TIMER_sStateStruct * CONST pState = apSTATE_GET(TIMER, oId);
  TIMER_sRegisters * CONST pBase = pState->pBaseAddress;

  apINSTANCE_CHECK(TIMER);
  
  apASSERT(pState->ClockFrequency > 0);
  apASSERT(Frequency > 0);

  /* Disable timer */
  apTIMER_Stop( oId);

  /* set the mode to periodic, and repeat to repeat_forever since we will be repeating */ 
  apBIT_SET(pBase->Control, TIMER_MODE, TIMER_PERIODIC);
  pState->RepeatCount = apTIMER_REPEAT_FOREVER;

  /* set the user defined handler that will be called on interrupt */
  pState->rHandler = rHandler;
  pState->HandlerParam = HandlerParam;
  pState->eMode = apTIMER_MODE_PERIODIC;
  pState->LoIntervalLoadValue = 0;
  pState->ExtraLoSaveCount = 0;
  pState->ExtraLoCount = 0;

  longtemp = (long long)((pState->ClockFrequency)/Frequency);

  /* set the Load and ePrescale to match Frequency */ 
  if (pState->eSize == apTIMER_32_BIT)
  {
    TIMER_CalculateTime32(oId, longtemp, TIMER_STANDARD_INTERVAL);
  }
  else
  {  
    TIMER_CalculateTime16(oId, longtemp, TIMER_STANDARD_INTERVAL);
  }  

  /* Enable the timer */
  apTIMER_Start( oId);

}


/*====================================================================*/
PUBLIC double apTIMER_FrequencyGet (apOS_TIMER_oId oId)
{
  long long longtemp;
  double frequency;
  
  TIMER_sStateStruct * CONST pState = apSTATE_GET(TIMER, oId);

  apINSTANCE_CHECK(TIMER);
  
  longtemp = ((long long)pState->ExtraSaveCount + 1 ) *
                           ((long long)(pState->IntervalLoadValue) << (pState->eIntervalPreScale << 2));

  frequency = (double) (pState->ClockFrequency)/ (double)longtemp; 

  return frequency; 
}

/*====================================================================*/
PUBLIC void apTIMER_IntervalSet (apOS_TIMER_oId oId,
                                 apTIMER_rCallBackHandler rHandler,
                                 UWORD32 HandlerParam,
                                 apTIMER_sIntervalData *pIntervalData)
{  
  long long longtemp;
  TIMER_sStateStruct * CONST pState = apSTATE_GET(TIMER, oId);
  TIMER_sRegisters * CONST pBase = pState->pBaseAddress;

  apINSTANCE_CHECK(TIMER);
  
  /* disable the timer while we set things up - previous timer will be lost 
   */
  apTIMER_Stop( oId);

  apASSERT(pIntervalData->RepeatCount > 0);

  pState->rHandler     = rHandler;
  pState->HandlerParam = HandlerParam;
  pState->eMode        = pIntervalData->eMode;

  apBIT_SET(pBase->Control, TIMER_MODE, TIMER_PERIODIC);

  longtemp =  (long long) (pState->ClockFrequency) * (long long) pIntervalData->Interval;

  longtemp = TIMER_ConvertUnits( longtemp, pIntervalData->eIntervalUnits);

  if (pState->eSize == apTIMER_32_BIT)
  {
    TIMER_CalculateTime32(oId, longtemp, TIMER_STANDARD_INTERVAL);
  }
  else
  {
    TIMER_CalculateTime16(oId, longtemp, TIMER_STANDARD_INTERVAL);
  }  
  /* Check requested mode and set TIMER_sState values accordingly */
  switch (pIntervalData->eMode)
  {
  case apTIMER_MODE_SINGLE_SHOT:
    pState->RepeatCount = 1;
    break;
  case apTIMER_MODE_SQUARE_WAVE:
    pState->eCurrentInterval = TIMER_LO;
    pState->RepeatCount = pIntervalData->RepeatCount;
    longtemp =  (long long) (pState->ClockFrequency) * (long long) pIntervalData->LoInterval;

    longtemp = TIMER_ConvertUnits( longtemp, pIntervalData->eLoIntervalUnits);

    if (pState->eSize == apTIMER_32_BIT)
    {
      TIMER_CalculateTime32(oId, longtemp, TIMER_LO_INTERVAL);
    }
    else
    {
      TIMER_CalculateTime16(oId, longtemp, TIMER_LO_INTERVAL);
    }
    break;  
  case apTIMER_MODE_PERIODIC:
  case apTIMER_MODE_WRAPAROUND:
    pState->RepeatCount = pIntervalData->RepeatCount;
    break;   
  }
  
  /* If interval set and start straight away then enable timer */   
  if (pIntervalData->eStart == apTIMER_SET_AND_START)
  {
    apTIMER_Start( oId);
  }
}


/*====================================================================*/
PRIVATE long long TIMER_ConvertUnits(long long Interval,
                                     apTIMER_eUnits eUnits)
{
  long long longtemp = 0;

  /* Convert interval depending on units specified.
   */

    switch (eUnits)
   {
     case apTIMER_NANOSECONDS:
       longtemp = (Interval / (long long) 1000000000);
       break;
     case apTIMER_MICROSECONDS:
       longtemp = (Interval / (long long) 1000000);
       break;
     case apTIMER_MILLISECONDS:
       longtemp = (Interval / (long long) 1000);
       break;
     case apTIMER_SECONDS:
       longtemp = Interval;
       break;
    };

    if (longtemp == 0)
    {
      longtemp = 1;
      apDEBUG_WARN("Timer value too small, set to shortest time possible. %ll timer ticks \n", longtemp);
    }
    return longtemp;  
}


/*====================================================================*/
PRIVATE void TIMER_CalculateTime16(apOS_TIMER_oId oId,
                                   long long Interval,
                                   TIMER_eInterval eIntervalType)
{
  apTIMER_ePrescale ePrescale;

  TIMER_sStateStruct * CONST pState = apSTATE_GET(TIMER, oId);
  TIMER_sRegisters * CONST pBase = pState->pBaseAddress;

  volatile UWORD32 *pLoad = (eIntervalType == TIMER_STANDARD_INTERVAL) ? &pState->ExtraSaveCount : &pState->ExtraLoSaveCount;
  volatile UWORD32 *pCount = (eIntervalType == TIMER_STANDARD_INTERVAL) ? &pState->ExtraCount : &pState->ExtraLoCount;

  /* set the Load and ePrescale to match Interval in microseconds;
   */
  ePrescale = apTIMER_DIVIDE_BY_1;
  
  if (Interval & 0xffffffffffff0000ull)
  {
    Interval>>=4;
    ePrescale = apTIMER_DIVIDE_BY_16;
  }
  if (Interval & 0xffffffffffff0000ull)
  {
    Interval>>=4;
    ePrescale = apTIMER_DIVIDE_BY_256;
  }
  if (Interval & 0xffffffffffff0000ull)
  {
    /* timer won't fit - use additional counter */
    UWORD32 extras;

    // Calculate the number of pieces we have to split the interval
    extras = (UWORD32)((Interval >> 16) + 1);
    Interval  = Interval/extras;
    *pCount = extras-1;

    // Store the number of pieces (we'll need this for repeats), 
    // this also acts as a flag to say we are doing this extended interval.
    *pLoad = extras-1;

  }
  else
  {
    /* time will fit in 16 bits so clear additional counter */
    *pLoad = 0;
    *pCount = 0;
  }
  
  Interval = Interval & 0x000000000000ffff;
  
  if (eIntervalType == TIMER_STANDARD_INTERVAL)
  {
    pState->IntervalLoadValue = (UWORD32)Interval;
    pState->eIntervalPreScale = ePrescale;
  }
  else
  {
    pState->LoIntervalLoadValue = (UWORD32)Interval;
    pState->eLoIntervalPreScale = ePrescale;
  }
  
  pBase->Load = (UWORD32)Interval;
  apBIT_SET(pBase->Control, TIMER_PRESCALE, ePrescale);
}

/*====================================================================*/
PRIVATE void TIMER_CalculateTime32(apOS_TIMER_oId oId,
                                   long long Interval,
                                   TIMER_eInterval eIntervalType)
{
  apTIMER_ePrescale ePrescale;

  TIMER_sStateStruct * CONST pState = apSTATE_GET(TIMER, oId);
  TIMER_sRegisters * CONST pBase = pState->pBaseAddress;

  volatile UWORD32 *pLoad = (eIntervalType == TIMER_STANDARD_INTERVAL) ? &pState->ExtraSaveCount : &pState->ExtraLoSaveCount;
  volatile UWORD32 *pCount = (eIntervalType == TIMER_STANDARD_INTERVAL) ? &pState->ExtraCount : &pState->ExtraLoCount;

  /* set the Load and ePrescale to match Interval in microseconds;
   * We have to use 64-bit longlong's to prevent overflows.
   */
  ePrescale = apTIMER_DIVIDE_BY_1;
  
  if (Interval & 0xffffffff00000000ull)
  {
    Interval>>=4;
    ePrescale = apTIMER_DIVIDE_BY_16;
  }
  if (Interval & 0xffffffff00000000ull)
  {
    Interval>>=4;
    ePrescale = apTIMER_DIVIDE_BY_256;
  }
  if (Interval & 0xffffffff00000000ull)
  {
    /* timer won't fit - use additional counter */
    UWORD32 extras;

    // Calculate the number of pieces we have to split the interval
    extras = (UWORD32)((Interval >> 32) + 1);
    Interval  = Interval/extras;
    *pCount = extras-1;

    // Store the number of pieces (we'll need this for repeats), 
    // this also acts as a flag to say we are doing this extended interval.
    *pLoad = extras-1;

  }
  else
  {
    /* time will fit in 32 bits so clear additional counter */
    *pLoad = 0;
    *pCount = 0;
  }
  
  Interval = Interval & 0x00000000ffffffff;
  
  if (eIntervalType == TIMER_STANDARD_INTERVAL)
  {
    pState->IntervalLoadValue = (UWORD32)Interval;
    pState->eIntervalPreScale = ePrescale;
  }
  else
  {
    pState->LoIntervalLoadValue = (UWORD32)Interval;
    pState->eLoIntervalPreScale = ePrescale;
  }
  
  pBase->Load = (UWORD32)Interval;
  apBIT_SET(pBase->Control, TIMER_PRESCALE, ePrescale);
}

/*====================================================================*/
PUBLIC void apTIMER_Start (apOS_TIMER_oId oId)
{
  TIMER_sStateStruct * CONST pState = apSTATE_GET(TIMER, oId);
  TIMER_sRegisters * CONST pBase = pState->pBaseAddress;
    
  apINSTANCE_CHECK(TIMER);

  apTIMER_Clear(oId);
  apBIT_SET(pBase->Control, TIMER_ENABLE, TIMER_ENABLED);
#if defined(apTIMER_VERSION) && apTIMER_VERSION == apTIMER_ADK
  apBIT_SET(pBase->Control, TIMER_INT_ENABLE, TIMER_INT_ENABLED);
#endif
}


/*====================================================================*/
PUBLIC void apTIMER_Stop (apOS_TIMER_oId oId)
{
  TIMER_sStateStruct * CONST pState = apSTATE_GET(TIMER, oId);
  TIMER_sRegisters * CONST pBase = pState->pBaseAddress;
    
  apINSTANCE_CHECK(TIMER);

  apBIT_SET(pBase->Control, TIMER_ENABLE, TIMER_DISABLED);
#if defined(apTIMER_VERSION) && apTIMER_VERSION == apTIMER_ADK
  apBIT_SET(pBase->Control, TIMER_INT_ENABLE, TIMER_INT_DISABLED);
#endif
} 


/*====================================================================*/
PUBLIC void apTIMER_CallbackSet (apOS_TIMER_oId oId,
                                 apTIMER_rCallBackHandler rHandler)
{
  TIMER_sStateStruct * CONST pState = apSTATE_GET(TIMER, oId);
  
  apINSTANCE_CHECK(TIMER);

  pState->rHandler = rHandler;
}


/*====================================================================*/
PUBLIC apError apTIMER_SetReserve (apOS_TIMER_oId oId)
{
  TIMER_sStateStruct * CONST pState = apSTATE_GET(TIMER, oId);
  TIMER_sRegisters * CONST pBase = pState->pBaseAddress;
      
  apINSTANCE_CHECK(TIMER);
  
  if((pState->eStatus == TIMER_RESERVED) ||
     (apBIT_GET(pBase->Control, TIMER_ENABLE)))
  {
    return apERR_BUSY;
  }
  
  pState->eStatus = TIMER_RESERVED;
  return apERR_NONE;
}


/*====================================================================*/
PUBLIC apError apTIMER_SetFree (apOS_TIMER_oId oId)
{
  TIMER_sStateStruct * CONST pState = apSTATE_GET(TIMER, oId);
  TIMER_sRegisters * CONST pBase = pState->pBaseAddress;
    
  apINSTANCE_CHECK(TIMER);

  if(apBIT_GET(pBase->Control, TIMER_ENABLE))
  {
    return apERR_BUSY;
  }

  pState->eStatus = TIMER_FREE;
  return apERR_NONE;
}


/*====================================================================*/
PUBLIC apError apTIMER_CheckStatus (apOS_TIMER_oId oId)
{
  TIMER_sStateStruct * CONST pState = apSTATE_GET(TIMER, oId);
  TIMER_sRegisters * CONST pBase = pState->pBaseAddress;
    
  apINSTANCE_CHECK(TIMER);

  if((pState->eStatus == TIMER_RESERVED) ||
     (apBIT_GET(pBase->Control, TIMER_ENABLE)))
  {
    return apERR_BUSY;
  }
  return apERR_NONE;
}


/*====================================================================*/
PUBLIC void apTIMER_Clear (apOS_TIMER_oId oId)
{
  TIMER_sStateStruct * CONST pState = apSTATE_GET(TIMER, oId);
  TIMER_sRegisters * CONST pBase = pState->pBaseAddress;
    
  apINSTANCE_CHECK(TIMER);

  pBase->Clear = 0; 
}


/*====================================================================*/
PUBLIC UWORD32 apTIMER_ValueGet (apOS_TIMER_oId oId)
{  
  TIMER_sStateStruct * CONST pState = apSTATE_GET(TIMER, oId);
  TIMER_sRegisters * CONST pBase = pState->pBaseAddress;
      
  apINSTANCE_CHECK(TIMER);

  return pBase->Value;
}


/*====================================================================*/
PUBLIC void apTIMER_Load (apOS_TIMER_oId oId, UWORD32 Interval)
{  
  TIMER_sStateStruct * CONST pState = apSTATE_GET(TIMER, oId);
  TIMER_sRegisters * CONST pBase = pState->pBaseAddress;
      
  apINSTANCE_CHECK(TIMER);

  pBase->Load = Interval;
}

/*====================================================================*/
PUBLIC void apTIMER_LoadBackground (apOS_TIMER_oId oId, UWORD32 Interval)
{  
  TIMER_sStateStruct * CONST pState = apSTATE_GET(TIMER, oId);
  TIMER_sRegisters * CONST pBase = pState->pBaseAddress;
      
  apINSTANCE_CHECK(TIMER);

#if defined(apTIMER_VERSION) && apTIMER_VERSION == apTIMER_ADK
  pBase->BackgroundLoad = Interval;
#else
  IGNORE(pBase);
  IGNORE(Interval);
#endif
}

/*====================================================================*/
PUBLIC apTIMER_ePrescale apTIMER_PrescaleGet (apOS_TIMER_oId oId)
{
  TIMER_sStateStruct * CONST pState = apSTATE_GET(TIMER, oId);
  TIMER_sRegisters * CONST pBase = pState->pBaseAddress;
    
  apINSTANCE_CHECK(TIMER);

  return (apTIMER_ePrescale) apBIT_GET(pBase->Control, TIMER_PRESCALE);
}

/*====================================================================*/
PUBLIC void apTIMER_PrescaleSet (apOS_TIMER_oId oId, apTIMER_ePrescale ePrescale)
{
  TIMER_sStateStruct * CONST pState = apSTATE_GET(TIMER, oId);
  TIMER_sRegisters * CONST pBase = pState->pBaseAddress;
    
  apINSTANCE_CHECK(TIMER);
  apASSERT(ePrescale == apTIMER_DIVIDE_BY_1  ||
           ePrescale == apTIMER_DIVIDE_BY_16 ||
           ePrescale == apTIMER_DIVIDE_BY_256);

  apBIT_SET(pBase->Control, TIMER_PRESCALE, ePrescale);
}

/*====================================================================*/
PUBLIC apError apTIMER_ModeSet (apOS_TIMER_oId oId, apTIMER_eMode eMode)
{
  apError ReturnStatus = apERR_NONE;
  TIMER_sStateStruct * CONST pState = apSTATE_GET(TIMER, oId);
  TIMER_sRegisters * CONST pBase = pState->pBaseAddress;
    
  apINSTANCE_CHECK(TIMER);

  switch (eMode)
  {
  case apTIMER_MODE_SINGLE_SHOT:
    apBIT_SET(pBase->Control, TIMER_MODE, TIMER_PERIODIC);
    pState->eMode = apTIMER_MODE_SINGLE_SHOT;
    pState->RepeatCount = 1;
    break;
  case apTIMER_MODE_SQUARE_WAVE:
    ReturnStatus = apERR_UNSUPPORTED;
    break;  
  case apTIMER_MODE_PERIODIC:
    apBIT_SET(pBase->Control, TIMER_MODE, TIMER_PERIODIC);
    pState->eMode = apTIMER_MODE_PERIODIC;  
    pState->RepeatCount = apTIMER_REPEAT_FOREVER;
    break;
  case apTIMER_MODE_WRAPAROUND:
    apBIT_SET(pBase->Control, TIMER_MODE, TIMER_FREE_RUNNING);
    pState->eMode = apTIMER_MODE_WRAPAROUND;  
    pState->RepeatCount = 1;
    break;   
  default:
    ReturnStatus = apERR_UNSUPPORTED;
  }

  return ReturnStatus;
}