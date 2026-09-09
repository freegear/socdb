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
--  File Name              : LatencyTest2.c.rca
--  File Revision          : 1.3
--
--  Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This test performs accesses through different AHB ports and
--           tests whether the AHB priority scheme is properly followed, as
--           far as returning data to HRDATA bus is concerned.
--
-- --=======================================================================--*/
void LatencyTest2()
{
  /*
     Summary: LatencyTest2
     =====================
     It does the following functionality
   
     o  Initialise the SDRAMs from Port3.

     o  Perform write to the 16Mx16 memory with BRC from port2.
        Increment the address by 8000 so that each time different page is
        written.

     o  Try to perform read from the Port1 to the same bank.

     o  Verify that the Port1 gets the bus at the earliest.

  */
  int i;
  int32 Addr, Data,Address;
  int LoBits, Bound;
  char debugstr[100];
  int trans[17] = {2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,5};

  /****************************************************************************/
  /* Port 3 transactions                                                      */
  /****************************************************************************/

  #if (INFILE == 3)
  WaitLoop(0x3);
  C("TEST ID : MPMC_LatencyTest2");
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
  HSW(,0x0000032);
  WaitLoop(0x270);

  /* Program the latency counter for HREADY1 check                            */
  HSA(HREADY1CNT, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000055);

  /* Enable the latency checkeer                                              */
  HSA(MPMCTrCR, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000040);

  ENDIANNESS = 0;
  HSEN(LITTLE); 

  HSA(MPMCTrSR, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000000);

  /* A write of 1 into the corresponding bit (fourth bit for port 3) is used  */
  /* as a synching-up mechanism by other AHB port to start their transaction. */
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000008);
  WaitLoop(0x300);

  /****************************************************************************/
  /* Port 2 transactions                                                      */
  /****************************************************************************/

  #elif (INFILE == 2)

  /* By polling the fourth bit of MpmcTrTES register, this port (Port 1) is   */
  /* synching-up the time with respect to port-3 and determining the time     */
  /* at which port-1 itself starts the transactions.                          */

  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000008, ,0x00000008);
  WaitLoop(0x3);
  WaitLoop(0x3);
  WaitLoop(0x3);
  
  Address = 0x4042A7FC;
  Data = 0x0;
  WaitLoop(0x9);
  
  /* Perform single write from the Port3 with the address incrementing as     */
  /*  0x8000                                                                  */
  /* so that for each write different page is accessed.                       */
  for (i = 0; i < 200; i++)
  {
    C("Writing from Port2");
    HSA(Address, NSEQ, SINGLE, OK, WRD);
    HSW(, 0x00000000);
    Address = Address + 0x08000;
  }
  WaitLoop(0x3);

  WaitLoop(0x10);
  /****************************************************************************/
  /* Port 1 transactions                                                      */
  /****************************************************************************/

  #elif (INFILE == 1)
  WaitLoop(0x2);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000000);

  /* By polling the fourth bit of MpmcTrTES register, this port (Port 1) is   */
  /* synching-up the time with respect to port-3 and determining the time     */
  /* at which port-1 itself starts the transactions.                          */

  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000008, ,0x00000008);
  WaitLoop(0x80);
  /* Perform incr16 read from the Port1                                       */
  Address = 0x4031A2FC;
  for (i=0;i<=20;i++) {
  C("Reading from Port1");
  HSA(Address, NSEQ, INCR16, OK, WRD);
  HSR(,Data, ,0x00000000);
  HSR(,Data, ,0x00000000);
  HSR(,Data, ,0x00000000);
  HSR(,Data, ,0x00000000);
  HSR(,Data, ,0x00000000);
  HSR(,Data, ,0x00000000);
  HSR(,Data, ,0x00000000);
  HSR(,Data, ,0x00000000);
  HSR(,Data, ,0x00000000);
  HSR(,Data, ,0x00000000);
  HSR(,Data, ,0x00000000);
  HSR(,Data, ,0x00000000);
  HSR(,Data, ,0x00000000);
  HSR(,Data, ,0x00000000);
  HSR(,Data, ,0x00000000);
  HSR(,Data, ,0x00000000);
  Address = Address + 0x40;
  LoBits = Address & 0x03FF;
  Bound  = LoBits + 64;
  if (Bound > 1024)
    Address = Address + 100;
  }

  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000002);
  WaitLoop(0x200);
 #endif
}
/*-- --=============================== End ================================-- */
