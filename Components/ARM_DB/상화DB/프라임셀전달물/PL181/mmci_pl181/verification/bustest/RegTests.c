/* --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : RegTests.c.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Tests to verify MMCI register accesses
--
-- --=========================================================================*/

/******************************************************************************/
/****************************** RegisterTests *********************************/
/******************************************************************************/
void RegTests()

{

  /*
   Summary: Register Test
   ======================
   This test checks the following functionalities :

   o  All MMCI registers are read immediately after reset to verify
      that they initialise to values mentioned in the specification.
      Initially PRESETn is asserted for a few PCLKs. Then all PCLK
      domain registers are read back to verify reset values.
      Then MCLKRST is asserted for a few MCLKs. Then, all registers
      are read back to verify reset values.

   o  The Read/Writeable registers are written with patterns of 0x55,
      0xAA, 0xFF and 0x00. Data is read back and compared with the
      expected pattern.

   o  The following registers have hardware protection against writes
      during the synchronisation period:
       o MMCIPower
       o MMCIClock
       o MMCICommand
       o MMCIDataCtrl
      This function also contains tests to verify this hardware
      protection.
   */

  /* Default  Value Test */

  C( "MMCI REGISTER RESET VALUE TESTS" );
  /* Read PCLK-domain registers after PRESETn and before the assertion
     of nMCLKRST */
  PSR(DATA_0s, MASK_MMCIPower, MMCIPower);
  PSR(DATA_0s, MASK_MMCIClock, MMCIClock);
  PSR(DATA_0s, MASK_MMCIArgument, MMCIArgument);
  PSR(DATA_0s, MASK_MMCICommand, MMCICommand)
  PSR(DATA_0s, MASK_MMCIDataLength, MMCIDataLength);
  PSR(DATA_0s, MASK_MMCIDataCtrl, MMCIDataCtrl);
  PSR(DATA_0s, MASK_MMCIDataTimer, MMCIDataTimer);
  PSR(DATA_0s, MASK_MMCIMask0, MMCIMask0);
  PSR(DATA_0s, MASK_MMCIMask1, MMCIMask1);
  PSR(DATA_0s, MASK_MMCISelect, MMCISelect);
  PSR(DATA_0s, MASK_MMCIFifoCnt, MMCIFifoCnt);

  /* Clock generation */
  PSW(MCLK_PERIOD , MMCITBMCLKPeriod);

  /* Assert nMCLKRST */
  PSW(MCLKRESETASSERT, MMCITBCLKRSTCntl);

  /* Wait for 2 MCLK periods */
  PI(DELAY * 0x2);

  /* De-assert nMCLKRST */
  PSW(0x00000000, MMCITBCLKRSTCntl);
  Idle(0xA * DELAY);

  if(PCLK_PERIOD == MCLK_PERIOD )
    {
     /**** Route PCLK line onto MMCICLK ****/
     PCLKOn();
    }
  else
    {
     /**** Route MClk line onto MMCICLK ****/
     MCLKOn();
    }
    Idle(0xA * DELAY);

  /* Temporarily disable Protocol checkers in the Trickbox during
     Register tests to prevent spurious error messages */
  PSW(0x0001FFFF,MMCITBPCDisable);

  /* Read all registers after both PRESETn and nMCLKRST are asserted and
     negated */

  PSR(DATA_0s, MASK_MMCIRespCmd,  MMCIRespCmd);
  PSR(DATA_0s, MASK_MMCIResponse0, MMCIResponse0);
  PSR(DATA_0s, MASK_MMCIResponse1, MMCIResponse1);
  PSR(DATA_0s, MASK_MMCIResponse2, MMCIResponse2);
  PSR(DATA_0s, MASK_MMCIResponse3, MMCIResponse3);

  PSR(DATA_0s, MASK_MMCIPower,  MMCIPower);
  PSR(DATA_0s, MASK_MMCIArgument, MMCIArgument);
  PSR(DATA_0s, MASK_MMCICommand, MMCICommand)
  PSR(DATA_0s, MASK_MMCIDataLength, MMCIDataLength,);
  PSR(DATA_0s, MASK_MMCIDataCtrl,  MMCIDataCtrl,);
  PSR(DATA_0s, MASK_MMCIDataTimer, MMCIDataTimer);
  PSR(DATA_0s, MASK_MMCIDataCnt, MMCIDataCnt);
  PSR(DATA_0s, MASK_STATUS, MMCIStatus);
  PSR(DATA_0s, MASK_MMCIMask0, MMCIMask0);
  PSR(DATA_0s, MASK_MMCIMask1, MMCIMask1);
  PSR(DATA_0s, MASK_MMCISelect,  MMCISelect);
  PSR(DATA_0s, MASK_MMCIFifoCnt, MMCIFifoCnt);

  PSR(DATA_0s, MASK_TCR,  MMCITCR,mmcitcrread);
  PSR(0x00000022, MASK_ITIP,  MMCIITIP,mmciitipread);
  PSR(DATA_0s, MASK_ITOP, MMCIITOP,mmciitopread);

  PSR(0x81, MASK_PERIPHPCELL, MMCIPeriphID0);
  PSR(0x11, MASK_PERIPHPCELL, MMCIPeriphID1);
  PSR(0x04, MASK_PERIPHPCELL, MMCIPeriphID2);
  PSR(0x00, MASK_PERIPHPCELL, MMCIPeriphID3);
  PSR(0x0D, MASK_PERIPHPCELL, MMCIPCellID0);
  PSR(0xF0, MASK_PERIPHPCELL, MMCIPCellID1);
  PSR(0x05, MASK_PERIPHPCELL, MMCIPCellID2);
  PSR(0xB1, MASK_PERIPHPCELL, MMCIPCellID3);

  C("MMCI REGSTER READ-ONLY TEST");

  PSW(DATA_0s, MMCIFifoCnt);
  PSR(DATA_0s, MASK_MMCIFifoCnt, MMCIFifoCnt);
  PSW(DATA_Fs, MMCIFifoCnt);
  PSR(DATA_0s, MASK_MMCIFifoCnt, MMCIFifoCnt);
  PSW(DATA_5s, MMCIFifoCnt);
  PSR(DATA_0s, MASK_MMCIFifoCnt, MMCIFifoCnt);
  PSW(DATA_As, MMCIFifoCnt);
  PSR(DATA_0s, MASK_MMCIFifoCnt, MMCIFifoCnt);
  PSW(DATA_0s, MMCIRespCmd);
  PSR(DATA_0s, MASK_MMCIRespCmd, MMCIRespCmd);
  PSW(DATA_Fs, MMCIRespCmd);
  PSR(DATA_0s, MASK_MMCIRespCmd, MMCIRespCmd);
  PSW(DATA_5s, MMCIRespCmd);
  PSR(DATA_0s, MASK_MMCIRespCmd, MMCIRespCmd);
  PSW(DATA_As, MMCIRespCmd);
  PSR(DATA_0s, MASK_MMCIRespCmd, MMCIRespCmd);

  PSW(DATA_0s, MMCIResponse0);
  PSR(DATA_0s, MASK_MMCIResponse0, MMCIResponse0);
  PSW(DATA_Fs, MMCIResponse0);
  PSR(DATA_0s, MASK_MMCIResponse0, MMCIResponse0);
  PSW(DATA_5s, MMCIResponse0);
  PSR(DATA_0s, MASK_MMCIResponse0, MMCIResponse0);
  PSW(DATA_As, MMCIResponse0);
  PSR(DATA_0s, MASK_MMCIResponse0, MMCIResponse0);

  PSW(DATA_0s, MMCIResponse1);
  PSR(DATA_0s, MASK_MMCIResponse1, MMCIResponse1);
  PSW(DATA_Fs, MMCIResponse1);
  PSR(DATA_0s, MASK_MMCIResponse1, MMCIResponse1);
  PSW(DATA_5s, MMCIResponse1);
  PSR(DATA_0s, MASK_MMCIResponse1, MMCIResponse1);
  PSW(DATA_As, MMCIResponse1);
  PSR(DATA_0s, MASK_MMCIResponse1, MMCIResponse1);

  PSW(DATA_0s, MMCIResponse2);
  PSR(DATA_0s, MASK_MMCIResponse2, MMCIResponse2);
  PSW(DATA_Fs, MMCIResponse2);
  PSR(DATA_0s, MASK_MMCIResponse2, MMCIResponse2);
  PSW(DATA_5s, MMCIResponse2);
  PSR(DATA_0s, MASK_MMCIResponse2, MMCIResponse2);
  PSW(DATA_As, MMCIResponse2);
  PSR(DATA_0s, MASK_MMCIResponse2, MMCIResponse2);

  PSW(DATA_0s, MMCIResponse3);
  PSR(DATA_0s, MASK_MMCIResponse3, MMCIResponse3);
  PSW(DATA_Fs, MMCIResponse3);
  PSR(DATA_0s, MASK_MMCIResponse3, MMCIResponse3);
  PSW(DATA_5s, MMCIResponse3);
  PSR(DATA_0s, MASK_MMCIResponse3, MMCIResponse3);
  PSW(DATA_As, MMCIResponse3);
  PSR(DATA_0s, MASK_MMCIResponse3, MMCIResponse3);

  PSW(DATA_0s, MMCIDataCnt);
  PSR(DATA_0s, MASK_MMCIDataCnt, MMCIDataCnt);
  PSW(DATA_Fs, MMCIDataCnt);
  PSR(DATA_0s, MASK_MMCIDataCnt, MMCIDataCnt);
  PSW(DATA_5s, MMCIDataCnt);
  PSR(DATA_0s, MASK_MMCIDataCnt, MMCIDataCnt);
  PSW(DATA_As, MMCIDataCnt);
  PSR(DATA_0s, MASK_MMCIDataCnt, MMCIDataCnt);

  PSW(DATA_0s, MMCIStatus);
  PSR(DATA_0s, MASK_STATUS, MMCIStatus);
  PSW(DATA_Fs, MMCIStatus);
  PSR(DATA_0s, MASK_STATUS, MMCIStatus);
  PSW(DATA_5s, MMCIStatus);
  PSR(DATA_0s, MASK_STATUS, MMCIStatus);
  PSW(DATA_As, MMCIStatus);
  PSR(DATA_0s, MASK_STATUS, MMCIStatus);

  PSW(DATA_0s, MMCIPeriphID0);
  PSR(0x81, MASK_PERIPHPCELL, MMCIPeriphID0);
  PSW(DATA_Fs, MMCIPeriphID0);
  PSR(0x81, MASK_PERIPHPCELL, MMCIPeriphID0);
  PSW(DATA_5s, MMCIPeriphID0);
  PSR(0x81, MASK_PERIPHPCELL, MMCIPeriphID0);
  PSW(DATA_As, MMCIPeriphID0);
  PSR(0x81, MASK_PERIPHPCELL, MMCIPeriphID0);

  PSW(DATA_0s, MMCIPeriphID1);
  PSR(0x11, MASK_PERIPHPCELL, MMCIPeriphID1);
  PSW(DATA_Fs, MMCIPeriphID1);
  PSR(0x11, MASK_PERIPHPCELL, MMCIPeriphID1);
  PSW(DATA_5s, MMCIPeriphID1);
  PSR(0x11, MASK_PERIPHPCELL, MMCIPeriphID1);
  PSW(DATA_As, MMCIPeriphID1);
  PSR(0x11, MASK_PERIPHPCELL, MMCIPeriphID1);

  PSW(DATA_0s, MMCIPeriphID2);
  PSR(0x04, MASK_PERIPHPCELL, MMCIPeriphID2);
  PSW(DATA_Fs, MMCIPeriphID2);
  PSR(0x04, MASK_PERIPHPCELL, MMCIPeriphID2);
  PSW(DATA_5s, MMCIPeriphID2);
  PSR(0x04, MASK_PERIPHPCELL, MMCIPeriphID2);
  PSW(DATA_As, MMCIPeriphID2);
  PSR(0x04, MASK_PERIPHPCELL, MMCIPeriphID2);

  PSW(DATA_0s, MMCIPeriphID3);
  PSR(0x00, MASK_PERIPHPCELL, MMCIPeriphID3);
  PSW(DATA_Fs, MMCIPeriphID3);
  PSR(0x00, MASK_PERIPHPCELL, MMCIPeriphID3);
  PSW(DATA_5s, MMCIPeriphID3);
  PSR(0x00, MASK_PERIPHPCELL, MMCIPeriphID3);
  PSW(DATA_As, MMCIPeriphID3);
  PSR(0x00, MASK_PERIPHPCELL, MMCIPeriphID3);

  PSW(DATA_0s, MMCIPCellID0);
  PSR(0x0D, MASK_PERIPHPCELL, MMCIPCellID0);
  PSW(DATA_Fs, MMCIPCellID0);
  PSR(0x0D, MASK_PERIPHPCELL, MMCIPCellID0);
  PSW(DATA_5s, MMCIPCellID0);
  PSR(0x0D, MASK_PERIPHPCELL, MMCIPCellID0);
  PSW(DATA_As, MMCIPCellID0);
  PSR(0x0D, MASK_PERIPHPCELL, MMCIPCellID0);

  PSW(DATA_0s, MMCIPCellID1);
  PSR(0xF0, MASK_PERIPHPCELL, MMCIPCellID1);
  PSW(DATA_Fs, MMCIPCellID1);
  PSR(0xF0, MASK_PERIPHPCELL, MMCIPCellID1);
  PSW(DATA_5s, MMCIPCellID1);
  PSR(0xF0, MASK_PERIPHPCELL, MMCIPCellID1);
  PSW(DATA_As, MMCIPCellID1);
  PSR(0xF0, MASK_PERIPHPCELL, MMCIPCellID1);

  PSW(DATA_0s, MMCIPCellID2);
  PSR(0x05, MASK_PERIPHPCELL, MMCIPCellID2);
  PSW(DATA_Fs, MMCIPCellID2);
  PSR(0x05, MASK_PERIPHPCELL, MMCIPCellID2);
  PSW(DATA_5s, MMCIPCellID2);
  PSR(0x05, MASK_PERIPHPCELL, MMCIPCellID2);
  PSW(DATA_As, MMCIPCellID2);
  PSR(0x05, MASK_PERIPHPCELL, MMCIPCellID2);

  PSW(DATA_0s, MMCIPCellID3);
  PSR(0xB1, MASK_PERIPHPCELL, MMCIPCellID3);
  PSW(DATA_Fs, MMCIPCellID3);
  PSR(0xB1, MASK_PERIPHPCELL, MMCIPCellID3);
  PSW(DATA_5s, MMCIPCellID3);
  PSR(0xB1, MASK_PERIPHPCELL, MMCIPCellID3);
  PSW(DATA_As, MMCIPCellID3);
  PSR(0xB1, MASK_PERIPHPCELL, MMCIPCellID3);

  PSW(DATA_0s, MMCIITIP);
  PSR(0x22, MASK_ITIP,  MMCIITIP);
  PSW(DATA_Fs, MMCIITIP);
  PSR(0x22, MASK_ITIP,  MMCIITIP);
  PSW(DATA_5s, MMCIITIP);
  PSR(0x22, MASK_ITIP,  MMCIITIP);
  PSW(DATA_As, MMCIITIP);
  PSR(0x22, MASK_ITIP,  MMCIITIP);

  /* Register Read/Write Tests */

  C( "MMCI REGSTER R/W TEST" );

  PSW(0x00000001, MMCITCR);
  PSR(0x00000001, MASK_TCR , MMCITCR);
  PSW(DATA_Fs, MMCITCR);
  PSR(0x0000000F, MASK_TCR, MMCITCR);
  PSW(DATA_5s, MMCITCR);
  PSR(0x00000005, MASK_TCR, MMCITCR);
  PSW(0x0000000B, MMCITCR);
  PSR(0x0000000B, MASK_TCR, MMCITCR);


  PSW(DATA_0s, MMCIITIP);
  PSR(0x00000000, MASK_ITIPWRITEBIT, MMCIITIP);
  PSW(DATA_Fs, MMCIITIP);
  PSR(0x00000001, MASK_ITIPWRITEBIT, MMCIITIP);
  PSW(DATA_5s, MMCIITIP);
  PSR(0x00000001, MASK_ITIPWRITEBIT, MMCIITIP);
  PSW(DATA_As, MMCIITIP);
  PSR(0x00000000, MASK_ITIPWRITEBIT, MMCIITIP);

  PSW(DATA_0s, MMCIITOP);
  PSR(DATA_0s, MASK_ITOP, MMCIITOP);
  PSW(DATA_Fs, MMCIITOP);
  PSR(0x00000C7F, MASK_ITOP, MMCIITOP);
  PSW(DATA_5s, MMCIITOP);
  PSR(0x00000455, MASK_ITOP, MMCIITOP);
  PSW(DATA_As, MMCIITOP);
  PSR(0x0000082A, MASK_ITOP, MMCIITOP);

  /* Write benign values into test registers */
  PSW(0x00000008, MMCITCR);
  PSW(DATA_0s, MMCIITIP);
  PSW(DATA_0s, MMCIITOP);

  PSW(DATA_0s, MMCIPower);
  PSR(DATA_0s, MASK_MMCIPower, MMCIPower);
  PSW(DATA_Fs, MMCIPower);
  PSR(0x000000FF, MASK_MMCIPower, MMCIPower);
  PSW(DATA_5s, MMCIPower);
  PSR(0x00000055, MASK_MMCIPower, MMCIPower);
  PSW(DATA_As, MMCIPower);
  PSR(0x000000AA, MASK_MMCIPower, MMCIPower);

  /* Clock Register read and write tests */
  PSW(0xFFFFFEFF, MMCIClock);
  PSR(0x000006FF, MASK_MMCIClock, MMCIClock);
  PSW(0x55555E55, MMCIClock);
  PSR(0x00000655, MASK_MMCIClock, MMCIClock);
  PSW(0xAAAAAEAA, MMCIClock);
  PSR(0x000006AA, MASK_MMCIClock, MMCIClock);

  PSW(DATA_0s, MMCIArgument);
  PSR(DATA_0s, MASK_MMCIArgument, MMCIArgument);
  PSW(DATA_Fs, MMCIArgument);
  PSR(DATA_Fs, MASK_MMCIArgument, MMCIArgument);
  PSW(DATA_5s, MMCIArgument);
  PSR(DATA_5s, MASK_MMCIArgument, MMCIArgument);
  PSW(DATA_As, MMCIArgument);
  PSR(DATA_As, MASK_MMCIArgument, MMCIArgument);

  PSW(DATA_0s, MMCICommand);
  PSR(DATA_0s, MASK_MMCICommand, MMCICommand);
  PSW(0xFFFFF0FF, MMCICommand);
  PSR(0x000000FF, MASK_MMCICommand, MMCICommand);
  PSW(0x55555055, MMCICommand);
  PSR(0x00000055, MASK_MMCICommand, MMCICommand);
  PSW(DATA_As, MMCICommand);
  PSR(0x000002AA, MASK_MMCICommand, MMCICommand);

  PSW(DATA_0s, MMCIDataLength);
  PSR(DATA_0s, MASK_MMCIDataLength, MMCIDataLength);
  PSW(DATA_Fs, MMCIDataLength);
  PSR(0x0000FFFF, MASK_MMCIDataLength, MMCIDataLength);
  PSW(DATA_5s, MMCIDataLength);
  PSR(0x00005555, MASK_MMCIDataLength, MMCIDataLength);
  PSW(DATA_As, MMCIDataLength);
  PSR(0x0000AAAA, MASK_MMCIDataLength, MMCIDataLength);

  PSW(DATA_0s, MMCIDataCtrl);
  PSR(DATA_0s, MASK_MMCIDataCtrl, MMCIDataCtrl);
  PSW(DATA_Fs, MMCIDataCtrl);
  PSR(0x000000FF, MASK_MMCIDataCtrl, MMCIDataCtrl);
  PSW(DATA_5s, MMCIDataCtrl);
  PSR(0x00000055, MASK_MMCIDataCtrl, MMCIDataCtrl);
  PSW(DATA_As, MMCIDataCtrl);
  PSR(0x000000AA, MASK_MMCIDataCtrl, MMCIDataCtrl);

  PSW(DATA_0s, MMCISelect);
  PSW(DATA_0s, MMCIDataTimer);
  PSW(DATA_0s, MMCIMask0);
  PSW(DATA_0s, MMCIMask1);
  PSR(DATA_0s, MASK_MMCISelect , MMCISelect);
  PSR(DATA_0s, MASK_MMCIDataTimer, MMCIDataTimer);
  PSR(DATA_0s, MASK_MMCIMask0, MMCIMask0);
  PSR(DATA_0s, MASK_MMCIMask1, MMCIMask1);
  PSW(DATA_Fs, MMCISelect);
  PSW(DATA_Fs, MMCIDataTimer);
  PSW(DATA_Fs, MMCIMask0);
  PSW(DATA_Fs, MMCIMask1);
  PSR(0x00000000, MASK_MMCISelect, MMCISelect);
  PSR(DATA_Fs, MASK_MMCIDataTimer, MMCIDataTimer);
  PSR(0x003FFDFF, MASK_MMCIMask0, MMCIMask0);
  PSR(0x003FFDFF, MASK_MMCIMask1, MMCIMask1);
  PSW(DATA_5s, MMCISelect);
  PSW(DATA_5s, MMCIDataTimer);
  PSW(DATA_5s, MMCIMask0);
  PSW(DATA_5s, MMCIMask1);
  PSR(0x00000000, MASK_MMCISelect, MMCISelect);
  PSR(DATA_5s, MASK_MMCIDataTimer, MMCIDataTimer);
  PSR(0x00155555, MASK_MMCIMask0, MMCIMask0);
  PSR(0x00155555, MASK_MMCIMask1, MMCIMask1);
  PSW(DATA_As, MMCISelect);
  PSW(DATA_As, MMCIDataTimer);
  PSW(DATA_As, MMCIMask0);
  PSW(DATA_As, MMCIMask1);
  PSR(0x00000000, MASK_MMCISelect, MMCISelect);
  PSR(DATA_As, MASK_MMCIDataTimer, MMCIDataTimer);
  PSR(0x002AA8AA, MASK_MMCIMask0, MMCIMask0);
  PSR(0x002AA8AA, MASK_MMCIMask1, MMCIMask1);


  C("TESTING HARDWARE PROTECTION OF REGISTERS");
  PSW(0x00000000, MMCITCR);

  PSW(0x55555554, MMCIPower);
  PSW(DATA_As, MMCIPower);
  PSR(0x00000054, MASK_MMCIPower , MMCIPower);

  PSW(CMDINDEXFF, MMCICommand);
  PSW(DATA_As, MMCICommand);
  PSR(0x0000003F, MASK_MMCICommand , MMCICommand);

  PSW(DATA_5s, MMCIDataCtrl);
  PSW(DATA_As, MMCIDataCtrl);
  PSR(0x00000055, MASK_MMCIDataCtrl , MMCIDataCtrl);

  PSW(0x0000000F, MMCIClock);
  PSW(DATA_As, MMCIClock);
  PSR(0x0000000F, MASK_MMCIClock , MMCIClock);

  PSW(0x00000000, MMCITCR);
  PSW(0x00000000, MMCIDataCtrl);
  PSW(0x00000000, MMCICommand);
  PSW(0x00000000, MMCIClock);
  PSW(0x00000000, MMCIPower);
  PSW(0x00000000, MMCIMask0);
  PSW(0x00000000, MMCIMask1);
  PSW(0x00000000, MMCIDataTimer);
  PSW(0x00000000, MMCISelect);
  PSW(0x00000000, MMCIDataLength);
  PSW(0x00000000, MMCIArgument);
  PSW(0x00000000, MMCIITIP);
  PSW(0x00000000, MMCIITOP);
  PSW(0x00000000,MMCITBPCDisable);
  C( "END OF REG TEST" );

  /* Dummy cycles to allow spurious transfers initiated during
     register tests, to complete
  */
  Idle(DELAY * 0xA0);

}

/*******************************  End  ****************************************/
