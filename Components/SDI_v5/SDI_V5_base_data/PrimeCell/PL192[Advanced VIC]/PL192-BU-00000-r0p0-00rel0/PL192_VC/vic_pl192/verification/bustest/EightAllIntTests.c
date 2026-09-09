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
-- File Name              : EightAllIntTests.c.rca
-- File Revision          : 1.8
--
-- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform Eight-interrupt, Sixteen-interrupt and 
--           Thirty-two-interrupt tests on the Vic.
--
-- --=========================================================================*/
 
/******************************************************************************/
/********************* List of Functions Called *******************************/
/******************************************************************************/
/*** Function name                              Located in                  ***/
/*** ---------------------------------------------------------------------- ***/
/*** InitValue()                                IntRoutines.c               ***/
/*** Initialise()                               IntRoutines.c               ***/
/*** EightInterrupt()                           IntRoutines.c               ***/
/*** ApplyIntr()                                IntRoutines.c               ***/
/*** AllIntService()                            IntRoutines.c               ***/
/*** SxtnInterrupt()                            IntRoutines.c               ***/
/*** AllInterrupt()                             IntRoutines.c               ***/
/******************************************************************************/
 
/******************************************************************************/
/************* Eight, Sixteen and All Interrupt Tests *************************/
/******************************************************************************/

void EightAllIntTests()
{
  /*
    Summary: Eight, Sixteen and All Interrupt Tests 
    ===============================================
    This function performs the following:

    o  Initialises all registers.

    o  Writes the interrupt value in the TrIntSource register.

    o  Services the interrupt using a general function used to handle
       all the interrupts.
   
    Either 8, 16 or 32 bits in the VICINTSOURCE vector are set by
    invoking separate functions. All interrupts are serviced according
    to their priorities following which they are cleared. Thirty two
    combinations are performed with Vectored Interrupts enabled. Two
    sequences with Vectored Interrupts disabled are also performed. All
    the above tests are repeated with the interrupts being raised via
    the VICSoftInt register.
  */
  int j1, j2, j3, j4, j5, j6, j7, j8, j9, j10, j11, j12, j13, j14, j15;
  int j16, i;
 
  for (i = 0; i < (INT_COUNT) ; i++)
  {
      /** Before applying the interrupts, some of the registers like **/
      /** VICIntEnable, VICSoftInt, etc. are initialised. The        **/
      /** InitValue() function assigns a new value to all global     **/
      /** variables. These values are written into their respective  **/
      /** address locations by the Initialise() function. The last   **/
      /** argument of the function Initialise() decides whether the  **/
      /** Vectored interrupts will be active or not. 32 cases are    **/
      /** considered when the Vectored interrupts are enabled. 2     **/
      /** cases are considered by keeping the Vectored interrupts    **/
      /** disabled.                                                  **/
      InitValue(i);
      Initialise();

    C("Eight Interrupts - applied via VICINTSOURCE");

    j1 = 0;
    j2 = 1;
    j3 = 2;
    j4 = 3;
    j5 = 4;
    j6 = 5;
    j7 = 6;
    j8 = 7;
    for ( ; j1 < INT_COUNT; )
    {

      /** Select the Interrupt requests to be raised. **/
      D_TrIntSource = EightInterrupt(j1, j2, j3, j4, j5, j6, j7, j8);
  
      /** Raise the selected Interrupts via VICINTSOURCE. **/
      ApplyIntr(0);

      /** Service all active interrupts in order of priority. **/
      AllIntService(0);
      j1 += 8;
      j2 += 8;
      j3 += 8;
      j4 += 8;
      j5 += 8;
      j6 += 8;
      j7 += 8;
      j8 += 8;
    }

    /** Clear ALL interrupt sources. **/
    D_TrIntSource = Data0;
    ApplyIntr(0);
   
    C("Eight Interrupts - applied via the VICSoftInt Register");

    j1 = 0;
    j2 = 2;
    j3 = 4;
    j4 = 6;
    j5 = 8;
    j6 = 10;
    j7 = 12;
    j8 = 14;
    for ( ; j1 < INT_COUNT; )
    {

      /** Select the Interrupt requests to be raised. **/
      D_TrIntSource = EightInterrupt(j1, j2, j3, j4, j5, j6, j7, j8);

      /** Raise the selected Interrupts via the VICSoftInt register. **/
      ApplyIntr(1);

      /** Service all active interrupts in order of priority. **/
      AllIntService(1);
      j1 += 16;
      j2 += 16;
      j3 += 16;
      j4 += 16;
      j5 += 16;
      j6 += 16;
      j7 += 16;
      j8 += 16;
    }

    /** Writes cannot be done directly into the VICSoftInt register. **/
    /** The VICSoftIntClear register should be cleared before any    **/
    /** writes are performed to the VICSoftInt register              **/
    D_TrIntSource = Data0;
    ApplyIntr(1);

    C("Sixteen Interrupts - applied via VICINTSOURCE");

    j1 = 0;
    j2 = 1;
    j3 = 2;
    j4 = 3;
    j5 = 4;
    j6 = 5;
    j7 = 6;
    j8 = 7;
    j9 = 8;
    j10 = 9;
    j11 = 10;
    j12 = 11;
    j13 = 12;
    j14 = 13;
    j15 = 14;
    j16 = 15;
    for ( ; j1 < INT_COUNT; )
    {

      /** Select the Interrupt requests to be raised. **/
      D_TrIntSource = SxtnInterrupt(j1, j2, j3, j4, j5, j6, j7, j8, j9,
                                    j10, j11, j12, j13, j14, j15, j16);

      /** Raise the selected Interrupts via VICINTSOURCE. **/
      ApplyIntr(0);

      /** Service all active interrupts in order of priority. **/
      AllIntService(0);
      j1 += 16;
      j2 += 16;
      j3 += 16;
      j4 += 16;
      j5 += 16;
      j6 += 16;
      j7 += 16;
      j8 += 16;
      j9 += 16;
      j10 += 16;
      j11 += 16;
      j12 += 16;
      j13 += 16;
      j14 += 16;
      j15 += 16;
      j16 += 16;
    }

    /** Clear ALL interrupt sources. **/
    D_TrIntSource = Data0;
    ApplyIntr(0);
 
    C("Sixteen Interrupts - applied via the VICSoftInt Register");

    j1 = 0;
    j2 = 2;
    j3 = 4;
    j4 = 6;
    j5 = 8;
    j6 = 10;
    j7 = 12;
    j8 = 14;
    j9 = 16;
    j10 = 18;
    j11 = 20;
    j12 = 22;
    j13 = 24;
    j14 = 26;
    j15 = 28;
    j16 = 30;

    /** Select the Interrupt requests to be raised. **/
    D_TrIntSource = SxtnInterrupt(j1, j2, j3, j4, j5, j6, j7, j8, j9,
                                  j10, j11, j12, j13, j14, j15, j16);

    /** Raise the selected Interrupts via the VICSoftInt register. **/
    ApplyIntr(1);

    /** Service all active interrupts in order of priority. **/
    AllIntService(1);

    /** Writes cannot be done directly into the VICSoftInt register. **/
    /** The VICSoftIntClear register should be cleared before any    **/
    /** writes are performed to the VICSoftInt register              **/
    D_TrIntSource = Data0;
    ApplyIntr(1);
 
    C("All Interrupts - applied via VICINTSOURCE");

    /** Select the Interrupt requests to be raised. **/
    D_TrIntSource = AllInterrupt();

    /** Raise the selected Interrupts via VICINTSOURCE. **/ 
    ApplyIntr(0);

    /** Service all active interrupts in order of priority. **/ 
    AllIntService(0);

    /** Clear ALL interrupt sources. **/ 
    D_TrIntSource = Data0;
    ApplyIntr(0);
 
    C("All Interrupts - applied via the VICSoftInt Register");

    /** Select the Interrupt requests to be raised. **/
    D_TrIntSource = AllInterrupt();

    /** Raise the selected Interrupts via the VICSoftInt register. **/
    ApplyIntr(1);

    /** Service all active interrupts in order of priority. **/
    AllIntService(1);

    /** Writes cannot be done directly into the VICSoftInt register. **/
    /** The VICSoftIntClear register should be cleared before any    **/
    /** writes are performed to the VICSoftInt register.             **/
    D_TrIntSource = Data0;
    ApplyIntr(1);
  }
}
 
/************************************ End *************************************/
