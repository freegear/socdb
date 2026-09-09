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
--  File Name              : Ssp_Spi00_sspdisableTest_S.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL022-REL1v2
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function Spi00_sspdisableTest_S
             which may be called in the main file Ssp.c                       */
/******************************************************************************/

void Spi00_sspdisableTest_S()
{

 /* Called by SspdisableTest_S */
 
  int buffer[32];
  int i ;

 C("spi00 ssp disable Test for Slave");

 C("Baud 5, Wordlength 11");

 /* Program the SSP */
 ProgramReg(SSP_PRE_1 , SSPCPSR ,32 );
 ProgramReg(SSP_SCLK_RATE5 | SSP_SPI00 | DataSize[11] , SSPCR0,32);
 ProgramReg(SSP_MS,SSPCR1,32);

 /* Program the SSPTB */
 ProgramReg(PRE_1, SSPTBPRE, 5 );
 ProgramReg(SSPTB_SPI00 | SSPTB_MS | SSPTB_OD,  SSPTBSCR1, 5);

 ssptb_enable_value = ( SSPTB_ENABLE | SSPTB_SCLK_RATE5 | SSPTB_SPI 
                        | DataSize[11]) ;
 WordLength = DataSize[11] ;
 CalculateTimeout(PRE_1 , SSPTB_SCLK_RATE5);

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
 
 /* Write data to the SSPTB  */
 for(i=0; i< 5 ; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength], SSPTBSTDR, 5 );
  } 

 /* Enable SSPTB  */
    ProgramReg(ssptb_enable_value ,SSPTBSCR0,5);

 /* During 1st word transmission  */
   PO(SSPTB_RXFE | SSPTB_BSY ,masks[9],SSPTBSSR, 3*TimeOut,SPI_N_11);
   PSR(SSPTB_RXFE | SSPTB_BSY ,masks[9],SSPTBSSR,SPI_N_11);
 
 /* Wait until transmission is over and SSP flags are set */
   PO(SSPTB_TXFE | SSPTB_RXWFLG,masks[9],SSPTBSSR, 6*TimeOut,SPI_N_12);
   PSR(SSPTB_TXFE | SSPTB_RXWFLG,masks[9],SSPTBSSR, SPI_N_12);
 
 /* Read 5 words */
   for(i=0; i< 5 ; i++)
   {
    PSR(0x0000,Masks[WordLength],SSPTBSRDR,SPI_N_DATA5);
  }

 /* Clear OD bit */
    ProgramReg(SSPTB_MS , SSPTBSCR1, 5);
 
 /* Enable SSP  */
    ProgramReg(SSP_ENABLE | SSP_MS ,SSPCR1,5);

 /* Write data to SSPTB  */
 for(i=5; i< 10; i++)
  {
    ProgramReg(buffer[i] & Masks[WordLength], SSPTBSTDR, 5 );
  }
 
 /* Read SSP Status register */
     PSR(SSP_BSY | SSP_TNF ,masks[5],SSPSR,SPI_N_1);
     PSR(SSPTB_RXFE | SSPTB_BSY,masks[9],SSPTBSSR,SPI_N_1);

 /* During 1st word transmission   */
   PO( SSP_BSY | SSP_TNF , masks[5] , SSPSR , 3*TimeOut,SPI_N_2);
   PSR(SSP_BSY | SSP_TNF , masks[5] , SSPSR ,SPI_N_2);
 
 /* After one word transmission  over  */
   PO(  SSP_BSY | SSP_RNE | SSP_TNF , masks[5] , SSPSR , 3*TimeOut,SPI_N_3);
   PSR( SSP_BSY | SSP_RNE | SSP_TNF , masks[5] , SSPSR ,SPI_N_3);
 
 /* Wait until transmission is over and SSP flags are set */
   PO(  SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR, 6*TimeOut ,SPI_N_4);
   PSR( SSP_RNE | SSP_TNF | SSP_TFE, masks[5], SSPSR,SPI_N_4);
 
 /* Read 5 words */
  for(i=0; i< 5 ; i++)
  {
   PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPTBSRDR,SPI_N_DATA4);
  }

 /* Read next 5 words */
   for(i=5; i< 10 ; i++)
   {
    PSR(buffer[i] & Masks[WordLength] ,Masks[WordLength] ,SSPDR,SPI_N_data4);
  }

 /* Disable SSP and SSPTB */
   ProgramReg(0x00 , SSPTBSCR0 ,5 );
   ProgramReg(0x00 , SSPTBSCR1 ,5 );
   ProgramReg(0x00 ,SSPCR1,7);
 
 C("spi00 sspdisable Test for Slave over");
 
}/* End Function */ 
