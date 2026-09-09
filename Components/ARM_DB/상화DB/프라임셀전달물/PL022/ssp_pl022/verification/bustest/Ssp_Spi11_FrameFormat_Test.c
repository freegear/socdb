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
--  File Name              : Ssp_Spi11_FrameFormat_Test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function Spi11_FrameFormat_Test
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void Spi11_FrameFormat_Test()
{
   /*
   Summary: SPI11 Frame Format Tests 
   =================================
 
   o These are the series of tests which test transmission and reception of
     data by the SSP through the TrickBox. The SSP and the trickbox are 
     programmed in the SPI11 mode.

   o These tests are conducted for different combinations of baud rate and
     word lengths.

   */

  int32 SSPTB_SCR0_VALUE  ;
  int32 SSP_SCR0_VALUE  ;

 C("SPI11 Frame Format Test");
 
 
 C("Baud 0, Wordlength 14");
 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg( SSP_SCLK_RATE0 | SSP_SPI11 | DataSize[14] , SSPCR0,32);
 
 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 ProgramReg(SSPTB_SPI11 ,  SSPTBSCR1, 5);
 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE0 | SSPTB_SPI | 
                        DataSize[14]) ;
 WordLength = DataSize[14] ;
 CalculateTimeout(PRE_1 , SSPTB_SCLK_RATE0 );
 Testspi11(8,14);  
 Idle(15);

 C(" Baud 1, Wordlength 10 ");
 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg( SSP_SCLK_RATE1 | SSP_SPI11 | DataSize[10] , SSPCR0,32);
 
 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 ProgramReg(SSPTB_SPI11 ,  SSPTBSCR1, 5);
 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE1 | SSPTB_SPI |
                        DataSize[10]) ;
 WordLength = DataSize[10] ; 
 CalculateTimeout(PRE_1 , SSPTB_SCLK_RATE1 );
 Testspi11(8,10);  
 Idle(7);

 C(" Baud 2, Wordlength 7 ");
 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg( SSP_SCLK_RATE2 | SSP_SPI11 | DataSize[7] , SSPCR0,32);
 
 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 ProgramReg(SSPTB_SPI11 ,  SSPTBSCR1, 5);
 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE2 | SSPTB_SPI |  
                        DataSize[7]) ;
 WordLength = DataSize[7] ;
 CalculateTimeout(PRE_1 , SSPTB_SCLK_RATE2 );
 Testspi11(8,7); 
 Idle(9);

 C(" Baud 3, Wordlength 5 ");
 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg( SSP_SCLK_RATE3 | SSP_SPI11 | DataSize[5] , SSPCR0,32);
 
 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 ProgramReg(SSPTB_SPI11 ,  SSPTBSCR1, 5);
 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE3 | SSPTB_SPI | 
                        DataSize[5]) ;
 WordLength = DataSize[5] ;
 CalculateTimeout(PRE_1 , SSPTB_SCLK_RATE3 );
 Testspi11(8,5); 
 Idle(4);

 /* Disable SSP and SSPTB */
 ProgramReg( 0x0 , SSPTBSCR0 ,5);
 ProgramReg( 0x0 , SSPCR1 ,5 );
 
 C("SPI11 Frame Foramt Test End");

}/* End Function */
