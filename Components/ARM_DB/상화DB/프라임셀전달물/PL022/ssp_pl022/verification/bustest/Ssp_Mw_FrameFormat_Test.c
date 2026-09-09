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
--  File Name              : Ssp_Mw_FrameFormat_Test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function Mw_FrameFormat_Test
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void Mw_FrameFormat_Test()
{
   /*
   Summary: MW Frame Format Tests 
   ==============================
 
   o These are the series of tests which test transmission and reception of
     data by the SSP through the TrickBox The SSP and the trickbox are 
     programmed in the NMW mode.
 
   o These tests are conducted for different combinations of baud rate and
     all the word lengths.

   */

 int32 SSPTB_SCR0_VALUE  ;
 int32 SSP_SCR0_VALUE  ;

 C("Microwire Frame Format Test");
 
 C(" Baud 0, Wordlength 16");
 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg(SSP_SCLK_RATE0 | SSP_MICROWIRE | DataSize[16],  SSPCR0,32);
 
 /* Programm SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 ProgramReg(0x0 ,  SSPTBSCR1, 5);
 
 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE0 | SSPTB_MICROWIRE | 
                        DataSize[16]) ;
 WordLength = DataSize[16] ;
 CalculateTimeout(PRE_1 , SSPTB_SCLK_RATE0 );
 TestMW(8,16);
 Idle(5);

 C(" Baud 0, Wordlength 15");
 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg(SSP_SCLK_RATE0 | SSP_MICROWIRE | DataSize[15],  SSPCR0,32);
 
 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 ProgramReg(0x0 ,  SSPTBSCR1, 5);
 
 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE0 | SSPTB_MICROWIRE | 
                        DataSize[15]) ;
 WordLength = DataSize[15] ;
 TestMW(8,15);
 Idle(7);

 C(" Baud 0, Wordlength 14");
 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg(SSP_SCLK_RATE0 | SSP_MICROWIRE | DataSize[14],  SSPCR0,32);
 
 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 ProgramReg(0x0 ,  SSPTBSCR1, 5);
 
 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE0 | SSPTB_MICROWIRE | 
                        DataSize[14]) ;
 WordLength = DataSize[14] ;
 TestMW(8,14);
 Idle(4);

 C(" Baud 1, Wordlength 13");
 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg(SSP_SCLK_RATE1 | SSP_MICROWIRE | DataSize[13],  SSPCR0,32);
 
 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 ProgramReg(0x0 ,  SSPTBSCR1, 5);

 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE1 | SSPTB_MICROWIRE |
                        DataSize[13]) ;
 WordLength = DataSize[13] ;
 CalculateTimeout(PRE_1 , SSPTB_SCLK_RATE1 );
 TestMW(8,13);
 Idle(6);

 C(" Baud 1, Wordlength 12");
 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg(SSP_SCLK_RATE1 | SSP_MICROWIRE | DataSize[12],  SSPCR0,32);
 
 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 ProgramReg(0x0 ,  SSPTBSCR1, 5);

 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE1 | SSPTB_MICROWIRE | 
                        DataSize[12]) ;
 WordLength = DataSize[12] ;
 TestMW(8,12); 
 Idle(9);

 C(" Baud 1, Wordlength 11");
 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg(SSP_SCLK_RATE1 | SSP_MICROWIRE | DataSize[11],  SSPCR0,32);
 
 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 ProgramReg(0x0 ,  SSPTBSCR1, 5);

 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE1 | SSPTB_MICROWIRE |
                        DataSize[11]) ;
 WordLength = DataSize[11] ;
 TestMW(8,11);
 Idle(8);

 C(" Baud 1, Wordlength 10");
 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg(SSP_SCLK_RATE1 | SSP_MICROWIRE | DataSize[10],  SSPCR0,32);
 
 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 ProgramReg(0x0 ,  SSPTBSCR1, 5);

 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE1 | SSPTB_MICROWIRE |  
                        DataSize[10]) ;
 WordLength = DataSize[10] ;
 TestMW(8,10);
 Idle(4);

 C(" Baud 2, Wordlength 9");
 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg(SSP_SCLK_RATE2 | SSP_MICROWIRE | DataSize[9],  SSPCR0,32);
 
 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 ProgramReg(0x0 ,  SSPTBSCR1, 5);

 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE2 | SSPTB_MICROWIRE |
                        DataSize[9]) ;
 WordLength = DataSize[9] ;
 CalculateTimeout(PRE_1 , SSPTB_SCLK_RATE2 );
 TestMW(8,9); 
 Idle(9);

 C(" Baud 2, Wordlength 8");
 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg(SSP_SCLK_RATE2 | SSP_MICROWIRE | DataSize[8],  SSPCR0,32);
 
 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 ProgramReg(0x0 ,  SSPTBSCR1, 5);

 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE2 | SSPTB_MICROWIRE |
                        DataSize[8]) ;
 WordLength = DataSize[8] ;
 TestMW(8,8); 
 Idle(7);

 C(" Baud 2, Wordlength 7");
 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg(SSP_SCLK_RATE2 | SSP_MICROWIRE | DataSize[7],  SSPCR0,32);
 
 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 ProgramReg(0x0 ,  SSPTBSCR1, 5);

 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE2 | SSPTB_MICROWIRE |  
                        DataSize[7]) ;
 WordLength = DataSize[7] ;
 TestMW(8,7); 
 Idle(5);

 C(" Baud 3, Wordlength 6");
 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg(SSP_SCLK_RATE3 | SSP_MICROWIRE | DataSize[6],  SSPCR0,32);
 
 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 ProgramReg(0x0 ,  SSPTBSCR1, 5);

 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE3 | SSPTB_MICROWIRE |  
                        DataSize[6]) ;
 WordLength = DataSize[6] ;
 CalculateTimeout(PRE_1 , SSPTB_SCLK_RATE3 );
 TestMW(8,6); 
 Idle(5);

 C(" Baud 3, Wordlength 5");
 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg(SSP_SCLK_RATE3 | SSP_MICROWIRE | DataSize[5],  SSPCR0,32);
 
 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 ProgramReg(0x0 ,  SSPTBSCR1, 5);

 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE3 | SSPTB_MICROWIRE | 
                        DataSize[5]) ;
 WordLength = DataSize[5] ;
 TestMW(8,5); 
 Idle(9);

 C(" Baud 3, Wordlength 4");
 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg(SSP_SCLK_RATE3 | SSP_MICROWIRE | DataSize[4],  SSPCR0,32);
 
 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 ProgramReg(0x0 ,  SSPTBSCR1, 5);

 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE3 | SSPTB_MICROWIRE | 
                        DataSize[4]) ;
 WordLength = DataSize[4] ;
 TestMW(8,4); 

 /* Disable SSP and SSPTB */
 ProgramReg( 0x0 ,SSPCR1,5);
 ProgramReg( 0x0 , SSPTBSCR0 ,5);
 
 C("Microwire Frame Format Test End");

}/* End Function */
