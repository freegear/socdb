/* --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : ClockOffTest.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
--
-- ---------------------------------------------------------------------
-- Purpose :
--           Routines to perform All thirtytwo plus 2 daisy interrupts
--           and switch off HCLK and check the interrupt reached the CPU.
--
-- --=================================================================*/
 
/**********************************************************************/
/********************* List of Functions Called ***********************/
/**********************************************************************/
/*** Function name                              Located in          ***/
/*** -------------------------------------------------------------- ***/
/*** InitValue()                                IntRoutines.c       ***/
/*** Initialise()                               IntRoutines.c       ***/
/*** ApplyIntr()                                IntRoutines.c       ***/
/*** VicAllIntService()                            IntRoutines.c       ***/
/*** AllInterrupt()                             IntRoutines.c       ***/
/**********************************************************************/
 
/**********************************************************************/
/**************** All Interrupt Tests With VIC Port *******************/
/**********************************************************************/

void ClockOffTest()
{
  /*
    Summary: All Interrupt Tests with VIC port enbaled processor
    ============================================================
    This function performs the following:
    
    o Programs HCLK to switch off and asserts the interrupt. The nVICIRQ
      and nVICFIQ should reach the CPU. After some time switch on the HCLK.
      The interrupt routine should start once the HCLK has reached the CPU.
    
    o Program the VICSoftInt register to assert the interrupt. Once the
      interrupts are asserted, switch off the HCLK. Now, the nVICIRQ should
      not deasserted because of HCLK off.
  */
  int i;

  for (i = 0; i < 3; i++)
  {

    /** Before applying the interrupts, some of the registers like        **/
    /** VICIntEnable, VICSoftInt, etc. are initialised. The               **/
    /** InitRandValue() function assigns a random value to all global     **/
    /** variables. These values are written into their respective         **/
    /** address locations by the Initialise() function.                   **/

    C("Initialising the registers.");
    InitValue(i);

    D_VICTrAckCnt = (i) & 0x7;
    if (D_VICTrAckCnt == 0)
       D_VICTrAckCnt = 3;

    Initialise();


    C("Switch off the HCLK");
    HSA(VICTrTCR, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
    HSW( , 0x7F);
    
    C("All Interrupts - applied via VICINTSOURCE");

    /** Select the Interrupt requests to be raised. **/
    D_TrIntSource = AllInterrupt();

    /** Raise the selected Interrupts via VICINTSOURCE. **/ 
    ApplyIntr(0);

    C("Switch on the HCLK");
    HSA(VICTrTCR, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
    HSW( , 0x5F);

    /** Service all active interrupts in order of priority. **/ 
    VicAllIntService(0);

    /** Clear ALL interrupt sources. **/ 
    D_TrIntSource = Data0;
    ApplyIntr(0);
 
    C("All Interrupts - applied via the VICSoftInt Register");

    /** Select the Interrupt requests to be raised. **/
    D_TrIntSource = AllInterrupt();

    /** Raise the selected Interrupts via the VICSoftInt register. **/
    ApplyIntr(1);

    C("Switch off the HCLK");
    HSA(VICTrTCR, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
    HSW( , 0x7F);

    WaitLoop(0x10);

    C("Switch on the HCLK");
    HSA(VICTrTCR, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
    HSW( , 0x5F);

    /** Service all active interrupts in order of priority. **/
    VicAllIntService(1);

    /** Writes cannot be done directly into the VICSoftInt register. **/
    /** The VICSoftIntClear register should be cleared before any    **/
    /** writes are performed to the VICSoftInt register.             **/
    D_TrIntSource = Data0;
    ApplyIntr(1);
  }
}
 
/******************************** End *********************************/
