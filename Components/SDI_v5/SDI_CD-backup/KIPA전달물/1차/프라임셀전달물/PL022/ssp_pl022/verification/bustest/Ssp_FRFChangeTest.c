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
--  File Name              : Ssp_FRFChangeTest.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function FRFChangeTest
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void FRFChangeTest()
{

  /*
  Summary: Frame Format Change Test for Slave
  ===========================================
  This test verifies the SSP Slave's operation when the Frame Format is changed
  from TI to NM, from NM to TI and from TI to SPI. The remaining combinations
  are covered while executing other tests. The SSP is first programmed with the
  'source' frame format. Then the frame format is changed to the 'destination'
  frame format and a few data transfers are initiated to verify the SSP slave's
  operation in the new frame format. 
  */

   C("FRF Change test for Slave");

   ProgramReg(SSP_SCLK_RATE5 | SSP_TI | DataSize[16] , SSPCR0,32);
   Data_Test_S( SSP_SCLK_RATE6,0x00,0x00,SSP_MICROWIRE);
   C("MW Data test for Slave over");
 
   ProgramReg(SSP_SCLK_RATE5 | SSP_MICROWIRE | DataSize[16] , SSPCR0,32);
   Data_Test_S( SSP_SCLK_RATE5,0x00,0x00,SSP_TI);
   C("TI Data test for Slave over");

   ProgramReg(SSP_SCLK_RATE5 | SSP_TI | DataSize[16] , SSPCR0,32);
   Data_Test_S( SSP_SCLK_RATE5,0x00,0x00,SSPTB_SPI);
   C("SPI00 Data test for Slave over");
   
   C("FRF Change test for Slave over");

}/* End Function */
