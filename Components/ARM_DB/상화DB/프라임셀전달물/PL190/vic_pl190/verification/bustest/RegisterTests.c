/* --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : RegisterTests.c.rca
-- File Revision          : 1.6
--
-- Release Information    : PrimeCell(TM)-PL190-REL1v1
--
-- ---------------------------------------------------------------------
-- Purpose :
--           Routines to perform Register Tests on the Vic.      
--
-- --=================================================================*/
 
/**********************************************************************/
/********************* List of Functions Called ***********************/
/**********************************************************************/
/*** Function name                              Located in          ***/
/*** -------------------------------------------------------------- ***/
/*** WriteReadTests()                           VicCommon.c         ***/
/**********************************************************************/
 
/**********************************************************************/
/************************** RegisterTests *****************************/
/**********************************************************************/

void RegisterTests()
{ 
  /*
     Summary: Register Tests 
     =======================
     This function performs the following: 
 
     o  Write-Read tests are done on the registers of the VIC.
 
     This function uses two different functions for the register tests.
     The function 'WriteReadTests' writes a data into a register. If the
     register is R/W then the data expected back is the same as that is
     written. If the register is Read-only, then the expected data is
     their Reset value. But the the enable and clear registers can't be
     checked using this method. For them a new function called
     'DiffWriteRead' is used. It writes a data in the specified address,
     and then reads another data from another address. Both the
     addresses and data are passed as parameters. While writing into
     enable registers, only the HIGH bits cause changes in the register.
     Similarly, for clear registers also, only the HIGH bits cause a
     change. 
  */
     
  int32 testdata;
 
  /** Perform accesses in Supervisor Mode. **/
  prot = 0x2;

  testdata = Data5;
  C("Pattern Write-Read Tests -> 0x55555555");
  WriteReadTests(testdata, NoMask);
 
  testdata = Data0;
  C("Pattern Write-Read Tests -> 0x00000000");
  WriteReadTests(testdata, NoMask);
 
  testdata = DataF;
  C("Pattern Write-Read Tests -> 0xFFFFFFFF");
  WriteReadTests(testdata, NoMask);
 
  testdata = DataA;
  C("Pattern Write-Read Tests -> 0xAAAAAAAA");
  WriteReadTests(testdata, NoMask);
 
  C("VICIntEnable and VICSoftInt Tests");

  /** Initially, the contents of VICIntEnable and VICSoftInt are **/
  /** ZERO. Hence, the data written and read back should be the  **/
  /** same.                                                      **/
  HSA(VICIntEnable, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , Data5);
  HSA(VICIntEnable, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , Data5, , NoMask, ,RegisterTests_1);
  HSA(VICSoftInt, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , Data5);
  HSA(VICSoftInt, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , Data5, , NoMask, ,RegisterTests_2);
 
  /** Perform a Write to the Wait State Register of the TrickBox. **/
  HSA(VICTrWaitStReg, NSEQ, INCR, , WRD, , 0x1);
  HSW( , Data5);

  /** Now, the contents of VICIntEnable and VICSoftInt are  **/
  /** 0x55555555. Hence, the data written and read back are **/
  /** different.                                            **/
  HSA(VICIntEnable, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , Data9);
  HSA(VICIntEnable, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , DataD, , NoMask, ,RegisterTests_3);
  HSA(VICSoftInt, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , Data9);
  HSA(VICSoftInt, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , DataD, , NoMask, ,RegisterTests_4);
 
  /** Repeat with a different pattern. **/
  HSA(VICIntEnable, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , Data2);
  HSA(VICIntEnable, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , DataF, , NoMask, ,RegisterTests_5);
  HSA(VICSoftInt, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , Data2);
  HSA(VICSoftInt, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , DataF, , NoMask, ,RegisterTests_6);
 
  /** Performs a Read from the Wait State Register of the TrickBox. **/
  HSA(VICTrWaitStReg, NSEQ, INCR, , WRD, , 0x1);
  HSR( , Data5, , NoMask, ,RegisterTests_7);

  /** Data is written into the 'clear' register and read back from **/
  /** the 'enable' register.                                       **/
 
  HSA(VICIntEnClear, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , Data3);
  HSA(VICIntEnable, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , DataC, , NoMask, ,RegisterTests_8);
  HSA(VICSoftIntClear, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , Data3);
  HSA(VICSoftInt, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , DataC, , NoMask, ,RegisterTests_9);
 
  HSA(VICIntEnClear, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , Data5);
  HSA(VICIntEnable, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , Data8, , NoMask, ,RegisterTests_10);
  HSA(VICSoftIntClear, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , Data5);
  HSA(VICSoftInt, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , Data8, , NoMask, ,RegisterTests_11);
 
  HSA(VICIntEnClear, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , Data8);
  HSA(VICIntEnable, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , Data0, , NoMask, ,RegisterTests_12);
  HSA(VICSoftIntClear, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , Data8);
  HSA(VICSoftInt, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , Data0, , NoMask, ,RegisterTests_13);
}

/******************************** End *********************************/
