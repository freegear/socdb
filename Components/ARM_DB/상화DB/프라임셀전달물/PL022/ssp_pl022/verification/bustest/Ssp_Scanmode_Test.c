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
--  File Name              : Ssp_Scanmode_Test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function Scanmode_Test
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void Scanmode_Test()
{

  /*
  Summary: Scan Mode Test
  =======================

  This test is for validating the SSP scan test hold input. In this, two
  known data patterns are written into a writeable register. A test reset 
  is asserted by setting and clearing the TESTRST bit in the SSPTCR of the
  SSP. After this test reset, the two writable registers should be reset to
  their reset values. Now the same test is conducted with SCANMODE pin 
  driven HIGH. This time the two registers should retain the two known data
  patterns.
  
  */

 C("SCAN MODE TEST ");

 /* Write known data to SCR0 */
 ProgramReg(0x5555 ,SSPCR0,7);

 /* Read Back SCR0 */
 PSR( 0x5555 ,Masks[15],SSPCR0 ,scanmode_1);

 /* Set TESTRST bit */
 ProgramReg(SET_TESTRST ,SSPTCR,1);

 /* Read Back SCR0 */
 PSR( 0x0 ,Masks[15],SSPCR0 ,scanmode_2);

 /* Clear TESTRST bit */
 ProgramReg(0x0 ,SSPTCR,1);

 /* Read Back SCR0 */
 PSR( 0x0 ,Masks[15],SSPCR0 ,scanmode_3);

 /* Enable Scanmode in SSPTB */
 if(SSPCLK_PERIOD == PCLK_PERIOD)
   ProgramReg(SCANMODE_ENABLE | (0X0E),TB_SET_PINS , 1);
 else
   ProgramReg(SCANMODE_ENABLE | (0X12),TB_SET_PINS , 1);

 /* Write known data to SCR0 */
 ProgramReg(0x5555 ,SSPCR0,7);

 /* Read Back SCR0 */
 PSR( 0x5555 ,Masks[15],SSPCR0 ,scanmode_4);

 /* Set TESTRST bit */
 ProgramReg(SET_TESTRST ,SSPTCR,1);

 /* Read Back SCR0 */
 PSR( 0x5555 ,Masks[15],SSPCR0 ,scanmode_5);

 /* Clear TESTRST bit */
 ProgramReg(0x0 ,SSPTCR,1);

 /* Read Back SCR0 */
 PSR( 0x5555 ,Masks[15],SSPCR0 ,scanmode_6);

 /* Disable Scanmode in SSPTB */
  if(SSPCLK_PERIOD == PCLK_PERIOD )
   ProgramReg(0x0E ,TB_SET_PINS , 1);
 else
   ProgramReg(0x12 ,TB_SET_PINS , 1);

 /* Disable SSP and SSPTB */
 ProgramReg(0x0 ,SSPCR1,7);
 ProgramReg(0x00 , SSPTBSCR0 ,5 );

 C("SCAN MODE TEST OVER");

 }/* End Function */
