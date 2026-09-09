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
--  File Name              : Ssp_NonBacktoBack_Test.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function NonBacktoBack_Test
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void NonBacktoBack_Test(int32 SSP_SCLK_RATE,int32 spo,int32 sph,int32 mode)
{
   /*

   Summary: Mode Non Backtoback Test 
   ====================================
 
 The purpose of this test is to check the SSP transmission and
 reception operations in non back to back mode. A block of four
 data words are written into the Tx FIFO of the SSP. The SSP is 
 enabled and allowed to finish transmission.The received data is
 read and compared for error free transmission/reception. After
 some idle time (without disabling the SSP) a block of three data
 words written to the SSP and polled till the transmission is over.
 The received data is read and compared for error free transmission
 / reception. Every time a block of different data values are written
 to the SSP and the above process is repeated.

   */
 
  int SSPDataBuffer[32];
  int TBDataBuffer[32];
  int i ;
  int32 SSPTB_SCLK_RATE;
 
 SSPTB_SCLK_RATE = SSP_SCLK_RATE;

 C("Non Back to Back Test");
  
 C(" Wordlength 16");

 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );

 /* Program SSPTB */
 ProgramReg(PRE_1, SSPTBPRE, 5 );
 WordLength = DataSize[16] ;
 CalculateTimeout(PRE_1 , SSPTB_SCLK_RATE);

 if (mode == SSPTB_SPI)
 {
  ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE | SSPTB_SPI
                        | DataSize[16]) ;
  if(spo==0 && sph==0)
    {
     ProgramReg(SSP_SCLK_RATE | SSP_SPI00 | DataSize[16] , SSPCR0,32);
     ProgramReg(SSPTB_SPI00 ,  SSPTBSCR1, 5);
    }
  else if(spo==1 && sph==0)
    {
     ProgramReg(SSP_SCLK_RATE | SSP_SPI01 | DataSize[16] , SSPCR0,32);
     ProgramReg(SSPTB_SPI01 ,  SSPTBSCR1, 5);
    }
  else if(spo==0 && sph==1)
    {
     ProgramReg(SSP_SCLK_RATE | SSP_SPI10 | DataSize[16] , SSPCR0,32);
     ProgramReg(SSPTB_SPI10 ,  SSPTBSCR1, 5);
    }
  else if(spo==1 && sph==1)
    {
     ProgramReg(SSP_SCLK_RATE | SSP_SPI11 | DataSize[16] , SSPCR0,32);
     ProgramReg(SSPTB_SPI11 ,  SSPTBSCR1, 5);
    }
 }
 else if(mode == SSP_TI)
 {
   ProgramReg(SSP_SCLK_RATE | SSP_TI | DataSize[16] , SSPCR0,32);
   ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE | SSPTB_TI
                        | DataSize[16]) ;
 
 }
 else if(mode == SSP_MICROWIRE)
 {
   ProgramReg(SSP_SCLK_RATE | SSP_MICROWIRE | DataSize[16] , SSPCR0,32);
   ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE | SSPTB_MICROWIRE
                        | DataSize[16]) ;
 
 }

 for(i=0;i<32; i++)
       SSPDataBuffer[i] = i;
 
  for(i=0;i<32; i++)
        TBDataBuffer[i] =  i % 2 ;

 /* Read SSP Status register */
 PSR( SSP_TNF | SSP_TFE ,masks[8],SSPSR,N_0);

 /* Write four words to SSP  */
 for(i=0; i< 4 ; i++)
  {
    ProgramReg(SSPDataBuffer[i] & Masks[WordLength], SSPDR, 1 );
  }
 
 /* Read SSP Status register */
 PO( SSP_BSY | SSP_TNF , masks[5] , SSPSR , TimeOut ,N_1);
 PSR(SSP_BSY | SSP_TNF ,masks[5],SSPSR,N_1);
 
 /* Enable SSPTB  */
 ProgramReg(ssptb_enable_value ,SSPTBSCR0,5);

 /* Write data to SSPTB  */
 for(i=0; i< 16 ; i++)
 {
  ProgramReg(TBDataBuffer[i] & Masks[WordLength], SSPTBSTDR, 5 );
 } 

 /* Enable SSP  */
 ProgramReg(SSP_ENABLE,SSPCR1,5); 
 
 /* During 1st word transmission  */
 PO( SSP_BSY | SSP_TNF , masks[5] , SSPSR , TimeOut,N_2);
 PSR(SSP_BSY | SSP_TNF , masks[5] , SSPSR ,N_2);
 
 /* After one word transmission is over  */
 PO(  SSP_BSY | SSP_RNE | SSP_TNF , masks[5] , SSPSR , 2*TimeOut,N_3);
 PSR( SSP_BSY | SSP_RNE | SSP_TNF , masks[5] , SSPSR ,N_3);
 
 /* Wait until transmission is over and SSP flags are set */
 PO(  SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR,8*TimeOut ,N_4);
 PSR( SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR,N_4);
 
 /* Read 4 words */
 if(mode == SSP_MICROWIRE)
 {
  for(i=0; i< 4 ; i++)
   {
    PSR(TBDataBuffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,mw_N_data4);
    PSR(SSPDataBuffer[i] & Masks[7] ,Masks[WordLength] ,SSPTBSRDR,MW_N_DATA4);
    }
 }
 else
 {
  for(i=0; i< 4 ; i++)
  {
   PSR(TBDataBuffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,N_data4);
   PSR(SSPDataBuffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,N_DATA4);
  }
 }


 /* Read SSP Status register */
 PO(  SSP_TNF | SSP_TFE , masks[5], SSPSR, 3*TimeOut,N_5);
 PSR( SSP_TNF | SSP_TFE , masks[5], SSPSR,N_5);

 if (mode == SSPTB_SPI && sph == 1 )
 {
  ProgramReg(0x00 , SSPTBSCR0 ,10 );
  Idle(12);
  ProgramReg(ssptb_enable_value ,SSPTBSCR0,5);
 }

 /* Write three words to the SSP  */
 for(i=4; i< 7 ; i++)
 {
  ProgramReg(SSPDataBuffer[i] & Masks[WordLength], SSPDR, 1 );
 }

 /* During 1st word transmission   */
 PO( SSP_BSY | SSP_TNF , masks[5] , SSPSR , 2*TimeOut,N_6);
 PSR(SSP_BSY | SSP_TNF , masks[5] , SSPSR ,N_6);
 
 /* After one word transmission is over  */
 PO(  SSP_BSY | SSP_RNE | SSP_TNF , masks[5] , SSPSR , 2*TimeOut,N_7);
 PSR( SSP_BSY | SSP_RNE | SSP_TNF , masks[5] , SSPSR ,N_7);
 
 /* Wait until transmission is over and SSP flags are set */
 PO(  SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR, 6*TimeOut ,N_8);
 PSR( SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR,N_8);
 
 /* Read next 3 words */
 if(mode == SSP_MICROWIRE)
 {
  for(i=4; i< 7 ; i++)
   {
    PSR(TBDataBuffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,mw_N_data4);
    PSR(SSPDataBuffer[i] & Masks[7] ,Masks[WordLength] ,SSPTBSRDR,MW_N_DATA4);
    }
 }
 else
 {
  for(i=4; i< 7 ; i++)
  {
   PSR(TBDataBuffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,N_data3);
   PSR(SSPDataBuffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,N_DATA3);
  }
 }


 /* Read SSP Status register */
 PO(  SSP_TNF | SSP_TFE , masks[5], SSPSR, 3*TimeOut,N_9);
 PSR( SSP_TNF | SSP_TFE , masks[5], SSPSR,N_9);

 if (mode == SSPTB_SPI && sph == 1 )
 {
 ProgramReg(0x00 , SSPTBSCR0 ,10 );
 Idle(15);
 ProgramReg(ssptb_enable_value ,SSPTBSCR0,5);
 }

 /* Write two words to the SSP  */
 for(i=7; i< 9 ; i++)
 {
  ProgramReg(SSPDataBuffer[i] & Masks[WordLength], SSPDR, 1 );
 }

 /* During 1st word transmission   */
 PO( SSP_BSY | SSP_TNF , masks[5] , SSPSR , TimeOut,N_a);
 PSR(SSP_BSY | SSP_TNF , masks[5] , SSPSR ,N_a);
 
 /* Wait until transmission is over and SSP flags are set */
 PO(  SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR, 6*TimeOut ,N_c);
 PSR( SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR,N_c);
 
 /* Read next 2 words */
 if(mode == SSP_MICROWIRE)
 {
  for(i=7; i< 9 ; i++)
   {
    PSR(TBDataBuffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,mw_N_data4);
    PSR(SSPDataBuffer[i] & Masks[7] ,Masks[WordLength] ,SSPTBSRDR,MW_N_DATA4);
    }
 }
 else
 {
  for(i=7; i< 9 ; i++)
  {
  PSR(TBDataBuffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,N_data2);
  PSR(SSPDataBuffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,N_DATA2);
  }
 }


 /* Read SSP Status register */
 PO(  SSP_TNF | SSP_TFE , masks[5], SSPSR, 3*TimeOut,N_d);
 PSR( SSP_TNF | SSP_TFE , masks[5], SSPSR,N_d);

 if (mode == SSPTB_SPI && sph == 1 )
 {
 ProgramReg(0x00 , SSPTBSCR0 ,10 );
 Idle(27);
 ProgramReg(ssptb_enable_value ,SSPTBSCR0,5);
 }

 /* Write five words to the SSP  */
 for(i=9; i< 14 ; i++)
 {
  ProgramReg(SSPDataBuffer[i] & Masks[WordLength], SSPDR, 1 );
 }

 /* During 1st word transmission   */
 PO( SSP_BSY | SSP_TNF , masks[5] , SSPSR , TimeOut,N_e);
 PSR(SSP_BSY | SSP_TNF , masks[5] , SSPSR ,N_e);
 
 /* After one word transmission is over  */
 PO(  SSP_BSY | SSP_RNE | SSP_TNF , masks[5] , SSPSR , 2*TimeOut,N_f);
 PSR( SSP_BSY | SSP_RNE | SSP_TNF , masks[5] , SSPSR ,N_f);
 
 /* Wait until transmission is over and SSP flags are set */
 PO(  SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR, 10*TimeOut ,N_10);
 PSR( SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR,N_10);
 
 /* Read next 2 words */
 if(mode == SSP_MICROWIRE)
 {
  for(i=9; i< 14 ; i++)
   {
    PSR(TBDataBuffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,mw_N_data4);
    PSR(SSPDataBuffer[i] & Masks[7] ,Masks[WordLength] ,SSPTBSRDR,MW_N_DATA4);
    }
 }
 else
 {
  for(i=9; i< 14 ; i++)
  {
   PSR(TBDataBuffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,N_data2);
   PSR(SSPDataBuffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,N_DATA2);
  }
 }

 if (mode == SSPTB_SPI && sph == 1 )
 {
 ProgramReg(0x00 , SSPTBSCR0 ,10 );
 Idle(19);
 ProgramReg(ssptb_enable_value ,SSPTBSCR0,5);
 }

 /* Write four words to the SSP  */
 for(i=14; i< 16 ; i++)
 {
  ProgramReg(SSPDataBuffer[i] & Masks[WordLength], SSPDR, 1 );
 }

 /* During 1st word transmission   */
 PO( SSP_BSY | SSP_TNF , masks[5] , SSPSR , TimeOut,N_11);
 PSR(SSP_BSY | SSP_TNF , masks[5] , SSPSR ,N_11);
 
 /* Wait until transmission is over and SSP flags are set */
 PO(  SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR, 6*TimeOut ,N_13);
 PSR( SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR,N_13);
 
 /* Read next 2 words */
 if(mode == SSP_MICROWIRE)
 {
  for(i=14; i< 16 ; i++)
   {
    PSR(TBDataBuffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,mw_N_data4);
    PSR(SSPDataBuffer[i] & Masks[7] ,Masks[WordLength] ,SSPTBSRDR,MW_N_DATA4);
    }
 }
 else
 {
  for(i=14 ; i< 16 ; i++)
  {
   PSR(TBDataBuffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,N_data24);
   PSR(SSPDataBuffer[i] & Masks[WordLength],Masks[WordLength],SSPTBSRDR,N_DATA24);
  }
 }

 /* Disable SSP and SSPTB */
 ProgramReg(0x0 ,SSPCR1,5);
 ProgramReg(0x00 , SSPTBSCR0 ,5 );
 
 C("Non Back to Back test over");
 
}/* End Function */
