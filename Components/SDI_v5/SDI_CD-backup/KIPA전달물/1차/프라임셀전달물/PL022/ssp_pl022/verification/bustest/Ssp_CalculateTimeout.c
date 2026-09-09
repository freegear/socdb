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
--  File Name              : Ssp_CalculateTimeout.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function CalculateTimeout
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void CalculateTimeout(int32 Prescale_val ,int32 clkrate )

{
   TimeOut = (( SSPCLK_PERIOD / PCLK_PERIOD) * DataSize[WordLength] * Prescale_val * ( clkrate  + 1 ));
}/* End Function */
