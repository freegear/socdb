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
--  File Name              : LatencyTest10.c.rca
--  File Revision          : 1.4
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
void LatencyTest10()
{
  /*
     Summary: LatencyTest10
     =======================
     It does the following functionality

     o  Initialise the SDRAMs from Port3.

     o  Perform locked transfers from the AHB0 and check that AHB1 and AHB2 are
        not performing any transactions and Port0 gets the bus at the earliest.

     o  Perform locked transfers from AHB1 and confirm that the AHB1 got the
        bus grant at the earliest.

     o  Perform locked transfers from AHB2 and confirm that the AHB2 got the
        bus grant at the earliest.

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
  C("TEST ID : MPMC_LatencyTest10");
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

  ENDIANNESS = 0;
  HSEN(LITTLE); 

  HSA(MPMCTrSR, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000000);

  /* Program the latency counter to check the HREADY0                         */
  HSA(HREADY0CNT, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000055);

  /* Program the latency counter to check the HREADY1                         */
  HSA(HREADY1CNT, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000055);

  /* The control register is programmed to enable hready latency checking. */
  HSA(MPMCTrCR, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000060);

  /* A write of 1 into the corresponding bit (fourth bit for port 3) is used  */
  /* as a synching-up mechanism by other AHB port to start their transaction. */
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000008);

  WaitLoop(0x1000);
  /****************************************************************************/
  /* Port 2 transactions                                                      */
  /****************************************************************************/

  #elif (INFILE == 2)
  WaitLoop(0x3);

  /* By polling the fourth bit of MpmcTrTES register, this port (Port 1) is   */
  /* synching-up the time with respect to port-3 and determining the time     */
  /* at which port-1 itself starts the transactions.                          */

  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000008, ,0x00000008);
  WaitLoop(0x3);

  /* Perform locked transfers from Port2 and apply idle state in between.     */
  for(csel = 5; csel < 6; csel++)
  {
     msize = 2;
     i = 0;
     for (burst = 0; burst < 8; burst++)
     {
        for(size = 0;size < 3; size++)
        {
          C("Access from Port2 which has locked the bus");
          chip = csel;
          Addr = rand() & 0x00084FFC;
          Addr = Addr | 0x00040000;
          i = i + 1;
          LoBits = Addr & 0x03FF;
          Bound  = LoBits + 64;
          if (Bound > 1024)
            Addr = Addr + 100;
          Addr = Addr | (chip << 28);
          Data = 0x11111111;
          if( sizetype[size]== "BYTE")
          {
            debug_info(" Byte Transfer ");
            LockedBurstWrRd1(chip,burst,Addr,size,msize,Data);
          }
          else if(sizetype[size] == "HWRD")
          {
            debug_info(" Halfword Transfer ");
            LockedBurstWrRd1(chip,burst,Addr,size,msize,Data);
          }
          else if(sizetype[size] == "WRD")
          {
            debug_info(" Word Transfer ");
            LockedBurstWrRd1(chip,burst,Addr,size,msize,Data);
          }
        }
        WaitLoop(0x5);
      }
    }
  
  WaitLoop(0x10);
/******************************************************************************/
/* Port 0 transactions                                                        */
/******************************************************************************/
  #elif (INFILE == 0)
  WaitLoop(0x2);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000000);
  /* By polling the fourth bit of MpmcTrTES register, this port (Port 1) is   */
  /* synching-up the time with respect to port-3 and determining the time     */
  /* at which port-1 itself starts the transactions.                          */
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000008, ,0x00000008);
  WaitLoop(0x3);

  /* Perform locked transfers from Port0 and insert idle transfers in between */
  for(csel = 6; csel < 7; csel++)
  {
     msize = 2;
     i = 0;
     for (burst = 0; burst < 8; burst++)
     {
        for(size = 0;size < 3; size++)
        {
          C("Access from Port0 which has locked the bus");
          chip = csel;
          Addr = rand() & 0x00084FFC;
          Addr = Addr | 0x00080000;
          i = i + 1;
          LoBits = Addr & 0x03FF;
          Bound  = LoBits + 64;
          if (Bound > 1024)
            Addr = Addr + 1048;
          Addr = Addr | (chip << 28);
          Data = 0x11111111;
          if( sizetype[size]== "BYTE")
          {
            debug_info(" Byte Transfer ");
            LockedBurstWrRd1(chip,burst,Addr,size,msize,Data);
          }
          else if(sizetype[size] == "HWRD")
          {
            debug_info(" Halfword Transfer ");
            LockedBurstWrRd1(chip,burst,Addr,size,msize,Data);
          }
          else if(sizetype[size] == "WRD")
          {
            debug_info(" Word Transfer ");
            LockedBurstWrRd1(chip,burst,Addr,size,msize,Data);
          }
        }
        WaitLoop(0x5);
      }
    }
  
  /* Write '1' to 1st bit of MPMCTrTES register to indicate that the Port1 has   */
  /* completed its operation                                                     */
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000002);
  WaitLoop(0x200);

  /****************************************************************************/
  /* Port 1 transactions                                                      */
  /****************************************************************************/

  #elif (INFILE == 1)
  WaitLoop(0x3);
  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HSW(, 0x00000000);
  WaitLoop(0x3);

  /* By polling the fourth bit of MpmcTrTES register, this port (Port 1) is   */
  /* synching-up the time with respect to port-3 and determining the time     */
  /* at which port-1 itself starts the transactions.                          */

  HSA(MPMCTrTES, NSEQ, INCR, OK, WRD);
  HPO(, 0x00000008, ,0x00000008);
  WaitLoop(0x3);
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
          Addr = rand() & 0x000043FC;
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
            LockedBurstWrRd1(chip,burst,Addr,size,msize,Data);
          }
          else if(sizetype[size] == "HWRD")
          {
            debug_info(" Halfword Transfer ");
            LockedBurstWrRd1(chip,burst,Addr,size,msize,Data);
          }
          else if(sizetype[size] == "WRD")
          {
            debug_info(" Word Transfer ");
            LockedBurstWrRd1(chip,burst,Addr,size,msize,Data);
          }
        }
        WaitLoop(0x5);
      }
    }
 #endif
}
/*-- --=============================== End ================================-- */
