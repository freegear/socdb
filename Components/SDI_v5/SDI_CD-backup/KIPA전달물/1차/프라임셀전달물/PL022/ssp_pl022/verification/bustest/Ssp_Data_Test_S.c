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
--  File Name              : Ssp_Data_Test_S.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function Data_Test_S
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void Data_Test_S(int32 SSP_SCLK_RATE,int32 spo,int32 sph,int32 mode)
{
   /*

   Summary: Data Check Test 
   ========================
 
    The purpose of this test is to check the the Setup and Hold times  
   in non back to back mode. A series of 1's and 0's are transmitted 
   as data to facilitate the toggling of the Transmit line. Any setup/hold
   violations on the data output line of the SSP with respect to the sampling
   edge of SCLKIN are flagged by the Trickbox.

   */
  int SSPDataBuffer[32];
  int TBDataBuffer[32];
  int i ;
  int32 SSPTB_SCLK_RATE;
 
 SSPTB_SCLK_RATE = SSP_SCLK_RATE;
 C(" data Test for Slave");
  
 C("Baud 5, Wordlength 16");

 /* Program SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg(SSP_MS ,SSPCR1,32);

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
     ProgramReg(SSPTB_SPI00 | SSPTB_MS,  SSPTBSCR1, 5);
    }
  else if(spo==1 && sph==0)
    { 
     ProgramReg(SSP_SCLK_RATE | SSP_SPI01 | DataSize[16] , SSPCR0,32);
     ProgramReg(SSPTB_SPI01 | SSPTB_MS,  SSPTBSCR1, 5);
    }
  else if(spo==0 && sph==1)
    {
     ProgramReg(SSP_SCLK_RATE | SSP_SPI10 | DataSize[16] , SSPCR0,32);
     ProgramReg(SSPTB_SPI10 | SSPTB_MS,  SSPTBSCR1, 5);
    }
  else if(spo==1 && sph==1)
    {
     ProgramReg(SSP_SCLK_RATE | SSP_SPI11 | DataSize[16] , SSPCR0,32);
     ProgramReg(SSPTB_SPI11 | SSPTB_MS,  SSPTBSCR1, 5);
    }
 }
 else if(mode == SSP_TI) 
 {
   ProgramReg(SSPTB_TI ,SSPTBSCR0,5);
   ProgramReg(SSP_SCLK_RATE | SSP_TI | DataSize[16] , SSPCR0,32);
   ProgramReg( SSPTB_MS,  SSPTBSCR1, 5);
  ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE | SSPTB_TI
                        | DataSize[16]) ;

 }
 else if(mode == SSP_MICROWIRE)
 {
   ProgramReg(SSP_SCLK_RATE | SSP_MICROWIRE | DataSize[16] , SSPCR0,32);
   ProgramReg( SSPTB_MS,  SSPTBSCR1, 5);
   ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE | SSPTB_MICROWIRE
                        | DataSize[16]) ;

 }
 
 for(i=0;i<32; i++)
        SSPDataBuffer[i] = 0x5555;
 
  for(i=0;i<32; i++)
        TBDataBuffer[i] =  0x5555;

 /* Read SSP Status register */
 PSR( SSP_TNF | SSP_TFE ,masks[5],SSPSR,N_0);

 /* Write four words to SSP  */
 for(i=0; i< 4 ; i++)
 {
  ProgramReg(SSPDataBuffer[i] & Masks[WordLength], SSPDR, 1 );
 }
 
 /* Read SSP Status register */
 PO( SSP_BSY | SSP_TNF , masks[5] , SSPSR , 5*TimeOut ,N_1);
 PSR(SSP_BSY | SSP_TNF ,masks[5],SSPSR,N_1);
 
 /* Write data to SSPTB  */
 for(i=0; i< 4 ; i++)
 {
  ProgramReg(TBDataBuffer[i] & Masks[WordLength], SSPTBSTDR, 5 );
 } 

 /* Enable SSP  */
 ProgramReg(SSP_ENABLE | SSP_MS ,SSPCR1,5); 
 
 /* Enable SSPTB  */
 ProgramReg(ssptb_enable_value ,SSPTBSCR0,5);

 /* During 1st word transmission  */
 PO( SSP_BSY | SSP_TNF , masks[5] , SSPSR , 5*TimeOut,N_2);
 PSR(SSP_BSY | SSP_TNF , masks[5] , SSPSR ,N_2);
 
 /* After one word transmission is over  */
 PO(  SSP_BSY | SSP_RNE | SSP_TNF , masks[5] , SSPSR , 5*TimeOut,N_3);
 PSR( SSP_BSY | SSP_RNE | SSP_TNF , masks[5] , SSPSR ,N_3);
 
 /* Wait until transmission is over and SSP flags are set */
 PO(  SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR, 8*TimeOut ,N_4);
 PSR( SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR,N_4);

 /* Read next 4 words */
 if(mode ==0x20)
 {
  for(i=0; i< 4 ; i++)
   {
    PSR(TBDataBuffer[i] & Masks[7] ,Masks[WordLength] ,SSPDR,mw_N_data4);
    PSR(SSPDataBuffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,MW_N_DATA4);
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
 
 /* Disable SSP and SSPTB */
 ProgramReg(0x00 , SSPTBSCR0 ,5 );
 ProgramReg(0x00,SSPTBSCR1,5);
 ProgramReg(0x0 ,SSPCR1,5);
 
 Idle(10);

}/* End Function */
