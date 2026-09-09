/* --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : RandomTest.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           To test with Random values of the configuration registers.
--
-- --=========================================================================*/
 
/******************************************************************************/
/************************* List of Functions Called ***************************/
/******************************************************************************/
/*** Function name                              Located in                  ***/
/*** ---------------------------------------------------------------------- ***/
/*** ApplyIntr()                                IntRoutines.c               ***/
/******************************************************************************/
 
/******************************************************************************/
/***************** Interrupt  Stacking Test (Including Daisy) *****************/
/******************************************************************************/


char Str[120];
int seed;

void RandInitReg()
{
  /* Initialise the register values.             */
  /* All the interrupt are IRQs - 32 IRQs.       */
  /* Daisy is set to IRQ - 33rd Interrupt.       */
  /* No soft priority, No soft priority masking. */
  int i, j, prio;
  int TPrio[32];

  D_VICTrTCR = 0x05F;

  srandom(seed++);
  init_addr = random();

  D_VICIntEnable = 0xFFFFFFFF;
  D_VICSoftInt   = 0x00000000;

  srandom(seed++);
  D_VICIntSelect = random();

  srandom(seed++);
  prio = random();
  D_VICSWPriorityMask = prio & 0xFFFF;

  srandom(seed++);
  prio = random();
  D_VICVectPriorityDaisy = prio & 0xF;

  D_TrIntIn      = 0x00000001;
  ProtectionOff  = 0x00000000;
  D_TrVectAddrIn = 0xAAAA0000;
  for(i = 0; i < INT_COUNT; i++)
  {
    srandom(seed++);
    prio = random();
    prio = prio &0xF;
    D_VICVectPriority[i] = prio;
    TPrio[i] = prio;
    SWPrio[i] = i;
  }
  
  /* sort the priority values and keep them in SWPrio to determine the     *
   * highest priority interrupt when checking the address.                 */
  for(i = 0; i < INT_COUNT; i++)
  {
    for(j = 0; j < INT_COUNT-1; j++)
    {
      if(TPrio[j]>TPrio[j+1])
      {
        /* Swap in array TPrio */
        prio = TPrio[j];
        TPrio[j] = TPrio[j+1];
        TPrio[j+1] = prio;
        /* Swap in array SWPrio */
        prio = SWPrio[j];
        SWPrio[j] = SWPrio[j+1];
        SWPrio[j+1] = prio;
      }
    }
  }
 
 

}

/* ************************************************************************** */
/* Select Random interrupts.                                                  */
/* ************************************************************************** */
int RandInt()
{
  srandom(seed++);
  return random();
}

void RandomTest()
{
  /*
    Summary: Random Test 
    ===============================================
    This function performs the following:

    o  Initialises all registers with random values.

    o  Apply random number of interrupts.

    o  Service all the interrupts.

  */
  int i;
  char Str[100];

  seed = 3;

  for(i = 0; i < 10; i++)
  {
    sprintf(Str, "Iteration %d", i);
    C(Str);

    RandInitReg();
    
    /* Initialise all the registers. */
    Initialise();
    
    C("All Interrupts - applied via VICINTSOURCE");
    /** Apply Random interrupts. **/
    D_TrIntSource = RandInt();
    ApplyIntr(0);

    /** Service all active interrupts in order of priority. **/ 
    AllIntService(0);
  
    C("Clear ALL interrupt sources.");   
    D_TrIntSource = Data0;
    ApplyIntr(0);
  
    D_TrIntSource = Data0;
    ApplyIntr(1);
  
    C("All Interrupts - applied via the VICSoftInt Register");
    D_TrIntSource = RandInt();
    ApplyIntr(1);
  
    AllIntService(1);
  
    /** Writes cannot be done directly into the VICSoftInt register. **/
    /** The VICSoftIntClear register should be cleared before any    **/
    /** writes are performed to the VICSoftInt register.             **/
    D_TrIntSource = Data0;
    ApplyIntr(1);
  }
}

 
/******************************** End *****************************************/
