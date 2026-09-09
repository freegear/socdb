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
--  File Name              : Ssp_Spi11_ris_Interrupt_Test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function Spi11_ris_Interrupt_Test
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void Spi11_ris_Interrupt_Test()
{
  /* 
  Summary: RIS Interrupt Tests
  ============================
  
  o These tests check the generation of RIS(Rx) interrupts. The values
    of SSPRXINTR and SSPINTR are checked through the Interrupt
    Identification Registers. This test is being conducted in the SPI11 
    mode.

  */


  int32 SSPTB_SCR0_VALUE  ;
  int32 SSP_SCR0_VALUE  ;
 
 C("SPI11 RIS INTERRUPT TEST");
 
 C("Baud 1, Wordlength 16, RXW_4");

 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg(SSP_SCLK_RATE1 | SSP_SPI11 | DataSize[16] , SSPCR0,32);
 ssp_enable_value_scr1 = (SSP_ENABLE) ;
 /* Mask ALL interrupts */
 ProgramReg(SSP_IMCLR, SSPIMSC, 5);

 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 RXW_Value = ( SSPTB_RXW_4   | SSPTB_SPI11 );
 ProgramReg( RXW_Value  , SSPTBSCR1, 5);
 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE1 | SSPTB_SPI | 
                        DataSize[16]) ;
 WordLength = DataSize[16] ;
 CalculateTimeout(PRE_1 , SSPTB_SCLK_RATE1 );
 RIS_Test(); 

 /* Disable SSP and SSPTB */
 ProgramReg(0x0 ,SSPCR1,5);
 ProgramReg(0x00 , SSPTBSCR0 ,5 );
  
 C("RIS Interrupt Test End " );

}/* End Function */
