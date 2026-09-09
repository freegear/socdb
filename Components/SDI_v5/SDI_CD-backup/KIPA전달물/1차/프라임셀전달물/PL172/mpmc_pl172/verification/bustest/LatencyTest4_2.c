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
--  File Name              : LatencyTest4_2.c.rca
--  File Revision          : 1.3
--
--  Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This test performs accesses through different AHB ports and
--           tests whether the AHB priority scheme is properly followed, as
--           far as returning data to HRDATA bus is concerned.
-- --=======================================================================--*/
void LatencyTest4_2()
{
  /*
     Summary: LatencyTest4_2
     =======================
     It does the following functionality
  
     o  Initialise the SDRAMs.

     o  Perform write to the 16Mx16 memory with BRC from port2.
        Increment the address by 8000 so that each time different page is
        written.

     o  Try to perform write from the Port0.

     o  Try to perform write from the Port1.

     o  Verify that the Port0 and Port1 gets the bus at the earliest.

     o  Perform write to the 16Mx16 memory with BRC from port2.

     o  Try to perform write from the Port0.

     o  Try to perform write from the Port1.

     o  Verify that the Port0 and Port1 gets the bus at the earliest.
  */
  int i;
  int32 Addr, Data,Address;
  char debugstr[100];
  int trans[17] = {2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,5};
  int trans3[5] = {2,3,3,3,5};
  int trans1[2] = {2,5};
  int trans2[2] = {3,5};
  int LoBits, Bound;

/******************************************************************************/
/* Port 3 transactions                                                        */
/******************************************************************************/

  #if (INFILE == 3)
  C("TEST ID : MPMC_LatencyTest4_2");
  C("Configuring the Memory Banks and the MPMC");

  WriteData(MPMCControl, 0x00000001, "WRD");
  WriteData(MPMCTrTES, 0x00000000, "WRD");
/******************************************************************************/
/* Configuring the memory controller and mode initializing the memory for     */
/* dynamic memory chip selects.                                               */
/******************************************************************************/
TimingInit(2,  /* tRP */
             6,  /* tRAS */
             8,  /* tSREX */
             5,  /* tAPR */
             6,  /* tDAL */
             2,  /* tWR */
             4,  /* tRDL */
             7,  /* tRC */
             7,  /* tRFC */
             4,  /* tXSR */
             2,  /* tRRD */
             3); /* tMRD */

  SyncInitializeProc(
  /* mode register parameters for dynamic-chip-select 4-7 */
  /* BrstLen BrstTyp CAS      RAS      Opmode WrBrstMod */
     2,      0,      2,       2,       0,     0,
     2,      0,      2,       2,       0,     0,
     3,      0,      3,       2,       0,     0,
     3,      0,      2,       3,       0,     0,
  /* memory controller parameters for dynamic-chip-select 4-7                 */
  /* Memory   Address map   Read    Write   Write   Col   Number   Row        */
  /* type     information   buffer  buffer  protect width of banks width      */
     0,       1,3,1,1,      1,      1,      0,      3,    1,       2,
     0,       2,2,0,1,      1,      1,      0,      2,    1,       1,
     0,       1,0,0,0,      1,      1,      0,      2,    0,       0,
     0,       1,1,0,0,      1,      1,      0,      2,    1,       1,
  /* others */
     11, /* no. of bits, by which LSB of Row Addr is offset, as per Addrmap */
     12, /* no. of bits, by which LSB of Row Addr is offset, as per Addrmap */
     10, /* no. of bits, by which LSB of Row Addr is offset, as per Addrmap */
     11, /* no. of bits, by which LSB of Row Addr is offset, as per Addrmap */
     0,  /* Big Endian */
     0); /* 1:2 clock ratio */

  /* Program the operational value to REFRESH field */
  HSA(MPMCDyRef,NSEQ,INCR,OK,WRD,0x7FF, , ,0);
  HSW(,0x000000C);
  WaitLoop(0x27);

  WriteData(MPMCTrCR, 0x00000020, "WRD");
  
  ENDIANNESS = 0;
  HSEN(LITTLE); 

  HSA(MPMCTrSR, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000000);

  HSA(HREADY0CNT, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000055);

  HSA(HREADY1CNT, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000100);

  HSA(MPMCTrCR, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000060);

  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000008);
  WaitLoop(0x28000);
/******************************************************************************/
/* Port 2 transactions                                                        */
/******************************************************************************/

  #elif (INFILE == 2)
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000000);
  WaitLoop(0x3);

  /* Wait till Port3 completes the initialisation of the registers and memory */
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000008, ,0x00000008);

  WaitLoop(0x3);
  
  Address = 0x4000A7FC;
  Data = 0x0;
  WaitLoop(0x9);
  
  for (i = 0; i < 200; i++)
  {
    C("Port2 : Case1 : Continuous single write with 0x8000 as addr incrementing value");
    HSA(Address, NSEQ, SINGLE, OK, WRD);
    HSW(, 0x00000000);
    Address = Address + 0x08000;
  }
 
  Address = 0x400004FC;
  for (i = 0; i < 200; i++)
  {
    C("Port2 : Case1 : Continuous single write with 0x4 as addr incrementing value");
    HSA(Address, NSEQ, SINGLE, OK, WRD);
    HSW(, 0x00000000);
    Address = Address + 0x4;
  }

  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000004);
  
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000003, ,0x00000003);
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000000);

  WaitLoop(0x10);

  Address = 0x4000A7F0;
  Data = 0x0;
  WaitLoop(0x9);

  for (i = 0; i < 200; i++)
  {
    C("Port2 : Case2 : Continuous incr write with 0x8000 as addr incrementing value");
    HSA(Address, NSEQ, INCR, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    Address = Address & 0xFFFFFFF0;
    Address = Address + 0x08000;
  }

  Address = 0x40000700;
  Data = 0x0;
  WaitLoop(0x9);

  for (i = 0; i < 200; i++)
  {
    C("Port2 : Case2 : Continuous incr write");
    HSA(Address, NSEQ, INCR, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    Address = Address + 0x10;
  }

  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000004);

  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000003, ,0x00000003);
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000000);

  WaitLoop(0x10);


  Address = 0x4000A7F0;
  Data = 0x0;
  WaitLoop(0x9);

  for (i = 0; i < 200; i++)
  {
    C("Port2 : Case3 : Continuous incr4 write with 0x8000 as addr incrementing value");
    HSA(Address, NSEQ, INCR4, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    Address = Address & 0xFFFFFFF0;
    Address = Address + 0x08000;
  }

  Address = 0x40000700;
  Data = 0x0;
  WaitLoop(0x9);

  for (i = 0; i < 200; i++)
  {
    C("Port2 : Case3 : Continuous incr4 write");
    HSA(Address, NSEQ, INCR4, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    Address = Address + 0x10;
  }

  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000004);

  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000003, ,0x00000003);
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000000);

  WaitLoop(0x10);


  Address = 0x4000A7E0;
  Data = 0x0;
  WaitLoop(0x9);

  for (i = 0; i < 200; i++)
  {
    C("Port2 : Case4 : Continuous incr8 write with 0x8000 as addr incrementing value");
    HSA(Address, NSEQ, INCR8, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    Address = Address & 0xFFFFFFF0;
    Address = Address + 0x08000;
  }

  Address = 0x40000700;
  Data = 0x0;
  WaitLoop(0x9);

  for (i = 0; i < 200; i++)
  {
    C("Port2 : Case4 : Continuous incr8 write");
    HSA(Address, NSEQ, INCR8, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    Address = Address + 0x10;
    LoBits = Address & 0x03FF;
    Bound  = LoBits + 64;
    if (Bound > 1024)
      Address = Address + 100;
  }

  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000004);

  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000003, ,0x00000003);
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000000);

  WaitLoop(0x10);


  Address = 0x4000A7C0;
  Data = 0x0;
  WaitLoop(0x9);
  for (i = 0; i < 200; i++)
  {
    C("Port2 : Case5 : Continuous incr16 write with 0x8000 as addr incrementing value");
    HSA(Address, NSEQ, INCR16, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    Address = Address & 0xFFFFFFF0;
    Address = Address + 0x08000;
  }

  Address = 0x4000020C;
  Data = 0x0;
  WaitLoop(0x9);

  for (i = 0; i < 200; i++)
  {
    C("Port2 : Case5 : Continuous incr16 write");
    HSA(Address, NSEQ, INCR16, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    Address = Address + 0x40;
    LoBits = Address & 0x03FF;
    Bound  = LoBits + 64;
    if (Bound > 1024)
      Address = Address + 100;

  }

  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000004);

  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000003, ,0x00000003);
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000000);

  WaitLoop(0x10);


  Address = 0x4000A7FC;
  Data = 0x0;
  WaitLoop(0x9);
  for (i = 0; i < 200; i++)
  {
    C("Port2 : Case6 : Continuous WRAP4 write with 0x8000 as addr incrementing value");
    HSA(Address, NSEQ, WRAP4, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    Address = Address & 0xFFFFFFF0;
    Address = Address + 0x08000;
  }

  Address = 0x4000020C;
  Data = 0x0;
  WaitLoop(0x9);

  for (i = 0; i < 200; i++)
  {
    C("Port2 : Case6 : Continuous WRAP4 write");
    HSA(Address, NSEQ, WRAP4, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    Address = Address + 0x10;
  }

  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000004);

  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000003, ,0x00000003);
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000000);

  WaitLoop(0x10);


  Address = 0x4000C7CC;
  Data = 0x0;
  WaitLoop(0x9);
  for (i = 0; i < 200; i++)
  {
    C("Port2 : Case7 : Continuous WRAP8 write with 0x8000 as addr incrementing value");
    HSA(Address, NSEQ, WRAP4, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    Address = Address & 0xFFFFFFF0;
    Address = Address + 0x08000;
  }

  Address = 0x4000020C;
  Data = 0x0;
  WaitLoop(0x9);

  for (i = 0; i < 200; i++)
  {
    C("Port2 : Case7 : Continuous WRAP8 write");
    HSA(Address, NSEQ, WRAP8, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    Address = Address + 0x20;
  }

  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000004);

  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000003, ,0x00000003);
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000000);


  Address = 0x4000C9CC;
  Data = 0x0;
  WaitLoop(0x9);
  for (i = 0; i < 100; i++)
  {
    C("Port2 : Case8 : Continuous WRAP16 write with 0x8000 as addr incrementing value");
    HSA(Address, NSEQ, WRAP4, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    Address = Address & 0xFFFFFFF0;
    Address = Address + 0x08000;
  }

  Address = 0x4000040C;
  Data = 0x0;
  WaitLoop(0x9);

  for (i = 0; i < 100; i++)
  {
    C("Port2 : Case8 : Continuous WRAP16 write");
    HSA(Address, NSEQ, WRAP16, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    Address = Address + 0x40;
  }

  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000004);

  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000003, ,0x00000003);
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000000);

/******************************************************************************/
/* Port 0 transactions                                                        */
/******************************************************************************/

  #elif (INFILE == 0)
  WaitLoop(0x3);

  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000008, ,0x00000008);

  WaitLoop(0x80);
  
  Address = 0x4031A2FC;
  for (i=0;i<=70;i++)
  {
    C("Port0 : Case1 : Continuous incr write");
    HSA(Address, NSEQ, INCR, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    WaitLoop(0x96);
    Address = Address + 0x14;
    LoBits = Address & 0x03FF;
    Bound  = LoBits + 64;
    if (Bound > 1024)
      Address = Address + 100;
  }

  Address = 0x4000A2FC;
  for (i=0;i<=75;i++)
  {
    C("Port0 : Case1 : Continuous incr write to the same page as from the Port2");
    HSA(Address, NSEQ, INCR, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    WaitLoop(0x96);
    Address = Address + 0x14;
    LoBits = Address & 0x03FF;
    Bound  = LoBits + 64;
    if (Bound > 1024)
      Address = Address + 100;
  }

  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000001);
  
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000006, ,0x00000006);
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000000);

  Address = 0x400012FC;
  for (i=0;i<=75;i++)
  {
    C("Port0 : Case2 : Continuous incr write");
    HSA(Address, NSEQ, INCR, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    WaitLoop(0x96);
    Address = Address + 0x14;
    LoBits = Address & 0x03FF;
    Bound  = LoBits + 64;
    if (Bound > 1024)
      Address = Address + 100;

  }


  Address = 0x400072FC;
  for (i=0;i<=110;i++)
  {
    C("Port0 : Case2 : Continuous incr write to the same page as from the Port2");
    HSA(Address, NSEQ, INCR, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    WaitLoop(0x96);
    Address = Address + 0x14;
    LoBits = Address & 0x03FF;
    Bound  = LoBits + 64;
    if (Bound > 1024)
      Address = Address + 100;

  }

  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000001);

  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000006, ,0x00000006);
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000000);

  Address = 0x4042A0FC;
  for (i=0;i<=70;i++)
  {
    C("Port0 : Case3 : Continuous incr16 write");
    HSA(Address, NSEQ, INCR16, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    WaitLoop(0x96);
    Address = Address + 0x40;
    LoBits = Address & 0x03FF;
    Bound  = LoBits + 64;
    if (Bound > 1024)
      Address = Address + 100;

  }


  Address = 0x4000A0FC;
  for (i=0;i<=70;i++)
  {
    C("Port0 : Case3 : Continuous in16 write to the same page as from the Port2");
    HSA(Address, NSEQ, INCR16, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    WaitLoop(0x96);
    Address = Address + 0x40;
    LoBits = Address & 0x03FF;
    Bound  = LoBits + 64;
    if (Bound > 1024)
      Address = Address + 100;

  }

  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000001);

  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000006, ,0x00000006);
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000000);

  Address = 0x4043A4FC;
  for (i=0;i<=75;i++)
  {
    C("Port0 : Case4 : Continuous incr16 write");
    HSA(Address, NSEQ, INCR16, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    WaitLoop(0x96);
    Address = Address + 0x40;
    LoBits = Address & 0x03FF;
    Bound  = LoBits + 64;
    if (Bound > 1024)
      Address = Address + 100;

  }


  Address = 0x400010FC;
  for (i=0;i<=75;i++)
  {
    C("Port0 : Case4 : Continuous in16 write to the same page as from the Port2");
    HSA(Address, NSEQ, INCR16, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    WaitLoop(0x96);
    Address = Address + 0x40;
    LoBits = Address & 0x03FF;
    Bound  = LoBits + 64;
    if (Bound > 1024)
      Address = Address + 100;

  }

  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000001);

  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000006, ,0x00000006);
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000000);

  Address = 0x4043A1FC;
  for (i=0;i<=75;i++)
  {
    C("Port0 : Case5 : Continuous incr write");
    HSA(Address, NSEQ, INCR, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    WaitLoop(0x96);
    Address = Address + 0x40;
    LoBits = Address & 0x03FF;
    Bound  = LoBits + 64;
    if (Bound > 1024)
      Address = Address + 100;
  }


  Address = 0x400030FC;
  for (i=0;i<=75;i++)
  {
    C("Port0 : Case5 : Continuous in16 write to the same page as from the Port2");
    HSA(Address, NSEQ, INCR16, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    WaitLoop(0x96);
    Address = Address + 0x40;
    LoBits = Address & 0x03FF;
    Bound  = LoBits + 64;
    if (Bound > 1024)
      Address = Address + 100;

  }

  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000001);

  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000006, ,0x00000006);
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000000);

  Address = 0x4053A1FC;
  for (i=0;i<=75;i++)
  {
    C("Port0 : Case6 : Continuous incr write");
    HSA(Address, NSEQ, INCR, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    WaitLoop(0x96);
    Address = Address + 0x40;
    Address = Address + 0x40;
    LoBits = Address & 0x03FF;
    Bound  = LoBits + 64;
    if (Bound > 1024)
      Address = Address + 100;
  }

  Address = 0x400031FC;
  for (i=0;i<=75;i++)
  {
    C("Port0 : Case6 : Continuous in16 write to the same page as from the Port2");
    HSA(Address, NSEQ, INCR16, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    WaitLoop(0x96);
    Address = Address + 0x40;
    LoBits = Address & 0x03FF;
    Bound  = LoBits + 64;
    if (Bound > 1024)
      Address = Address + 100;

  }

  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000001);

  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000006, ,0x00000006);
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000000);

  Address = 0x4053B2AC;
  for (i=0;i<=75;i++)
  {
    C("Port0 : Case7 : Continuous incr write");
    HSA(Address, NSEQ, INCR, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    WaitLoop(0x96);
    Address = Address + 0x40;
    LoBits = Address & 0x03FF;
    Bound  = LoBits + 64;
    if (Bound > 1024)
      Address = Address + 100;

  }


  Address = 0x400032CC;
  for (i=0;i<=75;i++)
  {
    C("Port0 : Case7 : Continuous in16 write to the same page as from the Port2");
    HSA(Address, NSEQ, INCR16, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    WaitLoop(0x96);
    Address = Address + 0x40;
    LoBits = Address & 0x03FF;
    Bound  = LoBits + 64;
    if (Bound > 1024)
      Address = Address + 100;

  }

  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000001);

  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000006, ,0x00000006);
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000000);

  Address = 0x4043B2AC;
  for (i=0;i<=75;i++)
  {
    C("Port0 : Case8 : Continuous incr write");
    HSA(Address, NSEQ, INCR, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    WaitLoop(0x96);
    Address = Address + 0x40;
    LoBits = Address & 0x03FF;
    Bound  = LoBits + 64;
    if (Bound > 1024)
      Address = Address + 100;

  }


  Address = 0x400034CC;
  for (i=0;i<=75;i++)
  {
    C("Port0 : Case8 : Continuous in16 write to the same page as from the Port2");
    HSA(Address, NSEQ, INCR16, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    WaitLoop(0x96);
    Address = Address + 0x40;
    LoBits = Address & 0x03FF;
    Bound  = LoBits + 64;
    if (Bound > 1024)
      Address = Address + 100;

  }

  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000001);

  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000006, ,0x00000006);
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000000);

/******************************************************************************/
/* Port 1 transactions                                                        */
/******************************************************************************/

  #elif (INFILE == 1)
  
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000008, ,0x00000008);

  WaitLoop(0x80);

  Address = 0x4000B7AC;
  Data = 0x0;
  WaitLoop(0x9);

  for (i = 0; i < 200; i++)
  {
    C("Port1 : Case1 : Continuous wrap16 write with 0x8000 as addr incrementing value");
    HSA(Address, NSEQ, WRAP16, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    Address = Address + 0x08000;
  }

  Address = 0x400014FC;
  for (i = 0; i < 200; i++)
  {
    C("Port1 : Case1 : Continuous WRAP16 write with 0x40 as addr incrementing value");
    HSA(Address, NSEQ, WRAP16, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    Address = Address + 0x40;
  }

  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000002);
 
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000005, ,0x00000005);
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000000);

  WaitLoop(0x10);

  Address = 0x4001A7E4;
  Data = 0x0;
  WaitLoop(0x9);

  for (i = 0; i < 200; i++)
  {
    C("Port1 : Case2 : Continuous wrap8 write with 0x8000 as addr incrementing value");
    HSA(Address, NSEQ, WRAP8, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    Address = Address & 0xFFFFFFF0;
    Address = Address + 0x08000;
  }

  Address = 0x40000700;
  Data = 0x0;
  WaitLoop(0x9);

  for (i = 0; i < 200; i++)
  {
    C("Port1 : Case2 : Continuous wrap8 write");
    HSA(Address, NSEQ, WRAP8, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    Address = Address + 0x20;
    Address = Address + 0x40;
    LoBits = Address & 0x03FF;
    Bound  = LoBits + 64;
    if (Bound > 1024)
      Address = Address + 100;
  }

  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000002);

  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000005, ,0x00000005);
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000000);

  Address = 0x4000B7F0;
  Data = 0x0;
  WaitLoop(0x9);

  for (i = 0; i < 200; i++)
  {
    C("Port1 : Case3 : Continuous wrap4 write with 0x8000 as addr incrementing value");
    HSA(Address, NSEQ, WRAP4, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    Address = Address & 0xFFFFFFF0;
    Address = Address + 0x08000;
  }

  Address = 0x40000504;
  Data = 0x0;
  WaitLoop(0x9);

  for (i = 0; i < 200; i++)
  {
    C("Port1 : Case3 : Continuous wrap4 write");
    HSA(Address, NSEQ, WRAP4, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    Address = Address + 0x10;
  }

  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000002);

  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000005, ,0x00000005);
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000000);

  WaitLoop(0x10);

  Address = 0x4000C7C0;
  Data = 0x0;
  WaitLoop(0x9);
  for (i = 0; i < 200; i++)
  {
    C("Port1 : Case4 : Continuous incr16 write with 0x8000 as addr incrementing value");
    HSA(Address, NSEQ, INCR16, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    Address = Address & 0xFFFFFFF0;
    Address = Address + 0x08000;
  }

  Address = 0x4000030C;
  Data = 0x0;
  WaitLoop(0x9);

  for (i = 0; i < 200; i++)
  {
    C("Port1 : Case4 : Continuous incr16 write");
    HSA(Address, NSEQ, INCR16, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    Address = Address + 0x40;
    LoBits = Address & 0x03FF;
    Bound  = LoBits + 64;
    if (Bound > 1024)
      Address = Address + 100;

  }

  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000002);

  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000005, ,0x00000005);
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000000);


  Address = 0x4000B7E0;
  Data = 0x0;
  WaitLoop(0x9);

  for (i = 0; i < 200; i++)
  {
    C("Port1 : Case5 : Continuous incr8 write with 0x8000 as addr incrementing value");
    HSA(Address, NSEQ, INCR8, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    Address = Address & 0xFFFFFFF0;
    Address = Address + 0x08000;
  }

  Address = 0x40000720;
  Data = 0x0;
  WaitLoop(0x9);

  for (i = 0; i < 200; i++)
  {
    C("Port1 : Case5 : Continuous incr8 write");
    HSA(Address, NSEQ, INCR8, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    Address = Address + 0x20;
  }

  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000004);

  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000001, ,0x00000001);
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000000);

  WaitLoop(0x10);

  Address = 0x4000B7F0;
  Data = 0x0;
  WaitLoop(0x9);

  for (i = 0; i < 200; i++)
  {
    C("Port1 : Case6 : Continuous incr4 write with 0x8000 as addr incrementing value");
    HSA(Address, NSEQ, INCR4, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    Address = Address & 0xFFFFFFF0;
    Address = Address + 0x08000;
  }

  Address = 0x40000100;
  Data = 0x0;
  WaitLoop(0x9);

  for (i = 0; i < 200; i++)
  {
    C("Port1 : Case6 : Continuous incr4 write");
    HSA(Address, NSEQ, INCR4, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    Address = Address + 0x10;
  }

  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000002);

  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000005, ,0x00000005);
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000000);

  WaitLoop(0x10);


  Address = 0x4000E7F0;
  Data = 0x0;
  WaitLoop(0x9);

  for (i = 0; i < 200; i++)
  {
    C("Port1 : Case7 : Continuous incr write with 0x8000 as addr incrementing value");
    HSA(Address, NSEQ, INCR, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    Address = Address & 0xFFFFFFF0;
    Address = Address + 0x08000;
  }

  Address = 0x40000200;
  Data = 0x0;
  WaitLoop(0x9);

  for (i = 0; i < 200; i++)
  {
    C("Port1 : Case7 : Continuous incr write");
    HSA(Address, NSEQ, INCR, OK, WRD);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    HSW(, 0x00000000);
    Address = Address + 0x10;
  }

  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000002);

  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000005, ,0x00000005);
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000000);

  
  Address = 0x400007FC;
  Data = 0x0;
  WaitLoop(0x9);
  
  for (i = 0; i < 200; i++)
  {
    C("Port1 : Case8 : Continuous single write with 0x8000 as addr incrementing value");
    HSA(Address, NSEQ, SINGLE, OK, WRD);
    HSW(, 0x00000000);
    Address = Address + 0x08000;
  }
 
  Address = 0x400000FC;
  for (i = 0; i < 200; i++)
  {
    C("Port1 : Case8 : Continuous single write with 0x4 as addr incrementing value");
    HSA(Address, NSEQ, SINGLE, OK, WRD);
    HSW(, 0x00000000);
    Address = Address + 0x4;
  }

  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000002);
  
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000005, ,0x00000005);
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000000);

 #endif
}
/*-- --=============================== End ================================-- */
