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
--  File Name              : MultiPortWrProtTest.c.rca
--  File Revision          : 1.3
--
--  Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Checks write protect feature with multiport access.
--
-- --=======================================================================--*/
void MultiPortWrProtTest()
{
  /*
     Summary: MultiPortWrProtTest
     ============================
     It does the following functionality
  
     o  Program Chip select 0 (static memory) as write protected, 32 bit
        memory width. 
   
     o  Perform write to the CS0 from the Port3 with HSIZE as BYTE and expect
        ERROR response. After read perform read to the same chip select.

     o  Perform read from the Port2 to the dynamic memory with HSIZE as WORD.
  
     o  If the controller posts the write request to the memory inspite of
        write protect enable, the trick memory is gives the error messages.
  */
  int i;
  int32 Data, Address;
  char debugstr[100];
  #if (INFILE == 3)
  C("Configuring the Memory Banks and the MPMC");

  WriteData(MPMCControl, 0x00000001, "WRD");
  TimingInit(2,6,8,5,6,2,4,7,7,4,2,3);
  SyncInitializeProc(3, 0, 2, 3, 0, 0,
                     2, 0, 2, 2, 0, 0,
                     3, 0, 3, 2, 0, 0,
                     3, 0, 2, 3, 0, 0,
                     0,1,3,0,0,1,1,0,3,1,2,
                     0,2,2,0,1,1,1,0,2,1,1,
                     0,1,0,0,0,1,1,0,2,0,0,
                     0,1,1,0,0,1,1,0,2,1,1,
                     12,12,10,11,
                     0,
                     0);

  StInitProc(0,2,0,0,0,0,0,0,1,0x3,0x3,0x4,0x7,0x5,0x5,0x3);
  TrickMemInit(0,2,0,0,0,0,0,0,1,0x3,0x3,0x4,0x7,0x5,0x5,MPMCTrMEMBData[0],
               0x0);

  WriteData(MPMCControl, 0x00000001, "WRD");
  ENDIANNESS = 0;
  HSEN(LITTLE); 


  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000008);
  WaitLoop(0x3);
  C("Write to write protected memory : Iteration 1");
  HSA(0x00000000, NSEQ, INCR, ERROR, BYTE);
  HSW(, 0x00000000);
  Data = 0x0;
  for (i = 0; i < 20; i++)
  {
    HSW(, Data);
    Data = Data + 1;
  }
  C("Write to write protected memory : Iteration 2");
  HSA(0x00000050, NSEQ, INCR, ERROR, BYTE);
  HSW(, 0x00000000);
  for (i = 0; i < 20; i++)
  {
    HSW(, Data);
    Data = Data + 1;
  }
  C("Write to write protected memory : Iteration 3");
  HSA(0x000000B0, NSEQ, INCR, ERROR, BYTE);
  HSW(, 0x00000000);
  Data = 0x0;
  for (i = 0; i < 20; i++)
  {
    HSW(, Data);
    Data = Data + 1;
  }
  C("Write to write protected memory : Iteration 4");
  HSA(0x00000100, NSEQ, INCR, ERROR, BYTE);
  HSW(, Data);
  for (i = 0; i < 20; i++)
  {
    HSW(, Data);
    Data = Data + 1;
  }
  C("Write to write protected memory : Iteration 5");
  HSA(0x00000150, NSEQ, INCR, ERROR, BYTE);
  HSW(, Data);
  for (i = 0; i < 20; i++)
  {
    HSW(, Data);
    Data = Data + 1;
  }

  C("Read from write protected memory : Iteration 1");
  HSA(0x00000150, NSEQ, INCR, OK, BYTE);
  HSR(, Data, ,0x00000000);
  for (i = 0; i < 20; i++)
  {
    HSR(, Data, ,0x00000000);
    Data = Data + 1;
  }

  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000000);
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000004, ,0x00000004);
  WaitLoop(0x3);

  #elif (INFILE == 2)
  WaitLoop(0x3);

  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000008, ,0x00000008);

  WaitLoop(0x3);

  C("Read from Dynamic memory : Iteration 1");
  HSA(0x40001000, NSEQ, INCR, OK, WRD);
  HSR(, 0x00000000, ,0x00000000);
  Data = 0x0;
  for (i = 0; i < 10; i++)
  {
    HSR(, Data, ,0x00000000);
    Data = Data + 1;
  }

  C("Read from Dynamic memory : Iteration 2");
  HSA(0x40001050, NSEQ, INCR, OK, WRD);
  HSR(, Data, ,0x00000000);
  for (i = 0; i < 10; i++)
  {
    HSR(, Data, ,0x00000000);
    Data = Data + 1;
  }

  C("Read from Dynamic memory : Iteration 3");
  HSA(0x400010B0, NSEQ, INCR, OK, WRD);
  HSR(, 0x00000000, ,0x00000000);
  Data = 0x0;
  for (i = 0; i < 10; i++)
  {
    HSR(, Data, ,0x00000000);
    Data = Data + 1;
  }

  C("Read from Dynamic memory : Iteration 4");
  HSA(0x40001200, NSEQ, INCR, OK, WRD);
  HSR(, Data, ,0x00000000);
  for (i = 0; i < 10; i++)
  {
    HSR(, Data, ,0x00000000);
    Data = Data + 1;
  }

  C("Read from Dynamic memory : Iteration 5");
  HSA(0x40001250, NSEQ, INCR, OK, WRD);
  HSR(, Data, ,0x00000000);
  for (i = 0; i < 10; i++)
  {
    HSR(, Data, ,0x00000000);
    Data = Data + 1;
  }
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000004);
  WaitLoop(0x3);
  #endif
}
/*-- --=============================== End ================================-- */
