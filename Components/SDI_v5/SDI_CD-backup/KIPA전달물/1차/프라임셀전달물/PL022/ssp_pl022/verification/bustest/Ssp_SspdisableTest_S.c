/*------------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2000 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--
--  File Name              : Ssp_SspdisableTest_S.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function SspdisableTest_S
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void SspdisableTest_S()
{
 /*
  Summary: SSP Disable Test for Slave
  ===================================
 
 The purpose of this test is to check that the SSP doesn't transmit data when it
 is programmed to operate as a Slave but is not enabled. A block of five data 
 words is written into the Tx FIFO of the Trickbox and the SSP. Then the 
 transmission is allowed to take place with the master enabled. The status flags are checked to see that the master has completed the tranmission of the data 
 and the transmit FIFO of the SSP is not empty. Again a block of five words 
 are written into the Trickbox and the SSP is enabled. 
      Transmission is allowed to take place and the data is read and 
 compared for error free transmission. This is done for all the modes.

  */
  Ti_sspdisableTest_S();
  Mw_sspdisableTest_S();
  Spi00_sspdisableTest_S();
  Spi01_sspdisableTest_S();
  Spi10_sspdisableTest_S();
  Spi11_sspdisableTest_S();
}/* End Function */
