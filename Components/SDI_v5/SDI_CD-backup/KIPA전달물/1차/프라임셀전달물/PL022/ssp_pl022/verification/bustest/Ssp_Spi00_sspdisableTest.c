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
--  File Name              : Ssp_Spi00_sspdisableTest.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function Spi00_sspdisableTest
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void Spi00_sspdisableTest()
{

 /* Called by SspdisableTest */
 
  int buffer[32];
  int i ;

 C("spi00 ssp disable Test");

 C("Baud 0, Wordlength 11");

 /* Program the SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg(SSP_SCLK_RATE0 | SSP_SPI00 | DataSize[11] , SSPCR0,32);

 /* Program the SSPTB */
 ProgramReg(PRE_1, SSPTBPRE, 5 );
 ProgramReg(SSPTB_SCLK_RATE0 | SSPTB_SPI  | DataSize[11],SSPTBSCR0,5);
 ProgramReg(SSPTB_SPI00 | SSPTB_OD,  SSPTBSCR1, 5);

 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE0 | SSPTB_SPI 
                        | DataSize[11]) ;
 WordLength = DataSize[11] ;
 CalculateTimeout(PRE_1 , SSPTB_SCLK_RATE0);

  for(i=0;i<32; i++)
        buffer[i] = i; 

 /* Read SSP Status register */
        PSR( SSP_TNF | SSP_TFE ,masks[5],SSPSR,SPI_N_0);

 /* Write five words to the SSP  */
 for(i=0; i< 5 ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength], SSPDR, 1 );
  }
 
 /* Read SSP Status register */
     PO( SSP_BSY | SSP_TNF , masks[5] , SSPSR , 3*TimeOut ,SPI_N_1);
     PSR(SSP_BSY | SSP_TNF ,masks[5],SSPSR,SPI_N_1);
 
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
     PSR(SSP_BSY | SSP_TNF ,masks[5],SSPSR,SPI_N_1);
     PSR(SSPTB_RXFE ,masks[9],SSPTBSSR,SPI_N_1);

 /* Disable OD Bit */
    ProgramReg(0x00,  SSPTBSCR1, 5);

 /* Enable SSP  */
    ProgramReg(SSP_ENABLE,SSPCR1,5); 
 
 /* During 1st word transmission   */
   PO( SSP_BSY | SSP_TNF , masks[5] , SSPSR , 3*TimeOut,SPI_N_2);
   PSR(SSP_BSY | SSP_TNF , masks[5] , SSPSR ,SPI_N_2);
 
 /* After one word transmission  over  */
   PO(  SSP_BSY | SSP_RNE | SSP_TNF , masks[5] , SSPSR , 3*TimeOut,SPI_N_3);
   PSR( SSP_BSY | SSP_RNE | SSP_TNF , masks[5] , SSPSR ,SPI_N_3);
 
 /* Wait until transmission is over and SSP flags are set */
   PO(  SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR, 7*TimeOut ,SPI_N_4);
   PSR( SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR,SPI_N_4);
 
 /* Read 5 words */
  for(i=0; i< 5 ; i++)
  {
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,SPI_N_data4);
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,SPI_N_DATA4);
  }

 /* Disable SSP and SSPTB */
   ProgramReg(0x0 ,SSPCR1,7);
   ProgramReg(0x00 , SSPTBSCR0 ,5 );
 
 C("spi00 sspdisable Test over");
 
}/* End Function */ 
