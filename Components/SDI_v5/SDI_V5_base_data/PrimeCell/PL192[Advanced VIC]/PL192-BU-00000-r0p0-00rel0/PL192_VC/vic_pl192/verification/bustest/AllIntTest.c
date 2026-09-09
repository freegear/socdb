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
-- File Name              : AllIntTest.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform ALL interrupt tests on the Vic.
--
-- --=========================================================================*/
 
/******************************************************************************/
/************************* List of Functions Called ***************************/
/******************************************************************************/
/*** Function name                              Located in                  ***/
/*** ---------------------------------------------------------------------- ***/
/*** InitValue()                                IntRoutines.c               ***/
/*** Initialise()                               IntRoutines.c               ***/
/*** ApplyIntr()                                IntRoutines.c               ***/
/*** AllIntService()                            IntRoutines.c               ***/
/*** AllInterrupt()                             IntRoutines.c               ***/
/******************************************************************************/
 
/******************************************************************************/
/***************** Eight, Sixteen and All Interrupt Tests *********************/
/******************************************************************************/

void AllIntTest()
{
  /*
    Summary: All Interrupt Tests 
    ===============================================
    This function performs the following:

    o  Initialises all registers.

    o  Writes the interrupt value in the TrIntSource register.

    o  Services the interrupt using a general function used to handle
       all the interrupts.
   
    Either 32 bits in the VICINTSOURCE vector are set by
    invoking separate functions. All interrupts are serviced according
    to their priorities following which they are cleared. All
    the above tests are repeated with the interrupts being raised via
    the VICSoftInt register.
  */
  int i;

  for (i = 0; i < INT_COUNT; i++)
  {
    C("Vectored Interrupts are enabled");

    /** Before applying the interrupts, some of the registers like        **/
    /** VICIntEnable, VICSoftInt, etc. are initialised. The               **/
    /** InitRandValue() function assigns a random value to all global     **/
    /** variables. These values are written into their respective         **/
    /** address locations by the Initialise() function.                   **/

    InitValue(i);
    Initialise();

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
