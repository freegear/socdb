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
--  File Name              : Ssp_Mw_Continuous.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function Mw_Continuous
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void Mw_Continuous()
{

 /* Called by Mw_BacktoBack_Test */

  int32 buffer[32];
  int i;
  int FIFO_FLG ; 
 
 C("MW Back to Back Test");
   for(i=0; i<32 ; i++)
        buffer[i] = i ;

 /* Read SSP Status register */
    PSR( SSP_TNF | SSP_TFE ,masks[5],SSPSR,MW_9_0);
 
 /* Read SSPTB Status register */
    PSR(SSPTB_TXFE | SSPTB_RXFE ,masks[8],SSPTBSSR,MW_9_tb0);

 /* Enable SSPTB  */
    ProgramReg(ssptb_enable_value ,SSPTBSCR0,5);

 /* Write data to the SSPTB  */
 for(i=0; i< 8 ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength], SSPTBSTDR, 5);
  } 

    PSR( SSPTB_RXFE ,masks[8],SSPTBSSR,MW_9_tb1);

 /* Write data to the SSP  */
 
  for(i=0; i< 8 ; i++)
  {
    ProgramReg( buffer[i] & Masks[7], SSPDR, 5 );
  }

 /* Read SSP Status register */
     PO( SSP_BSY , masks[5] , SSPSR , 9*TimeOut ,mw_9_1);
     PSR(SSP_BSY,masks[5],SSPSR,MW_9_1);
    
 /* Enable SSP  */
    ProgramReg(SSP_ENABLE,SSPCR1,0);
 
 /* During 1st word transmission   */
   PO(  SSP_BSY | SSP_TNF , masks[5] , SSPSR , 3*TimeOut,MW_9_2);
   PSR(  SSP_BSY | SSP_TNF , masks[5] , SSPSR ,MW_9_2);

 /* Read SSPTB Status register */
   PSR( SSPTB_BSY | SSPTB_RXFE ,masks[8],SSPTBSSR,MW_9_tb2);

 /* After one word transmission is over  */
   PO(  SSP_BSY | SSP_RNE | SSP_TNF , masks[5] , SSPSR , 3*TimeOut, MW_9_3);
   PSR(  SSP_BSY | SSP_RNE | SSP_TNF , masks[5] , SSPSR , MW_9_3);
 
 /* Read SSPTB Status register */
  if( ( RXW_Value & MASK_SSPTB_RXW) == SSPTB_RXW_4)
   {
  PO( SSPTB_RXWFLG | SSPTB_BSY ,masks[8] , SSPTBSSR , 8*TimeOut ,MW_9_tb5); 
  PSR(SSPTB_RXWFLG | SSPTB_BSY ,masks[8],SSPTBSSR,MW_9_tb5);
   /* Set FIFO level flag */
     FIFO_FLG = TRUE ;
   }
  
 Idle(10 * SSPCLK_PERIOD);

 /* Read next 4 data */
  for(i=0; i< 4 ; i++)
  {
   PSR(buffer[i] & Masks[7] ,Masks[7], SSPDR,data_MW_9_6);
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength], SSPTBSRDR,DATA_MW_9_6);
 }
 
 /* Write data to the SSP  */
 if( FIFO_FLG == TRUE)
 {
  for(i=8; i< 12 ; i++)
   {
     ProgramReg( buffer[i] & Masks[7], SSPDR, 0 );
     ProgramReg(buffer[i] & Masks[WordLength], SSPTBSTDR, 0);
    }
  }

 Idle(2 * SSPCLK_PERIOD);

 /* Wait until transmission is over and  SSP flags are set */
  PO( SSP_RFF |  SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR, 9*TimeOut ,MW_9_7 );
   PSR( SSP_RFF |  SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR,MW_9_7 );
 
 /* Read and compare the data  */
 for(i=4; i< 12 ; i++)
 {
   PSR(buffer[i] & Masks[7] ,Masks[7] ,SSPDR,data_MW_9_8);
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,DATA_MW_9_8);
 }

 /* Read SSP status register */ 
    PSR(SSP_TNF | SSP_TFE , masks[5], SSPSR,MW_9_9);
    PO(SSP_TNF | SSP_TFE , masks[5], SSPSR, 3*TimeOut,MW_9_9);

 /* Disable SSP and SSPTB */
    ProgramReg(0x0 ,SSPCR1,5);
    ProgramReg(0x00 , SSPTBSCR0 ,5 );

 C("MW Back to Back Test Over");
 
}/* End Function */
