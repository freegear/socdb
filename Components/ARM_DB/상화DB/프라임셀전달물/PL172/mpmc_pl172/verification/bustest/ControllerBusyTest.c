/*-- --=======================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2001-2002 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : ControllerBusyTest.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--           This function checks the functionality of busy bit
--
--           TEST ID : MPMC_ControllerBusy_1
--
-- --=======================================================================--*/
/******************************************************************************/
/**************************** ControllerBusyTest ******************************/
/******************************************************************************/
void ControllerBusyTest(void)
{
  /*
    Summary: ControllerBusyTest
    ===========================
    This test does the following functionalities:

     o Perform memory access and check the busy bit 

     o Keep the controller in Idle state and check the busy bit
  */
  unsigned long Address,Offset;
  int32 DyAddress;
  int i;
  unsigned long chpsel = 0;
  C("TEST ID : MPMC_ControllerBusy_1");
  MPMCTrMEMBData[0] = 0x00000000;
  DyAddress = 0x40000000;
  WriteData(MPMCTrTES, 0x00000000, "WRD");
  /* Write zero to address mirror bit */
  WriteData(MPMCControl, 0x00000001, "WRD");
  C("Initialize SDRAMs");
  TimingInit(2,6,8,5,6,5,4,7,7,4,2,3);
  SyncInitializeProc(3, 0, 2, 2, 0, 0,
                     2, 0, 2, 2, 0, 0,
                     3, 0, 2, 2, 0, 0,
                     3, 0, 2, 2, 0, 0,
                     0,1,3,0,0,1,1,0,3,1,0,
                     0,2,2,0,1,1,1,0,2,1,1,
                     0,1,0,0,0,1,1,0,2,0,0,
                     0,1,1,0,0,1,1,0,2,1,0,
                     12,12,10,11,
                     0,
                     0);
  StInitProc(0,2,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x0,0x3);
  TrickMemInit(0,2,0,0,1,0,0,0,0,0x4,0x5,0x6,0x7,0x9,0x0,MPMCTrMEMBData[0],
               0x0);
  Offset = rand() & 0xFFC;
  Address = MEM0_BASE + (MPMCTrMEMBData[0] << 11) + Offset;
  /* Perform memory access */ 
  C("Perform static memory access");
  HSA(Address, NSEQ, INCR, OK, WRD);
  HSW(,0x55555555);
  for(i = 0; i < 8; i++)
    HSW(, 0x55555556);

  WaitLoop(0x3);
  C("Poll for busy bit");
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);
  WaitLoop(0x3);

  /* Read from AHB */
  Address = MEM0_BASE + (MPMCTrMEMBData[0] << 11) + Offset;
  HSA(Address, NSEQ, INCR, OK, WRD);
  HSR(,0x55555555, ,0xFFFFFFFF);
  for(i = 0; i < 8; i++)
    HSR(, 0x55555556, ,0xFFFFFFFF);

  WaitLoop(0x3);
  C("Poll for busy bit");
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000001, ,0x00000001);
  WaitLoop(0x3);
  WriteData(MPMCControl, 0x00000001, "WRD");

  /* Insert Idle state */
  WaitLoop(0x5);

  /* Read the busy bit of MPMCStatus register */
  C("Read busy bit");
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(, 0x00000000, ,0x00000001, , ,ControllerBusyTest_3); 
  
  WaitLoop(0x3);
  C("Perform dynamic memory access");
  HSA(DyAddress, NSEQ, INCR, OK, WRD);
  HSW(,0x55555555);
  for(i = 0; i < 130; i++)
    HSW(, 0x55555556);

  WaitLoop(0x3);
  C("Poll for busy bit");
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000001, ,0x00000001);

  WaitLoop(0x3);
  HSA(DyAddress,NSEQ,INCR, OK, WRD); 
  HSR(,0x55555555, ,MaskALL);
  for(i = 0; i < 130; i++)
    HSR(, 0x55555556, ,MaskALL);


  /* Read the busy bit of MPMCStatus register */
  debug_info("Read the busy bit");
  ReadData(MPMCStatus, 0x00000001,0x00000001, "WRD");

  WaitLoop(0x3);
  /* Read the busy bit of MPMCStatus register */
  debug_info("Read busy bit");
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(, 0x00000000, ,0x00000001, , ,ControllerBusyTest_3);
  WriteData(MPMCTrTES, 0x00000008, "WRD");
}
/*-- --================================ End ================================--*/
