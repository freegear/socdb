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
-- File Name              : VicEnStack16Test.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Tests the nesting of the interrupts for Vic Port enabled devices.
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


void VicEnStack16Test()
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
    VicInitReg();

    /* Program the Ack Count. Non zero Ack count -> VIC port enabled */
    D_VICTrAckCnt = (i) & 0x7;
    if (D_VICTrAckCnt == 0)
       D_VICTrAckCnt = 3;
    
    /* Initialise all the registers and apply the Daisy interrupt. */
    Initialise();
  
    WaitLoop(3);
    HSA(VICITOP1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
    HPO( , ADDRV, , , );
    WaitLoop(3);
 
    C("Interrupts - applied via VICINTSOURCE");
  
    VicStackIntr(i, 0);
  
    /* Service Daisy Interrupt */
    VicStackDaisyServ();
  
      /** Clear ALL interrupt sources. **/ 
    C("Clear ALL interrupt sources.");   
    D_TrIntSource = Data0;
    ApplyIntr(0);
  
    D_TrIntSource = Data0;
    ApplyIntr(1);
  
    C("All Interrupts - applied via the VICSoftInt Register");
  
    VicStackIntr(i, 1);
  
    /** Writes cannot be done directly into the VICSoftInt register. **/
    /** The VICSoftIntClear register should be cleared before any    **/
    /** writes are performed to the VICSoftInt register.             **/
    D_TrIntSource = Data0;
    ApplyIntr(1);
  }
}

 
/************************************ End *************************************/
