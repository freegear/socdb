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
--  File Name              : SMWAITFlagTests.c.rca
--  File Revision          : 1.17
--
--  Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform SMWAIT Flag Tests on the SMC.
--
-- --=========================================================================*/

/******************************************************************************/
/***************************** SMWAIT Flag Tests ******************************/
/******************************************************************************/

void SMWAITFlagTests()
{
  /*
     Summary: SMWAIT Flag Tests
     ==========================
     This function performs the following:

     o  SMWAIT is asserted and de-asserted before and after 32 wait states
     o  SMWAIT Flag is monitored
     o  SMWAIT is asserted after WST1/WST2 followed by transfers to that bank
        and other banks
     o  Checks for SMWAIT Flag is not set and it gives ERROR response
     o  Checks boundary cases of assertion of SMWAIT just before the WST1/WST2
        counter expiry and also on the same clock of counter expiry
     o  Checks a boundary case of de-assertion of SMWAIT on the 32 wait states
  */

  int32 MemAddr, StatValue, TestData, EWSValue;

  C("Configuring the SMC and the Memory banks with SMWAIT Enabled and");
  /** Set Bank 0 Memory Type as SRAM (32 bits width) **/
  /** ExtWait Enabled, WaitPol = 1 **/
  /** Boundary Case disabled **/
  SMCTrMEMBData[0] = 0x00000000;
  ConfigureUUT(0, 0x02, 0x1F, 0x04, 0x02, 0x00, 0x00000087, 0x000004,
               0x000002);
  ConfigureMemory(0, 0x02, 0x1F, 0x04, 0x342, SMCTrMEMBData[0], 0x02,
                  0x00, 0x000000);

  /** Set Bank 1 Memory Type as SRAM (32 bits width) **/
  /** ExtWait Enabled, WaitPol = 1 **/
  /** Boundary Case disabled **/
  SMCTrMEMBData[1] = 0x00000000;
  ConfigureUUT(1, 0x02, 0x1F, 0x04, 0x02, 0x00, 0x00000087, 0x000005,
               0x000002);
  ConfigureMemory(1, 0x02, 0x1F, 0x04, 0x342, SMCTrMEMBData[1], 0x02,
                  0x00, 0x000000);

  /** Set Bank 2 Memory Type as SRAM (32 bits width) **/
  SMCTrMEMBData[2] = 0x00000000;
  /** ExtWait Enabled, WaitPol = 1 **/
  /** Boundary Case enabled **/
  ConfigureUUT(2, 0x02, 0x00, 0x04, 0x02, 0x00, 0x00000087, 0x000005,
               0x000003);
  ConfigureMemory(2, 0x02, 0x00, 0x04, 0x742, SMCTrMEMBData[2], 0x02,
                  0x00, 0x000000);

  /** Set Bank 3 Memory Type as SRAM (32 bits width) **/
  /** ExtWait Enabled, WaitPol = 1 **/
  /** Boundary Case enabled **/
  SMCTrMEMBData[3] = 0x00000000;
  ConfigureUUT(3, 0x02, 0x00, 0x04, 0x02, 0x00, 0x00000087, 0x000005,
               0x000005);
  ConfigureMemory(3, 0x02, 0x00, 0x04, 0x742, SMCTrMEMBData[3], 0x02,
                  0x00, 0x000000);

  /** Set Bank 4 Memory Type as SRAM (16 bits width) **/
  SMCTrMEMBData[4] = 0x00000000;
  /** ExtWait Enabled, WaitPol = 1 **/
  /** Boundary Case disabled **/
  ConfigureUUT(4, 0x02, 0x0A, 0x04, 0x02, 0x00, 0x00000047, 0x000007,
               0x000008);
  ConfigureMemory(4, 0x02, 0x0A, 0x04, 0x341, SMCTrMEMBData[4], 0x02,
                  0x00, 0x000000);

  /** Set Bank 5 Memory Type as SRAM (16 bits width) **/
  /** ExtWait Enabled, WaitPol = 1 **/
  /** Boundary Case disabled **/
  SMCTrMEMBData[5] = 0x00000000;
  ConfigureUUT(5, 0x03, 0x0A, 0x00, 0x03, 0x00, 0x00000047, 0x000006,
               0x000008);
  ConfigureMemory(5, 0x03, 0x0A, 0x00, 0x341, SMCTrMEMBData[5], 0x03,
                  0x00, 0x000000);

  /** Set Bank 6 Memory Type as SRAM (8 bits width) **/
  SMCTrMEMBData[6] = 0x00000000;
  /** ExtWait Enabled, WaitPol = 1 **/
  /** Boundary Case disabled **/
  ConfigureUUT(6, 0x04, 0x0B, 0x02, 0x04, 0x00, 0x00000006, 0x000006,
               0x000009);
  ConfigureMemory(6, 0x04, 0x0B, 0x02, 0x300, SMCTrMEMBData[6], 0x04,
                  0x00, 0x000000);

  /** Set Bank 7 Memory Type as SRAM (8 bits width) **/
  /** ExtWait Enabled, WaitPol = 1 **/
  /** Boundary Case disabled **/
  SMCTrMEMBData[7] = 0x00000000;
  ConfigureUUT(7, 0x02, 0x0C, 0x01, 0x05, 0x00, 0x00000006, 0x000006,
               0x000006);
  ConfigureMemory(7, 0x02, 0x0C, 0x01, 0x300, SMCTrMEMBData[7], 0x05,
                  0x00, 0x000000);

   /* TODO */
  C("Enable CancelSMWAIT");
  HSA(SMCTrCNCLWAIT, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( , 0x3FF);

  C("SMWAIT is asserted before counter expiry");
  HSA(SMCTrCS2WTR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x3000005);

  /** Write into the Memory through the SMC **/
  MemAddr = SMCMEM_0 + (SMCTrMEMBData[0] << 11);
  TestData = 0x55555555;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);

  /** Read from the Memory through the SMC **/
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , TestData, , NoMask, ,SMWAITFlagTests_1);

  StatValue = ZERO;
  ReadStatus(0, StatValue);

  C("SMWAIT is asserted after counter expiry");
  HSA(SMCTrCS2WTR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x300003F);

  /** Write into the Memory through the SMC **/
  TestData = 0xAAAAAAAA;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);

  /** Read from the Memory through the SMC **/
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , TestData, , NoMask, ,SMWAITFlagTests_2);

  ReadStatus(0, StatValue);

  C("SMWAIT is asserted at counter expiry");
  HSA(SMCTrCS2WTR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x300001F);

  /** Write into the Memory through the SMC **/
  TestData = 0xAAAAAAAA;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);

  /** Read from the Memory through the SMC **/
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , TestData, , NoMask, ,SMWAITFlagTests_3);

  ReadStatus(0, StatValue);

  MemAddr = SMCMEM_1 + (SMCTrMEMBData[1] << 11);
  TestData = 0x11223344;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSW( , 0x12345678);

  C("SMWAIT is asserted before counter expiry and times out");
  HSA(SMCTrCS2WTR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x3000002);
  HSA(SMCTrCEWTR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x2C);

  /** Write into the Memory through the SMC **/
  /** The transfer gets aborted and expecting ERROR response **/
  HSA(MemAddr, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
  HSW( , 0x44332211);

  WaitLoop(2);
  StatValue = 0x04;
  ReadStatus(1, StatValue);

  ClrStatus(1);

  /** Read the Memory through the SMC data **/
  /** The transfer gets aborted and expecting ERROR response **/
  HSA(MemAddr, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
  HSR( , ZERO, , NoMask, ,SMWAITFlagTests_4);

  WaitLoop(2);
  ReadStatus(1, StatValue);

  ClrStatus(1);

  /** Reconfigure the CEWT Register for proper operation **/
  HSA(SMCTrCEWTR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x02);

  /** Read the Memory for the unmodified data **/
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x11223344, , NoMask, ,SMWAITFlagTests_5);

  C("SMWAIT is de-asserted and CANCELSMWAIT is asserted simultaneously");
  HSA(SMCTrCEWTR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x1F);

  /** Write into the Memory through the SMC **/
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x11223344);

  /** Read the Memory through the SMC data **/
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x11223344, , NoMask, ,SMWAITFlagTests_6);

  StatValue = ZERO;
  ReadStatus(1, StatValue);

  C("SMWAIT is de-asserted after CANCELSMWAIT assertion");
  HSA(SMCTrCEWTR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x3F);

  /** Write into the Memory through the SMC **/
  /** The transfer gets aborted and expecting ERROR response **/
  HSA(MemAddr, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
  HSW( , TestData);

  WaitLoop(1);
  EWSValue = 0x01;
  ReadEWS(EWSValue);

  StatValue = 0x04;
  ReadStatus(1, StatValue);

  /** Write into the Memory through the SMC **/
  /** Since the SMWAIT is still asserted, the transfer gets aborted and **/
  /** expecting ERROR response **/
  HSA(MemAddr+4, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
  HSW( , 0x44332211);

  WaitLoop(1);
  EWSValue = 0x01;
  ReadEWS(EWSValue);

  StatValue = 0x04;
  ReadStatus(1, StatValue);

  EWSValue = 0x00;
  ReadEWS(EWSValue);

  ClrStatus(1);

  /** Read the Memory through the SMC data **/
  /** The transfer gets aborted and expecting ERROR response **/
  HSA(MemAddr, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
  HSR( , ZERO, , NoMask, ,SMWAITFlagTests_7);

  WaitLoop(1);
  EWSValue = 0x01;
  ReadEWS(EWSValue);

  StatValue = 0x04;
  ReadStatus(1, StatValue);

  EWSValue = 0x00;
  ReadEWS(EWSValue);

  ClrStatus(1);

  /** Read the Memory through the SMC data **/
  /** Since the SMWAIT is still asserted, the transfer gets aborted and **/
  /** expecting ERROR response **/
  HSA(MemAddr+4, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
  HSR( , ZERO, , NoMask, ,SMWAITFlagTests_8);

  WaitLoop(1);
  EWSValue = 0x01;
  ReadEWS(EWSValue);

  StatValue = 0x04;
  ReadStatus(1, StatValue);

  EWSValue = 0x00;
  ReadEWS(EWSValue);

  ClrStatus(1);

  /** Reconfigure the CEWT Register for proper operation **/
  HSA(SMCTrCEWTR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x02);

  /** Read the Memory for the unmodified data **/
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , TestData, , NoMask, ,SMWAITFlagTests_9);
  HSR( , 0x12345678, , NoMask, ,SMWAITFlagTests_10);


  /** SMWAIT is Asserted when the Timer count has reached 1 **/
  /** This is tested to verify that the SMWAIT assertion is given **/
  /** preference even if the Timer count value has reached one **/

  /** Set Bank 1 Memory Type as SRAM (32 bits width) **/
  /** ExtWait Enabled, WaitPol = 1 **/
  /** Boundary Case disabled **/

  C("SMWAIT ASSERTED when Count value is 1");

  SMCTrMEMBData[1] = 0x00000000;
  ConfigureUUT(1, 0x02, 0x1F, 0x1F, 0x02, 0x00, 0x00000087, 0x00001D,
               0x000002);
  ConfigureMemory(1, 0x02, 0x1F, 0x1F, 0x342, SMCTrMEMBData[1], 0x02,
                  0x00, 0x000000);
  MemAddr = SMCMEM_1 + (SMCTrMEMBData[1] << 11);

  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x11112222);

  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , 0x11112222, , NoMask, ,SMWAITFlagTests_11);
 
  WaitLoop(6);

/** Corner case where an externally waited write is cancelled to **/ 
/** a 16 bit memory and read is performed on 32 bit memory **/
/** Bank5 is configured as 16 bit memory and externally waited write **/
/** is cancelled to bank5 and a read is performed on the bank1 configured **/
/** as 32 bit **/

 C("Corner case where an externally waited write is cancelled to a 16 bit memory and read is performed on 32 bit memory");

  /** Set Bank 5 Memory Type as SRAM (16 bits width) **/
  /** ExtWait Enabled, WaitPol = 1 **/
  /** Boundary Case disabled **/

  SMCTrMEMBData[5] = 0x00000000;
  ConfigureUUT(5, 0x03, 0x1F, 0x1F, 0x03, 0x00, 0x00000047, 0x000006,
               0x000008);
  ConfigureMemory(5, 0x03, 0x1F, 0x1F, 0x341, SMCTrMEMBData[5], 0x03,
                  0x00, 0x000000);

 C("SMWAIT is de-asserted after CANCELSMWAIT assertion"); 
  HSA(SMCTrCS2WTR5, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x3000002);
  HSA(SMCTrCEWTR5, NSEQ, INCR, , WRD, , 0x1, , , , ,); 
  HSW( , 0x23);  

  MemAddr = SMCMEM_5 + (SMCTrMEMBData[5] << 11);
  TestData = 0x12345678;
  HSA(MemAddr, NSEQ, INCR,ERROR , WRD, , 0x1, , , , ,);
  HSW( , TestData);

  /** Read the Memory through the SMC data **/
  /** The transfer gets aborted and expecting ERROR response **/
  HSA(MemAddr, NSEQ, INCR, ERROR, WRD, , 0x1, , , , ,);
  HSR( , ZERO, , NoMask, ,SMWAITFlagTests_12);


  WaitLoop(8); 

  MemAddr = SMCMEM_1 + (SMCTrMEMBData[1] << 11);

  /** Reading the data from bank1**/
  HSA(MemAddr, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSR( , 0x11112222, , NoMask, ,SMWAITFlagTests_13);



  
}

/************************************ End *************************************/
