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
--  File Name              : RegisterTests.c.rca
--  File Revision          : 1.9
--
--  Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--  
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform Register Tests on the SSMC.
--
-- --=========================================================================*/

/******************************************************************************/
/************************* List of Functions Called ***************************/
/******************************************************************************/
/*** Function name                                      Located in          ***/
/*** ---------------------------------------------------------------------- ***/
/*** WriteReadTests()                                   SsmcCommon.c        ***/
/******************************************************************************/

/******************************************************************************/
/******************************* RegisterTests ********************************/
/******************************************************************************/

void RegisterTests()
{
  /*
     Summary: Register Tests
     =======================
     This function performs the following:

     o  Write-Read tests are done on the registers of the SSMC.
  */

  int32 TestData, WTCNCLData, ExtMuxData, SMBLSPOLData;
  char Message[100];


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
  HSW( , WTCNCLData);

  /** Configuring the system to LITTLE endian mode: Set ENDIANNESS = 0 **/
  ENDIANNESS = 0;
  HSA(SSMCTrEndian, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , ENDIANNESS);
  HSEN(LITTLE);

  /*
     Programming the SSMCTrExtMuxWT register.The constant ExtMuxDI/EN disables
     or enables the  External Mux. The constants ExtMuxAss0 to 15 and
     ExtMuxDAss0 to 15 define the Assertion and Deassertion counts.
  */
  ExtMuxData = ExtMuxAss5 | ExtMuxDAss5 | ExtMuxDI;
  HSA(SSMCTrExtMux, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , ExtMuxData);

  /** Programming the SSMCTrSMBLSPOL register **/
  SMBLSPOLData = SMBLSPOL_0;
  HSA(SSMCTrSMBLSPOL, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SMBLSPOLData);

  TestData = Data5;
  C("PATTERN WRITE-READ TESTS -> 0x55555555");
  WriteReadTests(TestData);

  TestData = Data0;
  C("PATTERN WRITE-READ TESTS -> 0x00000000");
  WriteReadTests(TestData);

  TestData = DataF;
  C("PATTERN WRITE-READ TESTS -> 0xFFFFFFFF");
  WriteReadTests(TestData);

  TestData = DataA;
  C("PATTERN WRITE-READ TESTS -> 0xAAAAAAAA");
  WriteReadTests(TestData);

}

/************************************ End *************************************/
