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
--  File Name              : Ssp_RefClkOn.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function RefClkOn
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void RefClkOn()
{
  /*
    Summary: SSPRefClk to SSpCLK
    ===========================
    This test routes the SSPRefClk onto the SSPCLK line.
  */

 C( "SSPRefClk to SSpCLK" );

 /* Clear pclksel */
 PSW(GENCLK_ENABLE | RSTMODE_ENABLE,TB_SET_PINS);

 /* Poll for pclkon zero */
 PO(0x000,MASK_SSPTB_PCLKON,SSPTBSSR,,testing);

 /* Set sspclksel */
 PSW(SSPCLK_ENABLE | RSTMODE_ENABLE,TB_SET_PINS);

}/* End Function */
