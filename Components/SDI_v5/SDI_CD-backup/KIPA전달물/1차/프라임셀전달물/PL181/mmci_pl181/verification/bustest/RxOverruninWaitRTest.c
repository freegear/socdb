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
-- File Name              : RxOverruninWaitRTest.c.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL181-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Test to trigger Overrun when the DPSM is in the WAIT_R
--           state
--
-- --=========================================================================*/

/******************************************************************************/
/**************************** RxOverruninWaitRTest ****************************/
/******************************************************************************/

void RxOverruninWaitRTest(void)
{
/*
   Summary : RxOverruninWaitRTest
   ==============================

   This test triggers an Overrun error condition when the DPSM is in
   the WAIT_R state and verifies that the Overrun flag is set in this
   state.

   The DataCounter is programmed for receiving 65 bytes of data so
   that the DPSM returns to the WAIT_R state one byte duration
   after the FIFO is full. The write of the last received data into
   the FIFO triggers an Overrun, which is expected to result in the
   Overun flag in the Status register getting set.
*/

  int i;

  PSW(CLKDIV1 | CLKENB, MMCIClock);
  PSW(0x00000020, MMCIMask0);
  PSW(0x00000041, MMCIDataLength);
  PSW(0x0000001F, MMCIDataTimer);
  PSW(0x0000000F, MMCITBDataTimer);
  PO(0x00000001, TBTXFIFOEMPTY, MMCITBStatus,0x0000FFFF);
  for (i=0 ; i<16; i++)
     PSW(~DATA_As, MMCITBFIFOReg);
  PSW(~DATA_As, MMCITBFIFOReg);
  PSW(DATATXRENB | DATARXDIR | STREAMMODE, MMCIDataCtrl);
  PO(0x00002000, RXACTIVE, MMCIStatus);
  RoutableInterrupt(0x00000020, 0x00000020, 0x0000FFFF);
  for (i=0 ; i<16; i++)
     PSR(DATA_As, DATA_0s, MMCIFIFO);
  PO(0x00000000, RXACTIVE, MMCIStatus);

  C("End of RxOverrrun Test with DPSM in WAIT_R state");
  PSW(CLEARALL, MMCIClear);
  PO(0x00000000, STATICFLAGS, MMCIStatus,0x0000FFFF);
}

/*******************************  End  ****************************************/
