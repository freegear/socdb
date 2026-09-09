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
--  File Name              : Ssp_NonBacktoBack_Check_Test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function NonBacktoBack_Check_Test
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void NonBacktoBack_Check_Test()
{
 NonBacktoBack_Test( SSP_SCLK_RATE1,0x00,0x00,SSP_TI);
 C("TI Non Back to Back test over");
 NonBacktoBack_Test( SSP_SCLK_RATE0,0x00,0x00,SSP_MICROWIRE);
 C("MW Non Back to Back test over");
 NonBacktoBack_Test( SSP_SCLK_RATE0,0x00,0x00,SSPTB_SPI);
 C("SPI00 Non Back to Back test over");
 NonBacktoBack_Test( SSP_SCLK_RATE0,0x01,0x00,SSPTB_SPI);
 C("SPI01 Non Back to Back test over");
 NonBacktoBack_Test( SSP_SCLK_RATE1,0x00,0x01,SSPTB_SPI);
 C("SPI10 Non Back to Back test over");
 NonBacktoBack_Test( SSP_SCLK_RATE0,0x01,0x01,SSPTB_SPI);
 C("SPI11 Non Back to Back test over");
}/* End Function */
