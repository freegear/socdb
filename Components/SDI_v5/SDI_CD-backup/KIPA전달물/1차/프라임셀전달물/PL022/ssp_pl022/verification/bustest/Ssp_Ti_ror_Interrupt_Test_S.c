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
--  File Name              : Ssp_Ti_ror_Interrupt_Test_S.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function Ti_ror_Interrupt_Test_S
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void Ti_ror_Interrupt_Test_S()
{
  /* 
  Summary: ROR Interrupt Test for Slave
  =====================================
  
  o These tests check the generation of ROR interrupts. The values
    of SSPRORINTR and SSPINTR are checked through the Interrupt
    Identification Registers. This test is being conducted in the TI    
    mode.

  */

  int32 SSPTB_SCR0_VALUE  ;
  int32 SSP_SCR0_VALUE  ;

 C("TI ROR INTERRUPT TEST for Slave");
 
 C("Baud 6, Wordlength 16, RXW_4");

 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg(SSP_SCLK_RATE6 | SSP_TI | DataSize[16] , SSPCR0,32);
 ssp_enable_value_scr1 = (SSP_ENABLE | SSP_MS);
 ProgramReg(SSP_MS,SSPCR1,32);
 /* Mask ALL interrupts */
 ProgramReg(SSP_IMCLR, SSPIMSC, 5);
 
 /* Program SSPTB */
 ProgramReg(PRE_1 , SSPTBPRE ,5 );
 ProgramReg(SSPTB_TI,SSPTBSCR0,5);
 RXW_Value = ( SSPTB_RXW_4   );
 ProgramReg( RXW_Value |  SSPTB_MS , SSPTBSCR1, 5);
 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE6 | SSPTB_TI |  
                        DataSize[16]) ;
 WordLength = DataSize[16] ;
 CalculateTimeout(PRE_1 , SSPTB_SCLK_RATE6 );
 ROR_Test_S();

 /* Disable SSP and SSPTB */
 ProgramReg(0x00 ,SSPTBSCR0 ,5);
 ProgramReg(0x00 ,SSPTBSCR1 ,5);
 ProgramReg(0x0  ,SSPCR1    ,5);
 
 C("ROR Interrupt Test End for Slave" );

}/* End Function */
