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
-- File Name              : PendingModeTest.c.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Tests to verify MMCI operation when programmed in
--           Pend mode
--
-- --=========================================================================*/

/******************************************************************************/
/****************************  PENDINGMODE  Test ******************************/
/******************************************************************************/

void PendingModeTest ()
{
  /*
     Summary : Pending Mode Test
     ===========================

     In this test the pending bit in the Command register is set, the
     Data Control register is set for stream mode and the DataLength
     register is loaded with a count of 5. The MMCI is
     configured for transmitting data. The trickbox checks the protocol
     for pending mode.
     This test is repeated for DataLength values of 6 and 7.
     If the DataLength is set to 5 then command transmission is
     expected to end more than one MMCICLKOUT after the end of data
     transmission. If DataLength is equal to or greater
     than 6 then the command is expected to end exactly 1 MMCICLKOUT
     after data ends i.e. the end bits of the Command and data streams
     are expected to be aligned.
  */
  int32 i;

  PSW(POWERON | VOLTAGE15, MMCIPower);
  PSW(0x0000001F, MMCIDataTimer);
  PSW(0x0000001F, MMCITBDataTimer);

  if (PCLK_PERIOD == 100)
    PSW(CLKDIV2 | CLKENB, MMCIClock);
  else
    PSW(CLKDIV1 | CLKENB, MMCIClock);

  CLKDIV = CLKDIV2;

  PSW(CLEARALL, MMCIClear);

  C("PENDING MODE TESTS WITH MMCI IN TRANSMIT MODE");
  PSW(DATA_As, MMCIArgument);
  PO(0x00000000, CMDACTIVE, MMCIStatus,0x0000FFFF);
  local = CMDINDEXFF | NORESP_LONGRSP_SET | COMMANDENB | PENDINGMODE;
  PSW(local, MMCICommand);
  PSR(0x00000800, CMDACTIVE, MMCIStatus);

  PSW(0x00000005, MMCIDataLength);
  Idle((DELAY) * (2*(CLKDIV + 1)) * 2);
  PSW(DATATXRENB | STREAMMODE, MMCIDataCtrl);
  PO(0x00041000, TXFIFOEMPTY | TXACTIVE, MMCIStatus,0x0000FFFF);
  PSW(DATA_As, MMCIFIFO);
  PSW(DATA_As, MMCIFIFO);
  PO(0x00000100, DATAEND, MMCIStatus,0x0000FFFF);
  PSR(0xAAAAAAAA, MASK_TBMMCIFIFO, MMCITBFIFOReg);
  PSR(0x000000AA, 0x000000FF, MMCITBFIFOReg);
  PSW(0x00000100, MMCIClear);

  PO(0x00000000, CMDACTIVE, MMCIStatus,0x0000FFFF);
  Idle((DELAY) * (2*(CLKDIV + 1)) * 0x2);
  PSR(DATA_As, MASK_TBRECDCMDARG, MMCITBRecdCmdArg);
  PSR(0x0000003F, MASK_TBRECDCMDIND, MMCITBRecdCmdInd);

  if (MCLK_PERIOD == PCLK_PERIOD)
  {
  PSW(0x00000100, MMCITBPCDisable);
  PSW(CLEARALL, MMCIClear);
  PSW(DATA_Fs, MMCIArgument);
  PO(0x00000000, CMDACTIVE, MMCIStatus,0x0000FFFF);
  local = CMDINDEXFF | NORESP_LONGRSP_SET | COMMANDENB | PENDINGMODE;
  PSW(local, MMCICommand);
  PSR(0x00000800, CMDACTIVE, MMCIStatus);

  PSW(0x00000006, MMCIDataLength);
  Idle((DELAY) * (2*(CLKDIV + 1)) * 0x2);
  PSW(DATATXRENB | STREAMMODE, MMCIDataCtrl);
  PO(0x00041000, TXFIFOEMPTY | TXACTIVE, MMCIStatus,0x0000FFFF);
  PSW(DATA_Fs, MMCIFIFO);
  PSW(DATA_Fs, MMCIFIFO);
  PO(0x00000100, DATAEND, MMCIStatus,0x0000FFFF);

  C("PEND PULSE SYNCHRONISED WITH CPSM START PULSE");
  PSW(local, MMCICommand);
  PI(0x02);
  PSW(DATATXRENB | STREAMMODE, MMCIDataCtrl);

  PSW(DATAENDCLR, MMCIClear);

  PO(0x00041000, TXFIFOEMPTY | TXACTIVE, MMCIStatus,0x0000FFFF);
  PSW(DATA_Fs, MMCIFIFO);
  PSW(DATA_Fs, MMCIFIFO);
  PO(0x00000000, DATAEND, MMCIStatus,0x0000FFFF);
  PSR(DATA_Fs, MASK_TBMMCIFIFO, MMCITBFIFOReg);
  PSR(0x0000FFFF, 0x0000FFFF, MMCITBFIFOReg);
  PO(0x00000100, DATAEND, MMCIStatus,0x0000FFFF);
  PSR(DATA_Fs, MASK_TBMMCIFIFO, MMCITBFIFOReg);
  PSR(0x0000FFFF, 0x0000FFFF, MMCITBFIFOReg);
  PSW(DATABLOCKENDCLR, MMCIClear);
  Idle((DELAY) * (2*(CLKDIV + 1)) * 0x2);

  PO(0x00000000, CMDACTIVE, MMCIStatus,0x0000FFFF);
  Idle((DELAY) * (2*(CLKDIV + 1)) * 0x2);
  PSR(DATA_Fs, MASK_TBRECDCMDARG, MMCITBRecdCmdArg);
  PSR(0x0000003F, MASK_TBRECDCMDIND, MMCITBRecdCmdInd);
  PSW(0x00000000, MMCITBPCDisable);

  }
  C("PENDING MODE TESTS WITH MMCI IN RECEIVE MODE");
  PSW(CLEARALL, MMCIClear);
  PO(0x00000000, STATICFLAGS, MMCIStatus, 0x0000FFFF);

  PSW(DATA_Fs, MMCIArgument);
  PO(0x00000000, CMDACTIVE, MMCIStatus, 0x0000FFFF);
  local = CMDINDEXFF | NORESP_LONGRSP_SET | COMMANDENB | PENDINGMODE;
  PSW(local, MMCICommand);
  PSR(0x00000800, CMDACTIVE, MMCIStatus);

  PSW(0x00000006, MMCIDataLength);
  Idle((DELAY) * (2*(CLKDIV + 1)) * 0x2);
  PSW(DATATXRENB | DATARXDIR | STREAMMODE, MMCIDataCtrl);
  PO(0x00000001, TBTXFIFOEMPTY, MMCITBStatus, 0x0000FFFF);
  PSW(DATA_Fs, MMCITBFIFOReg);
  PSW(DATA_Fs, MMCITBFIFOReg);
  PO(0x00000100, DATAEND, MMCIStatus, 0x0000FFFF);
  PSR(DATA_Fs, MASK_TBMMCIFIFO, MMCIFIFO);
  PSR(0x0000FFFF, 0x0000FFFF, MMCIFIFO);
  PSW(DATABLOCKENDCLR, MMCIClear);
  PSW(CLEARALL, MMCIClear);
  PO(0x00000000, STATICFLAGS, MMCIStatus, 0x0000FFFF);

  PO(0x00000000, CMDACTIVE, MMCIStatus,0x0000FFFF);
  Idle((DELAY) * (2*(CLKDIV + 1)) * 0x2);
  PSR(DATA_Fs, MASK_TBRECDCMDARG, MMCITBRecdCmdArg);
  PSR(0x0000003F, MASK_TBRECDCMDIND, MMCITBRecdCmdInd);

  PSW(CLEARALL, MMCIClear);
  PSW(DATA_Fs, MMCIArgument);
  PO(0x00000000, CMDACTIVE, MMCIStatus, 0x0000FFFF);
  local = CMDINDEXFF | NORESP_LONGRSP_SET | COMMANDENB | PENDINGMODE;
  PSW(local, MMCICommand);
  PSR(0x00000800, CMDACTIVE, MMCIStatus);

  PSW(0x00000007, MMCIDataLength);
  Idle((DELAY) * (2*(CLKDIV + 1)) * 0x2);
  PSW(DATATXRENB | DATARXDIR | STREAMMODE, MMCIDataCtrl);
  PO(0x00000001, TBTXFIFOEMPTY, MMCITBStatus, 0x0000FFFF);
  PSW(DATA_Fs, MMCITBFIFOReg);
  PSW(DATA_Fs, MMCITBFIFOReg);
  PO(0x00000100, DATAEND, MMCIStatus, 0x0000FFFF);
  PSR(DATA_Fs, MASK_TBMMCIFIFO, MMCIFIFO);
  PSR(0x0000FFFF, 0x0000FFFF, MMCIFIFO);
  PSW(DATABLOCKENDCLR, MMCIClear);
  PSW(CLEARALL, MMCIClear);
  PO(0x00000000, STATICFLAGS, MMCIStatus, 0x0000FFFF);

  PO(0x00000000, CMDACTIVE, MMCIStatus,0x0000FFFF);
  Idle((DELAY) * (2*(CLKDIV + 1)) * 0x2);
  PSR(DATA_Fs, MASK_TBRECDCMDARG, MMCITBRecdCmdArg);
  PSR(0x0000003F, MASK_TBRECDCMDIND, MMCITBRecdCmdInd);


  PSW(CLEARALL, MMCIClear);
  PSW(DATA_5s, MMCIArgument);
  PO(0x00000000, CMDACTIVE, MMCIStatus,0x0000FFFF);
  local = CMDINDEXFF | NORESP_LONGRSP_SET | COMMANDENB | PENDINGMODE;
  PSW(local, MMCICommand);
  PSR(0x00000800, CMDACTIVE, MMCIStatus);

  PSW(0x00000007, MMCIDataLength);
  Idle((DELAY) * (2*(CLKDIV + 1)) * 0x2);
  PSW(DATATXRENB | STREAMMODE, MMCIDataCtrl);
  PO(0x00041000, TXFIFOEMPTY | TXACTIVE, MMCIStatus,0x0000FFFF);
  PSW(DATA_5s, MMCIFIFO);
  PSW(DATA_5s, MMCIFIFO);
  PO(0x00000100, DATAEND, MMCIStatus,0x0000FFFF);
  PSR(DATA_5s, MASK_TBMMCIFIFO, MMCITBFIFOReg);
  PSR(0x00555555, 0x00FFFFFF, MMCITBFIFOReg);

  PO(0x00000000, CMDACTIVE, MMCIStatus,0x0000FFFF);
  Idle((DELAY) * (2*(CLKDIV + 1)) * 0x2);
  PSR(DATA_5s, MASK_TBRECDCMDARG, MMCITBRecdCmdArg);
  PSR(0x0000003F, MASK_TBRECDCMDIND, MMCITBRecdCmdInd);
}
/*********************************   End  *************************************/
