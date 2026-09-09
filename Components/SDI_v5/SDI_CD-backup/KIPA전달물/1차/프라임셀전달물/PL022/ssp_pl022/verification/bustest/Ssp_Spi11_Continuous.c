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
--  File Name              : Ssp_Spi11_Continuous.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function Spi11_Continuous
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void Spi11_Continuous()
{

 /* Called by Spi11_BacktoBack_Test */

  int32 buffer[32];
  int i;
  int FIFO_FLG ; 
 
 C("spi11  Back to Back");
 for(i=0; i<32 ; i++)
   buffer[i] =  i;

 /* Read SSP Status register */
 PSR( SSP_TNF | SSP_TFE ,masks[5],SSPSR,spi_7C_0);
 
 /* Read SSPTB Status register */
 PSR(SSPTB_TXFE | SSPTB_RXFE ,masks[8],SSPTBSSR,spi_7C_tb0);

 /* Write data to the SSP  */
 for(i=0; i< 8 ; i++)
 {
   ProgramReg( buffer[i] & Masks[WordLength], SSPDR, 1 );
 }
 
 /* Read SSP Status register */
 PO( SSP_BSY , masks[5] , SSPSR , 9*TimeOut , spi_7C_1);

 /*  Enable SSPTB  */
 ProgramReg(ssptb_enable_value ,SSPTBSCR0,5);
       
 /*  Write data to the SSPTB  */
 for(i=0; i< 8 ; i++)
 {
   ProgramReg(buffer[i] & Masks[WordLength], SSPTBSTDR, 5);
 } 

 /* Read SSPTB Status register */
 PO( SSPTB_RXFE , masks[8] , SSPTBSSR , 9*TimeOut , spi_7C_tb1); 
  
 /* Enable SSP  */
 ProgramReg(SSP_ENABLE,SSPCR1,1);
  
 /* During 1st word transmission   */
 PO(  SSP_BSY | SSP_TNF , masks[5] , SSPSR , 2*TimeOut,spi_7C_2);
 
 /* After one word transmission  over  */
 PO(  SSP_BSY | SSP_RNE | SSP_TNF , masks[5] , SSPSR , 2*TimeOut, spi_7C_3);
 
 /* Read SSPTB Status register */
 if( (RXW_Value & MASK_SSPTB_RXW)== SSPTB_RXW_4)
 {
  PO( SSPTB_RXWFLG | SSPTB_BSY ,masks[8] , SSPTBSSR , 5*TimeOut ,spi_7C_tb4); 
  PSR(SSPTB_RXWFLG | SSPTB_BSY ,masks[8],SSPTBSSR,spi_7C_tb4);

  /* Set FIFO level flg */
  FIFO_FLG = TRUE ;
 }

 /* Read next 4 data */
 for(i=0; i< 4 ; i++)
 {
  PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,data_spi_7C_5);
  PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,DATA_spi_7C_5);
 }

 /* Write data to the SSP and SSPTB  */
 if( FIFO_FLG == TRUE)
 {
  for(i=8; i< 12 ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength], SSPTBSTDR, 0);
    ProgramReg( buffer[i] & Masks[WordLength], SSPDR, 0 );
  }
 }

 /* Wait until transmission is over and  SSP flags are set */
 PO( SSP_RFF | SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR, 9*TimeOut ,spi_7C_6 );
 PSR( SSP_RFF |  SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR,spi_7C_6 );

 /* Read and compare the data  */
 for(i=4; i< 12 ; i++)
 {
  PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,data_spi_7C_7);
  PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,DATA_spi_7C_7);
 }
 
 /* Read SSP and SSPTB Status register */
 PO(SSP_TNF | SSP_TFE , masks[5], SSPSR, 2*TimeOut,spi_7C_8);
 PSR(SSP_TNF | SSP_TFE , masks[5], SSPSR,spi_7C_8);
 PO( SSPTB_RXFE | SSPTB_TXFE  , masks[8], SSPTBSSR,2*TimeOut, spi_7C_9);
 PSR( SSPTB_RXFE | SSPTB_TXFE  , masks[8], SSPTBSSR,spi_7C_9);

 /* Disable SSP and SSPTB */
 ProgramReg(0x0 ,SSPCR1,5);
 ProgramReg(0x00 , SSPTBSCR0 ,5 );

  C("spi11 Back to Back Test Over");
}/* End Function */
