/* --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2000-2001 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : MultiPortDiffComb1.c.rca
--  File Revision          : 1.3
--
--  Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Does different types of memory access
--
-- --=======================================================================--*/
void MultiPortDiffComb1()
{
  int i;
  int32 Addr, Data,Address;
  char debugstr[100];
  int LoBits, Bound;
  #if (INFILE == 3)
  C("TEST ID : MPMC_MultiPortDiffComb1");
  C("Configuring the Memory Banks and the MPMC");

  WriteData(MPMCControl, 0x00000001, "WRD");
  WriteData(MPMCTrTES, 0x00000000, "WRD");
  TimingInit(2,6,8,5,6,2,4,7,7,4,2,3);
  SyncInitializeProc(2, 0, 2, 2, 0, 0,
                     2, 0, 2, 2, 0, 0,
                     3, 0, 3, 2, 0, 0,
                     3, 0, 2, 3, 0, 0,
                     0,1,3,1,1,1,1,0,3,1,2,
                     0,2,2,0,1,1,1,0,2,1,1,
                     0,1,0,0,0,1,1,0,2,0,0,
                     0,1,1,0,0,1,1,0,2,1,1,
                     11,12,10,11,
                     0,
                     0);

  WriteData(MPMCTrSR, 0x00000000, "WRD");
  /* Program the operational value to REFRESH field */
  HSA(MPMCDyRef,NSEQ,INCR,OK,WRD,0x7FF, , ,0);
  HSW(,0x0000032);
  WaitLoop(0x270);

  MPMCTrMEMBData[0] = 0x00000000;
  /* Set Bank 0 Memory Type as SRAM (32 bits width)with 8 bit memory */
  StInitProc(0,2,0,0,1,0,0,0,0,0x2,0x2,0x2,0x2,0x2,0x2,0x4);
  TrickMemInit(0,2,0,0,1,0,0,0,0,0x2,0x2,0x2,0x2,0x2,0x2,MPMCTrMEMBData[0],
               0x0);

  ENDIANNESS = 0;
  HSEN(LITTLE); 


  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000008);

  Address = 0x4042A7F0;
  Data = 0x0;
  WaitLoop(0x9);
  for (i = 0; i < 40; i++)
  {
    C("Writing from Port3");
    HSA(Address, NSEQ, SINGLE, OK, WRD);
    HSW(, Data);
    Address = Address + 0x08000;
    Data = Data + 1;
  }
  WaitLoop(0x3);

  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000008);

  WaitLoop(0x100);
  #elif (INFILE == 0)
  WaitLoop(0x2);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000000);

  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000008, ,0x00000008);
  WaitLoop(0x80);
  Address = 0x4031A2FC;
  for (i=0;i<=30;i++) {
  C("Reading from Port0");
  HSA(Address, NSEQ, INCR, OK, WRD);
  HSR(,Data, , 0x00000000);
  HSR(,Data, , 0x00000000);
  HSR(,Data, , 0x00000000);
  Address = Address + 0x10;
  LoBits = Address & 0x03FF;
  Bound  = LoBits + 64;
  if (Bound > 1024)
    Address = Address + 100;
  }
  WaitLoop(0x200);
 #endif
}
/*-- --=============================== End ================================-- */
