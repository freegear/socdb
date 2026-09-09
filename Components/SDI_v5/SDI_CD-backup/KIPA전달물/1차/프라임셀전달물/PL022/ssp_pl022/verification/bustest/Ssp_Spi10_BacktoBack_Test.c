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
--  File Name              : Ssp_Spi10_BacktoBack_Test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function Spi10_BacktoBack_Test
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void Spi10_BacktoBack_Test()
{
   /*
   Summary: SPI10 Backtoback Mode Tests 
   ====================================
 
   o In this test several bytes are written to the SSP and the trickbox
     and both devices are enabled. The trickbox Rx watermark level is set
     to four and when trickbox received four data words, four more data
     words are written to the SSP. The received data is compared for the
     error free transmission.

   */

  int32 SSPTB_SCR0_VALUE  ;
  int32 SSP_SCR0_VALUE  ;

 C("Spi10 Back to Back Test");
 
 C("PRESCALE 1, Baud 1, Wordlength 9, RXW 4");
 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg( SSP_SCLK_RATE1 | SSP_SPI10 | DataSize[16] , SSPCR0,32);

 /* Program SSPTB */
 ProgramReg(0x00 , SSPTBSCR0 ,5 );
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 RXW_Value = ( SSPTB_RXW_4   | SSPTB_SPI10 );
 ProgramReg( RXW_Value  , SSPTBSCR1, 5);
 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE1 | SSPTB_SPI |  
                        DataSize[16]) ;
 WordLength = DataSize[16] ;
 CalculateTimeout(PRE_2 , SSPTB_SCLK_RATE2 );
 Spi10_Continuous();

 /* Disable SSP and SSPTB */
 ProgramReg(0x0 ,SSPCR1,5);
 ProgramReg(0x00 , SSPTBSCR0 ,5 );

 C("spi10  Back to Back Test End");

}/* End Function */
