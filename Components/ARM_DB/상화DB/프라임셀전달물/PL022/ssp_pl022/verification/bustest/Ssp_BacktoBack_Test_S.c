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
--  File Name              : Ssp_BacktoBack_Test_S.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function BacktoBack_Test_S
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void BacktoBack_Test_S(int32 SSP_SCLK_RATE,int32 spo,int32 sph,int32 mode)
{
   /*
   Summary: Backtoback Mode Tests For Slave 
   ===========================================
 
   o In this test several bytes are written to the SSP and the trickbox
     and both devices are enabled. The trickbox Rx watermark level is set
     to four and when the trickbox receives four data words, four more data
     words are written to the SSP. The received data is compared for 
     error free transmission.
   */

  int32 SSPTB_SCR0_VALUE  ;
  int32 SSP_SCR0_VALUE  ;
  int32 SSPTB_SCLK_RATE;
 
 SSPTB_SCLK_RATE = SSP_SCLK_RATE;

 C(" Back to Back Test for Slave");
 
 C(" Wordlength 16 , RXW 4 ");

 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg(SSP_MS,SSPCR1,32);

 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 RXW_Value = SSPTB_RXW_4;
 WordLength = DataSize[16] ;
 CalculateTimeout(PRE_1 , SSPTB_SCLK_RATE );

 if (mode == SSPTB_SPI)
 {
  ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE | SSPTB_SPI
                        | DataSize[16]) ;
  if(spo==0 && sph==0)
    {
     ProgramReg(SSP_SCLK_RATE | SSP_SPI00 | DataSize[16] , SSPCR0,32);
     ProgramReg((RXW_Value & MASK_SSPTB_RXW) |SSPTB_SPI00 | SSPTB_MS, SSPTBSCR1,
 5);
    }
  else if(spo==1 && sph==0)
    {
     ProgramReg(SSP_SCLK_RATE | SSP_SPI01 | DataSize[16] , SSPCR0,32);
     ProgramReg((RXW_Value & MASK_SSPTB_RXW) |SSPTB_SPI01 | SSPTB_MS, SSPTBSCR1,
 5);
    }
  else if(spo==0 && sph==1)
    {
     ProgramReg(SSP_SCLK_RATE | SSP_SPI10 | DataSize[16] , SSPCR0,32);
     ProgramReg((RXW_Value & MASK_SSPTB_RXW) |SSPTB_SPI10 | SSPTB_MS, SSPTBSCR1,
 5);
    }
  else if(spo==1 && sph==1)
    {
     ProgramReg(SSP_SCLK_RATE | SSP_SPI11 | DataSize[16] , SSPCR0,32);
     ProgramReg((RXW_Value & MASK_SSPTB_RXW) |SSPTB_SPI11 | SSPTB_MS, SSPTBSCR1,
 5);
    }
 }
 else if(mode == SSP_TI)
 {
   ProgramReg(SSPTB_TI ,SSPTBSCR0,5);
   ProgramReg(SSP_SCLK_RATE | SSP_TI | DataSize[16] , SSPCR0,32);
   ProgramReg((RXW_Value & MASK_SSPTB_RXW) | SSPTB_MS,  SSPTBSCR1, 5);
   ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE | SSPTB_TI
                        | DataSize[16]) ;
 
 }
 else if(mode == SSP_MICROWIRE)
 {
   ProgramReg(SSP_SCLK_RATE | SSP_MICROWIRE | DataSize[16] , SSPCR0,32);
   ProgramReg((RXW_Value & MASK_SSPTB_RXW) | SSPTB_MS,  SSPTBSCR1, 5);
   ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE | SSPTB_MICROWIRE
                        | DataSize[16]) ;
 }

 Continuous_S(mode);
 Idle(10);

 /* Disable SSP and SSPTB */
 ProgramReg(0x00 , SSPTBSCR0 ,5 );
 ProgramReg(0x00 , SSPTBSCR1 ,5 );
 ProgramReg(0x0 ,SSPCR1,5);
 
}/* End Function */
