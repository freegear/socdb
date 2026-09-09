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
--  File Name              : Ssp_Ti_FrameFormat_Test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function Ti_FrameFormat_Test
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void Ti_FrameFormat_Test()
{
   /*
   Summary: TI Frame Format Tests 
   ==============================
 
   o These are a series of tests which test transmission and reception of
     data by the SSP through the TrickBox The SSP and the trickbox are 
     programmed in the TI mode.

   o These tests are conducted for different combinations of baud rate and
     all the word lengths.

   */

 C("TI Frame Format Test");

 C("Baud 0, Wordlength 16");

 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg(SSP_SCLK_RATE0 | SSP_TI | DataSize[16] , SSPCR0,32);

 /* Program SSPTB */
 ProgramReg(PRE_1, SSPTBPRE, 5 );
 ProgramReg(0x00,  SSPTBSCR1, 5);

 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE0 | SSPTB_TI 
                        | DataSize[16]) ;
 WordLength = DataSize[16] ;
 CalculateTimeout(PRE_1 , SSPTB_SCLK_RATE0);
 TestTI(8,16); 
 Idle(15);
           
 C(" Baud 0, Wordlength 15 ");

 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg( SSP_SCLK_RATE0 | SSP_TI | DataSize[15] , SSPCR0,32);

 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 ProgramReg( 0x00 ,  SSPTBSCR1, 5);

 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE0 | SSPTB_TI 
                       | DataSize[15]) ;
 WordLength = DataSize[15] ;
 TestTI(8,15); 
 Idle(10);
           
 C(" Baud 0, Wordlength 14 ");

 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg( SSP_SCLK_RATE0 | SSP_TI | DataSize[14] , SSPCR0,32);

 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 ProgramReg( 0x00 ,  SSPTBSCR1, 5);

 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE0 | SSPTB_TI 
                        | DataSize[14]) ;
 WordLength = DataSize[14] ;
 TestTI(8,14); 
 Idle(20);
           
 C(" Baud 1, Wordlength 13 ");

 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg( SSP_SCLK_RATE1 | SSP_TI | DataSize[13] , SSPCR0,32);

 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 ProgramReg( 0x00 ,  SSPTBSCR1, 5);

 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE1 | SSPTB_TI |
                        DataSize[13]) ;
 WordLength = DataSize[13] ;
 TestTI(8,13); 
 Idle(18);

 C(" Baud 1, Wordlength 12 ");

 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg( SSP_SCLK_RATE1 | SSP_TI | DataSize[12] , SSPCR0,32);

 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 ProgramReg( 0x00 ,  SSPTBSCR1, 5);

 ssptb_enable_value = ( SSPTB_ENABLE |  SSPTB_SCLK_RATE1 | SSPTB_TI | 
                        DataSize[12]) ;
 WordLength = DataSize[12] ;
 TestTI(8,12); 
 Idle(19);


 C(" Baud 1, Wordlength 11 ");

 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg( SSP_SCLK_RATE1 | SSP_TI | DataSize[11] , SSPCR0,32);

 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 ProgramReg( 0x00 ,  SSPTBSCR1, 5);

 ssptb_enable_value = ( SSPTB_ENABLE |  SSPTB_SCLK_RATE1 | SSPTB_TI |  
                        DataSize[11]) ;
 WordLength = DataSize[11] ;
 TestTI(8,11); 
 Idle(21);

 C(" Baud 1, Wordlength 10 ");

 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg( SSP_SCLK_RATE1 | SSP_TI | DataSize[10] , SSPCR0,32);

 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 ProgramReg( 0x00 ,  SSPTBSCR1, 5);

 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE1 | SSPTB_TI |  
                        DataSize[10]) ;
 WordLength = DataSize[10] ;
 TestTI(8,10); 
 Idle(14);

 C(" Baud 2, Wordlength 9 ");
 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg( SSP_SCLK_RATE2 | SSP_TI | DataSize[9] , SSPCR0,32);

 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 ProgramReg( 0x00 ,  SSPTBSCR1, 5);

 ssptb_enable_value = ( SSPTB_ENABLE |  SSPTB_SCLK_RATE2 | SSPTB_TI | 
                        DataSize[9]) ;
 WordLength = DataSize[9] ;
 TestTI(8,9); 
 Idle(21);

 C(" Baud 2, Wordlength 8 ");
 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg( SSP_SCLK_RATE2 | SSP_TI | DataSize[8] , SSPCR0,32);

 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 ProgramReg( 0x00 ,  SSPTBSCR1, 5);

 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE2 | SSPTB_TI |
                        DataSize[8]) ;
 WordLength = DataSize[8] ;
 TestTI(8,8); 
 Idle(11);

 C(" Baud 2, Wordlength 7 ");
 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg( SSP_SCLK_RATE2 | SSP_TI | DataSize[7] , SSPCR0,32);

 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 ProgramReg( 0x00 , SSPTBSCR1, 5);

 ssptb_enable_value = ( SSPTB_ENABLE |  SSPTB_SCLK_RATE2 | SSPTB_TI |
                        DataSize[7]) ;
 WordLength = DataSize[7] ;
 TestTI(8,7); 
 Idle(17);

 C(" Baud 3, Wordlength 6 ");
 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg( SSP_SCLK_RATE3 | SSP_TI | DataSize[6] , SSPCR0,32);

 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 ProgramReg( 0x00 ,  SSPTBSCR1, 5);

 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE3 | SSPTB_TI |  
                        DataSize[6] ) ;
 WordLength = DataSize[6] ;
 TestTI(8,6); 
 Idle(12);

 C(" Baud 3, Wordlength 5 ");
 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg( SSP_SCLK_RATE3 | SSP_TI | DataSize[5] , SSPCR0,32);

 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 ProgramReg( 0x00 ,  SSPTBSCR1, 5);

 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE3 | SSPTB_TI | 
                        DataSize[5]) ;
 WordLength = DataSize[5] ;
 TestTI(8,5); 
 Idle(17);

 C("PRE Scale 2, Baud 3, Wordlength 4 ");
 /* Program SSP */
 ProgramReg(SSP_PRE_2 , SSPCPSR ,32 );
 ProgramReg( SSP_SCLK_RATE3 | SSP_TI | DataSize[4] , SSPCR0,32);

 /* Program SSPTB */
 ProgramReg(PRE_2 , SSPTBPRE ,5 );
 ProgramReg( 0x00 ,  SSPTBSCR1, 5);

 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE3 | SSPTB_TI |  
                        DataSize[4]) ;
 WordLength = DataSize[4] ;
 CalculateTimeout(PRE_2 ,SSPTB_SCLK_RATE3);
 TestTI(8,4); 
 Idle(21);

 /* Disable SSP and SSPTB */
 ProgramReg( 0x0 ,SSPCR1,5);
 ProgramReg( 0x0 , SSPTBSCR0 ,5);
 
 C("TI Frame Format Test End ");

}/* End Function */
