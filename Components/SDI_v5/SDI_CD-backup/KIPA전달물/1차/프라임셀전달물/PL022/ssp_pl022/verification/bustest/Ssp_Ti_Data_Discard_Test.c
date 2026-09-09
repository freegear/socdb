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
--  File Name              : Ssp_Ti_Data_Discard_Test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function Ti_Data_Discard_Test
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void Ti_Data_Discard_Test()
{

  /*
  Summary: Data discard test for Slave in TI mode
  ===============================================
  This test verifies that the SSP discards a frame in the TI mode if it is
  disabled midway through a frame. Both the data being transmitted and the data
  being received are discarded.

  One data word each is written to the Transmit FIFOs of the SSP and the 
  Trickbox. Data transfer is enabled, and midway through a frame, the SSP and 
  the Trickbox are disabled. The SSP is then expected to return to Idle with
  the Transmit FIFO and the Receive FIFO empty.
  */

  int buffer[32];
  int i ;

 C("TI data Discard Test for Slave");
 
 C("Baud 5, Wordlength 16");
 
 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg(SSPTB_TI ,SSPTBSCR0,5);
 ProgramReg(SSP_SCLK_RATE5 | SSP_TI | DataSize[16] , SSPCR0,32);
 ProgramReg(SSP_MS ,SSPCR1,32);
 
 /* Program SSPTB */
 ProgramReg(PRE_1, SSPTBPRE, 5 );
 ProgramReg(0x10,  SSPTBSCR1, 5);
 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE5 | SSPTB_TI
                        | DataSize[16]) ;
 WordLength = DataSize[16] ;
 CalculateTimeout(PRE_1 , SSPTB_SCLK_RATE5);
 
 for(i=0;i<32; i++)
        buffer[i] = 0x5555;
 
 /* Read SSP Status register */
        PSR( SSP_TNF | SSP_TFE ,masks[5],SSPSR,TI_N_0);
 
 /* Write word to SSP  */
 for(i=0; i< 1 ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength], SSPDR, 1 );
  }
 
 /* Read SSP Status register */
     PO( SSP_BSY | SSP_TNF , masks[5] , SSPSR , TimeOut ,TI_N_1);
     PSR(SSP_BSY | SSP_TNF ,masks[5],SSPSR,TI_N_1);
 
 /* Write data to SSPTB  */
 for(i=0; i< 1 ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength], SSPTBSTDR, 5 );
  }
 
 /* Enable SSP  */
    ProgramReg(SSP_ENABLE | SSP_MS ,SSPCR1,5);
 
 /* Enable SSPTB  */
    ProgramReg(ssptb_enable_value ,SSPTBSCR0,5);

   Idle (8 * PRE_1 * (SSPTB_SCLK_RATE5/256 + 1) * SSPCLK_PERIOD / PCLK_PERIOD );

 /* Disable SSP and SSPTB */
    ProgramReg(0x00 , SSPTBSCR0 ,5 );
    ProgramReg(0x00,SSPTBSCR1,5);
    ProgramReg(0x0 ,SSPCR1,5);
 
 /* Wait until transmission is over and SSP flags are set */
   PO( SSP_TNF | SSP_TFE, masks[5], SSPSR, TimeOut ,TI_N_4);
   PSR( SSP_TNF | SSP_TFE, masks[5], SSPSR,TI_N_4);
   PO(SSPTB_TXFE | SSPTB_RXFE,masks[9],SSPTBSSR, TimeOut,TI_N_12);
   PSR(SSPTB_TXFE | SSPTB_RXFE,masks[9],SSPTBSSR, TI_N_12);
 
    C("TI Data Discard test for Slave over");
 
}/* End Function */
