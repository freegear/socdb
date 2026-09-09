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
--  File Name              : MultiPortPgAccessTest5.c.rca
--  File Revision          : 1.3
--
--  Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This test performs accesses through different AHB2 and AHB1 ports
--           and tests whether the AHB priority scheme is properly followed, as
--           far as returning data to HRDATA bus is concerned.

-- --=======================================================================--*/
void MultiPortPgAccessTest5()
{
  int i;
  int32 Addr, Data,Address;
  char debugstr[100];
/******************************************************************************/
/* Port 3 access
/******************************************************************************/

  #if (INFILE == 3)
  C("TEST ID : MPMC_MultiPortPgAccessTest5");
  WaitLoop(0x10);
  C("Configuring the Memory Banks and the MPMC");

  WriteData(MPMCControl, 0x00000001, "WRD");
  WriteData(MPMCTrTES, 0x00000000, "WRD");
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
  HSW(,0x0000032);
  WaitLoop(0x270);

  ENDIANNESS = 0;
  HSEN(LITTLE); 

  /* Program the latency counter for HREADY1 check                            */
  HSA(HREADY1CNT, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000055);

  /* Enable the latency checkeer                                              */
  HSA(MPMCTrCR, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000040);

  HSA(MPMCTrSR, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000000);

  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000008);

  WaitLoop(0x600);
/******************************************************************************/
/* Port 2 access
/******************************************************************************/
  #elif (INFILE == 2)

/* Wait till Port3 completes the initialisation of memory and registers       */
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000008, ,0x00000008);
  WaitLoop(0x3);
  Address = 0x4042A7F0;
  Data = 0x0;
  WaitLoop(0x9);
  for (i = 0; i < 100; i++)
  {
    C("Writing from Port3");
    HSA(Address, NSEQ, SINGLE, OK, WRD);
    HSW(, Data);
    Address = Address + 0x08000;
    Data = Data + 1;
  }
  WaitLoop(0x3);

  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000001, ,0x00000001);

  WaitLoop(0x3);
/******************************************************************************/
/* Port 1 access
/******************************************************************************/
  #elif (INFILE == 1)
  WaitLoop(0x2);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000000);

/* Wait till Port3 completes the initialisation of memory and registers       */
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000008, ,0x00000008);
  WaitLoop(0x80);
  Address = 0x4031A2FC;
  for (i=0;i<=3;i++) {
  C("Reading from Port0");
  HSA(Address, NSEQ, INCR16, OK, WRD);
  HSR(,Data, , 0x00000000);
  HSR(,Data, , 0x00000000);
  HSR(,Data, , 0x00000000);
  HSR(,Data, , 0x00000000);
  HSR(,Data, , 0x00000000);
  HSR(,Data, , 0x00000000);
  HSR(,Data, , 0x00000000);
  HSR(,Data, , 0x00000000);
  HSR(,Data, , 0x00000000);
  HSR(,Data, , 0x00000000);
  HSR(,Data, , 0x00000000);
  HSR(,Data, , 0x00000000);
  HSR(,Data, , 0x00000000);
  HSR(,Data, , 0x00000000);
  HSR(,Data, , 0x00000000);
  HSR(,Data, , 0x00000000);
  Address = Address + 0x40;
  }

  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000001);
  WaitLoop(0x3);

 #endif
}
/*-- --=============================== End ================================-- */
