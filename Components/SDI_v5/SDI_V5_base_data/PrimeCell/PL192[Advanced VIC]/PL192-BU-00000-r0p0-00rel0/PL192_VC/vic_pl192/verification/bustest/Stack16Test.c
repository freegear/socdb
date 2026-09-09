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
-- File Name              : Stack16Test.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Tests the nesting of the interrupts. 
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

void InitReg()
{
  /* Initialise the register values.             */
  /* All the interrupt are IRQs - 32 IRQs.       */
  /* Daisy is set to IRQ - 33rd Interrupt.       */
  /* No soft priority, No soft priority masking. */
  int i;

  D_VICTrTCR = 0x05F;
  init_addr = 0x0000A000;

  D_VICIntEnable = 0xFFFFFFFF;
  D_VICSoftInt   = 0x00000000;
  D_VICIntSelect = 0x00000000;
  D_VICSWPriorityMask    = 0xFFFF;
  D_VICVectPriorityDaisy = 0xF;
  D_TrIntIn      = 0x00000001;
  ProtectionOff  = 0x00000000;
  D_TrVectAddrIn = 0xAAAA0000;
  for(i = 0; i < INT_COUNT; D_VICVectPriority[i++] = 0xF);
}

void StackDaisyServ()
{
  /** The bit causing the IRQ is cleared. **/
  D_TrIntIn = D_TrIntIn | 0x00000002;
  HSA(VICTrIntIn, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , D_TrIntIn);

  /** A write access is done on the VICVectAddr. This marks the **/
  /** end of the Interrupt Service Routine.                     **/
  HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , ZERO);
}

void StackIntr(int intr, int select)
{
  int StackMax, i, D_intr, ADD_PRIO;
  StackMax = intr;
  
  for(i = 0; i < 15; i++)
  {

    /** Select the Interrupt requests to be raised. **/
    /** Start from the lowest.                      **/
    sprintf(Str, "Interrupt %X is applied", intr);
    C(Str);
    
    D_VICVectPriority[intr] = 0xE - i;
    ADD_PRIO = VICVectPriority_BASE + 4*intr;
    HSA(ADD_PRIO, NSEQ, INCR, , WRD, , 0x1, , , , , );
    HSW( , D_VICVectPriority[intr]);


    D_intr = LSB1 << intr;
    D_TrIntSource = D_intr;

    /** Raise the selected Interrupts via VICINTSOURCE. **/ 
    ApplyIntr(select);

    WaitLoop(2);

    /** Service all active interrupts in order of priority. **/ 
    HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot)
    HSR( , D_VICVectAddr[intr], , NoMask, ,Stack33Test_1);

  /*  D_VICVectPriority[intr] = 0xF;
    ADD_PRIO = VICVectPriority_BASE + 4*intr;
    HSA(ADD_PRIO, NSEQ, INCR, , WRD, , 0x1, , , , , );
    HSW( , D_VICVectPriority[intr]); */

    /** Apply Next highest priority interrupt. **/
    intr--;

  }

  C("--------- Serving the interrupts. -----------");
  for(i = 0; i < 15; i++)
    {
      WaitLoop(2);
      /** A write access is done on the VICVectAddr. This marks the **/
      /** end of the Interrupt Service Routine.                     **/
      HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
      HSW( , ZERO);
      sprintf(Str, "Interrupt %X is serviced", ++intr);
      C(Str);
    }
      return;
}

void Stack16Test()
{
  /*
    Summary: Stack Test 
    ===============================================
    This function performs the following:

    o  Initialises all registers.

    o  Enable interrupts one by one starting from lowest priority.

    o  Acknowledge the interrupts by reading the respective address.

    o  Apply the next interrupt before clearing the current one. Next interrupt
    will be of higher priority. Check if the previous interrupt is masked and
    new address is present on the address out lines.

    o  Service all the interrupts starting from the highest priority interrupt.
   
  */
  int i, intr;

  for(i = 14; i < INT_COUNT; i++)
  {
    InitReg();
    
    /* Initialise all the registers and apply the Daisy interrupt. */
    Initialise();
  
    /** Read Daisy Address to acknowledge Daisy **/ 
    HSA(VICVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot)
    HSR( , D_TrVectAddrIn, , NoMask, ,Stack33Test_0);
  
    C("Interrupts - applied via VICINTSOURCE");
  
    StackIntr(i, 0);
  
    /* Service Daisy Interrupt */
    StackDaisyServ();
  
      /** Clear ALL interrupt sources. **/ 
    C("Clear ALL interrupt sources.");   
    D_TrIntSource = Data0;
    ApplyIntr(0);
  
    D_TrIntSource = Data0;
    ApplyIntr(1);
  
    C("All Interrupts - applied via the VICSoftInt Register");
  
    StackIntr(i, 1);
  
    /** Writes cannot be done directly into the VICSoftInt register. **/
    /** The VICSoftIntClear register should be cleared before any    **/
    /** writes are performed to the VICSoftInt register.             **/
    D_TrIntSource = Data0;
    ApplyIntr(1);
  }
}

 
/************************************ End *************************************/
