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
-- File Name              : ClkCtrlTest.c.rca
-- File Revision          : 1.7
--
-- Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- ----------------------------------------------------------------------------
-- Purpose :
--          This test verifies the functionality of ClockStop(CS) bit of the
--          MPMCDyCntl register.
--          
--          TEST ID : MPMC_ClkCtrl_1
--
-- --=======================================================================--*/
/******************************************************************************/
/************************** Clock Control Test ********************************/
/******************************************************************************/
void ClkCtrlTest(void)
{
  /*
     Summary: Clock Control Test
     ===========================
     This test checks the following functionalities:
 
     o  Write CS and CE bits with zeros and trickbox checks MPMCCLKOUT 
 
     o  Write CS = 1 and trickbox checks MPMCCLKOUT 

     o  Disables the clock and verifies whether clock is running or not
  */

  unsigned long Address, column;
  int Device, bank, BankSel, chip,AddrMap,Row,Col;
  long int Data, Data1, Data2;
  int trans10[17] = {2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,5};
  char debugstr[100];
  C("TEST ID : MPMC_ClkCtrl_1");
  /* Write 0 to CS and CE bit of MPMCDyCntl register */ 

  WriteData(MPMCControl, 0x00000001, "WRD");

  C("Initialize SDRAMs");
  TimingInit(2,5,8,0,5,5,0,7,7,0,2,3);
  SyncInitializeProc(3, 0, 2, 2, 0, 0, 
                     2, 0, 2, 1, 0, 0, 
                     3, 0, 2, 1, 0, 0,
                     3, 0, 2, 1, 0, 0, 
                     0,1,3,0,0,1,1,0,3,1,2,
                     0,2,2,0,1,1,1,0,2,1,1,
                     0,1,0,0,0,1,1,0,2,0,0,
                     0,1,1,0,0,1,1,0,2,1,1,
                     12,12,10,11,
                     0,
                     0);
  WriteData(MPMCTrExBkOff, 0x00000010, "WRD");
  C("Deassert clock control and clock enable");

  WriteData(MPMCDyCntl, 0x00000000, "WRD");

  C("Poll for Buffer empty");
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);
  C("Single write followed by single read");

  /* Wait for engine to idle */
  WaitLoop(0x10);

  /* Generate random address */
  chip = rand() % 8;
  if(chip < 4)
    chip = 4;
  Address = rand() & 0xFFFFFFFC;
  Address = Address | chip << 28;
  /* Generate 32 bit random data */
  Data  = rand();
  Data1 = rand();
  Data2 = Data1 % 4;
  Data  = Data | Data1 << 16 | (Data2 % 2) << 15 | (Data2 / 2) << 31;

  C("Port 3 write");

  /* Write Data into memory */
  sprintf(debugstr,"Data %X has been written to address %X",Data, Address);
  debug_info(debugstr);
  WriteData(Address, Data, "WRD");

  /* Insert Idle state */
  WaitLoop(0x10);

  /* Wait till S becomes zero indicating that buffer is flushed */
  debug_info("Poll buffer status bit");
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD,0x0);
  HPO(, 0x00000000, ,0x00000002);

  C("Port 3 read");

  /* Read to verify the written value */
  ReadData(Address, Data, MaskALL, "WRD");
 
  /* Write 1 to CS bit of MPMCDyCntl register */

  C("Assert clock control");

  WriteData(MPMCDyCntl, 0x00000002, "WRD");

  C("Poll buffer status bit");
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD,0x0);
  HPO(, 0x00000000, ,0x00000002);

  C("Poll for busy bit");
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);

  C("Disable MPMCCLKOUT and keep CS and CE asserted");
  HSA(MPMCDyCntl, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000023);

  WaitLoop(0x10);

  C("Poll buffer status bit");
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD,0x0);
  HPO(, 0x00000000, ,0x00000002);

  C("Poll for busy bit");
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);

  C("Disable MPMCCLKOUT and keep CS asserted and CE disabled");
  HSA(MPMCDyCntl, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000022);

  WaitLoop(0x10);

  C("Poll buffer status bit");
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD,0x0);
  HPO(, 0x00000000, ,0x00000002);

  C("Poll for busy bit");
  HSA(MPMCStatus, NSEQ, INCR, OK, WRD, , , , , , ,);
  HPO(,0x00000000, ,0x00000003);

  C("Enable MPMCCLKOUT and keep CS and CE disabled");
  HSA(MPMCDyCntl, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000020);

  Sequence('w', 0x40000024,trans10,"inc",2,0x44444444,0);
  Sequence('r', 0x40000024,trans10,"inc",2,0x44444444,0);
  WaitLoop(0x10);
}
/*-- --================================ End ================================--*/
