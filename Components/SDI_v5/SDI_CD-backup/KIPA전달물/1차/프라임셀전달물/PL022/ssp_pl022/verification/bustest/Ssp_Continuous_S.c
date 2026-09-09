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
--  File Name              : Ssp_Continuous_S.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function Continuous_S
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void Continuous_S(int32 mode)

{
  /* Called by BacktoBack_Test_S() */

  int32 buffer[32];
  int i;
  int32 time ;
  int FIFO_FLG ; 
 
 C("TEST Continuous for slave");
 
 for(i=0;i<32;i++)
 buffer[i]=i;

 /* Read SSP Status register */
 PSR( SSP_TNF | SSP_TFE ,masks[5],SSPSR,tt2_ssp13);
 
 /* Read SSPTB Status register */
 PSR(SSPTB_TXFE | SSPTB_RXFE ,masks[8],SSPTBSSR,tt2_tb_05);

 /* Write 8 data to the SSPTB  */
 for( i =0 ; i< 12 ; i++)
 {
  ProgramReg(buffer[i] & Masks[WordLength], SSPTBSTDR, 1);
 }

 /* Read SSPTB Status register */
 PO( SSPTB_RXFE , masks[8] , SSPTBSSR , 9*TimeOut ,TBtt2);  
 PSR(SSPTB_RXFE ,masks[8],SSPTBSSR,TBtt2);

 /* Write 8 data to the SSP  */
 for( i=0 ; i< 8 ; i++)
 {
  ProgramReg( buffer[i] & Masks[WordLength], SSPDR, 0 );
 } 

 /* Read SSP Status register */
 PO( SSP_BSY  , masks[5] , SSPSR , 9*TimeOut , tt2_1);
 PSR(SSP_BSY ,masks[5],SSPSR,tt2_1);

 /* Enable SSP  */
 ProgramReg(SSP_ENABLE |SSP_MS,SSPCR1,1);
 
 /* Enable SSPTB  */
 ProgramReg(ssptb_enable_value ,SSPTBSCR0,5);

 /* During transmission   */
 if(mode == 0x20)
 {
  PO(  SSP_BSY | SSP_TNF | SSP_RNE, masks[5] , SSPSR , 5*TimeOut, tt2_1B);
  PSR( SSP_BSY | SSP_TNF | SSP_RNE, masks[5],SSPSR,tt2_1B);
 }
 else
 {
 PO(  SSP_BSY | SSP_TNF , masks[5] , SSPSR , 3*TimeOut, tt2_1B);
 PSR( SSP_BSY | SSP_TNF , masks[5],SSPSR,tt2_1B);
 }

 /* After one data transmission is over  */
 if(mode == 0x20)
 {
  PO(  SSP_BSY | SSP_TNF | SSP_RNE, masks[5] , SSPSR , 5*TimeOut, tt2_1B);
  PSR( SSP_BSY | SSP_TNF | SSP_RNE, masks[5],SSPSR,tt2_1B);
 }
 else
 {
 PO(  SSP_BSY | SSP_TNF ,masks[5] , SSPSR , 3*TimeOut, tt2_0e);
 PSR( SSP_BSY | SSP_TNF , masks[5],SSPSR,tt2_0e);
 }
 PO( SSPTB_BSY|SSPTB_RXFE ,masks[8] , SSPTBSSR , 3*TimeOut , tt2_52+);  
 PSR(SSPTB_RXFE|SSPTB_BSY ,masks[8],SSPTBSSR,tt2_52+);

 /* After 3 word transmission is over  */
 PO( SSP_BSY  |SSP_RNE | SSP_TNF  , masks[5] , SSPSR , 6*TimeOut, tt2_3e);
 PSR( SSP_BSY |  SSP_RNE | SSP_TNF  , masks[5],SSPSR,tt2_3e);

 /* Read SSPTB status register */        
 if( (RXW_Value & MASK_SSPTB_RXW ) == SSPTB_RXW_4)
 {
  PO( SSPTB_RXWFLG | SSPTB_BSY ,masks[8] , SSPTBSSR , 4*TimeOut , tt2r1); 
  PSR(SSPTB_RXWFLG |SSPTB_BSY ,masks[8],SSPTBSSR,tt2_4r1);
  /* Set FIFO level flg */
  FIFO_FLG = TRUE ;
  }

 Idle(10 * SSPCLK_PERIOD);
 
 /* Write 4 data to the SSP  */
 for( i=8 ; i< 12 ; i++)
 {
  ProgramReg( buffer[i] & Masks[7], SSPDR, 0 );
 } 

 /* Read SSP SSPDR register and compare data */
 if( FIFO_FLG == TRUE )
 {
  if(mode ==0x20)
  {
  for(i=0; i< 4 ; i++)
   {
    PSR(buffer[i] & Masks[7] ,Masks[7] ,SSPDR,mw_N_data4);
    PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,MW_N_DATA4);
    }
  }
  else
  {
  for( i=0 ; i< 4 ; i++)
   {
   PSR(buffer[i] & Masks[WordLength],Masks[WordLength] ,SSPDR,tt2_comparedata0);
   PSR(buffer[i] & Masks[WordLength],Masks[WordLength] ,SSPTBSRDR,tt2compareDATA0);
   }
  }
 }

 Idle(2 * SSPCLK_PERIOD);

 /* After transmission is over  */
 PO(  SSP_RFF |  SSP_RNE | SSP_TNF | SSP_TFE , masks[5] , SSPSR , 17*TimeOut, tt2_8e);
 PSR( SSP_RFF | SSP_RNE | SSP_TNF | SSP_TFE , masks[5],SSPSR,tt2_8e);

 /* Read  SSP SSPDR register and compare data */
 if(mode ==0x20)
 {
  for(i=4; i< 12 ; i++)
   {
    PSR(buffer[i] & Masks[7] ,Masks[7] ,SSPDR,mw_N_data4);
    PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,MW_N_DATA4);
    }
 }
 else
 {
  for( i=4 ; i< 12; i++)
  {
   PSR(buffer[i] & Masks[WordLength],Masks[WordLength] ,SSPDR,tt2_comparedata4);
   PSR(buffer[i] & Masks[WordLength],Masks[WordLength] ,SSPTBSRDR,tt2compareDATA4);
  }
 }

 /* Read SSPTB and SSP status register */        
 PO( SSPTB_TXFE | SSPTB_RXFE , masks[8] , SSPTBSSR , 5*TimeOut , R1);
 PSR(SSPTB_TXFE | SSPTB_RXFE ,masks[8],SSPTBSSR,tt2_r8);
 PO( SSP_TNF | SSP_TFE , masks[5], SSPSR, 5*TimeOut, tt2_ssr8);

 /* Disable SSPTB */
 ProgramReg(0x00 , SSPTBSCR0 ,5 );
 ProgramReg(0x00 , SSPTBSCR1 ,5 );
 ProgramReg(0x0 ,SSPCR1,5);

 C("Continuous Test for slave Over");

}/* End Function */
