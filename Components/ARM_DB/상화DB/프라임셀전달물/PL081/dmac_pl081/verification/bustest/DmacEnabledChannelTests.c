/* --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000-2001 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : DmacEnabledChannelTests.c.rca
-- File Revision          : 1.5
--
-- Release Information    : PrimeCell(TM)-PL081-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           To test the enabled-channel register.
-- --=========================================================================*/
 
/******************************************************************************/
/************************* List of Functions Called ***************************/
/******************************************************************************/
/*** Function name                              Located in                  ***/
/*** ---------------------------------------------------------------------- ***/
/*** Read                                       DmacCommon.c                ***/
/*** WaitLoop                                   DmacCommon.c                ***/
/*** Write                                      DmacCommon.c                ***/
/******************************************************************************/
 
void EnabledChannelTests()
{
  /* 
    Summary: Enabled-Channel Test
    =============================
      The objective of this test is to check the "DMAEnabledChannel"
      register by enabling and disabling the channels individually.
  */

  int32 ChannelList[] = {DMACC0Config, DMACC1Config, DMACC2Config, DMACC3Config,
                       DMACC4Config, DMACC5Config, DMACC6Config, DMACC7Config};
  int32 *AddrPtr = ChannelList;
  int32 RegAddr;
  int32 ExpData = 0x00000000;
  int i;

  C("Test No : DMA_CHNL_NABL_1");

  Read(DMACEnbldChns, ExpData, NoMask);

  for (i=0;i<2;i++)
  {
   Write(*(AddrPtr+i), CHXENABLE);
   /* The shift left operator inserts a zero on LSB. So it is ORed with
      0x00000001 to make it '1' */
   ExpData = 0x0000001 << i;
   Read(DMACEnbldChns, ExpData, NoMask);

   /* Disable the channel and check the enabled channel register */
   Write(*(AddrPtr+i), CHXDISABLE);
   ExpData = 0x0000000;
   WaitLoop(1);
   Read(DMACEnbldChns, ExpData, NoMask);
  }

  C("Test No : DMA_CHNL_NABL_2");

  /* The objective of this tset is to test the "DMAEnabledChannel" register
     by enabling and disabling all the channels together. */

  Read(DMACEnbldChns, ExpData, NoMask);

  for (i=0;i<2;i++)
  {
   Write(*(AddrPtr+i), CHXENABLE);
   /* The shift left operator inserts a zero on LSB. So it is ORed with
      0x00000001 to make it '1' */
   ExpData = (ExpData << 1) | 0x0000001;
   Read(DMACEnbldChns, ExpData, NoMask);
  }

  Read(DMACEnbldChns, ExpData, NoMask);

  for (i=1;i>=0;i--)
  {
   Write(*(AddrPtr+i), CHXDISABLE);
   /* It is assumed that the shift right operator inserts a zero on MSB */
   ExpData = (ExpData >> 1);
   WaitLoop(1);
   Read(DMACEnbldChns, ExpData, NoMask);
  }
}
/************************************ End *************************************/
