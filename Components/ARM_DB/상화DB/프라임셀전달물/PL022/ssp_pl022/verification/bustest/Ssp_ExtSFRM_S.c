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
--  File Name              : Ssp_ExtSFRM_S.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function ExtSFRM_S
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void ExtSFRM_S()
{

   /*
 
   Summary: Extended SFRMIN Test for Slave
   =====================================
 
    In this test a non-Zero count value is written into the SSPTBESFRM
    register in the Trickbox. This value specifies the number of clock 
    cycles for which SFRM will be high for each frame of transmit data
    in the TI mode. Data is written into both the trickbox and the SSP.
    The Trickbox and the SSP are enabled. The SSP Slave is expected to 
    sample the first bit of data on the first falling edge of SCLK that 
    occurs after SFRM has gone low. Also, the SSP is expected to retain
    the first bit of transmitted data on the SSPTXD line till SFRM goes
    low.Transmission/reception is allowed to complete and the data is read
    and compared for error free transmission.  
     
   */

   C(" Extended SFrame Test for Slave");

   ProgramReg(0x5, SSPTBCR2 ,5);
   Data_Test_S( SSP_SCLK_RATE5,0x00,0x00,SSP_TI);
   C("TI Data test for Slave over");

   ProgramReg(0x9, SSPTBCR2 ,5);
   BacktoBack_Test_S( SSP_SCLK_RATE5,0x00,0x00,SSP_TI);
   C("TI Back to Back test for Slave over");

   ProgramReg(0x11, SSPTBCR2 ,5);
   Ti_FrameFormat_Test_S();

   ProgramReg(0xc, SSPTBCR2 ,5);
   NonBacktoBack_Test_S( SSP_SCLK_RATE5,0x00,0x00,SSP_TI);
   C("TI Non Back to Back test for Slave over");

   ProgramReg(0x000, SSPTBCR2 ,5);

   C(" Extended SFrame Test for Slave over");

}/* End Function */
