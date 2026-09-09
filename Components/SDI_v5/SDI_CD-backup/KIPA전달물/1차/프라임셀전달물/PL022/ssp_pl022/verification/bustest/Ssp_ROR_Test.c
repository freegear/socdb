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
--  File Name              : Ssp_ROR_Test.c.rca
--  File Revision          : 1.2
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function ROR_Test
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void ROR_Test()
{

 /* Called by Ti_ror_Interrupt_Test */

  int32 buffer[32];
  int i;
  int FIFO_FLG ; 
 
 C(" TEST ROR");

 for(i=0; i<32 ; i++)
   buffer[i] =  (32-i);

 /* Read SSP Status register */
    PSR( SSP_TNF | SSP_TFE ,masks[5],SSPSR,spi_7I_0);
 
 /* Read SSPTB Status register */
    PSR(SSPTB_TXFE | SSPTB_RXFE ,masks[8],SSPTBSSR,spi_7I_tb0);

 /* Enable SSPTB  */
    PSW(ssptb_enable_value ,SSPTBSCR0,SSPTBSCR0);

 /*  Write  data to the SSPTB  */
  for(i=0; i< 12 ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength], SSPTBSTDR, 0 );
  } 

 /* Write data to the SSP  */
  for(i=0; i< 8 ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength], SSPDR, 0 );
  }

 /* Read SSP Status register */
     PO(  SSP_BSY  , masks[5] , SSPSR , 9*TimeOut,spi_7I_1);
     PSR( SSP_BSY  , masks[5] , SSPSR ,spi_7I_1);
  
 /* Enable SSP ROR Interrupt */
    ProgramReg(SSP_RORSC, SSPIMSC, 3);

 /* Read SSP SSPRIS reg */
    PSR(0x0, MASK[1], SSPRIS, sspris_1);

 /* Read SSP SSPMIS reg */
    PSR(0x0, MASK[1], SSPMIS, sspmis_1);

 /* Enable SSP  */
    ProgramReg(ssp_enable_value_scr1,SSPCR1,3);

 /* Wait for RXWFLG seting */
 PO( SSPTB_RXWFLG | SSPTB_BSY,  masks[8] , SSPTBSSR , 8*TimeOut ,spi_7I_tb2); 
 PSR(SSPTB_RXWFLG | SSPTB_BSY  ,masks[8],  SSPTBSSR,spi_7I_tb2);

 /* Write four more data to the SSP  */
  for(i=8; i< 12 ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength], SSPDR, 0 );
  }

 /* Wait for SSPINTR */ 
 PO(SSPTB_RXWFLG | SSPTB_RORFLG | SSPTB_SSPINT | SSPTB_BSY ,masks[8] , SSPTBSSR , 9*TimeOut ,spi_7I_tb3); 
 PSR(SSPTB_RXWFLG | SSPTB_RORFLG | SSPTB_SSPINT | SSPTB_BSY  ,masks[8],SSPTBSSR,spi_7I_tb3);
  
 /* Read SSP SSPRIS reg */
 PSR(SSP_RORRIS , MASK[1] ,SSPRIS ,sspris_ror1);

 /* Read SSP SSPMIS reg */
 PSR(SSP_RORMIS , MASK[1] ,SSPMIS ,sspmis_ror1);

 /* Write  to SSPICR reg to clear the RXROR interrupt*/
 ProgramReg(SSP_RORIC ,SSPICR ,0);

 /* Wait for SSPINTR to be inactive */
 PO(SSPTB_RXWFLG | SSPTB_BSY ,masks[8],SSPTBSSR,4*TimeOut,spi_7I_tb4);
 PSR(SSPTB_RXWFLG | SSPTB_BSY ,masks[8],SSPTBSSR,spi_7I_tb4);

 /* Read SSP SSPRIS reg */
 PSR(0x0 , MASK[1] ,SSPRIS ,sspris_ror2);

 /* Read SSP SSPMIS reg */
 PSR(0x0 , MASK[1] ,SSPMIS ,sspmis_ror2);

 /* Again wait for SSPINTR */ 
 PO( SSPTB_RXWFLG | SSPTB_RORFLG | SSPTB_SSPINT | SSPTB_BSY ,masks[8] , SSPTBSSR , 9*TimeOut ,spi_7I_tb5); 
 PSR(SSPTB_RXWFLG | SSPTB_RORFLG | SSPTB_SSPINT | SSPTB_BSY  ,masks[8],SSPTBSSR,spi_7I_tb5);

 /* Read SSP SSPRIS reg */
 PSR(SSP_RORRIS , MASK[1] ,SSPRIS ,sspris_ror3);

 /* Read SSP SSPMIS reg */
 PSR(SSP_RORMIS , MASK[1] ,SSPMIS ,sspmis_ror3);

 /* Wait until transmission is over and  SSP flags are set */
 PO( SSP_RFF | SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR, 9*TimeOut ,spi_7I_6 );
  PSR( SSP_RFF | SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR,spi_7I_6 );

 /* Read SSPTB Status Register, check SSPTB_RORFLG and SSPTB_SSPINT asserted */ 
  PSR(SSPTB_TXFE | SSPTB_RXWFLG | SSPTB_RORFLG | SSPTB_SSPINT  ,masks[8],SSPTBSSR,spi_7I_tb5);

 /* Read SSP SSPRIS reg */
 PSR(SSP_RORRIS , MASK[1] ,SSPRIS ,sspris_ror4);

 /* Read SSP SSPMIS reg */
 PSR(SSP_RORMIS , MASK[1] ,SSPMIS ,sspmis_ror4);

 /* Mask SSP ROR Interrupt */
  ProgramReg(0x0, SSPIMSC,3);

 /* Read SSPTB Status Register, check SSPTB_RORFLG and SSPTB_SSPINT deasserted */ 
  PSR(SSPTB_TXFE | SSPTB_RXWFLG ,masks[8],SSPTBSSR,spi_7I_tb5);

 /* Read SSP SSPRIS reg */
 PSR(SSP_RORRIS , MASK[1] ,SSPRIS ,sspris_ror5);

 /* Read SSP SSPMIS reg */
 PSR(0x0 , MASK[1] ,SSPMIS ,sspmis_ror5);

 /* Enable SSP ROR Interrupt */
 ProgramReg(SSP_RORSC, SSPIMSC, 3);

 /* Read SSPTB Status Register, check SSPTB_RORFLG and SSPTB_SSPINT asserted */ 
  PSR(SSPTB_TXFE | SSPTB_RXWFLG | SSPTB_RORFLG | SSPTB_SSPINT ,masks[8],SSPTBSSR,spi_7I_tb5);

 /* Write to SSPICR to clear RXROR interrupt*/
 ProgramReg(SSP_RORIC ,SSPICR ,0);

 /* Read SSPTB Status Register, check SSPTB_RORFLG and SSPTB_SSPINT deasserted */ 
  PSR(SSPTB_TXFE | SSPTB_RXWFLG ,masks[8],SSPTBSSR,spi_7I_tb5);

 /* Read SSP SSPRIS reg */
 PSR(0x0 , MASK[1] ,SSPRIS ,sspris_ror6);

 /* Read SSP SSPMIS reg */
 PSR(0x0 , MASK[1] ,SSPMIS ,sspmis_ror6);

 /* Read and compare the data  */
 for(i=0; i< 8 ; i++)
 {
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,data_spi_7I_7);
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,DATA_spi_7I_7); 
 }

 /* Read SSP SSPRIS reg */
 PSR(0x0 , MASK[1] ,SSPRIS ,sspris_ror7);

 /* Read SSP SSPMIS reg */
 PSR(0x0 , MASK[1] ,SSPMIS ,sspmis_ror6);

 /* Read and compare the data  */
 for(i=8; i< 12 ; i++)
 {
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,DATA_spi_7I_7); 
 }

 /* Disable SSP and SSPTB */
   ProgramReg(0x0 ,SSPCR1,7);
   ProgramReg(0x00 , SSPTBSCR0 ,5 );

 C(" ssp test ROR over ");

}/* End Function */
