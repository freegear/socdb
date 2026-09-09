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
--  File Name              : LatencyTest7.c.rca
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
void LatencyTest7()
{
  /*
     Summary: LatencyTest7
     =====================
     It does the following functionality

     o  Initialise the SDRAMs from Port3.

     o  Perform write to the 16Mx16 memory with BRC from port2.
        Increment the address by 8000 so that each time different page is
        written.

     o  Perform locked transactions from the AHB0.

     o  Perform write/read transactions from the AHB1.

     o  Perform write/read to the 16Mx16 memory with BRC from port2.

     o  Verify that the Port1 gets the bus at the earliest.
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
  C("TEST ID : MPMC_LatencyTest7");
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

  /* Program the latency counter to check the HREADY0                         */
  HSA(HREADY0CNT, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000055);

  /* Enable the latecny check of the HREADY0                                  */
  HSA(MPMCTrCR, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000020);

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
  
  /* Perform single write from Port2                                          */
  Address = 0x4042A7FC;
  Data = 0x0;
  WaitLoop(0x9);
  
  for (i = 0; i < 100; i++)
  {
    C("Writing from Port2");
    HSA(Address, NSEQ, SINGLE, OK, WRD);
    HSW(,0x00000000);
    Address = Address + 0x8000;
  }
  WaitLoop(0x3);
  C("Reading from Port2");
  HSA(Address, NSEQ, INCR, OK, WRD);
  HSR(, 0x00000000, ,0x00000000);
  for (i = 0; i < 200; i++)
    HSR(, 0x00000000, ,0x00000000);
  WaitLoop(0x10);

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
  WaitLoop(0x55);

  Address = 0x40A00000;
  for (i = 0; i < 100; i++)
  {
    C("Writing from Port1");
    Sequence('w',Address,trans,"i16",0,0xBBBBBBBC,0); 
    Address = Address + 0x0004;
    Data = Data + 16;
  }
  WaitLoop(0x3);
  C("Reading from Port1");
  HSA(Address, NSEQ, INCR, OK, WRD);
  HSR(, 0x00000000, ,0x00000000);
  for (i = 0; i < 200; i++)
    HSR(, 0x00000000, ,0x00000000);
  WaitLoop(0x80);

  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000002);
  WaitLoop(0x200);

  /****************************************************************************/
  /* Port 0 transactions                                                      */
  /****************************************************************************/

  #elif (INFILE == 0)
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000000);
  WaitLoop(0x3);

  /* Wait till Port3 completes its initialisation of memory and registers     */
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000008, ,0x00000008);
  WaitLoop(0x100);

  /* Perform the locked transfers from Port0                                  */
  for(csel = 4; csel < 5; csel++)
  {
     msize = 2;
     i = 0;
     for (burst = 0; burst < 8; burst++)
     {
        for(size = 0;size < 3; size++)
        {
          C("Access from Port0 which has locked the bus");
          chip = csel;
          Addr = rand() & 0x000843FC;
          i = i + 1;
          LoBits = Addr & 0x03FF;
          Bound  = LoBits + 64;
          if (Bound > 1024)
            Addr = Addr - 400;
          Addr = Addr | (chip << 28);
          Data = 0x11111111;
          if( sizetype[size]== "BYTE")
          {
            debug_info(" Byte Transfer ");
            LockedBurstWrRd(chip,burst,Addr,size,msize,Data);
          }
          else if(sizetype[size] == "HWRD")
          {
            debug_info(" Halfword Transfer ");
            LockedBurstWrRd(chip,burst,Addr,size,msize,Data);
          }
          else if(sizetype[size] == "WRD")
          {
            debug_info(" Word Transfer ");
            LockedBurstWrRd(chip,burst,Addr,size,msize,Data);
          }
        }
        WaitLoop(0x5);
      }
    }
 #endif
}
/*-- --=============================== End ================================-- */
