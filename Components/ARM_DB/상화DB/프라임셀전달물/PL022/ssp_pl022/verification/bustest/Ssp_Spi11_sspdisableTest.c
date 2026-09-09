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
--  File Name              : Ssp_Spi11_sspdisableTest.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function Spi11_sspdisableTest
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void Spi11_sspdisableTest()
{

 /* Called by SspdisableTest */

  int buffer[32];
  int i ;

 C("spi11 ssp Disable Test");

 C("Baud 1, Wordlength 7");

 /* Program the SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg(SSP_SCLK_RATE1 | SSP_SPI11 | DataSize[7] , SSPCR0,32);

 /* Program the SSPTB */
 ProgramReg(PRE_1, SSPTBPRE, 5 );
 ProgramReg(SSPTB_SCLK_RATE0 | SSPTB_SPI  | DataSize[7],SSPTBSCR0,5);
 ProgramReg(SSPTB_SPI11 | SSPTB_OD,  SSPTBSCR1, 5);

 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE1 | SSPTB_SPI 
                        | DataSize[7]) ;
 WordLength = DataSize[7] ;
 CalculateTimeout(PRE_1 , SSPTB_SCLK_RATE1);

  for(i=0;i<32; i++)
        buffer[i] = i; 

 /* Read SSP Status register */
        PSR( SSP_TNF | SSP_TFE ,masks[5],SSPSR,SPI_N11_0);

 /* Write five words to the SSP  */
 for(i=0; i< 5 ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength], SSPDR, 1 );
  }
 
 /* Read SSP Status register */
     PO( SSP_BSY | SSP_TNF , masks[5] , SSPSR , 3*TimeOut ,SPI_N11_1);
     PSR(SSP_BSY | SSP_TNF ,masks[5],SSPSR,SPI_N11_1);
 
 /* Enable SSPTB  */
    ProgramReg(ssptb_enable_value ,SSPTBSCR0,5);

 /* Write data to the SSPTB  */
 for(i=0; i< 5 ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength], SSPTBSTDR, 5 );
  } 

 /* Idle Cycles */
     Idle(4*TimeOut);
 
 /* Read SSP Status register */
     PSR(SSP_BSY | SSP_TNF ,masks[5],SSPSR,SPI_N11_1);
     PSR(SSPTB_RXFE ,masks[9],SSPTBSSR,SPI_N11_1);

 /* Disable OD Bit */
     ProgramReg(SSPTB_SPI11,  SSPTBSCR1, 5);
 
 /* Enable SSP  */
    ProgramReg(SSP_ENABLE,SSPCR1,5); 
 
 /* During 1st word transmission   */
   PO( SSP_BSY | SSP_TNF , masks[5] , SSPSR , 3*TimeOut,SPI_N11_2);
   PSR(SSP_BSY | SSP_TNF , masks[5] , SSPSR ,SPI_N11_2);
 
 /* After one word transmission  over  */
   PO(  SSP_BSY | SSP_RNE | SSP_TNF , masks[5] , SSPSR , 3*TimeOut,SPI_N11_3);
   PSR( SSP_BSY | SSP_RNE | SSP_TNF , masks[5] , SSPSR ,SPI_N11_3);
 
 /* Wait until transmission is over and SSP flags are set */
   PO(  SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR, 5*TimeOut ,SPI_N11_4);
   PSR( SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR,SPI_N11_4);
 
 /* Read next 5 words */
 for(i=0; i< 5 ; i++)
 {
  PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,SPI_N11_data4);
  PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,SPI_N11_DATA4);
 }

 /* Disable SSP and SSPTB */
   ProgramReg(0x0 ,SSPCR1,7);
   ProgramReg(0x00 , SSPTBSCR0 ,5 );
 
 C("spi11 sspdisable Test over");
 
}/* End Function */
