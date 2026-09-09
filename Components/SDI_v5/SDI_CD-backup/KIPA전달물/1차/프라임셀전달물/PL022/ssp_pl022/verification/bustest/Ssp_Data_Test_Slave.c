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
--  File Name              : Ssp_Data_Test_Slave.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function Data_Test_Slave
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void Data_Test_Slave()
{
  /*
  Summary: Data Tests For Slave
  =============================

  The purpose of this test is to check the the Setup and Hold times  
  in non back to back mode. A series of 1's and 0's are transmitted 
  as data to facilitate the toggling of the Transmit line. Any setup/hold
  violations on the data output line of the SSP with respect to the sampling
  edge of SCLKIN are flagged by the Trickbox.
  */

 Data_Test_S( SSP_SCLK_RATE5,0x00,0x00,SSP_TI);
 C("TI Data test for Slave over");
 Data_Test_S( SSP_SCLK_RATE6,0x00,0x00,SSP_MICROWIRE);
 C("MW Data test for Slave over");
 Data_Test_S( SSP_SCLK_RATE5,0x00,0x00,SSPTB_SPI);
 C("SPI00 Data test for Slave over");
 Data_Test_S( SSP_SCLK_RATE5,0x01,0x00,SSPTB_SPI);
 C("SPI01 Data test for Slave over");
 Data_Test_S( SSP_SCLK_RATE5,0x00,0x01,SSPTB_SPI);
 C("SPI10 Data test for Slave over");
 Data_Test_S( SSP_SCLK_RATE5,0x01,0x01,SSPTB_SPI);
 C("SPI11 Data test for Slave over");

}/* End Function */
