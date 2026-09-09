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
-- File Name              : ResetRead.c.rca
-- File Revision          : 1.2
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose : Function added to increase the toggle coverage, where read
--           is done on all registers after reset.
--
-- --=========================================================================*/

void ResetRead(void)
{
  /*
  Summary: ResetRead function
  ===========================

  This function is used to increase the toggle coverage of address 
  lines. Here all the registers are read after reset.

  */

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

  PSR(DATA_0s, MASK_TCR,  MMCITCR,mcitcrread);
  PSR(DATA_0s, MASK_ITOP, MMCIITOP,mciitopread);

  PSR(0x81, MASK_PERIPHCELLID, MMCIPeriphID0);
  PSR(0x11, MASK_PERIPHCELLID, MMCIPeriphID1);
  PSR(0x04, MASK_PERIPHCELLID, MMCIPeriphID2);
  PSR(0x00, MASK_PERIPHCELLID, MMCIPeriphID3);
  PSR(0x0D, MASK_PERIPHCELLID, MMCIPCellID0);
  PSR(0xF0, MASK_PERIPHCELLID, MMCIPCellID1);
  PSR(0x05, MASK_PERIPHCELLID, MMCIPCellID2);
  PSR(0xB1, MASK_PERIPHCELLID, MMCIPCellID3);

}


/* --================================== End ==================================*/
