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
--  File Name              : Ssp_Mw_DeAssert_SFRM_Test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function Mw_DeAssert_SFRM_Test
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void Mw_DeAssert_SFRM_Test()
{

  /*
  Summary: SFRM deactivation test for Slave in NM mode
  ====================================================
  This test verifies that the SSP discards a frame in the NM mode if SFRMIN is
  negated midway through a frame.

  One data word is written to the SSP and the Trickbox. The Trickbox is
  programmed for a Receive data length of 8 and the SSP is programmed for a
  Transmit Data length of 12. When data transfer is allowed to occur, the data
  word transmitted by the Trickbox is expected to be received by the SSP, while
  the data word transmitted by the SSP is expected to get aborted after 8 bits
  have been received by the Trickbox and SFMIN is negated.

  TPR - Like Nm_Data_Discard_Test(), deassertion of SFRM during transmission of
  the Control word by the trickbox can be tested as follows:
  - Disable the Trickbox, but not the SSP, during the Transmission of the
    control word. i.e. say 4 SCLK periods after enabling the Trickbox,
    disable it. 
  - Wait for the SSP to become Idle. Then check the status register to verify 
    that it is empty.
  This test is to be added.
  */
 
  int buffer[32];
  int i ;

 C("Microwire DeAssert SFRAME Test for Slave");
  
 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg(SSP_SCLK_RATE5 | SSP_MICROWIRE | DataSize[12] , SSPCR0 ,32 );
 ProgramReg(SSP_MS , SSPCR1,32);

 /* Program SSPTB */
 ProgramReg(PRE_1, SSPTBPRE, 5 );
 ProgramReg(SSPTB_MS,  SSPTBSCR1, 5);

 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE5 | SSPTB_MICROWIRE 
                        | DataSize[8]) ;
 WordLength = DataSize[16] ;
 CalculateTimeout(PRE_1 , SSPTB_SCLK_RATE5);

 for(i=0;i<32; i++)
        buffer[i] = 0x5555;
 

 /* Read SSP Status register */
    PSR( SSP_TNF | SSP_TFE ,masks[5],SSPSR,MW_N_0);

 /* Enable SSP  */
    ProgramReg(SSP_ENABLE | SSP_MS,SSPCR1,5);
 
 /* Write one words to SSP  */
 for(i=0; i< 1 ; i++)
  {
    ProgramReg(buffer[i] , SSPDR, 1 );
  }
 
 /* Read SSP Status register */
     PO( SSP_BSY | SSP_TNF , masks[5] , SSPSR , TimeOut ,MW_N_1);
     PSR(SSP_BSY | SSP_TNF ,masks[5],SSPSR,MW_N_1);
 
 /* Write data to SSPTB  */
 for(i=0; i< 1 ; i++)
  {
    ProgramReg(buffer[i] , SSPTBSTDR, 5 );
  } 

 /* Enable SSPTB  */
    ProgramReg(ssptb_enable_value ,SSPTBSCR0,5);
 
 /* During 1st word transmission  */
   PO( SSP_BSY | SSP_TNF , masks[5] , SSPSR , TimeOut,MW_N_2);
   PSR(SSP_BSY | SSP_TNF , masks[5] , SSPSR ,MW_N_2);
   PO(SSPTB_RXFE | SSPTB_BSY |SSPTB_TXFE ,masks[9],SSPTBSSR, TimeOut,MW_N_11);
   PSR(SSPTB_RXFE | SSPTB_BSY |SSPTB_TXFE ,masks[9],SSPTBSSR,MW_N_11);
 
 /* Wait until transmission is over and SSP flags are set */
   PO(  SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR, TimeOut ,MW_N_4);
   PSR( SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR, MW_N_4);
   PO(SSPTB_TXFE ,masks[9],SSPTBSSR, TimeOut,MW_N_12);
   PSR(SSPTB_TXFE ,masks[9],SSPTBSSR, MW_N_12);

   Idle (16 * PRE_1 *(SSPTB_SCLK_RATE5/256 + 1)* SSPCLK_PERIOD / PCLK_PERIOD ); 

 /* Read 1 word */
   for(i=0; i< 1 ; i++)
   {
    PSR(buffer[i] & Masks[7] ,Masks[WordLength] ,SSPDR,MW_N_DATA4);
    PSR(buffer[i] & Masks[7] ,Masks[WordLength] ,SSPTBSRDR,MW_N_DATA4);
  }

 
 /* Disable SSP and SSPTB */
    ProgramReg(0x00 , SSPTBSCR0 ,5 );
    ProgramReg(0x00,SSPTBSCR1,5);
    ProgramReg(0x00 ,SSPCR1,5);
 
    Idle(10);

 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg(SSP_SCLK_RATE5 | SSP_MICROWIRE | DataSize[12] , SSPCR0 ,32 );
 ProgramReg(SSP_MS , SSPCR1,32);
 
 /* Program SSPTB */
 ProgramReg(PRE_1, SSPTBPRE, 5 );
 ProgramReg(SSPTB_MS,  SSPTBSCR1, 5);
 
 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE5 | SSPTB_MICROWIRE
                        | DataSize[8]) ;
 WordLength = DataSize[16] ;
 CalculateTimeout(PRE_1 , SSPTB_SCLK_RATE5);

 /* Read SSP Status register */
    PSR( SSP_TNF | SSP_TFE ,masks[5],SSPSR,MW_N_0);

 /* Enable SSP  */
    ProgramReg(SSP_ENABLE | SSP_MS,SSPCR1,5);
 
 /* Write four words to SSP  */
 for(i=0; i< 1 ; i++)
  {
    ProgramReg(buffer[i] , SSPDR, 1 );
  }
 
 /* Read SSP Status register */
    PO( SSP_BSY | SSP_TNF , masks[5] , SSPSR , TimeOut ,MW_N_1);
    PSR(SSP_BSY | SSP_TNF ,masks[5],SSPSR,MW_N_1);
 
 /* Write data to SSPTB  */
 for(i=0; i< 1 ; i++)
  {
    ProgramReg(buffer[i] , SSPTBSTDR, 5 );
  } 

 /* Enable SSPTB  */
    ProgramReg(ssptb_enable_value ,SSPTBSCR0,5);

   Idle (4 * PRE_1 * (SSPTB_SCLK_RATE5/256 + 1) * SSPCLK_PERIOD / PCLK_PERIOD );

 /* Disable SSPTB */
    ProgramReg(0x00 , SSPTBSCR0 ,5 );

 /* Read SSP flags */
   PO(SSP_BSY| SSP_TNF , masks[5], SSPSR, TimeOut ,MW_N_4);
   PSR(SSP_BSY | SSP_TNF , masks[5], SSPSR, MW_N_4);
   PO(SSPTB_TXFE | SSPTB_RXFE,masks[9],SSPTBSSR, TimeOut,MW_N_12);
   PSR(SSPTB_TXFE | SSPTB_RXFE,masks[9],SSPTBSSR, MW_N_12);

 /* Write data to SSPTB  */
 for(i=0; i< 1 ; i++)
  {
    ProgramReg(buffer[i] , SSPTBSTDR, 5 );
  }
 
 /* Enable SSPTB  */
    ProgramReg(ssptb_enable_value ,SSPTBSCR0,5);
 
 /* During 1st word transmission  */
   PO( SSP_BSY | SSP_TNF , masks[5] , SSPSR , TimeOut,MW_N_6);
   PSR(SSP_BSY | SSP_TNF , masks[5] , SSPSR ,MW_N_6);
   PO(SSPTB_RXFE | SSPTB_BSY |SSPTB_TXFE ,masks[9],SSPTBSSR, TimeOut,MW_N_13);
   PSR(SSPTB_RXFE | SSPTB_BSY |SSPTB_TXFE ,masks[9],SSPTBSSR,MW_N_13);
 
 /* Wait until transmission is over and SSP flags are set */
   PO(  SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR, TimeOut ,MW_N_8);
   PSR( SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR, MW_N_8);
   PO(SSPTB_TXFE ,masks[9],SSPTBSSR, TimeOut,MW_N_14);
   PSR(SSPTB_TXFE ,masks[9],SSPTBSSR, MW_N_14);

 /* Read 1 word */
   for(i=0; i< 1 ; i++)
   {
    PSR(buffer[i] & Masks[7] ,Masks[WordLength] ,SSPDR,MW_N_DATA4);
    PSR(buffer[i] & Masks[7] ,Masks[WordLength] ,SSPTBSRDR,MW_N_DATA4);
  }

 /* Disable SSP and SSPTB */
    ProgramReg(0x00 , SSPTBSCR0 ,5 );
    ProgramReg(0x00,SSPTBSCR1,5);
    ProgramReg(0x0 ,SSPCR1,5);
 
    C("MW DeAssert SFRAME test for Slave over");
 
}/* End Function */
