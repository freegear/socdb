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
--  File Name              : Ssp_BacktoBack_Test_Slave.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function BacktoBack_Test_Slave
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void BacktoBack_Test_Slave()
{
  /*
  Summary: Backtoback Mode Tests For Slave 
  ===========================================
 
  This function performs Back-to-back tests on the SSP slave for different
  Frame formats.
  */

 BacktoBack_Test_S( SSP_SCLK_RATE5,0x00,0x00,SSP_TI);
 C("TI Back to Back test for Slave over");
 BacktoBack_Test_S( SSP_SCLK_RATE6,0x00,0x00,SSPTB_SPI);
 C("SPI00 Back to Back test for Slave over");
 BacktoBack_Test_S( SSP_SCLK_RATE5,0x01,0x00,SSPTB_SPI);
 C("SPI01 Back to Back test for Slave over");
 BacktoBack_Test_S( SSP_SCLK_RATE5,0x00,0x01,SSPTB_SPI);
 C("SPI10 Back to Back test for Slave over");
 BacktoBack_Test_S( SSP_SCLK_RATE5,0x01,0x01,SSPTB_SPI);
 C("SPI11 Back to Back test for Slave over");
 BacktoBack_Test_S( SSP_SCLK_RATE5,0x00,0x00,SSP_MICROWIRE);
 C("MW Back to Back test for Slave over"); 

}/* End Function */
