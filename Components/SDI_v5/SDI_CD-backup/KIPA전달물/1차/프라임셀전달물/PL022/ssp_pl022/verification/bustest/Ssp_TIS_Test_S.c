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
--  File Name              : Ssp_TIS_Test_S.c.rca
--  File Revision          : 1.2
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function TIS_Test_S
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void TIS_Test_S()
{

 /* Called by Spi00_tis_Interrupt_Test_S */

  int32 buffer[32];
  int i;
  int FIFO_FLG ; 
 
 C(" TEST TIS for Slave");
 for(i=0; i<32 ; i++)
   buffer[i] =  i;
 
 /* Read SSP Status register */
 PSR(SSP_TNF | SSP_TFE ,masks[5],SSPSR,spi_6I_0);
 
 /* Read SSPTB Status register, check SSPINTR and SSPTXINTR deasserted */
 PSR(SSPTB_TXFE | SSPTB_RXFE ,masks[8],SSPTBSSR,spi_6I_tb0);

 /* Enable SSP TX FIFO Interrupt */
  ProgramReg(SSP_TXSC, SSPIMSC,3);

 /* Read SSPTB Status register, check SSPINTR and SSPTXINTR asserted */
 PSR(SSPTB_SSPINT | SSPTB_TFSFLG | SSPTB_TXFE | SSPTB_RXFE ,masks[8],SSPTBSSR,spi_6I_tb0);

 /* Read SSP SSPRIS reg */
  PSR(SSP_TXRIS, MASK[4], SSPRIS, sspris_1);

 /* Read SSP SSPMIS reg */
  PSR(SSP_TXMIS, MASK[4], SSPMIS, sspmis_tis1);

 /* Disable SSP TX FIFO Interrupt */
  ProgramReg(0x0, SSPIMSC,3);

 /* Read SSPTB Status register, check SSPINTR and SSPTXINTR deasserted */
 PSR(SSPTB_TXFE | SSPTB_RXFE ,masks[8],SSPTBSSR,spi_6I_tb0);

 /* Read SSP SSPRIS reg */
  PSR(SSP_TXRIS, MASK[4], SSPRIS, sspris_1);

 /* Read SSP SSPMIS reg */
  PSR(0x0, MASK[4], SSPMIS, sspmis_tis1);

 /* Enable SSP TX FIFO Interrupt */
  ProgramReg(SSP_TXSC, SSPIMSC,3);

 /* Enable SSP  */
 ProgramReg(ssp_enable_value_scr1,SSPCR1,3);

 /* Write data to the SSP  */
  for(i=0; i< 8 ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength], SSPDR, 0 );
  }

 /* Read SSP SSPMIS reg */
 PSR(0x0 , MASK[4] ,SSPMIS ,sspmis_tis2);

 /* Read SSP Status register */
 PO(  SSP_BSY  , masks[5] , SSPSR , 9*TimeOut,spi_6I_1);
 PSR( SSP_BSY  , masks[5] , SSPSR ,spi_6I_1);
  
 /*  Write  data to the SSPTB  */
  for(i=0; i< 10 ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength], SSPTBSTDR, 0 );
  } 

 /* Enable SSPTB  */
 ProgramReg(ssptb_enable_value ,SSPTBSCR0,1);
 
 /* Read SSPTB Status register */
 PO(SSPTB_BSY | SSPTB_RXFE ,masks[8],SSPTBSSR,9*TimeOut ,spi_6I_tb2);
 PSR(SSPTB_BSY | SSPTB_RXFE ,masks[8],SSPTBSSR,spi_6I_tb2);

 /* During 1st word transmission   */
 PO(  SSP_BSY | SSP_TNF , masks[5] , SSPSR , 3*TimeOut, spi_6I_2);
 PSR(  SSP_BSY | SSP_TNF , masks[5] , SSPSR ,spi_6I_2);

 /* After one word transmission  over  */
 PO(  SSP_BSY | SSP_RNE | SSP_TNF , masks[5] , SSPSR , 3*TimeOut, spi_6I_3); 
 PSR(  SSP_BSY | SSP_RNE | SSP_TNF , masks[5] , SSPSR ,spi_6I_3);
  
 /* Wait for SSPINT */ 
  PO( SSPTB_TFSFLG | SSPTB_SSPINT | SSPTB_BSY ,Masks[10] , SSPTBSSR , 9*TimeOut ,spi_6I_tb5); 
  PSR(SSPTB_TFSFLG | SSPTB_SSPINT | SSPTB_BSY ,Masks[10],SSPTBSSR,spi_6I_tb5);
  
 /* Read SSPMIS reg */
  PSR(SSP_TXSC , MASK[4] ,SSPMIS ,sspmis_tis3);

 /* Write data to the SSP  */
  for(i=8; i< 10 ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength], SSPDR, 0 );
  }

 /* Read SSPMIS reg */
  PSR(0x0 , MASK[4] ,SSPMIS ,sspmis_tis4);

 /* Wait for SSPINT  to go */ 
  PO(  SSPTB_BSY ,Masks[10] , SSPTBSSR , 20 ,spi_6I_TB5); 
  PSR( SSPTB_BSY ,Masks[10],SSPTBSSR,spi_6I_TB5);

 /* Again wait for SSPINT and 4th data transmission over */
  PO( SSPTB_TFSFLG | SSPTB_RXWFLG | SSPTB_SSPINT | SSP_BSY , Masks[10],SSPTBSSR,9*TimeOut ,spi_6I_6tb);
  PSR( SSPTB_TFSFLG | SSPTB_RXWFLG | SSPTB_SSPINT | SSP_BSY , Masks[10],SSPTBSSR,spi_6I_6tb);

 /* Read SSP SSPMIS reg */
  PSR(SSP_TXSC , MASK[4] ,SSPMIS ,sspmis_tis5);

 /* Read and compare the data  */
 for(i=0; i< 4 ; i++)
 {
   PSR(buffer[i] ,Masks[WordLength] ,SSPDR,data_spi_6I_7);
   PSR(buffer[i] ,Masks[WordLength] ,SSPTBSRDR,DATA_spi_6I_7); 
 }

 /* wait for transmission over */ 
 PO(  SSP_RNE | SSP_TNF |SSP_TFE , masks[5],SSPSR,9*TimeOut,spi_6I_8);

 /* Read and compare the data  */
 for(i=4; i< 10 ; i++)
 {
   PSR(buffer[i] ,Masks[WordLength] ,SSPDR,data_spi_6I_9);
   PSR(buffer[i] ,Masks[WordLength] ,SSPTBSRDR,DATA_spi_6I_9); 
 }

 /* Read SSP SSPMIS reg */
 PSR(0x0 , MASK[3] ,SSPMIS ,sspmis_tis6);

 /* Read SSP status register */ 
    PO(SSP_TNF | SSP_TFE , masks[5], SSPSR, TimeOut,spi_6I_A);
    PSR(SSP_TNF | SSP_TFE , masks[5], SSPSR,spi_6I_A);

 /* Disable SSP and SSPTB */
   ProgramReg(0x00 , SSPTBSCR0 ,5 );
   ProgramReg(0x00 , SSPTBSCR1 ,5 );
   ProgramReg(0x00 ,SSPCR1,5);

 C(" ssp test TIS for Slave over ");
 

}/* End Function */
