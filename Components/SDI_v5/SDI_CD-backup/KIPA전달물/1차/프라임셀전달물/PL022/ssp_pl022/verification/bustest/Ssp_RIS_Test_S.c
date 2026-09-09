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
--  File Name              : Ssp_RIS_Test_S.c.rca
--  File Revision          : 1.2
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function RIS_Test_S
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void RIS_Test_S()
{

 /* Called by Spi11_ris_Interrupt_Test_S */

  int32 buffer[32];
  int i;
  int FIFO_FLG ; 
 
 C(" TEST RIS for Slave");

 for(i=0; i<32 ; i++)
   buffer[i] =  0x5555;
 
 /* Read SSP Status register */
 PSR( SSP_TNF | SSP_TFE ,masks[5],SSPSR,spi_5I_0);
 
 /* Read SSPTB Status register */
   PSR(SSPTB_TXFE | SSPTB_RXFE ,masks[8],SSPTBSSR,spi_5I_tb0);

 /* Enable SSP RX FIFO Interrupt */
  ProgramReg(SSP_RXSC, SSPIMSC, 3);

 /* Enable SSP  */
 ProgramReg(ssp_enable_value_scr1,SSPCR1,3);
 
 /*  Write  data to the SSPTB  */
 for(i=0; i< 5 ; i++)
 {
   ProgramReg(buffer[i] & Masks[WordLength], SSPTBSTDR, 0 );
  } 

 /* Write data to the SSP  */
  for(i=0; i< 5 ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength], SSPDR, 0 );
  }

 /* Read SSP Status register */
 PO(  SSP_BSY | SSP_TNF , masks[5] , SSPSR , 3*TimeOut,spi_5I_1);
 PSR( SSP_BSY | SSP_TNF , masks[5] , SSPSR ,spi_5I_1);
  
 /* Enable SSPTB  */
  PSW(ssptb_enable_value ,SSPTBSCR0,SSPTBSCR0);

 /* During 1st word transmission   */
  PO(  SSP_BSY | SSP_TNF , masks[5] , SSPSR , 3*TimeOut, spi_5I_2);
  PSR(  SSP_BSY | SSP_TNF , masks[5] , SSPSR ,spi_5I_2);
 
 /* Read SSPTB Status register */
   PO(SSPTB_BSY | SSPTB_RXFE ,masks[8],SSPTBSSR,3*TimeOut,spi_5I_tb2);
   PSR(SSPTB_BSY | SSPTB_RXFE ,masks[8],SSPTBSSR,spi_5I_tb2);

 /* After one word transmission  over  */
  PO(  SSP_BSY | SSP_RNE | SSP_TNF , masks[5] , SSPSR , 3*TimeOut, spi_5I_3);
  PSR(  SSP_BSY | SSP_RNE | SSP_TNF , masks[5] , SSPSR ,spi_5I_3);

 /* Wait for SSPINTR */ 
 PO( SSPTB_RFSFLG | SSPTB_RXWFLG | SSPTB_SSPINT | SSPTB_BSY | SSPTB_TXFE ,masks[8] , SSPTBSSR , 5*TimeOut ,spi_5I_tb5); 
 PSR(SSPTB_RFSFLG | SSPTB_RXWFLG | SSPTB_SSPINT | SSPTB_BSY | SSPTB_TXFE ,masks[8],SSPTBSSR,spi_5I_tb5);
  
 /* Read SSP SSPRIS reg */
  PSR(SSP_RXRIS, MASK[3], SSPRIS, sspris_1);

 /* Read SSP SSPMIS reg */
  PSR(SSP_RXMIS, MASK[3], SSPMIS, sspmis_1);

 /* Mask SSP RX FIFO Interrupt */
  ProgramReg(0x0, SSPIMSC, 3);

 /* Read SSPTB Status Register, check SSPINTR and SSPRXINTR deasserted */ 
 PSR(SSPTB_RXWFLG | SSPTB_BSY | SSPTB_TXFE ,masks[8],SSPTBSSR,spi_5I_tb5);
  
 /* Read SSP SSPRIS reg */
  PSR(SSP_RXRIS, MASK[3], SSPRIS, sspris_2);

 /* Read SSP SSPMIS reg */
  PSR(0x0, MASK[3], SSPMIS, sspmis_2);

 /* Enable SSP RX FIFO Interrupt */
  ProgramReg(SSP_RXSC, SSPIMSC,3);

 /* Read SSPTB Status Register, check SSPINTR and SSPRXINTR asserted */ 
 PSR(SSPTB_RFSFLG | SSPTB_RXWFLG | SSPTB_SSPINT | SSPTB_BSY | SSPTB_TXFE ,masks[8],SSPTBSSR,spi_5I_tb5);

 /* Read SSP SSPRIS reg */
  PSR(SSP_RXRIS, MASK[3], SSPRIS, sspris_3);

 /* Read SSP SSPMIS reg */
  PSR(SSP_RXMIS, MASK[3], SSPMIS, sspmis_3);

 /* Wait until transmission is over and  SSP flags are set */
  PO( SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR, 3*TimeOut ,spi_5I_6 );
  PSR( SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR,spi_5I_6 );
 
 /* Read and compare the data  */
 for(i=0; i< 2 ; i++)
 {
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,data_spi_5I_7);
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,DATA_spi_5I_7); 
 }

 /* Read SSP SSPMIS reg */
 PSR(0x0 , MASK[1] ,SSPMIS ,sspmis_ris2);

 /* Read and compare the data  */
 for(i=2; i< 5 ; i++)
 {
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,data_spi_5I_7);
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,DATA_spi_5I_7); 
 }

 /* Read SSP status register */ 
    PO(SSP_TNF | SSP_TFE , masks[5], SSPSR, TimeOut,spi_5I_8);
    PSR(SSP_TNF | SSP_TFE , masks[5], SSPSR,spi_5I_8);

    PSR(SSPTB_TXFE | SSPTB_RXFE ,masks[8],SSPTBSSR,spi_5I_tb8);

 /* Disable SSP and SSPTB */
   ProgramReg(0x00 , SSPTBSCR0 ,5 );
   ProgramReg(0x00 , SSPTBSCR1 ,5 );
   ProgramReg(0x00 , SSPCR1,5);

 C(" ssp test RIS for Slave over ");

}/* End Function */
