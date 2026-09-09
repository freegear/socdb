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
-- File Name              : VicEnTwoFourIntTests.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform Two-interrupt and Four-interrupt tests
--           on the Vic with VIC port.
--
-- --=========================================================================*/
 
/******************************************************************************/
/************************* List of Functions Called ***************************/
/******************************************************************************/
/*** Function name                              Located in                  ***/
/*** ---------------------------------------------------------------------- ***/
/*** InitValue()                                IntRoutines.c               ***/
/*** Initialise()                               IntRoutines.c               ***/
/*** TwoInterrupt()                             IntRoutines.c               ***/
/*** ApplyIntr()                                IntRoutines.c               ***/
/*** FourInterrupt()                            IntRoutines.c               ***/
/*** AllIntService()                            IntRoutines.c               ***/
/******************************************************************************/
 

/******************************************************************************/
/****************** Two and Four Interrupt Tests ******************************/
/******************************************************************************/

void VicEnTwoFourIntTests()
{
  /*
     Summary: Two and Four Interrupt Tests
     =====================================
     This function performs the following:
 
     o  Initialises all registers.
 
     o  Writes the interrupt value in the TrIntSource register.
 
     o  Services the interrupt using a general function used to handle
        all the interrupts.
    
     Either 2 or 4 bits in the VICINTSOURCE vector are set by invoking
     separate functions. All interrupts are serviced according to their
     priorities following which they are cleared. Thirty two
     combinations are performed with Vectored Interrupts enabled. Two
     sequences with Vectored Interrupts disabled are also performed.
     All the above tests are repeated with the interrupts being 
     raised via the VICSoftInt register.
  */

  int j1, j2, j3, j4, i;
 
  for (i = 0; i < (INT_COUNT); i++)
  {

      /** Before applying the interrupts, some of the registers like **/
      /** VICIntEnable, VICSoftInt, etc. are initialised. The        **/
      /** InitValue() function assigns a new value to all global     **/
      /** variables. These values are written into their respective  **/
      /** address locations by the Initialise() function. The last   **/
      /** argument of the function Initialise() decides whether the  **/
      /** Vectored interrupts will be active or not. 32 cases are    **/
      /** considered, when the Vectored interrupts are enabled. 2    **/
      /** cases are considered by keeping the Vectored interrupts    **/
      /** disabled.                                                  **/
    InitValue(i);

    D_VICTrAckCnt = (i) & 0x7;
    if (D_VICTrAckCnt == 0)
       D_VICTrAckCnt = 3;

    Initialise();

    C("Two Interrupts - applied via VICINTSOURCE");

    for (j1 = 0, j2 = 1; j1 < INT_COUNT; )
    {
      /** Select the Interrupt requests to be raised. **/
      D_TrIntSource = TwoInterrupt(j1, j2);

      /** Raise the selected Interrupts via VICINTSOURCE. **/
      ApplyIntr(0);

      /** Service all active interrupts in order of priority. **/
      VicAllIntService(0);

      j1 += 2;
      j2 += 2;
    }

    /** Clear ALL interrupt sources. **/
    D_TrIntSource = Data0;
    ApplyIntr(0);
 
    C("Two Interrupts - applied via the VICSoftInt Register");
    for (j1 = 0, j2 = 2; j1 < INT_COUNT; )
    {

      /** Select the Interrupt requests to be raised. **/
      D_TrIntSource = TwoInterrupt(j1, j2);

      /** Raise the selected Interrupts via the VICSoftInt register **/
      ApplyIntr(1);

      /** Service all active interrupts in order of priority. **/
      VicAllIntService(1);

      j1 += 4;
      j2 += 4;
    }

    /** Writes cannot be done directly into the VICSoftInt register. **/
    /** The VICSoftIntClear register should be cleared before any    **/
    /** writes are performed to the VICSoftInt register.             **/
    D_TrIntSource = Data0;
    ApplyIntr(1);

    C("Four Interrupts - applied via VICINTSOURCE");
    for (j1 = 0, j2 = 1, j3 = 2, j4 = 3; j1 < INT_COUNT; )
    {

      /** Select the Interrupt requests to be raised. **/
      D_TrIntSource = FourInterrupt(j1, j2, j3, j4);

      /** Raise the selected Interrupts via VICINTSOURCE. **/
      ApplyIntr(0);

      /** Service all active interrupts in order of priority. **/
      VicAllIntService(0);
      j1 += 4;
      j2 += 4;
      j3 += 4;
      j4 += 4;
    }

    /** Clear ALL interrupt sources. **/
    D_TrIntSource = Data0;
    ApplyIntr(0);
 
    C("Four Interrupts - applied via the VICSoftInt Register");
    for (j1 = 0, j2 = 2, j3 = 4, j4 = 6; j1 < INT_COUNT; )
    {
 
      /** Select the Interrupt requests to be raised. **/
      D_TrIntSource = FourInterrupt(j1, j2, j3, j4);
 
      /** Raise the selected Interrupts via the VICSoftInt register. **/
      ApplyIntr(1);
 
      /** Service all active interrupts in order of priority. **/
      VicAllIntService(1);
      j1 += 8;
      j2 += 8;
      j3 += 8;
      j4 += 8;
    }

    /** Writes cannot be done directly into the VICSoftInt register. **/
    /** The VICSoftIntClear register should be cleared before any    **/
    /** writes are performed to the VICSoftInt register.             **/
    D_TrIntSource = Data0;
    ApplyIntr(1);
  }
}

/**************************************** End *********************************/
