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
--  File Name              : Ssp_SspdisableTest.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function SspdisableTest
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void SspdisableTest()
{
 /*
  Summary: SSP Disable Test
  =======================

 The purpose of this test is to check that the SSP doesn't transmit data when it is not enabled. A block of five data words is written into the Tx FIFO of the
 SSP with the OD bit set in the Trickbox  and some idle cycles are introduced.
 The TXD line from the uut is expected to be inactive. Any activity is detected
 by the Trickbox which flags an error. The the status flags are read to
 see that no transmission has taken place. Then the SSP is enabled and the data
 is read and compared for error free transmission. This is done for all the 
 modes.

 */
 
  Ti_sspdisableTest();
  Mw_sspdisableTest();
  Spi00_sspdisableTest();
  Spi01_sspdisableTest();
  Spi10_sspdisableTest();
  Spi11_sspdisableTest();
}/* End Function */
