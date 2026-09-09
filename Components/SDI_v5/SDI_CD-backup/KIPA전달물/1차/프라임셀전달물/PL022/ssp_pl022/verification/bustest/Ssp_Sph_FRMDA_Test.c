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
--  File Name              : Ssp_Sph_FRMDA_Test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function Sph_FRMDA_Test
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void Sph_FRMDA_Test()
{

  /*
 
   Summary: Frame Deactivation Test for Slave
   ==========================================
  In the SPI mode, when SPH is set, the SSP slave is expected to be compatible
  with two kinds of Masters - those that negate SFRM for one SCLK phase time
  between successive frames of continuous transmission and those Masters that
  don't. This test verfies the SSP slave's operation when interfacing with those
  Masters that do negate SFRM between successive frames in a continuous 
  transfer. The SPISFRMEN bit in SSPTBCR2 register of the Trickbox is set to 
  force the Trickbox to negate SFRM between successive frames. Then the 
  SPI Back-to-back tests are executed for SPO = 0 and SPO = 1.
  The SSP slave's operation when interfacing with SPI Masters that do not
  negate SFRM between successive frames in a continuous transfer, is verified
  as part of the default SSP slave Back-to-back tests in the 
  BacktoBack_Test_Slave() function.

  */

  C(" Frame Deactivation Test for Slave");

  ProgramReg(SSPTB_SPISFRMEN, SSPTBCR2 ,5);

  BacktoBack_Test_S( SSP_SCLK_RATE5,0x00,0x01,SSPTB_SPI);
  C("SPI10 Back to Back test for Slave over");

  BacktoBack_Test_S( SSP_SCLK_RATE5,0x01,0x01,SSPTB_SPI);
  C("SPI11 Back to Back test for Slave over");

  ProgramReg(0x000, SSPTBCR2 ,5);

  C(" Frame Deactivation Test for Slave over");

}/* End Function */
