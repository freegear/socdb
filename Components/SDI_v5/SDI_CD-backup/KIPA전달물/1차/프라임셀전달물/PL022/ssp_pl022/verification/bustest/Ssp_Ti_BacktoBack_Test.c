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
--  File Name              : Ssp_Ti_BacktoBack_Test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function Ti_BacktoBack_Test
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void Ti_BacktoBack_Test()
{
   /*
   Summary: TI Backtoback Mode Tests 
   =================================
 
   o In this test several bytes are written to the SSP and the trickbox
     and both devices are enabled. The trickbox Rx watermark level is set
     to four and when the trickbox receives four data words, four more data
     words are written to the SSP. The received data is compared for 
     error free transmission.

   */

  int32 SSPTB_SCR0_VALUE  ;
  int32 SSP_SCR0_VALUE  ;

 C("TI Back to Back Test");
 
 C("Baud 0, Wordlength 16 , RXW 4 ");

 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg( SSP_SCLK_RATE0 | SSP_TI | DataSize[16] , SSPCR0,32);

 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 RXW_Value = SSPTB_RXW_4;
 ProgramReg( RXW_Value & MASK_SSPTB_RXW , SSPTBSCR1, 5);
 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE0 | SSPTB_TI |  
                        DataSize[16]) ;
 WordLength = DataSize[16] ;
 CalculateTimeout(PRE_1 , SSPTB_SCLK_RATE0 );
 Ti_Continuous();
 Idle(10);

 /* Disable SSP and SSPTB */
 ProgramReg(0x0 ,SSPCR1,5);
 ProgramReg(0x00 , SSPTBSCR0 ,5 );
 
 C("TI Back to Back Test end");

}/* End Function */
