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
--  File Name              : Ssp_PCLKOn.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function PCLKOn
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void PCLKOn()
{
  /* 
    Summary: PCLK to SSPPRefClk
    ===========================
    This test routes the PCLK onto the SSPCLK line.
  */

  C( "PCLK to SSPPRefClk" );

 /* Clear sspclksel */
  PSW(RSTMODE_ENABLE,TB_SET_PINS);

 /* Poll for sspclkon zero */
  PO(0x000,MASK_SSPTB_REFCLKON,SSPTBSSR,,testing);

 /* Set pclksel */
  PSW(PCLK_ENABLE | GENCLK_ENABLE | RSTMODE_ENABLE ,TB_SET_PINS);

}/* End Function */
