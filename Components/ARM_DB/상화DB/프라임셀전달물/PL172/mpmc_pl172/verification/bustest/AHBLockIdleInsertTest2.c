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
--  File Name              : AHBLockIdleInsertTest2.c.rca
--  File Revision          : 1.2
--
--  Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--          This test performs the locked accesses from the AHB1 and inserts
--          idle states along with Lock signal high and check whether the
--          arbitration should not happen in the idle window.
-- --=======================================================================--*/
void AHBLockIdleInsertTest2()
{
  /*
     Summary: AHBLockIdleInsertTest2
     ===============================
     It does the following functionality

     o  Initialise the SDRAMs from Port3.

     o  Perform locked write to the 16Mx16 memory with BRC from port2.

     o  When the locked burst is completeed keep the lock signal stays active
        (HMASTLOCK = 1) and perform IDLE transfers with HSELMPMC Low.

     o  Perform locked write transactions from the AHB0 while AHB1 is doing 
        idle transfer to the same address.

     o  A locked read transfer occurs on AHB1 (HMASTLOCK =1).
        The value read back should be from the AHB1 write transfer.

  */

  int i;
  int chip, burst, csel, size, msize, LoBits, Bound;
  char* sizetype[]  = {"BYTE", "HWRD","WRD"};

  int Addr, Data,Address;
  char debugstr[100];
  int trans[17] = {2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,5};

  /****************************************************************************/
  /* Port 3 transactions                                                      */
  /****************************************************************************/

  #if (INFILE == 3)
  C("TEST ID : MPMC_AHBLockIdleInsertTest2");
  WaitLoop(0x5);
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

  /* Disable the latecny check of the HREADY0                                 */
  HSA(MPMCTrCR, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000000);

  ENDIANNESS = 0;
  HSEN(LITTLE); 

  HSA(MPMCTrSR, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000000);

  /* A write of 1 into the corresponding bit (fourth bit for port 3) is used  */
  /* as a synching-up mechanism by other AHB port to start their transaction. */
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000008);

  /* Insert wait state till other ports complete their operation              */
  WaitLoop(0x1000);
  
  /****************************************************************************/
  /* Port 1 transactions                                                      */
  /****************************************************************************/

  #elif (INFILE == 1)
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000000);

  WaitLoop(0x3);
  /* Wait till Port3 completes its initialisation task                        */
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000008, ,0x00000008);
  WaitLoop(0x10);

  Address = 0x40A00000;
  Data = 0x30000000;
  for (i = 0; i < 25; i++)
  {
    HSA(Address, NSEQ, INCR, OK, WRD, ,0x1, 0x1);
    HSW(,Data++);
    HSW(,Data++);
    HSW(,Data++);
    HSW(,Data++);
    Address = Address + 0x10;
  }
C("Apply IDLE states with HMASTLOCK high to the access from AHB1 and HSEL Low");
  for (i = 0; i < 100; i++)
  {
    HSA(0x80000000, IDLE, INCR, OK, WRD, ,0x1, 0x1);
    HSW(,0x87654321);
  }
  
  C("Read the data back from AHB1");
  Address = 0x40A00000;
  Data = 0x30000000;
  for (i = 0; i < 15; i++)
  {
    HSA(Address, NSEQ, INCR, OK, WRD, ,0x1, 0x1);
    HSR(,Data++, ,0xFFFFFFFF);
    HSR(,Data++, ,0xFFFFFFFF);
    HSR(,Data++, ,0xFFFFFFFF);
    HSR(,Data++, ,0xFFFFFFFF);
    Address = Address + 0x10;
  }
  WaitLoop(0x200);

  /****************************************************************************/
  /* Port 0 transactions                                                      */
  /****************************************************************************/

  #elif (INFILE == 0)
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000000);
  WaitLoop(0x3);
  /* Wait till Port3 completes its initialisation task                        */
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000008, ,0x00000008);
  WaitLoop(0x10);

  WaitLoop(0x95);
  
  Address = 0x40A00000;
  Data = 0x40000000;
  C("Try to perform write from Port0 to the same address as Port1");
  Address = 0x40A00000;
  for (i = 0; i < 15; i++)
  {
    HSA(Address, NSEQ, INCR, OK, WRD, ,0x1, 0x1);
    HSW(,Data++);
    HSW(,Data++);
    HSW(,Data++);
    HSW(,Data++);
    Address = Address + 0x10;
  }
  WaitLoop(0x200);

 #endif
}
/*-- --=============================== End ================================-- */
