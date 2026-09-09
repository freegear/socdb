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
-- File Name              : ProtectionTests.c.rca
-- File Revision          : 1.6
--
-- Release Information    : PrimeCell(TM)-PL190-REL1v1
--
-- ---------------------------------------------------------------------
-- Purpose :
--           Routines to perform Protection mode tests on the Vic.
--
-- --=================================================================*/
 
/**********************************************************************/
/********************* List of Functions Called ***********************/
/**********************************************************************/
/*** Function name                              Located in          ***/
/*** -------------------------------------------------------------- ***/
/*** BurstTransfer()                            VicCommon.c         ***/
/*** BusyTransfer()                             VicCommon.c         ***/
/*** IdleTransfer()                             VicCommon.c         ***/
/**********************************************************************/

/**********************************************************************/
/************************ Protection Tests ****************************/
/**********************************************************************/

void ProtectionTests()
{
  /*
     Summary: Protection mode Read/Write Tests
     =========================================
     This function performs the following: 
 
     o  Write/Read Tests are done after configuring the VIC in
        'PROTECTED' mode.

     o  The registers are accessed in 'USER' mode.

     o  The values are checked again to verify that it is not
        modified during the 'USER' accesses.
  */
  
  int i;
 
  C("Clear All Interrupt Sources");
  HSA(VICTrIntSource, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , ZERO);

  C("Configure the VIC in 'PROTECTED' mode");
  HSA(VICProtection, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , 0x1);
 
  prot = 0x2;
  C("Performs Register Write/Read Tests in SUPERVISOR mode");
  WriteReadTests(Data5, NoMask);
 
  /** Re-configure the VIC in 'PROTECTED' mode after Register Tests. **/
  HSA(VICProtection, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , 0x1);
 
  prot = 0x8;

  C("USER mode access while the VIC is in 'PROTECTED' mode");

  /** All register reads should return 0x0. **/
  WriteReadTests(DataA, MaskAll);
 
  prot = 0x2;

  C("SUPERVISOR mode access while the VIC is in 'PROTECTED' mode");

  /** Reads should return values present in the registers prior to **/
  /** the Privilege mode acceses.                                  **/
  HSA(VICIRQStatus, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , NoMask, ,ProtectionTests_1);
  HSA(VICFIQStatus, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , ZERO, , NoMask, ,ProtectionTests_2);
 
  HSA(VICPeriphID0, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , RST_VICPeriphID0, , NoMask, ,ProtectionTests_3);
  HSA(VICPeriphID1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , RST_VICPeriphID1, , NoMask, ,ProtectionTests_4);
  HSA(VICPeriphID2, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , RST_VICPeriphID2, , NoMask, ,ProtectionTests_5);
  HSA(VICPeriphID3, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , RST_VICPeriphID3, , NoMask, ,ProtectionTests_6);
 
  HSA(VICPCellID0, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , RST_VICPCellID0, , NoMask, ,ProtectionTests_7);
  HSA(VICPCellID1, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , RST_VICPCellID1, , NoMask, ,ProtectionTests_8);
  HSA(VICPCellID2, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , RST_VICPCellID2, , NoMask, ,ProtectionTests_9);
  HSA(VICPCellID3, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , RST_VICPCellID3, , NoMask, ,ProtectionTests_10);

  HSA(VICIntSelect, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , Data5, , NoMask, ,ProtectionTests_11);

  HSA(VICDefVectAddr, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , Data5, , NoMask, ,ProtectionTests_12);

  HSA(VICVectAddr_BASE, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , Data5, , , , ,ProtectionTests_13);
  for (i = 1; i < VEC_COUNT; i++)
  {
    HSR( , Data5, , , , ,ProtectionTests_14);
  }
 
  HSA(VICVectCntl_BASE, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , Data5, , , , ,ProtectionTests_15);
  for (i = 1; i < VEC_COUNT; i++)
  {
    HSR( , Data5, , , , ,ProtectionTests_16);
  }
 
  C("Burst Transfers in 'PROTECTED' mode");
  BurstTransfer(prot, MaskAll);

  C("BUSY Transfers in 'PROTECTED' mode");
  BusyTransfer(prot, MaskAll);

  C("IDLE Transfers in 'PROTECTED' mode");
  IdleTransfer(prot, MaskAll);

  C("Performing the ERROR Response Tests in 'PROTECTED' mode");
  HSA(VICVectAddr, NSEQ, SINGLE, ERROR, HWRD, , 0x1, , , , , prot);
  HSW( , ZERO);

  HSA(VICVectCntl_BASE + 0x4, NSEQ, SINGLE, ERROR, BYTE, , 0x1, , , , , prot);
  HSW( , ZERO);

  HSA(VICVectCntl_BASE + 0x4*12, NSEQ, SINGLE, ERROR, HWRD, , 0x1, , , , , prot);
  HSW( , ZERO);

  HSA(VICVectAddr_BASE + 0x4, NSEQ, SINGLE, ERROR, HWRD, , 0x1, , , , , prot);
  HSW( , ZERO);

  HSA(VICVectAddr_BASE + 0x4*12, NSEQ, SINGLE, ERROR, HWRD, , 0x1, , , , , prot);
  HSW( , ZERO);

  HSA(VICProtection, NSEQ, SINGLE, ERROR, HWRD, , 0x1, , , , , prot);
  HSW( , ZERO);

  C("Configure the VIC in 'USER' mode");
  HSA(VICProtection, NSEQ, INCR, , WRD, , 0x1, , , , , prot);
  HSW( , 0x0);
 
  prot = 0x0;

  /** Note :                                                      **/
  /**    An IDLE cycle must follow any reconfiguration of the VIC **/
  /**    PROTECTION  mode register.                               **/
  HSA(VICProtection, IDLE, INCR, , WRD, , 0x1, , , , , prot);
  HSR( , 0x1, , , , ,ProtectionTests_17);
}

/******************************** End *********************************/
