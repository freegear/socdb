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
--  File Name              : Ssp_Nm_Data_Discard_Test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function Nm_Data_Discard_Test
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void Nm_Data_Discard_Test()
{

  /*
  Summary: Data discard test for Slave in NM mode
  ===============================================
  This test verifies that the SSP discards a frame in the NM mode if it is
  disabled midway through a frame. Both the data being transmitted and the data
  being received are discarded.

  One data word each is written to the Transmit FIFOs of the SSP and the 
  Trickbox. Data transfer is enabled, and midway through a frame, the SSP and 
  the Trickbox are disabled. The SSP is then expected to return to Idle with
  the Transmit FIFO and the Receive FIFO empty.
  */

  int buffer[32];
  int i ;

 C("NM data Discard Test for Slave");
 
 C("Baud 5, Wordlength 16");
 
 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg(SSP_SCLK_RATE5 | SSP_MICROWIRE | DataSize[16] , SSPCR0,32);
 ProgramReg(SSP_MS ,SSPCR1,32);
 
 /* Program SSPTB */
 ProgramReg(PRE_1, SSPTBPRE, 5 );
 ProgramReg(0x10,  SSPTBSCR1, 5);
 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE5 | SSPTB_MICROWIRE
                        | DataSize[16]) ;
 WordLength = DataSize[16] ;
 CalculateTimeout(PRE_1 , SSPTB_SCLK_RATE5);
 
 for(i=0;i<32; i++)
        buffer[i] = 0x5555;
 
 /* Read SSP Status register */
    PSR( SSP_TNF | SSP_TFE ,masks[5],SSPSR,NM_N_0);
 
 /* Write word to SSP  */
 for(i=0; i< 1 ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength], SSPDR, 1 );
  }
 
 /* Read SSP Status register */
    PO( SSP_BSY | SSP_TNF , masks[5] , SSPSR , TimeOut ,NM_N_1);
    PSR(SSP_BSY | SSP_TNF ,masks[5],SSPSR,NM_N_1);
 
 /* Write data to SSPTB  */
 for(i=0; i< 1 ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength], SSPTBSTDR, 5 );
  }
 
 /* Enable SSP  */
    ProgramReg(SSP_ENABLE | SSP_MS ,SSPCR1,5);
 
 /* Enable SSPTB  */
    ProgramReg(ssptb_enable_value ,SSPTBSCR0,5);

   Idle (6 * PRE_1 * (SSPTB_SCLK_RATE5/256 + 1) * SSPCLK_PERIOD / PCLK_PERIOD );

 /* Disable SSP and SSPTB */
    ProgramReg(0x00 , SSPTBSCR0 ,5 );
    ProgramReg(0x00,SSPTBSCR1,5);
    ProgramReg(0x0 ,SSPCR1,5);
 
 /* Wait until transmission is over and SSP flags are set */
   PO( SSP_TNF | SSP_BSY, masks[5], SSPSR, TimeOut ,NM_N_4);
   PSR( SSP_TNF | SSP_BSY, masks[5], SSPSR,NM_N_4);
   PO(SSPTB_TXFE | SSPTB_RXFE ,masks[9],SSPTBSSR, TimeOut,NM_N_12);
   PSR(SSPTB_TXFE | SSPTB_RXFE ,masks[9],SSPTBSSR, NM_N_12);

 
 /* Program SSP */
    ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
    ProgramReg(SSP_SCLK_RATE5 | SSP_MICROWIRE | DataSize[16] , SSPCR0,32);
    ProgramReg(SSP_MS ,SSPCR1,32);
 
 /* Program SSPTB */
    ProgramReg(PRE_1, SSPTBPRE, 5 );
    ProgramReg(0x10,  SSPTBSCR1, 5);
 
 
 /* Read SSP Status register */
     PO( SSP_BSY | SSP_TNF , masks[5] , SSPSR , TimeOut ,NM_N_1);
     PSR(SSP_BSY | SSP_TNF ,masks[5],SSPSR,NM_N_1);
 
 /* Write data to SSPTB  */
 for(i=0; i< 1 ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength], SSPTBSTDR, 5 );
  }
 
 /* Enable SSP  */
    ProgramReg(SSP_ENABLE | SSP_MS ,SSPCR1,5);
 
 /* Enable SSPTB  */
    ProgramReg(ssptb_enable_value ,SSPTBSCR0,5);

    Idle (24 * PRE_1 * (SSPTB_SCLK_RATE5/256 + 1) * SSPCLK_PERIOD / PCLK_PERIOD );

    /* Perform a FIFO read to clear the FIFO prior to subsequent tests */
    PSR(buffer[i] & Masks[7] ,Masks[7] ,SSPDR, fifo_clear);

 /* Disable SSP and SSPTB */
    ProgramReg(0x00 , SSPTBSCR0 ,5 );
    ProgramReg(0x00,SSPTBSCR1,5);
    ProgramReg(0x0 ,SSPCR1,5);
 
 /* Wait until transmission is over and SSP flags are set */
   PO( SSP_TNF | SSP_TFE, masks[5], SSPSR, TimeOut ,NM_N_4);
   PSR( SSP_TNF | SSP_TFE, masks[5], SSPSR,NM_N_4);
   PO(SSPTB_TXFE | SSPTB_RXFE ,masks[9],SSPTBSSR, TimeOut,NM_N_12);
   PSR(SSPTB_TXFE | SSPTB_RXFE ,masks[9],SSPTBSSR, NM_N_12);
 
    C("NM Data Discard test for Slave over");
 
}/* End Function */
