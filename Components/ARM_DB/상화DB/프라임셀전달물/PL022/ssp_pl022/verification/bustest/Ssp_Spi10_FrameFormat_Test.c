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
--  File Name              : Ssp_Spi10_FrameFormat_Test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function Spi10_FrameFormat_Test
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void Spi10_FrameFormat_Test()
{
   /*
   Summary: SPI10 Frame Format Tests 
   =================================
 
   o These are the series of tests which test transmission and reception of
     data by the SSP through the TrickBox. The SSP and the trickbox are 
     programmed in the SPI10 mode.

   o These tests are conducted for different combinations of baud rate and
     word lengths.

   */


  int32 SSPTB_SCR0_VALUE  ;
  int32 SSP_SCR0_VALUE  ;

 C("SPI10 frame Format Test");
 
 C(" Baud 0, Wordlength 16 ");
 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg( SSP_SCLK_RATE0 | SSP_SPI10 | DataSize[16] , SSPCR0,32);
 
 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 ProgramReg(SSPTB_SPI10 ,  SSPTBSCR1, 5);
 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE0 | SSPTB_SPI |  
                        DataSize[16]) ;
 WordLength = DataSize[16] ;
 CalculateTimeout(PRE_1 , SSPTB_SCLK_RATE0 );
 Testspi10(8,16); 
 Idle(4);
 
 C(" Baud 1, Wordlength 11 ");
 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg( SSP_SCLK_RATE1 | SSP_SPI10 | DataSize[11] , SSPCR0,32);
 
 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 ProgramReg(SSPTB_SPI10 ,  SSPTBSCR1, 5);
 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE1 | SSPTB_SPI | 
                        DataSize[11]) ;
 WordLength = DataSize[11] ;
 CalculateTimeout(PRE_1 , SSPTB_SCLK_RATE1 );
 Testspi10(8,11);  
 Idle(2);

 C(" Baud 2, Wordlength 8 ");
 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg( SSP_SCLK_RATE2 | SSP_SPI10 | DataSize[8] , SSPCR0,32);
 
 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 ProgramReg(SSPTB_SPI10 ,  SSPTBSCR1, 5);
 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE2 | SSPTB_SPI |  
                        DataSize[8]) ;
 WordLength = DataSize[8] ;
 CalculateTimeout(PRE_1 , SSPTB_SCLK_RATE2 );
 Testspi10(8,8);  
 Idle(4);

 C(" Baud 3, Wordlength 4 ");
 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg( SSP_SCLK_RATE3 | SSP_SPI10 | DataSize[4] , SSPCR0,32);
 
 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 ProgramReg(SSPTB_SPI10 ,  SSPTBSCR1, 5);
 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE3 | SSPTB_SPI |  
                        DataSize[4]) ;
 WordLength = DataSize[4] ;
 CalculateTimeout(PRE_1 , SSPTB_SCLK_RATE3 );
 Testspi10(8,4);  
 Idle(5);

/* Disable SSP and SSPTB */
 ProgramReg( 0x0 , SSPTBSCR0 ,5);
 ProgramReg( 0x0 , SSPCR1 ,5 );
 
C(" SPI10 Frame Format Test End");

}/* End Function */
