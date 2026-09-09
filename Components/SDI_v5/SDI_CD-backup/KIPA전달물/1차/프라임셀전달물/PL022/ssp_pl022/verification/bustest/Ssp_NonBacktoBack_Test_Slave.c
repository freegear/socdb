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
--  File Name              : Ssp_NonBacktoBack_Test_Slave.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function NonBacktoBack_Test_Slave
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void NonBacktoBack_Test_Slave()
{
  /*
  Summary: Non Backtoback Tests For Slave 
  =======================================
 
  The purpose of this test is to check the SSP transmission and
  reception operations in non back to back mode. A block of four
  data words are written into the Tx FIFO of the SSP. The SSP is 
  enabled and allowed to finish transmission.The received data is
  read and compared for error free transmission/reception. After
  some idle time (without disabling the SSP) a block of three data
  words written to the SSP and polled till the transmission is over.
  The received data is read and compared for error free transmission
  / reception. Every time a block of different data values are written
  to the SSP and the above process is repeated.
  The tests are performed with the SSP being programmed in various Frame
  formats.
  */

 NonBacktoBack_Test_S( SSP_SCLK_RATE5,0x00,0x00,SSP_TI);
 C("TI Non Back to Back test for Slave over");
 NonBacktoBack_Test_S( SSP_SCLK_RATE5,0x00,0x00,SSP_MICROWIRE);
 C("MW Non Back to Back test for Slave over");
 NonBacktoBack_Test_S( SSP_SCLK_RATE5,0x00,0x00,SSPTB_SPI);
 C("SPI00 Non Back to Back test for Slave over");
 NonBacktoBack_Test_S( SSP_SCLK_RATE5,0x01,0x00,SSPTB_SPI);
 C("SPI01 Non Back to Back test for Slave over");
 NonBacktoBack_Test_S( SSP_SCLK_RATE5,0x00,0x01,SSPTB_SPI);
 C("SPI10 Non Back to Back test for Slave over");
 NonBacktoBack_Test_S( SSP_SCLK_RATE5,0x01,0x01,SSPTB_SPI);
 C("SPI11 Non Back to Back test for Slave over");
}/* End Function */
