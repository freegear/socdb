/* --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2003 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : BusAccessTests.c.rca
--  File Revision          : 1.9
--
--  Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform different BUSY and IDLE access tests on the
--           SSMC.
--
-- --=========================================================================*/

/******************************************************************************/
/************************ BUSY and IDLE Accesses Tests ************************/
/******************************************************************************/

void BusAccessTests()
{
  /*
     Summary: BUSY and IDLE Accesses Tests
     =====================================
     This function performs the following:

     o  Adds BUSY transfer in between reads, writes and BURST reads
     o  Adds IDLE transfer in between reads, writes and BURST transfers
  */

  int32 TestData, MemAddr, WTCNCLData, ExtMuxData, SMBLSPOLData;

  /*
      Programming SSMCCR and SSMCTrCR registers. The constants CLKRATIO and
      CLKSTATUS defined in the Ssmc.h set the required  MemClkRatio and
      SMClockEn field bits.
  */
  SSMCCRDATA = CLKRATIO | CLKSTATUS;
  ConfigureCLKRatio(SSMCCRDATA);

  /*
      Programming the SSMCTrBurstWT register to turn the mask ON/OFF and to
      set the BeatNo and BurstWT counts. The constants BWtMask_ON/OFF,
      Beat0 to 15 and SSMCTrBurstWT0 to 15 are defined in Ssmc.h.
  */
  SSMCTrBurstWTData = BWtMask_ON | Beat15 | SSMCTrBurstWT15;
  ConfigureBurstWT(SSMCTrBurstWTData);

  /*
      Programming the SSMCTrWTCNCL register. The constant SMWTCNCLDI/EN
      disables or Enables the SMCANCELWait signal. The constant SMWAITIGNORE_0/1
      enables or disables the SMWAITIGNORE respectively and the constants
      WTCNCL0 to 63 are used to load the CANCEL WAIT count.
  */
  WTCNCLData = SMWTCNCLDI | SMWAITIGNORE_1 | WTCNCL10 ;
  HSA(SSMCTrWTCNCL, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,WTCNCLData);

  /** Configuring the system to LITTLE endian mode  by setting ENDIANNESS = 0 **/
  ENDIANNESS = 0;
  HSA(SSMCTrEndian, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,ENDIANNESS);
  HSEN(LITTLE);

  /*
      Programming the SSMCTrExtMuxWT register.The constant ExtMuxDI/EN disables
      or enables the  External Mux. The constants ExtMuxAss0 to 15 and
      ExtMuxDAss0 to 15 define the Assertion and Deassertion counts.
  */
  ExtMuxData = ExtMuxAss5 | ExtMuxDAss5 | ExtMuxDI;
  HSA(SSMCTrExtMux, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,ExtMuxData);

  /** Programming the SSMCTrSMBLSPOL register **/
  SMBLSPOLData = SMBLSPOL_0;
  HSA(SSMCTrSMBLSPOL, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,SMBLSPOLData);

  /** Set Bank 3 Memory Type as SRAM (32 bits width) **/
  SSMCTrMEMBData[3] = 0x00000000;

  SMBCRData[3] = CRADDRVALIDWR_DI | CRADDRVALIDRD_DI |
                 CRSYNCENWR_ASY   | CRSYNCENRD_ASY   |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        |
                 CRWAITEN_EN      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
                 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[3] = TRWAITEN_EN | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK3, WSTIDCY1, WSTRD2, WSTWR3, WSTOEN1, WSTWEN1, SMBCRData[3],
               SSMCTrCS2WTRData[3], WSTBRD2);

  ConfigureMemory(BANK3, SSMCTrMEMBData[3]);


  /** Initialise the Memory Bank 3 **/
  TestData = 0x55555555;
  AHBWriteMem(3, 0, 8, TestData);

  C("INSERTS BUSY IN BETWEEN READS");
  MemAddr = MemAddr = SSMCMEM_3 + (SSMCTrMEMBData[3] << 11);
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,BusAccessTests_1);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,BusAccessTests_2);

  HSA(MemAddr+=4, BUSY, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++ & MaskAll, , NoMask, ,BusAccessTests_3);

  HSA(MemAddr, BUSY, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData & MaskAll, , NoMask, ,BusAccessTests_4);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,BusAccessTests_5);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,BusAccessTests_6);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,BusAccessTests_7);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData, , NoMask, ,BusAccessTests_8);

  C("INSERTS BUSY IN BETWEEN WRITES");
  TestData = 0xAAAAAAAA;
  MemAddr = MemAddr = SSMCMEM_3 + (SSMCTrMEMBData[3] << 11);
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);

  HSA(MemAddr+=4, BUSY, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);

  HSA(MemAddr, BUSY, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData);

  /** Verify that the BUSY transfer did not modify the Memory data **/
  TestData = 0x55555555 + 2;
  MemAddr = MemAddr = SSMCMEM_3 + (SSMCTrMEMBData[3] << 11) + 8;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData, , NoMask, ,BusAccessTests_9);

  C("INSERTS IDLE IN BETWEEN READS");
  TestData = 0xAAAAAAAA;
  MemAddr = MemAddr = SSMCMEM_3 + (SSMCTrMEMBData[3] << 11);
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,BusAccessTests_10);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,BusAccessTests_11);

  HSA(MemAddr+=4, IDLE, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++ & MaskAll, , NoMask, ,BusAccessTests_12);

  HSA(MemAddr+=4, IDLE, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++ & MaskAll, , NoMask, ,BusAccessTests_13);

  TestData++;
  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,BusAccessTests_14);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,BusAccessTests_15);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,BusAccessTests_16);

  C("INSERTS IDLE IN BETWEEN WRITES");
  TestData = 0xBBBBBBBB;
  MemAddr = MemAddr = SSMCMEM_3 + (SSMCTrMEMBData[3] << 11);
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);

  HSA(MemAddr+=4, IDLE, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);

  HSA(MemAddr+=4, IDLE, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData);

  /** Verify that the IDLE transfer did not modify the Memory data **/
  MemAddr = MemAddr = SSMCMEM_3 + (SSMCTrMEMBData[3] << 11) + 8;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x55555557, , NoMask, ,BusAccessTests_17);
  HSR( , 0xAAAAAAAE, , NoMask, ,BusAccessTests_18);

  C("INSERTS BUSY IN BETWEEN BURST READS");
  MemAddr = MemAddr = SSMCMEM_3 + (SSMCTrMEMBData[3] << 11);
  TestData = 0xBBBBBBBB;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,BusAccessTests_19);
  HSR( , TestData++, , NoMask, ,BusAccessTests_20);

  HSA(MemAddr+=8, BUSY, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData & MaskAll, , NoMask, ,BusAccessTests_21);

  HSA(MemAddr, BUSY, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData & MaskAll, , NoMask, ,BusAccessTests_22);

  HSA(MemAddr, SEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x55555557, , NoMask, ,BusAccessTests_23);
  HSR( , 0xAAAAAAAE, , NoMask, ,BusAccessTests_24);
  TestData+=2;
  HSR( , TestData++, , NoMask, ,BusAccessTests_25);
  HSR( , TestData++, , NoMask, ,BusAccessTests_26);
  HSR( , TestData++, , NoMask, ,BusAccessTests_27);
  HSR( , TestData++, , NoMask, ,BusAccessTests_28);

  C("INSERTS BUSY IN BETWEEN BURST WRITES");
  TestData = 0xCCCCCCCC;
  MemAddr = MemAddr = SSMCMEM_3 + (SSMCTrMEMBData[3] << 11);
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);
  HSW( ,TestData++);

  HSA(MemAddr+=8, BUSY, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);

  HSA(MemAddr, BUSY, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);

  /** Verify that the BUSY transfer did not modify the Memory data **/
  MemAddr = MemAddr = SSMCMEM_3 + (SSMCTrMEMBData[3] << 11) + 8;
  TestData = 0x55555555 + 2;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData, , NoMask, ,BusAccessTests_29);

  C("INSERTS IDLE IN BETWEEN BURST READS");
  TestData = 0xCCCCCCCC;
  MemAddr = MemAddr = SSMCMEM_3 + (SSMCTrMEMBData[3] << 11);
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,BusAccessTests_30);
  HSR( , TestData++, , NoMask, ,BusAccessTests_31);

  HSA(MemAddr+=8, IDLE, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++ & MaskAll, , NoMask, ,BusAccessTests_32);

  HSA(MemAddr+=4, IDLE, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++ & MaskAll, , NoMask, ,BusAccessTests_33);

  TestData = 0xBBBBBBBF;
  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , TestData++, , NoMask, ,BusAccessTests_34);
  HSR( , TestData++, , NoMask, ,BusAccessTests_35);
  HSR( , TestData++, , NoMask, ,BusAccessTests_36);
  HSR( , TestData, , NoMask, ,BusAccessTests_37);

  C("INSERTS IDLE IN BETWEEN BURST WRITES");
  TestData = 0xDDDDDDDD;
  MemAddr = MemAddr = SSMCMEM_3 + (SSMCTrMEMBData[3] << 11);
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);
  HSW( ,TestData++);

  HSA(MemAddr+=8, IDLE, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);

  HSA(MemAddr+=4, IDLE, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);

  HSA(MemAddr+=4, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( ,TestData++);
  HSW( ,TestData++);
  HSW( ,TestData++);
  HSW( ,TestData);

  /** Verify that the IDLE transfer did not modify the Memory data **/
  TestData = 0x55555555 + 2;
  MemAddr = MemAddr = SSMCMEM_3 + (SSMCTrMEMBData[3] << 11) + 8;
  HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSR( , 0x55555557, , NoMask, ,BusAccessTests_38);
  HSR( , 0xAAAAAAAE, , NoMask, ,BusAccessTests_39);
}

/************************************ End *************************************/
