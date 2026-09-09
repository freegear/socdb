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
--  File Name              : Ssp_Spi01_FrameFormat_Test_S.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function Spi01_FrameFormat_Test_S
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void Spi01_FrameFormat_Test_S()
{
   /*
   Summary: SPI01 Frame Format Test for Slave 
   ==========================================
 
   o These are the series of tests which test transmission and reception of
     data by the SSP through the TrickBox. The SSP and the trickbox are 
     programmed in the SPI01 mode.

   o These tests are conducted for different combinations of baud rate and
     word lengths.

   */


 int32 SSPTB_SCR0_VALUE  ;

 C("SPI01 Frame Format Test for Slave");
 
 C(" Baud 5, Wordlength 16 ");
 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg( SSP_SCLK_RATE5 | SSP_SPI01 | DataSize[16] , SSPCR0,32);
 ProgramReg(SSP_MS,SSPCR1,32);

 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 ProgramReg(SSPTB_SPI01 | SSPTB_MS,  SSPTBSCR1, 5);

 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE5 | SSPTB_SPI |  
                        DataSize[16]) ;
 WordLength = DataSize[16] ;
 CalculateTimeout(PRE_1 , SSPTB_SCLK_RATE5 );
 Testspi01_S(8,16); 
 Idle(5);

 C(" Baud 6, Wordlength 13 ");
 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg( SSP_SCLK_RATE6 | SSP_SPI01 | DataSize[13] , SSPCR0,32);
 ProgramReg(SSP_MS,SSPCR1,32);
 
 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 ProgramReg(SSPTB_SPI01 | SSPTB_MS,  SSPTBSCR1, 5);
 
 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE6 | SSPTB_SPI |  
                        DataSize[13]) ;
 WordLength = DataSize[13] ;
 CalculateTimeout(PRE_1 , SSPTB_SCLK_RATE6 );
 Testspi01_S(8,13); 
 Idle(7);

 C(" Baud 13, Wordlength 9 ");
 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg( SSP_SCLK_RATE13 | SSP_SPI01 | DataSize[9] , SSPCR0,32);
 ProgramReg(SSP_MS,SSPCR1,32);
 
 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 ProgramReg(SSPTB_SPI01 | SSPTB_MS,  SSPTBSCR1, 5);
 
 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE13 | SSPTB_SPI |  
                        DataSize[9]) ;
 WordLength = DataSize[9] ;
 CalculateTimeout(PRE_1 , SSPTB_SCLK_RATE13 );
 Testspi01_S(8,9); 
 Idle(9);

 C(" Baud 14, Wordlength 4 ");
 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg( SSP_SCLK_RATE14 | SSP_SPI01 | DataSize[4] , SSPCR0,32);
 ProgramReg(SSP_MS,SSPCR1,32);
 
 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 ProgramReg(SSPTB_SPI01 | SSPTB_MS,  SSPTBSCR1, 5);
 
 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE14 | SSPTB_SPI | 
                        DataSize[4]) ;
 WordLength = DataSize[4] ; 
 CalculateTimeout(PRE_1 , SSPTB_SCLK_RATE14 );
 Testspi01_S(8,4); 
 Idle(4);

 /* Disable SSP and SSPTB */
 ProgramReg(0x00 , SSPTBSCR0 , 5);
 ProgramReg( 0x00 , SSPTBSCR1 ,5);
 ProgramReg(0x00 ,SSPCR1,5);
 
C("SPI01 Frame Format Test for Slave over");

}/* End Function */
