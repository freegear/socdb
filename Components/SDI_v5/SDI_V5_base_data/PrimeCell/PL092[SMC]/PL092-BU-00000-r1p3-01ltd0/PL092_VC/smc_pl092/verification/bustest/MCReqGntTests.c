/* --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2000-2003 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : MCReqGntTests.c.rca
--  File Revision          : 1.17
--
--  Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform tests on the Request-Grant mechanism of the
--           SMC.
--
-- --=========================================================================*/

/******************************************************************************/
/********************* Deterministic Request-Grant Tests **********************/
/******************************************************************************/

void MCReqGntTests()
{
  /*
     Summary: Deterministic Request-Grant Tests
     ==========================================
     This function performs the following:

     o  MCBUSREQ is asserted and de-asserted at different possible timings
     o  The external BUS is observed for the correct data
  */

  int i;
  int32 MemAddr;

  /** Set Bank 1 Memory Type as SRAM (8 bits width) **/
  SMCTrMEMBData[1] = 0x00000000;
  ConfigureUUT(1, 0x02, 0x05, 0x04, 0x02, 0x02, 0x00000000, 0x000004,
               0x000007);
  ConfigureMemory(1, 0x02, 0x05, 0x04, 0x000, SMCTrMEMBData[1], 0x02,
                  0x02, 0x000000);

  /** Set Bank 6 Memory Type as SRAM (32 bits width) **/
  SMCTrMEMBData[6] = 0x00000000;
  ConfigureUUT(6, 0x02, 0x05, 0x04, 0x02, 0x02, 0x00000081, 0x000004,
               0x000007);
  ConfigureMemory(6, 0x02, 0x05, 0x04, 0x042, SMCTrMEMBData[6], 0x02,
                  0x02, 0x000000);

  C("MCBUS requests while SMC is accessing the BUS");
  HSA(SMCTrMCREQD, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0x06);

  HSA(SMCTrGNT2RMREQ, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0x1F);

  HSA(SMCTrMCADDR, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0xAAAAAAAA);

  /** Access MCBUSR which will raise the MCBUSREQ line after a delay **/
  /** specified by the MCREQD Register **/
  HSA(SMCTrMCBUSR, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0x55555555);

  WaitLoop(7);

  /** Writing into the memory - The SMC gets the Bus once the MCBUS is **/
  /** de-granted **/
  MemAddr = SMCMEM_6 + (SMCTrMEMBData[6] << 11);
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0x12345678);
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x12345678, , NoMask, ,MCReqGntTests_1);

  /** Access MCBUSR which will raise the MCBUSREQ line after a delay **/
  /** specified by the MCREQD Register **/
  HSA(SMCTrMCBUSR, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0x55555555);

  /** Writing into the memory - The second write will be deferred **/
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0xAABBCCDD);
  HSW( , 0xDDCCBBAA);

  /** Access MCBUSR which will raise the MCBUSREQ line after a delay **/
  /** specified by the MCREQD Register **/
  HSA(SMCTrMCBUSR, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0xAAAAAAAA, , MaskAll, ,MCReqGntTests_2);

  /** Verify the written data **/
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0xAABBCCDD, ,NoMask, ,MCReqGntTests_3);
  HSR( , 0xDDCCBBAA, ,NoMask, ,MCReqGntTests_4);

  /** Reconfigure the MCREQD and MCADDR Registers **/
  HSA(SMCTrMCREQD, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0x07);

  HSA(SMCTrMCADDR, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0x55555555);

  C("MCBUS and the SMC requests for the bus simultaneously");
  /** Access MCBUSR which will raise the MCBUSREQ line after a delay **/
  /** specified by the MCREQD Register **/
  for (i=0; i<3; i++)
  {
    HSA(SMCTrMCBUSR, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSW( , 0xAAAAAAAA);
  
    WaitLoop(i);
  
    HSA(MemAddr+i*4, NSEQ, INCR, OK, BYTE, , 0x1, , , , ,);
    HSW( , 0x00000078);
    HSW( , 0x00000056);
    HSW( , 0x00000034);
    HSW( , 0x00000012);
  
    /** Verify the written data **/
    HSA(MemAddr+i*4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
    HSR( , 0x12345678, ,NoMask, ,MCReqGntTests_5);
  }

  /** Reconfigure the MCREQD and MCADDR Registers **/
  HSA(SMCTrMCREQD, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0x10);

  HSA(SMCTrMCADDR, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0xDEADDEAD);

  C("MCBUS requests the bus when the SMC is doing a sequential write");
  /** Access MCBUSR which will raise the MCBUSREQ line after a delay **/
  /** specified by the MCREQD Register **/
  HSA(SMCTrMCBUSR, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0xFEDEACBF);

  /** Write into the 8 bit memory with HSIZE = WRD. This will take 4 memory **/
  /** transfers. The SMC looses the Grant before completing the transfer. **/
  /** It completes the transfer when it gets the Grant again **/
  MemAddr = SMCMEM_1 + (SMCTrMEMBData[1] << 11);
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0x11223344);

  /** Verify the written data **/
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x11223344, ,NoMask, ,MCReqGntTests_6);

  /** Access MCBUSR which will raise the MCBUSREQ line after a delay **/
  /** specified by the MCREQD Register **/
  HSA(SMCTrMCBUSR, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0xFEDEACBF);

  /** Read from the 8 bit memory with HSIZE = WRD. This will take 4 memory **/
  /** transfers. The SMC looses the Grant before completing the transfer. **/
  /** It completes the transfer when it gets the Grant again **/
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x11223344, ,NoMask, ,MCReqGntTests_6);

  /** Reconfigure the MCREQD and MCADDR Registers **/
  HSA(SMCTrMCREQD, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0x0D);

  /** Access MCBUSR which will raise the MCBUSREQ line after a delay **/
  /** specified by the MCREQD Register **/
  HSA(SMCTrMCBUSR, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0xFEDEACBF);

  /** Write into the 8 bit memory with HSIZE = HWRD. This will take 2 **/
  /** memory transfers. The SMC looses the Grant before completing the **/
  /** transfer. It completes the transfer when it gets the Grant again **/
  HSA(MemAddr, NSEQ, INCR, OK, HWRD, , 0x1, , , , ,);
  HSW( , 0x00002211);

  /** Verify the written data **/
  HSA(MemAddr, NSEQ, INCR, OK, HWRD, , 0x1, , , , ,);
  HSR( , 0x00002211, ,HWUnMaskL, ,MCReqGntTests_7);

  /** Access MCBUSR which will raise the MCBUSREQ line after a delay **/
  /** specified by the MCREQD Register **/
  HSA(SMCTrMCBUSR, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0xFEDEACBF);

  /** Read from the 8 bit memory with HSIZE = HWRD. This will take 4 memory **/
  /** transfers. The SMC looses the Grant before completing the transfer. **/
  /** It completes the transfer when it gets the Grant again **/
  HSA(MemAddr, NSEQ, INCR, OK, HWRD, , 0x1, , , , ,);
  HSR( , 0x00002211, ,HWUnMaskL, ,MCReqGntTests_7);

  WaitLoop(1);

  HSA(SMCTrMCREQD, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0x06);

  C("MCBUS requests the bus when the SMC is not using the bus");
  /** Access MCBUSR which will raise the MCBUSREQ line after a delay **/
  /** specified by the MCREQD Register **/
  HSA(SMCTrMCBUSR, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0xFEDEACBF);

  WaitLoop(6);

  MemAddr = SMCMEM_6 + (SMCTrMEMBData[6] << 11);
  HSA(MemAddr, NSEQ, INCR, OK, HWRD, , 0x1, , , , ,);
  HSW( , 0x0000CDEF);
  HSW( , 0x000089AB);

  /** Verify the written data **/
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x89ABCDEF, ,NoMask, ,MCReqGntTests_8);

  HSA(SMCTrGNT2RMREQ, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0x03);

  C("The DBI returns to IDLE state");
  /** Access MCBUSR which will raise the MCBUSREQ line after a delay **/
  /** specified by the MCREQD Register **/
  HSA(SMCTrMCBUSR, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0xFEDEACBF);

  WaitLoop(10);

  /** MCBUS requests for the Bus during a TurnAround state where a new **/
  /** Read Request arrives **/

  C("MCBUS requests the bus during TurnAround state")
  C("during which a new Read comes")

  /** Set Bank 1 Memory Type as SRAM (8 bits width) **/
  SMCTrMEMBData[1] = 0x00000000;
  ConfigureUUT(1, 0x0F, 0x05, 0x04, 0x02, 0x02, 0x00000000, 0x000004,
               0x000007);
  ConfigureMemory(1, 0x0F, 0x05, 0x04, 0x000, SMCTrMEMBData[1], 0x02,
                  0x02, 0x000000);

  /** Reconfigure the MCREQD and MCADDR Registers **/
  HSA(SMCTrMCREQD, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0x1A);

  HSA(SMCTrMCADDR, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0xDEADDEAD);

  HSA(SMCTrGNT2RMREQ, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0x1F);

  MemAddr = SMCMEM_1 + (SMCTrMEMBData[1] << 11);
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0x11223344);
 
  WaitLoop(10);

  /** Access MCBUSR which will raise the MCBUSREQ line after a delay **/
  /** specified by the MCREQD Register **/
  HSA(SMCTrMCBUSR, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , 0xFEDEACBF);

  /** Verify the written data **/
  HSA(MemAddr, NSEQ, INCR, OK, BYTE, , 0x1, , , , ,);
  HSR( , 0x11223344, ,BUnMask0, ,MCReqGntTests_9);

  MemAddr = SMCMEM_6 + (SMCTrMEMBData[6] << 11);
  WaitLoop(3);

  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x89ABCDEF, ,NoMask, ,MCReqGntTests_10);
 
  WaitLoop(10);
}

/************************************ End *************************************/
