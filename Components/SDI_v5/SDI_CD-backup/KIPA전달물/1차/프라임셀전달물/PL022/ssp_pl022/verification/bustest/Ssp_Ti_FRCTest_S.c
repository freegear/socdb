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
--  File Name              : Ssp_Ti_FRCTest_S.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function Ti_FRCTest_S
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void Ti_FRCTest_S()
{
 
   /*
 
   Summary: Free Running Clock Test for Slave
   ==========================================
   The purpose of this test is to check whether the transmission or reception
 of data takes place correctly even when SCLK is free running i.e SCLK is
 active even when there is no data transfer in progress. This test verifies 
 device operation when the data transfer is intermittent with idle times 
 between transfers,during which SCLK is active. 
 
 
 */

  int SSPDataBuffer[32];
  int TBDataBuffer[32];
  int i ;

   C(" TI Free Running Clock Test for Slave");
   C("Baud 5, Wordlength 16");

 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg(SSP_SCLK_RATE5 | SSP_TI | DataSize[16] , SSPCR0,32);
 ProgramReg(SSP_MS,SSPCR1,32);

 /* Program SSPTB */
 ProgramReg(PRE_1, SSPTBPRE, 5 );
 ProgramReg(SSPTB_MS,  SSPTBSCR1, 5);
 ProgramReg(SSPTB_TI ,SSPTBSCR0,5);
 ProgramReg(SSPTB_FRC, SSPTBCR2 ,5);

 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE5 | SSPTB_TI 
                        | DataSize[16]) ;
 WordLength = DataSize[16] ;
 CalculateTimeout(PRE_1 , SSPTB_SCLK_RATE5);

 for(i=0;i<32; i++)
        SSPDataBuffer[i] = i;
 
  for(i=0;i<32; i++)
        TBDataBuffer[i] =  i % 2 ;

 /* Read SSP Status register */
 PSR( SSP_TNF | SSP_TFE ,masks[5],SSPSR,TI_N_0);

 /* Write one word to SSP  */
 for(i=1; i< 2 ; i++)
  {
    ProgramReg(SSPDataBuffer[i] & Masks[WordLength], SSPDR, 1 );
  }
 
 /* Read SSP Status register */
 PO( SSP_BSY | SSP_TNF , masks[5] , SSPSR , TimeOut ,TI_N_1);
 PSR(SSP_BSY | SSP_TNF ,masks[5],SSPSR,TI_N_1);
 
 /* Write data to SSPTB  */
 for(i=1; i< 2 ; i++)
  {
   ProgramReg(TBDataBuffer[i] & Masks[WordLength], SSPTBSTDR, 5 );
  } 

 /* Enable SSP  */
 ProgramReg(SSP_ENABLE | SSP_MS,SSPCR1,5); 
 
 /* Enable SSPTB  */
 ProgramReg(ssptb_enable_value ,SSPTBSCR0,5);

 /* During 1st word transmission  */
 PO( SSP_BSY | SSP_TNF , masks[5] , SSPSR , TimeOut,TI_N_2);
 PSR(SSP_BSY | SSP_TNF , masks[5] , SSPSR ,TI_N_2);
 
 /* Wait until transmission is over and SSP flags are set */
 PO(  SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR, TimeOut ,TI_N_4);
 PSR( SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR,TI_N_4);
 
 /* Read one data word */
 for(i=1; i< 2 ; i++)
 {
  PSR(TBDataBuffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,TI_N_data4);
  PSR(SSPDataBuffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,TI_N_DATA4);
  }

 Idle (PRE_1 * ((SSPTB_SCLK_RATE5>>8) + 1) * SSPCLK_PERIOD / PCLK_PERIOD );

 /* Read SSP Status register */
 PO(  SSP_TNF | SSP_TFE , masks[5], SSPSR, TimeOut,TI_N_5);
 PSR( SSP_TNF | SSP_TFE , masks[5], SSPSR,TI_N_5);

 /* Write one word to the SSP  */
 for(i=2; i< 3 ; i++)
 {
  ProgramReg(SSPDataBuffer[i] & Masks[WordLength], SSPDR, 1 );
 }

 /* Write data to SSPTB  */
 for(i=2; i< 3 ; i++)
 {
  ProgramReg(TBDataBuffer[i] & Masks[WordLength], SSPTBSTDR, 5 );
 } 

 /* During 1st word transmission   */
 PO( SSP_BSY | SSP_TNF , masks[5] , SSPSR , TimeOut,TI_N_6);
 PSR(SSP_BSY | SSP_TNF , masks[5] , SSPSR ,TI_N_6);
 
 /* Wait until transmission is over and SSP flags are set */
 PO(  SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR, TimeOut ,TI_N_8);
 PSR( SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR,TI_N_8);
 
 /* Read next data words */
 for(i=2; i< 3 ; i++)
 {
  PSR(TBDataBuffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,TI_N_data3);
  PSR(SSPDataBuffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,TI_N_DATA3);
 }

 Idle (PRE_1 * ((SSPTB_SCLK_RATE5>>8) + 1) * SSPCLK_PERIOD / PCLK_PERIOD );

 /* Read SSP Status register */
 PO(  SSP_TNF | SSP_TFE , masks[5], SSPSR, TimeOut,TI_N_9);
 PSR( SSP_TNF | SSP_TFE , masks[5], SSPSR,TI_N_9);

 /* Write two words to the SSP  */
 for(i=3; i< 5 ; i++)
 {
  ProgramReg(SSPDataBuffer[i] & Masks[WordLength], SSPDR, 1 );
  }

 /* Write data to SSPTB  */
 for(i=3; i< 5 ; i++)
 {
  ProgramReg(TBDataBuffer[i] & Masks[WordLength], SSPTBSTDR, 5 );
  } 

 /* During 1st word transmission   */
 PO( SSP_BSY | SSP_TNF , masks[5] , SSPSR , TimeOut,TI_N_a);
 PSR(SSP_BSY | SSP_TNF , masks[5] , SSPSR ,TI_N_a);
 
 /* Wait until transmission is over and SSP flags are set */
 PO(  SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR, 3*TimeOut ,TI_N_c);
 PSR( SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR,TI_N_c);
 
 /* Read next 2 words */
 for(i=3; i< 5 ; i++)
 {
  PSR(TBDataBuffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,TI_N_data2);
  PSR(SSPDataBuffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,TI_N_DATA2);
  }

 Idle (PRE_1 * ((SSPTB_SCLK_RATE5>>8) + 1) * SSPCLK_PERIOD / PCLK_PERIOD );

 /* Read SSP Status register */
 PO(  SSP_TNF | SSP_TFE , masks[5], SSPSR, TimeOut,TI_N_d);
 PSR( SSP_TNF | SSP_TFE , masks[5], SSPSR,TI_N_d);

 /* Write two words to the SSP  */
 for(i=5; i< 7 ; i++)
 {
  ProgramReg(SSPDataBuffer[i] & Masks[WordLength], SSPDR, 1 );
  }

 /* Write data to SSPTB  */
 for(i=5; i< 7 ; i++)
 {
  ProgramReg(TBDataBuffer[i] & Masks[WordLength], SSPTBSTDR, 5 );
 } 

 /* During 1st word transmission   */
 PO( SSP_BSY | SSP_TNF , masks[5] , SSPSR , TimeOut,TI_N_e);
 PSR(SSP_BSY | SSP_TNF , masks[5] , SSPSR ,TI_N_e);

 /* After one word transmission is over  */
 PO(  SSP_BSY | SSP_RNE | SSP_TNF , masks[5] , SSPSR , TimeOut,TI_N_f);
 PSR( SSP_BSY | SSP_RNE | SSP_TNF , masks[5] , SSPSR ,TI_N_f);
 
 /* Wait until transmission is over and SSP flags are set */
 PO(  SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR, 3*TimeOut ,TI_N_10);
 PSR( SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR,TI_N_10);
 
 /* Read next 2 words */
 for(i=5; i< 7 ; i++)
 {
  PSR(TBDataBuffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,TI_N_data2);
  PSR(SSPDataBuffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,TI_N_DATA2);
  }

 Idle (PRE_1 * ((SSPTB_SCLK_RATE5>>8) + 1) * SSPCLK_PERIOD / PCLK_PERIOD );

 /* Write one word to the SSP  */
 for(i=7; i< 8 ; i++)
 {
  ProgramReg(SSPDataBuffer[i] & Masks[WordLength], SSPDR, 1 );
 }

 /* Write data to SSPTB  */
 for(i=7; i< 8 ; i++)
 {
  ProgramReg(TBDataBuffer[i] & Masks[WordLength], SSPTBSTDR, 5 );
  } 

 /* During 1st word transmission   */
 PO( SSP_BSY | SSP_TNF , masks[5] , SSPSR , TimeOut,TI_N_11);
 PSR(SSP_BSY | SSP_TNF , masks[5] , SSPSR ,TI_N_11);
 
 /* Wait until transmission is over and SSP flags are set */
 PO(  SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR, TimeOut ,TI_N_13);
 PSR( SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR,TI_N_13);

 /* Read data words */
 for(i=7 ; i< 8 ; i++)
 {
  PSR(TBDataBuffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,TI_N_data24);
  PSR(SSPDataBuffer[i] & Masks[WordLength],Masks[WordLength],SSPTBSRDR,TI_N_DATA24);
  }

 Idle (PRE_1 * ((SSPTB_SCLK_RATE5>>8) + 1) * SSPCLK_PERIOD / PCLK_PERIOD );

 /* Write  three words to the SSP  */
 for(i=8; i< 11 ; i++)
 {
  ProgramReg(SSPDataBuffer[i] & Masks[WordLength], SSPDR, 1 );
 }

 /* Write data to SSPTB  */
 for(i=8; i< 11 ; i++)
 {
  ProgramReg(TBDataBuffer[i] & Masks[WordLength], SSPTBSTDR, 5 );
  } 

 /* During 1st word transmission   */
 PO( SSP_BSY | SSP_TNF , masks[5] , SSPSR , TimeOut,TI_N_11);
 PSR(SSP_BSY | SSP_TNF , masks[5] , SSPSR ,TI_N_11);

 /* Wait until transmission is over and SSP flags are set */
 PO(  SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR, 4*TimeOut ,TI_N_13);
 PSR( SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR,TI_N_13);
 
 /* Read data words */
 for(i=8 ; i< 11 ; i++)
 {
  PSR(TBDataBuffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,TI_N_data24);
  PSR(SSPDataBuffer[i] & Masks[WordLength],Masks[WordLength],SSPTBSRDR,TI_N_DATA24);
  }


 Idle (PRE_1 * ((SSPTB_SCLK_RATE5>>8) + 1) * SSPCLK_PERIOD / PCLK_PERIOD );

 /* Write six word to the SSP  */
 for(i=11; i< 16 ; i++)
 {
  ProgramReg(SSPDataBuffer[i] & Masks[WordLength], SSPDR, 1 );
 }

 /* Write data to SSPTB  */
 for(i=11; i< 16 ; i++)
 {
  ProgramReg(TBDataBuffer[i] & Masks[WordLength], SSPTBSTDR, 5 );
 } 

 /* During 1st word transmission   */
 PO( SSP_BSY | SSP_TNF , masks[5] , SSPSR , TimeOut,TI_N_11);
 PSR(SSP_BSY | SSP_TNF , masks[5] , SSPSR ,TI_N_11);
 
 /* Wait until transmission is over and SSP flags are set */
 PO(  SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR, 7*TimeOut ,TI_N_13);
 PSR( SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR,TI_N_13);
 
 /* Read data words */
 for(i=11 ; i< 16 ; i++)
 {
  PSR(TBDataBuffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,TI_N_data24);
  PSR(SSPDataBuffer[i] & Masks[WordLength],Masks[WordLength],SSPTBSRDR,TI_N_DATA24);
 }

 /* Disable SSP and SSPTB */
 ProgramReg(0x00 , SSPTBSCR0 ,5 );
 ProgramReg(0x00 , SSPTBSCR1 ,5 );
 ProgramReg(0x0 ,SSPCR1,5);
 ProgramReg(0x000, SSPTBCR2 ,5);
 
 C(" TI Free Running Clock Test for Slave over");

}/* End Function */
